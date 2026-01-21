## 1. Implementation

- [ ] 1.1 Create helper local to detect if config path is file or directory
- [ ] 1.2 Create helper local to load and merge YAML files from a directory
- [ ] 1.3 Update `repos_config` local to support file or directory loading
- [ ] 1.4 Update `groups_config` local to support file or directory loading
- [ ] 1.5 Update `rulesets_config` local to support file or directory loading

## 2. Documentation

- [ ] 2.1 Update `docs/CONFIGURATION.md` with split file examples
- [ ] 2.2 Add example directory structure in `docs/examples.md`

## 3. Validation

- [ ] 3.1 Test with existing single-file configuration (backward compatibility)
- [ ] 3.2 Test with directory-based configuration for repositories
- [ ] 3.3 Test with directory-based configuration for groups
- [ ] 3.4 Test with directory-based configuration for rulesets
- [ ] 3.5 Test single file precedence when both file and directory exist
- [ ] 3.6 Run `terraform validate` and `terraform plan`
