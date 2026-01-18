# Quick Start Guide

This guide walks you through setting up the GitHub Organization Terraform Template.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- GitHub account with organization or personal account
- GitHub Personal Access Token

## Step 1: Create Your Repository

### Option A: Use GitHub Template

1. Click "Use this template" on the repository page
2. Name your new repository (e.g., `github-configs`)
3. Clone your new repository locally

### Option B: Fork the Repository

1. Fork this repository
2. Clone your fork locally

## Step 2: Create GitHub Token

1. Go to [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens)
2. Click "Generate new token (classic)"
3. Select scopes:
   - `repo` - Full control of private repositories
   - `admin:org` - Full control of orgs and teams
   - `delete_repo` - Delete repositories (optional)
4. Copy the token

## Step 3: Configure Environment

Create a `.env` file (never commit this):

```bash
cp .env.example .env
# Edit .env and add your token
```

Or export directly:

```bash
export GITHUB_TOKEN="ghp_your_token_here"
```

## Step 4: Configure Your Organization

Edit `config/config.yml`:

```yaml
organization: your-org-name  # Your GitHub org or username
subscription: free           # Your GitHub plan
```

## Step 5: Define Configuration Groups

Edit `config/groups.yml` to customize shared settings:

```yaml
base:
  teams:
    your-team: push  # Add your teams

oss:
  visibility: public
  has_issues: true
  # ... customize as needed

internal:
  visibility: private
  # ... customize as needed
```

## Step 6: Add Your Repositories

Edit `config/repositories.yml`:

```yaml
my-first-repo:
  description: "My first managed repository"
  groups: ["base", "oss"]
  topics:
    - terraform
    - managed

my-private-tool:
  description: "Internal tooling"
  groups: ["base", "internal"]
```

## Step 7: Initialize and Apply

```bash
# Initialize Terraform
make init

# Preview changes (safe - no modifications)
make plan

# Apply changes (creates/updates repositories)
make apply
```

## Step 8: Verify

After applying:

1. Check your GitHub organization for the new repositories
2. Verify settings match your configuration
3. Check rulesets are applied (for public repos on free tier)

## Next Steps

- Read [Configuration Reference](CONFIGURATION.md) for all available options
- Read [Customization Guide](CUSTOMIZATION.md) to extend the template
- Import existing repos with `./scripts/onboard-repos.sh --list`
- Set up CI/CD automation (see Customization Guide for examples)

## Troubleshooting

### "401 Unauthorized" error

- Verify your `GITHUB_TOKEN` is set correctly
- Check token has required scopes
- Ensure token hasn't expired

### "404 Not Found" for organization

- Verify organization name in `config/config.yml`
- Ensure token has access to the organization

### Rulesets not applied to private repos

- This is expected on GitHub Free tier
- Upgrade to Pro/Team for private repo rulesets

### Repository already exists

For existing repositories, import them:

```bash
cd terraform
terraform import 'module.repositories["repo-name"].github_repository.this' org-name/repo-name
```
