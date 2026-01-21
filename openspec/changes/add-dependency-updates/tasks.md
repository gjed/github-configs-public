## 1. Schema and Variables

- [ ] 1.1 Add `dependabot` variable to `terraform/modules/repository/variables.tf`
- [ ] 1.2 Add `renovate` variable to `terraform/modules/repository/variables.tf`
- [ ] 1.3 Add `renovate_file_path` variable with default `renovate.json`

## 2. File Generation Resources

- [ ] 2.1 Add `github_repository_file` resource for Dependabot in `main.tf`
- [ ] 2.2 Add `github_repository_file` resource for Renovate in `main.tf`
- [ ] 2.3 Add conditional logic to only create files when config is provided

## 3. Configuration Merging

- [ ] 3.1 Add Dependabot merge logic to `terraform/yaml-config.tf`
- [ ] 3.2 Add Renovate merge logic to `terraform/yaml-config.tf`
- [ ] 3.3 Handle `updates` list merging by ecosystem+directory key for Dependabot
- [ ] 3.4 Handle `packageRules` list concatenation for Renovate
- [ ] 3.5 Handle `extends` list merging and deduplication for Renovate

## 4. Module Integration

- [ ] 4.1 Pass merged Dependabot config from yaml-config.tf to repository module
- [ ] 4.2 Pass merged Renovate config from yaml-config.tf to repository module
- [ ] 4.3 Update `terraform/main.tf` module calls to include new variables

## 5. Example Configurations

- [ ] 5.1 Add example Dependabot group configuration to `config/groups.yml`
- [ ] 5.2 Add example Renovate group configuration to `config/groups.yml`
- [ ] 5.3 Add example repository with Dependabot override
- [ ] 5.4 Add example repository with Renovate override

## 6. Testing and Validation

- [ ] 6.1 Run `terraform validate` to verify syntax
- [ ] 6.2 Run `terraform plan` with example configurations
- [ ] 6.3 Verify generated Dependabot YAML is valid format
- [ ] 6.4 Verify generated Renovate JSON is valid format

## 7. Documentation

- [ ] 7.1 Document Dependabot configuration options in README
- [ ] 7.2 Document Renovate configuration options in README
- [ ] 7.3 Add migration notes for existing manual configs
