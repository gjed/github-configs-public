# Tasks: Add GitHub Organization Terraform Template

## 1. Project Foundation

- [ ] 1.1 Update `openspec/project.md` with project context (purpose, tech stack, conventions)
- [ ] 1.2 Create `.gitignore` with Terraform, Python, and editor patterns
- [ ] 1.3 Create `.env.example` documenting required environment variables
- [ ] 1.4 Create `Makefile` with common operations (init, plan, apply, validate)

## 2. Configuration Structure

- [ ] 2.1 Create `config/config.yml` with organization settings and subscription tier
- [ ] 2.2 Create `config/groups.yml` with example configuration groups (oss, internal)
- [ ] 2.3 Create `config/repositories.yml` with example repository definitions
- [ ] 2.4 Create `config/rulesets.yml` with example rulesets (main protection, release protection)

## 3. Terraform Core

- [ ] 3.1 Create `terraform/main.tf` with provider configuration and module instantiation
- [ ] 3.2 Create `terraform/yaml-config.tf` with YAML parsing and configuration merging logic
- [ ] 3.3 Create `terraform/outputs.tf` with useful output values

## 4. Repository Module

- [ ] 4.1 Create `terraform/modules/repository/main.tf` with repository, team, collaborator, and ruleset resources
- [ ] 4.2 Create `terraform/modules/repository/variables.tf` with input variable definitions
- [ ] 4.3 Create `terraform/modules/repository/outputs.tf` with module outputs

## 5. Documentation

- [ ] 5.1 Create `README.md` with project overview, quick start, and feature summary
- [ ] 5.2 Create `docs/QUICKSTART.md` with step-by-step setup guide
- [ ] 5.3 Create `docs/CONFIGURATION.md` with configuration reference
- [ ] 5.4 Create `docs/CUSTOMIZATION.md` with extension and customization guidance

## 6. CI/CD and Tooling

- [ ] 6.1 Create `.github/workflows/terraform.yml` with plan/apply workflow
- [ ] 6.2 Create `scripts/validate-config.py` for YAML validation

## 7. Validation and Testing

- [ ] 7.1 Run `terraform init` and verify provider installation
- [ ] 7.2 Run `terraform validate` to check configuration syntax
- [ ] 7.3 Run `terraform plan` with example configuration (dry run)
- [ ] 7.4 Verify documentation renders correctly

## Dependencies

- Tasks in section 3 depend on section 2 (configuration files must exist)
- Tasks in section 4 can run in parallel with section 3
- Section 7 depends on all previous sections

## Parallelizable Work

- Sections 2, 5, 6 can be worked on in parallel
- Tasks 4.1-4.3 can be done in parallel
- Tasks 5.1-5.4 can be done in parallel
