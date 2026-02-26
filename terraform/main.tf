# GitHub Organization Infrastructure as Code
# Uses the github-as-yaml module to manage repositories from YAML config.
#
# Prerequisites:
#   export GITHUB_TOKEN="ghp_..."
#
# Then run:
#   terraform init && terraform plan && terraform apply

terraform {
  required_version = ">= 1.0"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  # Uncomment to configure remote backend for team collaboration
  # backend "s3" {
  #   bucket = "your-terraform-state-bucket"
  #   key    = "github-org/terraform.tfstate"
  #   region = "us-east-1"
  # }
}

provider "github" {
  owner = "gjed"

  # Token is read from GITHUB_TOKEN environment variable
  # Token must have repo and admin:org scopes

  # Rate limiting for large organizations
  # GitHub API limits: 5000 requests/hour for authenticated requests
  read_delay_ms  = var.github_read_delay_ms
  write_delay_ms = var.github_write_delay_ms
}

module "github_org" {
  # Pin to a specific version tag for reproducible builds.
  source = "github.com/gjed/github-as-yaml//terraform?ref=1.0.0"

  # Path to the config directory relative to this file.
  # Must be a static string - computed values are not supported.
  config_path = "${path.root}/../config"

  # Optional: pass webhook secrets via environment variables or a secrets manager.
  webhook_secrets = var.webhook_secrets
}
