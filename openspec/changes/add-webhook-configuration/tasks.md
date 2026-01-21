# Tasks: Add Webhook Configuration Support

## 1. Schema and Variables

- [ ] 1.1 Add `webhooks` variable to `terraform/modules/repository/variables.tf`
- [ ] 1.2 Define webhook object type with url, content_type, secret, events, active, insecure_ssl fields

## 2. Repository Module Implementation

- [ ] 2.1 Add `github_repository_webhook` resource to `terraform/modules/repository/main.tf`
- [ ] 2.2 Implement environment variable lookup for webhook secrets
- [ ] 2.3 Add webhook outputs to `terraform/modules/repository/outputs.tf`

## 3. Webhook Definitions Loading

- [ ] 3.1 Add logic to load webhook definitions from `config/webhook/` directory
- [ ] 3.2 Merge webhook definition files alphabetically
- [ ] 3.3 Handle missing `config/webhook/` directory gracefully (empty map)

## 4. Configuration Merging

- [ ] 4.1 Add webhook reference resolution logic to `terraform/yaml-config.tf`
- [ ] 4.2 Support both reference-by-name and inline webhook definitions
- [ ] 4.3 Implement group webhook merging (later groups override by name)
- [ ] 4.4 Implement repository webhook merging (repo overrides group by name)
- [ ] 4.5 Add validation for undefined webhook references
- [ ] 4.6 Pass merged webhooks to repository module

## 5. Example Configuration

- [ ] 5.1 Create `config/webhook/` directory with example files (commented out)
- [ ] 5.2 Add example webhook references to group configuration (commented out)
- [ ] 5.3 Add example webhook references to repository configuration (commented out)

## 6. Documentation

- [ ] 6.1 Update README with webhook configuration examples
- [ ] 6.2 Document supported GitHub events
- [ ] 6.3 Document secret handling pattern (`env:VAR_NAME`)
- [ ] 6.4 Document webhook definition vs reference pattern

## 7. Validation

- [ ] 7.1 Run `terraform validate` to verify syntax
- [ ] 7.2 Run `terraform plan` to verify resource creation
- [ ] 7.3 Test webhook inheritance from groups
- [ ] 7.4 Test repository-level webhook overrides
- [ ] 7.5 Test undefined webhook reference error handling
