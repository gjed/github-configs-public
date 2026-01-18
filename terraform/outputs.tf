# Output values for managed resources

output "repositories" {
  description = "Map of managed repositories with their URLs"
  value = {
    for repo_name, repo in module.repositories : repo_name => {
      name       = repo.name
      url        = repo.html_url
      ssh_url    = repo.ssh_clone_url
      visibility = repo.visibility
    }
  }
}

output "repository_count" {
  description = "Total number of managed repositories"
  value       = length(module.repositories)
}

output "organization" {
  description = "GitHub organization being managed"
  value       = local.github_org
}

output "subscription_tier" {
  description = "GitHub subscription tier"
  value       = local.subscription
}

# Output warning when rulesets are skipped due to subscription tier
output "subscription_warnings" {
  description = "Warnings about features unavailable on current subscription tier"
  value = length(local.repos_with_skipped_rulesets) > 0 ? {
    message = "Rulesets skipped for ${length(local.repos_with_skipped_rulesets)} private repo(s) - requires paid GitHub plan"
    repos   = local.repos_with_skipped_rulesets
    tier    = local.subscription
  } : null
}
