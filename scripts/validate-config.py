#!/usr/bin/env python3
"""
Validate YAML configuration files for GitHub organization management.

Usage:
    python scripts/validate-config.py
    python scripts/validate-config.py --strict
"""

import sys
import yaml
from pathlib import Path

CONFIG_DIR = Path(__file__).parent.parent / "config"

REQUIRED_FILES = [
    "config.yml",
    "groups.yml",
    "repositories.yml",
    "rulesets.yml",
]

VALID_VISIBILITIES = ["public", "private", "internal"]
VALID_PERMISSIONS = ["pull", "triage", "push", "maintain", "admin"]
VALID_RULE_TYPES = [
    "deletion",
    "non_fast_forward",
    "required_linear_history",
    "required_signatures",
    "pull_request",
    "required_status_checks",
    "creation",
    "update",
    "required_deployments",
    "branch_name_pattern",
    "commit_message_pattern",
    "commit_author_email_pattern",
    "committer_email_pattern",
]


def load_yaml(filepath: Path) -> dict:
    """Load and parse a YAML file."""
    try:
        with open(filepath) as f:
            return yaml.safe_load(f) or {}
    except yaml.YAMLError as e:
        raise ValueError(f"Invalid YAML in {filepath}: {e}")


def validate_config(config: dict) -> list[str]:
    """Validate config.yml."""
    errors = []

    if "organization" not in config:
        errors.append("config.yml: Missing required field 'organization'")

    subscription = config.get("subscription", "free")
    if subscription not in ["free", "pro", "team", "enterprise"]:
        errors.append(f"config.yml: Invalid subscription '{subscription}'")

    return errors


def validate_groups(groups: dict) -> list[str]:
    """Validate groups.yml."""
    errors = []

    for group_name, group_config in groups.items():
        if not isinstance(group_config, dict):
            errors.append(f"groups.yml: Group '{group_name}' must be a dictionary")
            continue

        # Validate visibility if specified
        visibility = group_config.get("visibility")
        if visibility and visibility not in VALID_VISIBILITIES:
            errors.append(
                f"groups.yml: Group '{group_name}' has invalid visibility '{visibility}'"
            )

        # Validate teams if specified
        teams = group_config.get("teams", {})
        if teams:
            for team, permission in teams.items():
                if permission not in VALID_PERMISSIONS:
                    errors.append(
                        f"groups.yml: Group '{group_name}' team '{team}' has invalid permission '{permission}'"
                    )

    return errors


def validate_repositories(repos: dict, groups: dict, rulesets: dict) -> list[str]:
    """Validate repositories.yml."""
    errors = []

    for repo_name, repo_config in repos.items():
        if not isinstance(repo_config, dict):
            errors.append(
                f"repositories.yml: Repository '{repo_name}' must be a dictionary"
            )
            continue

        # Check required fields
        if "description" not in repo_config:
            errors.append(
                f"repositories.yml: Repository '{repo_name}' missing 'description'"
            )

        if "groups" not in repo_config:
            errors.append(
                f"repositories.yml: Repository '{repo_name}' missing 'groups'"
            )
        else:
            # Validate group references
            for group in repo_config["groups"]:
                if group not in groups:
                    errors.append(
                        f"repositories.yml: Repository '{repo_name}' references unknown group '{group}'"
                    )

        # Validate visibility if specified
        visibility = repo_config.get("visibility")
        if visibility and visibility not in VALID_VISIBILITIES:
            errors.append(
                f"repositories.yml: Repository '{repo_name}' has invalid visibility '{visibility}'"
            )

        # Validate teams if specified
        teams = repo_config.get("teams", {})
        for team, permission in teams.items():
            if permission not in VALID_PERMISSIONS:
                errors.append(
                    f"repositories.yml: Repository '{repo_name}' team '{team}' has invalid permission '{permission}'"
                )

        # Validate ruleset references
        for ruleset in repo_config.get("rulesets", []):
            if ruleset not in rulesets:
                errors.append(
                    f"repositories.yml: Repository '{repo_name}' references unknown ruleset '{ruleset}'"
                )

    return errors


def validate_rulesets(rulesets: dict) -> list[str]:
    """Validate rulesets.yml."""
    errors = []

    for ruleset_name, ruleset_config in rulesets.items():
        if not isinstance(ruleset_config, dict):
            errors.append(
                f"rulesets.yml: Ruleset '{ruleset_name}' must be a dictionary"
            )
            continue

        # Check required fields
        if "target" not in ruleset_config:
            errors.append(f"rulesets.yml: Ruleset '{ruleset_name}' missing 'target'")
        elif ruleset_config["target"] not in ["branch", "tag"]:
            errors.append(
                f"rulesets.yml: Ruleset '{ruleset_name}' has invalid target '{ruleset_config['target']}'"
            )

        if "enforcement" not in ruleset_config:
            errors.append(
                f"rulesets.yml: Ruleset '{ruleset_name}' missing 'enforcement'"
            )
        elif ruleset_config["enforcement"] not in ["active", "evaluate", "disabled"]:
            errors.append(
                f"rulesets.yml: Ruleset '{ruleset_name}' has invalid enforcement '{ruleset_config['enforcement']}'"
            )

        if "conditions" not in ruleset_config:
            errors.append(
                f"rulesets.yml: Ruleset '{ruleset_name}' missing 'conditions'"
            )

        if "rules" not in ruleset_config:
            errors.append(f"rulesets.yml: Ruleset '{ruleset_name}' missing 'rules'")
        else:
            for rule in ruleset_config["rules"]:
                if "type" not in rule:
                    errors.append(
                        f"rulesets.yml: Ruleset '{ruleset_name}' has rule without 'type'"
                    )
                elif rule["type"] not in VALID_RULE_TYPES:
                    errors.append(
                        f"rulesets.yml: Ruleset '{ruleset_name}' has invalid rule type '{rule['type']}'"
                    )

    return errors


def main():
    """Main validation entry point."""
    strict = "--strict" in sys.argv
    all_errors = []

    print("Validating configuration files...")
    print()

    # Check required files exist
    for filename in REQUIRED_FILES:
        filepath = CONFIG_DIR / filename
        if not filepath.exists():
            all_errors.append(f"Missing required file: config/{filename}")

    if all_errors:
        for error in all_errors:
            print(f"ERROR: {error}")
        sys.exit(1)

    # Load all config files
    try:
        config = load_yaml(CONFIG_DIR / "config.yml")
        groups = load_yaml(CONFIG_DIR / "groups.yml")
        repos = load_yaml(CONFIG_DIR / "repositories.yml")
        rulesets = load_yaml(CONFIG_DIR / "rulesets.yml")
    except ValueError as e:
        print(f"ERROR: {e}")
        sys.exit(1)

    # Validate each file
    all_errors.extend(validate_config(config))
    all_errors.extend(validate_groups(groups))
    all_errors.extend(validate_rulesets(rulesets))
    all_errors.extend(validate_repositories(repos, groups, rulesets))

    # Report results
    if all_errors:
        print("Validation FAILED:")
        print()
        for error in all_errors:
            print(f"  - {error}")
        print()
        print(f"Found {len(all_errors)} error(s)")
        sys.exit(1)
    else:
        print("Validation PASSED")
        print()
        print(f"  - Organization: {config.get('organization', 'not set')}")
        print(f"  - Subscription: {config.get('subscription', 'free')}")
        print(f"  - Groups: {len(groups)}")
        print(f"  - Repositories: {len(repos)}")
        print(f"  - Rulesets: {len(rulesets)}")
        sys.exit(0)


if __name__ == "__main__":
    main()
