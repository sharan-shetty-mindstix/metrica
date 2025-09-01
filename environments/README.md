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
│   │   ├── terraform.tfvars
│   │   ├── .env         # Environment variables (not in git)
│   │   └── .env.example # Template for .env file
│   └── deploy.sh        # Deployment script
├── stage/
│   ├── stack/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── variables/
│   │   ├── terraform.tfvars
│   │   ├── .env         # Environment variables (not in git)
│   │   └── .env.example # Template for .env file
│   └── deploy.sh
└── prod/
    ├── stack/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── variables/
    │   ├── terraform.tfvars
    │   ├── .env         # Environment variables (not in git)
    │   └── .env.example # Template for .env file
    └── deploy.sh
```

## Environment Variables & Security

### 🔐 **Using .env Files (Recommended)**

For security best practices, sensitive configuration values are stored in `.env` files that are **NOT committed to git**.

1. **Copy the template**:
   ```bash
   cp environments/dev/variables/.env.example environments/dev/variables/.env
   ```

2. **Edit the .env file** with your actual values:
   ```bash
   # Azure Configuration
   AZURE_LOCATION="East US"
   AZURE_SUBSCRIPTION_ID="your-actual-subscription-id"
   AZURE_TENANT_ID="your-actual-tenant-id"
   
   # GCP Configuration
   GCP_PROJECT_ID="your-actual-project-id"
   GCP_REGION="us-central1"
   ```

3. **The .env file is automatically loaded** by the deployment scripts

### 🚫 **Security Features**

- **`.env` files are in `.gitignore`** - Never committed to version control
- **`.env.example` files are committed** - Provide templates for team members
- **Environment variables are sourced** before terraform execution
- **Fallback to system environment variables** if .env file is missing

### 🔄 **Environment Variable Naming Convention**

Following industry best practices:

- **UPPER_CASE_WITH_UNDERSCORES** for environment variables
- **Descriptive names** that clearly indicate purpose
- **Grouped by service** (Azure, GCP, etc.)
- **Consistent across environments**

## Benefits of This Structure

1. **Separation of Concerns**: Configuration (stack) vs. values (variables)
2. **Better Organization**: Clear distinction between infrastructure code and environment values
3. **Easier Maintenance**: Variables can be updated without touching the main configuration
4. **Better Security**: Sensitive values can be managed separately and excluded from git
5. **Team Collaboration**: Developers can work on stack files while DevOps manages variables
6. **Environment Isolation**: Each environment can have different .env files

## Usage

### Deploying an Environment

1. **Set up environment variables**:
   ```bash
   # Copy template
   cp environments/dev/variables/.env.example environments/dev/variables/.env
   
   # Edit with your values
   nano environments/dev/variables/.env
   ```

2. **Navigate to the environment directory**:
   ```bash
   cd environments/dev
   ```

3. **Run the deployment script**:
   ```bash
   ./deploy.sh
   ```

   The script will:
   - Load environment variables from .env file
   - Change to the stack directory
   - Initialize Terraform
   - Plan the deployment
   - Ask for confirmation
   - Apply the changes
   - Show outputs

### Manual Terraform Commands

If you prefer to run Terraform commands manually:

1. **Source environment variables**:
   ```bash
   export $(cat environments/dev/variables/.env | grep -v '^#' | xargs)
   ```

2. **Navigate to the stack directory**:
   ```bash
   cd environments/dev/stack
   ```

3. **Initialize Terraform**:
   ```bash
   terraform init
   ```

4. **Plan deployment**:
   ```bash
   terraform plan -var-file="../variables/terraform.tfvars"
   ```

5. **Apply changes**:
   ```bash
   terraform apply -var-file="../variables/terraform.tfvars"
   ```

## Module Paths

Since the stack files are now in a subdirectory, module paths have been updated from:
- `../../modules/` to `../../../modules/`

## Variables

- **Stack Variables** (`stack/variables.tf`): Define the structure and types of variables
- **Environment Variables** (`.env`): Provide sensitive environment-specific values (not in git)
- **Terraform Variables** (`variables/terraform.tfvars`): Reference environment variables

## Best Practices

1. **Never commit .env files** - They contain sensitive information
2. **Use .env.example as templates** - Help team members set up their environments
3. **Use consistent naming** across environments
4. **Test changes** in dev/stage before applying to production
5. **Use workspaces** or separate state files for different environments
6. **Rotate credentials regularly** - Update .env files with new values
7. **Use different .env files** for different environments (dev, stage, prod)
8. **Always clean up terraform init files** after testing - Never commit .terraform/, .terraform.lock.hcl, or terraform.tfstate files

### 🧹 **Keeping Repository Clean**

After testing Terraform configurations, always remove these files:
```bash
# Remove terraform init files
rm -rf .terraform/ .terraform.lock.hcl terraform.tfstate*

# Or use the cleanup script
./cleanup.sh  # if you create one
```

**Why this matters:**
- **Repository size** - Terraform files can be large
- **Team collaboration** - Prevents conflicts between different environments
- **Security** - State files may contain sensitive information
- **Fresh deployments** - Ensures clean initialization each time
