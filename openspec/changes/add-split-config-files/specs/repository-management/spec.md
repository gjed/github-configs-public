## MODIFIED Requirements

### Requirement: YAML-Based Repository Configuration

The system SHALL read repository configurations from YAML files in the `config/` directory using
Terraform's native `yamldecode()` function. Configuration types (repositories, groups, rulesets) MAY be
defined as either a single `<type>.yml` file or a `<type>/` directory containing multiple `.yml` files.

#### Scenario: Load configuration files

- **WHEN** Terraform is initialized and planned
- **THEN** the system reads `config/config.yml`, `config/groups.yml`, `config/repositories.yml`, and
  `config/rulesets.yml`
- **AND** parses them into Terraform local values

#### Scenario: Invalid YAML syntax

- **WHEN** a configuration file contains invalid YAML syntax
- **THEN** Terraform fails with a parsing error message indicating the file and location

#### Scenario: Load configuration from directory

- **GIVEN** a `config/repositories/` directory exists with files `frontend.yml` and `backend.yml`
- **AND** no `config/repositories.yml` file exists
- **WHEN** Terraform is initialized and planned
- **THEN** the system reads all `.yml` files from the `config/repositories/` directory
- **AND** merges them into a single configuration map

#### Scenario: Single file takes precedence over directory

- **GIVEN** both `config/repositories.yml` file and `config/repositories/` directory exist
- **WHEN** Terraform is initialized and planned
- **THEN** the system uses only `config/repositories.yml`
- **AND** the directory contents are ignored

#### Scenario: Split groups configuration

- **GIVEN** a `config/groups/` directory exists with files `oss.yml` and `internal.yml`
- **AND** no `config/groups.yml` file exists
- **WHEN** Terraform is initialized and planned
- **THEN** the system reads all `.yml` files from the `config/groups/` directory
- **AND** merges them into a single groups configuration map

#### Scenario: Split rulesets configuration

- **GIVEN** a `config/rulesets/` directory exists with files `branch-protection.yml` and `tag-rules.yml`
- **AND** no `config/rulesets.yml` file exists
- **WHEN** Terraform is initialized and planned
- **THEN** the system reads all `.yml` files from the `config/rulesets/` directory
- **AND** merges them into a single rulesets configuration map

#### Scenario: Empty directory fallback

- **GIVEN** a `config/repositories/` directory exists but contains no `.yml` files
- **AND** no `config/repositories.yml` file exists
- **WHEN** Terraform is initialized and planned
- **THEN** the system uses an empty configuration map for repositories

#### Scenario: Duplicate keys across files in directory

- **GIVEN** a `config/repositories/` directory contains `frontend.yml` with key `my-repo`
- **AND** `backend.yml` also contains key `my-repo`
- **WHEN** Terraform is initialized and planned
- **THEN** the later file (alphabetically) overrides the earlier one
