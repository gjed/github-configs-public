## ADDED Requirements

### Requirement: Dependabot Configuration Management

The system SHALL support generating Dependabot configuration files (`.github/dependabot.yml`) from YAML
configuration in groups and repositories.

#### Scenario: Generate Dependabot config from group

- **GIVEN** group `use-dependabot` defines a `dependabot` configuration
- **AND** a repository uses group `use-dependabot`
- **WHEN** `terraform apply` is executed
- **THEN** a `.github/dependabot.yml` file is created in the repository
- **AND** the file contains the configuration from the group

#### Scenario: Repository-level Dependabot override

- **GIVEN** a repository inherits `dependabot` from a group
- **AND** the repository defines additional `dependabot.updates` entries
- **WHEN** the configuration is merged
- **THEN** updates are merged by `package_ecosystem` + `directory` key
- **AND** repository-level updates override group-level updates for the same key

#### Scenario: No Dependabot config

- **GIVEN** a repository does not have `dependabot` configured (directly or via groups)
- **WHEN** `terraform apply` is executed
- **THEN** no `.github/dependabot.yml` file is created

---

### Requirement: Renovate Configuration Management

The system SHALL support generating Renovate configuration files from YAML configuration in groups and
repositories.

#### Scenario: Generate Renovate config from group

- **GIVEN** group `use-renovate` defines a `renovate` configuration
- **AND** a repository uses group `use-renovate`
- **WHEN** `terraform apply` is executed
- **THEN** a `renovate.json` file is created in the repository
- **AND** the file contains the configuration from the group as valid JSON

#### Scenario: Repository-level Renovate override

- **GIVEN** a repository inherits `renovate` from a group
- **AND** the repository defines additional `renovate.packageRules`
- **WHEN** the configuration is merged
- **THEN** `packageRules` lists are concatenated (repository rules added after group rules)
- **AND** `extends` lists are merged and deduplicated
- **AND** scalar values are overridden by repository-level values

#### Scenario: Custom Renovate file location

- **GIVEN** a repository defines `renovate_file_path: ".github/renovate.json"`
- **WHEN** `terraform apply` is executed
- **THEN** the Renovate config file is created at `.github/renovate.json` instead of `renovate.json`

#### Scenario: No Renovate config

- **GIVEN** a repository does not have `renovate` configured (directly or via groups)
- **WHEN** `terraform apply` is executed
- **THEN** no Renovate configuration file is created

---

### Requirement: Dependency Update Config Merging

The system SHALL merge dependency update configurations from groups using defined merge strategies.

#### Scenario: Dependabot updates merge by key

- **GIVEN** group `base-deps` defines `dependabot.updates` with `npm` at `/`
- **AND** group `extra-deps` defines `dependabot.updates` with `npm` at `/` and `docker` at `/`
- **AND** repository uses groups `["base-deps", "extra-deps"]`
- **WHEN** the configuration is merged
- **THEN** the `npm` at `/` entry from `extra-deps` overrides the one from `base-deps`
- **AND** the `docker` at `/` entry is included
- **AND** there is exactly one `npm` + `/` entry in the final config

#### Scenario: Renovate extends deduplication

- **GIVEN** group `base` defines `renovate.extends: ["config:recommended"]`
- **AND** group `automerge` defines `renovate.extends: ["config:recommended", ":automergeMinor"]`
- **AND** repository uses groups `["base", "automerge"]`
- **WHEN** the configuration is merged
- **THEN** `extends` contains `["config:recommended", ":automergeMinor"]` without duplicates

---

### Requirement: Dependency Update File Resource Management

The system SHALL use `github_repository_file` to manage dependency update configuration files in
repositories.

#### Scenario: File creation

- **WHEN** a dependency update configuration is defined for a repository
- **AND** `terraform apply` is executed
- **THEN** the configuration file is created via `github_repository_file` resource
- **AND** the file is committed to the repository's default branch

#### Scenario: File update

- **WHEN** a dependency update configuration is changed
- **AND** `terraform apply` is executed
- **THEN** the existing configuration file is updated to match the new configuration

#### Scenario: File removal

- **WHEN** a dependency update configuration is removed from a repository
- **AND** `terraform apply` is executed
- **THEN** the configuration file is removed from the repository

---

### Requirement: Both Tools Simultaneously

The system SHALL allow configuring both Dependabot and Renovate for the same repository.

#### Scenario: Dual configuration

- **GIVEN** a repository defines both `dependabot` and `renovate` configurations
- **WHEN** `terraform apply` is executed
- **THEN** both `.github/dependabot.yml` and `renovate.json` files are created
- **AND** both files contain their respective valid configurations
