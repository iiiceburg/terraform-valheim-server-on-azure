# Initialize Terraform
- terraform init -upgrade

# Create a Terraform execution plan
- terraform plan -out main.tfplan

# Apply a Terraform execution plan
- terraform apply main.tfplan

# Verify the results
- terraform output -raw container_ipv4_address

# Clean up resources
- terraform plan -destroy -out main.destroy.tfplan
- terraform apply main.destroy.tfplan

