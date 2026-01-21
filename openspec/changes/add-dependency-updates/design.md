## Context

This feature adds dependency update configuration management for both Dependabot and Renovate. Both tools
serve similar purposes but have different configuration formats and capabilities. Organizations often
standardize on one tool, but some use both (e.g., Dependabot for security alerts, Renovate for updates).

**Stakeholders:** DevOps teams, security teams, developers managing dependencies

**Constraints:**

- Must work with GitHub provider's `github_repository_file` resource
- Configuration files must be valid for their respective tools
- Must support the existing group inheritance pattern

## Goals / Non-Goals

**Goals:**

- Generate valid Dependabot configuration files (`.github/dependabot.yml`)
- Generate valid Renovate configuration files (`renovate.json`)
- Support configuration inheritance from groups
- Allow repository-level overrides
- Provide sensible defaults for common use cases

**Non-Goals:**

- Full schema validation of all Dependabot/Renovate options (rely on tool-side validation)
- Managing Renovate GitHub App installation
- Automatic migration between Dependabot and Renovate
- Managing vulnerability alerts (separate GitHub feature)

## Decisions

### Decision 1: File Generation via `github_repository_file`

Use Terraform's `github_repository_file` resource to create/manage configuration files directly in
repositories. This ensures the files are tracked in Terraform state and can be updated or removed.

**Alternatives considered:**

- Template repositories: Limited flexibility, can't update existing repos
- GitHub Actions to sync files: Adds complexity, not declarative

### Decision 2: YAML-to-YAML Pass-through for Dependabot

The Dependabot configuration closely mirrors the official schema. Store it as-is in YAML and convert
directly to the generated file. This keeps the user-facing config familiar.

**Structure in `repositories.yml`/`groups.yml`:**

```yaml
dependabot:
  version: 2  # Optional, defaults to 2
  updates:
    - package_ecosystem: npm
      directory: "/"
      schedule:
        interval: weekly
```

### Decision 3: JSON Output for Renovate

Renovate uses JSON configuration. Store as YAML in our configs (for consistency), convert to JSON when
generating the file.

**Structure in `repositories.yml`/`groups.yml`:**

```yaml
renovate:
  extends:
    - "config:recommended"
  automerge: true
  packageRules:
    - matchPackagePatterns: ["*"]
      groupName: "all dependencies"
```

### Decision 4: Merge Strategy for Dependency Configs

- **Dependabot `updates`:** Merge by `package_ecosystem + directory` key (unique combination)
- **Renovate `packageRules`:** Concatenate lists (later rules take precedence in Renovate)
- **Renovate `extends`:** Concatenate and deduplicate
- **All other fields:** Later values override (consistent with existing merge behavior)

### Decision 5: File Location Options

- **Dependabot:** Always `.github/dependabot.yml` (required location)
- **Renovate:** Default to `renovate.json`, allow override to `.github/renovate.json` via config option

### Decision 6: Conflict Handling

If both `dependabot` and `renovate` are configured for the same repository, both files are generated.
This is a valid use case (different tools for different ecosystems).

## Risks / Trade-offs

| Risk                               | Mitigation                                                          |
| ---------------------------------- | ------------------------------------------------------------------- |
| Config schema drift                | Document supported options, allow passthrough for advanced options  |
| Large Renovate configs             | Support `extends` presets to keep configs minimal                   |
| File conflicts with manual configs | Document that Terraform-managed files will overwrite manual changes |
| Merge complexity                   | Start with simple merge rules, document behavior clearly            |

## Migration Plan

1. Add new variables to repository module (backward compatible - optional)
1. Add merge logic to yaml-config.tf
1. Add github_repository_file resources
1. Update documentation with examples
1. No breaking changes - existing repos unaffected

## Open Questions

- Should we support Renovate's `renovate.json5` format? (Decided: No, stick to standard JSON)
- Should we validate package ecosystem names? (Decided: No, let Dependabot/GitHub validate)
