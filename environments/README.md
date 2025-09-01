# Terraform Environments

This directory contains the Terraform configurations for different environments (dev, stage, prod).

## Folder Structure

Each environment follows this recommended structure:

```
environments/
├── dev/
│   ├── stack/           # Terraform configuration files
│   │   ├── main.tf      # Main Terraform configuration
│   │   ├── variables.tf # Variable definitions
│   │   └── outputs.tf   # Output definitions (if any)
│   ├── variables/       # Environment-specific variable values
│   │   └── terraform.tfvars
│   └── deploy.sh        # Deployment script
├── stage/
│   ├── stack/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── variables/
│   │   └── terraform.tfvars
│   └── deploy.sh
└── prod/
    ├── stack/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── variables/
    │   └── terraform.tfvars
    └── deploy.sh
```

## Benefits of This Structure

1. **Separation of Concerns**: Configuration (stack) vs. values (variables)
2. **Better Organization**: Clear distinction between infrastructure code and environment values
3. **Easier Maintenance**: Variables can be updated without touching the main configuration
4. **Better Security**: Sensitive values can be managed separately
5. **Team Collaboration**: Developers can work on stack files while DevOps manages variables

## Usage

### Deploying an Environment

1. Navigate to the environment directory:
   ```bash
   cd environments/dev
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

   The script will:
   - Change to the stack directory
   - Initialize Terraform
   - Plan the deployment
   - Ask for confirmation
   - Apply the changes
   - Show outputs

### Manual Terraform Commands

If you prefer to run Terraform commands manually:

1. Navigate to the stack directory:
   ```bash
   cd environments/dev/stack
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Plan deployment:
   ```bash
   terraform plan -var-file="../variables/terraform.tfvars"
   ```

4. Apply changes:
   ```bash
   terraform apply -var-file="../variables/terraform.tfvars"
   ```

## Module Paths

Since the stack files are now in a subdirectory, module paths have been updated from:
- `../../modules/` to `../../../modules/`

## Variables

- **Stack Variables** (`stack/variables.tf`): Define the structure and types of variables
- **Environment Variables** (`variables/terraform.tfvars`): Provide environment-specific values

## Best Practices

1. **Never commit sensitive values** in terraform.tfvars files
2. **Use consistent naming** across environments
3. **Version control** the stack files but consider using Terraform Cloud or similar for variable management
4. **Test changes** in dev/stage before applying to production
5. **Use workspaces** or separate state files for different environments
