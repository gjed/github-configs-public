# M0Rf30 was granted write access on terraform-github-config-as-yaml outside
# Terraform. Adopt the existing collaborator instead of re-adding it.
# Safe to delete once applied.
import {
  to = module.github_org.module.repositories["terraform-github-config-as-yaml"].github_repository_collaborator.this["M0Rf30"]
  id = "terraform-github-config-as-yaml:M0Rf30"
}
