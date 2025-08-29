# Environment Structure - HashiCorp Best Practices

This document explains the environment structure that follows HashiCorp's recommended practices for managing multiple environments with Terraform.

## Overview

The project now follows the **"Environment-per-directory"** pattern, which is one of HashiCorp's recommended approaches for managing multiple environments. This provides:

- **Complete isolation** between environments
- **Separate state files** for each environment
- **Environment-specific configurations** and variables
- **Independent deployments** without affecting other environments
- **Clear separation of concerns** following HashiCorp best practices

## Directory Structure

```
.
├── modules/                    # Reusable Terraform modules
│   ├── resource-group/        # Azure Resource Group module
│   ├── adls/                  # Azure Data Lake Storage module
│   ├── adf/                   # Azure Data Factory module
│   ├── gcs/                   # Google Cloud Storage module
│   ├── gcp-service-account/   # GCP Service Account module
│   └── key-vault/             # Azure Key Vault module
├── environments/              # Environment-specific configurations
│   ├── dev/                  # Development environment
│   │   ├── main.tf          # Dev-specific configuration
│   │   ├── variables.tf     # Dev variables with validation
│   │   ├── outputs.tf       # Dev outputs
│   │   ├── backend.tf       # Dev state backend configuration
│   │   ├── main.tfvars      # Dev variable values
│   │   └── deploy.sh        # Dev deployment script
│   └── prod/                # Production environment
│       ├── main.tf          # Prod-specific configuration
│       ├── variables.tf     # Prod variables with validation
│       ├── outputs.tf       # Prod outputs
│       ├── backend.tf       # Prod state backend configuration
│       ├── main.tfvars      # Prod variable values
│       └── deploy.sh        # Prod deployment script
├── deploy.sh                # Root deployment script
├── README.md               # Project documentation
└── .gitignore             # Git ignore rules
```

## Key Benefits

### 1. **Complete Environment Isolation**
- Each environment has its own directory
- Separate Terraform state files
- Independent configurations and variables
- No risk of accidentally affecting the wrong environment

### 2. **State Management**
- **Development**: `dev.terraform.tfstate` in `tfstatemetricadev` storage account
- **Production**: `prod.terraform.tfstate` in `tfstatemetricaprod` storage account
- No state conflicts between environments
- Easy to manage and troubleshoot

### 3. **Environment-Specific Configurations**

#### Development Environment
```hcl
# environments/dev/main.tf
module "adls" {
  # Development-specific settings
  account_replication_type = "LRS"  # Lower cost
}

module "gcs" {
  buckets = {
    ga-raw-data = {
      force_destroy = true  # Easy cleanup
    }
  }
}
```

#### Production Environment
```hcl
# environments/prod/main.tf
module "adls" {
  # Production-specific settings
  account_replication_type = "GRS"  # Higher availability
}

module "gcs" {
  buckets = {
    ga-raw-data = {
      force_destroy = false  # Protect data
      lifecycle_rules = [
        {
          age        = 365
          action_type = "Delete"
        }
      ]
    }
  }
}
```

### 4. **Variable Validation**
Each environment enforces its own variable validation:

```hcl
# environments/dev/variables.tf
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
  validation {
    condition     = var.environment == "dev"
    error_message = "This configuration is for dev environment only."
  }
}
```

### 5. **Deployment Scripts**
- **Development**: Simple confirmation prompt
- **Production**: Extra confirmation with "yes" requirement
- Environment-specific error handling and validation

## Deployment Workflow

### Option 1: Root Script (Recommended)
```bash
# Deploy to development
./deploy.sh dev

# Deploy to production
./deploy.sh prod
```

### Option 2: Environment-Specific Scripts
```bash
# Deploy to development
cd environments/dev
./deploy.sh

# Deploy to production
cd environments/prod
./deploy.sh
```

## Environment Differences

| Feature | Development | Production |
|---------|-------------|------------|
| **Storage Replication** | LRS (Locally Redundant) | GRS (Geo-Redundant) |
| **GCS Bucket Protection** | `force_destroy = true` | `force_destroy = false` |
| **Data Retention** | No lifecycle rules | 365-day retention policy |
| **Deployment Confirmation** | Simple prompt | "yes" required |
| **State Storage** | `tfstatemetricadev` | `tfstatemetricaprod` |
| **Resource Naming** | `metrica-dev-*` | `metrica-prod-*` |

## Security Considerations

### 1. **State Isolation**
- Separate storage accounts for each environment
- No cross-environment state access
- Environment-specific access controls

### 2. **Network Security**
- Private networking enabled for all resources
- RBAC enabled on Key Vault
- Service accounts with least-privilege access

### 3. **Data Protection**
- Development: Easy cleanup for testing
- Production: Data protection and retention policies

## Best Practices Implemented

### 1. **HashiCorp Recommendations**
- ✅ Environment-per-directory pattern
- ✅ Separate state files per environment
- ✅ Consistent naming conventions
- ✅ Input validation for all variables
- ✅ Modular design with clear boundaries

### 2. **Security Best Practices**
- ✅ Private networking by default
- ✅ RBAC and least-privilege access
- ✅ Encrypted storage and communication
- ✅ Secure credential management

### 3. **Operational Best Practices**
- ✅ Environment-specific configurations
- ✅ Clear deployment workflows
- ✅ Comprehensive documentation
- ✅ Error handling and validation

## Migration from Previous Structure

The previous structure had:
- Single `main.tf` file
- Environment variables in `.tfvars` files
- Shared state management

The new structure provides:
- **Better isolation** between environments
- **Clearer separation** of concerns
- **Easier maintenance** and troubleshooting
- **Follows HashiCorp best practices**

## Next Steps

1. **Configure Environment Variables**:
   ```bash
   vim environments/dev/main.tfvars
   vim environments/prod/main.tfvars
   ```

2. **Set up Backend Storage** (if not already configured):
   ```bash
   # Create storage accounts for state management
   az storage account create --name tfstatemetricadev --resource-group terraform-state-rg
   az storage account create --name tfstatemetricaprod --resource-group terraform-state-rg
   ```

3. **Deploy Environments**:
   ```bash
   ./deploy.sh dev
   ./deploy.sh prod
   ```

This structure provides a robust, scalable, and maintainable approach to managing multiple environments while following HashiCorp's recommended best practices.
