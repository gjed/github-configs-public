# GitHub Organization Terraform Template

Manage your GitHub organization's repositories as code using Terraform and YAML configuration.

## Features

- **YAML-based configuration** - Human-readable repository definitions
- **Configuration groups** - Share settings across multiple repositories (DRY)
- **Repository rulesets** - Enforce branch protection and policies
- **Subscription-aware** - Gracefully handles GitHub Free tier limitations
- **Onboarding script** - Easily import existing repositories

## Quick Start

### 1. Use this template

Click "Use this template" on GitHub to create your own repository.

### 2. Configure your organization

Edit `config/config.yml`:

```yaml
organization: your-org-name
subscription: free  # or pro, team, enterprise
```

### 3. Set up authentication

```bash
export GITHUB_TOKEN="your_github_token"
```

### 4. Define your repositories

Edit `config/repositories.yml`:

```yaml
my-awesome-project:
  description: "My awesome project"
  groups: ["base", "oss"]
  topics:
    - awesome
```

### 5. Apply configuration

```bash
make init
make plan   # Review changes
make apply  # Apply changes
```

## Project Structure

```text
.
├── config/                    # YAML configuration files
│   ├── config.yml             # Organization settings
│   ├── groups.yml             # Configuration groups
│   ├── repositories.yml       # Repository definitions
│   └── rulesets.yml           # Ruleset definitions
├── terraform/                 # Terraform code
│   ├── main.tf                # Entry point
│   ├── yaml-config.tf         # YAML parsing logic
│   ├── outputs.tf             # Output values
│   └── modules/repository/    # Repository module
├── docs/                      # Documentation
└── scripts/                   # Helper scripts
```

## Configuration Groups

Groups allow you to share settings across repositories:

```yaml
# config/groups.yml
oss:
  visibility: public
  has_issues: true
  delete_branch_on_merge: true
  rulesets:
    - oss-main-protection
```

Then reference in repositories:

```yaml
# config/repositories.yml
my-repo:
  description: "My open source project"
  groups: ["base", "oss"]
```

## Documentation

- [Quick Start Guide](docs/QUICKSTART.md)
- [Configuration Reference](docs/CONFIGURATION.md)
- [Customization Guide](docs/CUSTOMIZATION.md)

## Requirements

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- GitHub Personal Access Token with scopes:
  - `repo` - Full control of repositories
  - `admin:org` - Manage organization (for teams)
  - `delete_repo` - Delete repositories (optional)

## Commands

```bash
make init      # Initialize Terraform
make plan      # Preview changes
make apply     # Apply changes
make validate  # Validate configuration
make fmt       # Format Terraform files
```

## GitHub Subscription Tiers

| Feature | Free | Pro | Team | Enterprise |
|---------|------|-----|------|------------|
| Public repo rulesets | Yes | Yes | Yes | Yes |
| Private repo rulesets | No | Yes | Yes | Yes |
| Push rulesets | No | No | Yes | Yes |

The template automatically skips unsupported features based on your subscription tier.

## License

[MIT](LICENSE)
