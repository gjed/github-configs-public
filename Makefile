.PHONY: help init plan apply destroy validate fmt clean

# Default target
help:
	@echo "GitHub Organization Terraform Management"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  init      Initialize Terraform (download providers)"
	@echo "  plan      Preview changes without applying"
	@echo "  apply     Apply changes to GitHub"
	@echo "  destroy   Destroy all managed resources (use with caution)"
	@echo "  validate  Validate Terraform configuration"
	@echo "  fmt       Format Terraform files"
	@echo "  clean     Remove Terraform cache and state files"
	@echo ""
	@echo "Environment:"
	@echo "  GITHUB_TOKEN must be set (see .env.example)"

# Initialize Terraform
init:
	@echo "Initializing Terraform..."
	cd terraform && terraform init

# Plan changes
plan:
	@echo "Planning Terraform changes..."
	cd terraform && terraform plan

# Apply changes
apply:
	@echo "Applying Terraform changes..."
	cd terraform && terraform apply

# Destroy resources (with confirmation)
destroy:
	@echo "WARNING: This will destroy all managed resources!"
	cd terraform && terraform destroy

# Validate configuration
validate:
	@echo "Validating Terraform configuration..."
	cd terraform && terraform validate

# Format Terraform files
fmt:
	@echo "Formatting Terraform files..."
	cd terraform && terraform fmt -recursive

# Clean up
clean:
	@echo "Cleaning up Terraform cache..."
	rm -rf terraform/.terraform
	rm -f terraform/.terraform.lock.hcl
	@echo "Note: State files (*.tfstate) are preserved for safety"
