# GitHub Organization Terraform for Gjed

> **Note:** This repository is a clone of [github-configs-template](https://github.com/gjed/github-configs-template) used to manage gjed's public repositories and serves as a working example of the template in action.

Manage your GitHub organization's repositories as code using Terraform and YAML configuration.

<!-- markdownlint-disable MD033 -->
<p align="center">
  <img src="docs/logo.png" alt="GitHub Organization Terraform Template" width="400">
</p>
<!-- markdownlint-enable MD033 -->

## Features

- **YAML-based configuration** - Human-readable repository definitions
- **Configuration groups** - Share settings across multiple repositories (DRY)
- **Repository rulesets** - Enforce branch protection and policies
- **GitHub Actions permissions** - Control which actions can run and workflow permissions
- **Webhook management** - Configure CI/CD and notification webhooks as code
- **Subscription-aware** - Gracefully handles GitHub Free tier limitations
- **Onboarding script** - Easily import existing repositories

## How It Works

```text
                                    ┌─────────────────────┐
                                    │       GitHub        │
                                    │                     │
┌─────────────────┐                 │  ┌──────────────┐   │
│ repositories.yml│                 │  │ tf-modules   │   │
│                 │                 │  └──────────────┘   │
│ - tf-modules    │    Terraform    │  ┌──────────────┐   │
│ - api-gateway   │ ──────────────> │  │ api-gateway  │   │
│ - docs-site     │                 │  └──────────────┘   │
│                 │                 │  ┌──────────────┐   │
└─────────────────┘                 │  │ docs-site    │   │
                                    │  └──────────────┘   │
                                    └─────────────────────┘
```

## License

[Apache 2.0](LICENSE)
