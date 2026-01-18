# Load and parse YAML configuration
locals {
  # Read the YAML configuration files from config/ directory
  common_config   = yamldecode(file("${path.module}/../config/config.yml"))
  groups_config   = yamldecode(file("${path.module}/../config/groups.yml"))
  repos_config    = yamldecode(file("${path.module}/../config/repositories.yml"))
  rulesets_config = yamldecode(file("${path.module}/../config/rulesets.yml"))

  # Extract values from YAML
  github_org    = local.common_config.organization
  subscription  = lookup(local.common_config, "subscription", "free")
  config_groups = local.groups_config
  repos_yaml    = local.repos_config

  # Subscription tier feature availability
  # - free: Rulesets only work on public repositories
  # - pro: Rulesets work on public and private repositories
  # - team/enterprise: Full ruleset support including push rulesets
  rulesets_require_paid_for_private = contains(["free"], local.subscription)

  # Merge multiple config groups for each repository
  # Groups are applied sequentially: later groups override single values, lists are merged
  merged_configs = {
    for repo_name, repo_config in local.repos_yaml : repo_name => merge(
      # Apply each group sequentially - merge will override with later values
      [
        for group_name in repo_config.groups :
        lookup(local.config_groups, group_name, {})
      ]...
    )
  }

  # Merge topics from all groups for each repository
  merged_topics = {
    for repo_name, repo_config in local.repos_yaml : repo_name => distinct(flatten([
      # Topics from all groups
      for group_name in repo_config.groups :
      lookup(lookup(local.config_groups, group_name, {}), "topics", [])
    ]))
  }

  # Merge teams from all groups for each repository
  merged_teams = {
    for repo_name, repo_config in local.repos_yaml : repo_name => merge(
      # Apply each group's teams sequentially - later groups override
      [
        for group_name in repo_config.groups :
        lookup(lookup(local.config_groups, group_name, {}), "teams", {})
      ]...
    )
  }

  # Merge collaborators from all groups for each repository
  merged_collaborators = {
    for repo_name, repo_config in local.repos_yaml : repo_name => merge(
      # Apply each group's collaborators sequentially - later groups override
      [
        for group_name in repo_config.groups :
        lookup(lookup(local.config_groups, group_name, {}), "collaborators", {})
      ]...
    )
  }

  # Merge rulesets from all groups for each repository
  # Rulesets are collected from groups, then repo-specific rulesets are added
  # Note: On free tier, rulesets are skipped for private repositories
  merged_rulesets = {
    for repo_name, repo_config in local.repos_yaml : repo_name => {
      for ruleset_name in distinct(flatten(concat(
        # Collect ruleset names from all groups
        [
          for group_name in repo_config.groups :
          lookup(lookup(local.config_groups, group_name, {}), "rulesets", [])
        ],
        # Add repo-specific rulesets
        [lookup(repo_config, "rulesets", [])]
      ))) :
      ruleset_name => lookup(local.rulesets_config, ruleset_name, null)
      if lookup(local.rulesets_config, ruleset_name, null) != null
    }
  }

  # Calculate effective visibility for each repository (needed for ruleset filtering)
  repo_visibility = {
    for repo_name, repo_config in local.repos_yaml : repo_name =>
    lookup(repo_config, "visibility", lookup(local.merged_configs[repo_name], "visibility", "private"))
  }

  # Filter rulesets based on subscription tier and repository visibility
  # On free tier, rulesets are not available for private repositories
  effective_rulesets = {
    for repo_name, rulesets in local.merged_rulesets : repo_name =>
    (local.rulesets_require_paid_for_private && local.repo_visibility[repo_name] != "public") ? {} : rulesets
  }

  # Track which repos have rulesets skipped due to subscription limitations
  repos_with_skipped_rulesets = [
    for repo_name, rulesets in local.merged_rulesets : repo_name
    if length(rulesets) > 0 && length(local.effective_rulesets[repo_name]) == 0
  ]

  # Transform YAML repos into the format expected by the module
  # Multiple groups are applied sequentially with proper merging
  repositories = {
    for repo_name, repo_config in local.repos_yaml : repo_name => {
      name         = repo_name
      description  = repo_config.description
      homepage_url = lookup(repo_config, "homepage_url", lookup(local.merged_configs[repo_name], "homepage_url", null))
      config_group = join(", ", repo_config.groups) # Store all groups for reference

      # Apply repo-specific overrides, falling back to merged group config
      visibility                  = lookup(repo_config, "visibility", lookup(local.merged_configs[repo_name], "visibility", "private"))
      has_wiki                    = lookup(repo_config, "has_wiki", lookup(local.merged_configs[repo_name], "has_wiki", false))
      has_issues                  = lookup(repo_config, "has_issues", lookup(local.merged_configs[repo_name], "has_issues", false))
      has_projects                = lookup(repo_config, "has_projects", lookup(local.merged_configs[repo_name], "has_projects", false))
      has_downloads               = lookup(repo_config, "has_downloads", lookup(local.merged_configs[repo_name], "has_downloads", true))
      has_discussions             = lookup(repo_config, "has_discussions", lookup(local.merged_configs[repo_name], "has_discussions", false))
      allow_merge_commit          = lookup(repo_config, "allow_merge_commit", lookup(local.merged_configs[repo_name], "allow_merge_commit", true))
      allow_squash_merge          = lookup(repo_config, "allow_squash_merge", lookup(local.merged_configs[repo_name], "allow_squash_merge", true))
      allow_rebase_merge          = lookup(repo_config, "allow_rebase_merge", lookup(local.merged_configs[repo_name], "allow_rebase_merge", true))
      allow_auto_merge            = lookup(repo_config, "allow_auto_merge", lookup(local.merged_configs[repo_name], "allow_auto_merge", false))
      allow_update_branch         = lookup(repo_config, "allow_update_branch", lookup(local.merged_configs[repo_name], "allow_update_branch", false))
      delete_branch_on_merge      = lookup(repo_config, "delete_branch_on_merge", lookup(local.merged_configs[repo_name], "delete_branch_on_merge", false))
      web_commit_signoff_required = lookup(repo_config, "web_commit_signoff_required", lookup(local.merged_configs[repo_name], "web_commit_signoff_required", false))

      # License template - optional, can be set in group or repo
      license_template = lookup(repo_config, "license_template", lookup(local.merged_configs[repo_name], "license_template", null))

      # Topics: merge from all groups + repo-specific topics
      topics = distinct(concat(
        local.merged_topics[repo_name],
        lookup(repo_config, "topics", [])
      ))

      # Teams: merge from all groups + repo-specific teams (repo overrides group)
      teams = merge(
        local.merged_teams[repo_name],
        lookup(repo_config, "teams", {})
      )

      # Collaborators: merge from all groups + repo-specific collaborators (repo overrides group)
      collaborators = merge(
        local.merged_collaborators[repo_name],
        lookup(repo_config, "collaborators", {})
      )

      # Rulesets: apply rulesets from groups and repo-specific rulesets
      # Note: effective_rulesets filters based on subscription tier
      rulesets = local.effective_rulesets[repo_name]
    }
  }
}
