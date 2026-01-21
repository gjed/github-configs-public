# Change: Add Dependency Update Configuration Management

## Why

Dependency update configuration (Dependabot and Renovate) must be manually created in each repository,
leading to inconsistent update schedules, missing configs in new repositories, and no centralized policy
for dependency updates. Users need the ability to define dependency update configurations in YAML and
have them automatically generated as repository files.

## What Changes

- Add `dependabot` configuration support in groups and repositories to generate `.github/dependabot.yml`
- Add `renovate` configuration support in groups and repositories to generate `renovate.json`
- Support configuration inheritance from groups (same merge strategy as other settings)
- Use `github_repository_file` resource to manage generated configuration files
- Support common presets and templates for both tools
- Allow using either tool independently or different tools for different repositories

## Impact

- Affected specs: New `dependency-updates` capability
- Affected code:
  - `terraform/modules/repository/variables.tf` - new variables for dependabot/renovate configs
  - `terraform/modules/repository/main.tf` - new `github_repository_file` resources
  - `terraform/yaml-config.tf` - merge logic for dependency update configs
  - `config/groups.yml` - example group configurations
  - `config/repositories.yml` - example repository configurations
- Backward compatible: no changes to existing repositories without these configs
