# Change: Add Split Configuration File Support

## Why

As organizations grow, managing many repositories, groups, and rulesets in single YAML files becomes
unwieldy. Users need the flexibility to organize configurations into separate files within directories
for better maintainability and team ownership.

## What Changes

- Support loading configuration from either a single `<type>.yml` file OR a `<type>/` directory
  containing multiple `.yml` files
- Applies to: `repositories`, `groups`, and `rulesets` configuration types
- When a directory exists, all `.yml` files within it are loaded and merged
- Single file takes precedence if both file and directory exist (prevents ambiguity)

## Impact

- Affected specs: `repository-management`
- Affected code: `terraform/yaml-config.tf` (config loading logic)
- Backward compatible: existing single-file configurations continue to work unchanged
