# Data Pipeline Infrastructure

This Terraform configuration provisions a clean, focused data pipeline infrastructure for processing Google Analytics data through Google Cloud Platform to Azure Data Factory and Azure Data Lake Storage.

## Architecture

```
Google Analytics → Google Cloud Storage → Azure Data Factory → Azure Data Lake Storage
```

### Components

- **Google Cloud Storage**: Intermediate storage for GA data
- **Azure Data Factory**: Data orchestration and transformation
- **Azure Data Lake Storage**: Final data storage with hierarchical namespace
- **Azure Key Vault**: Secure storage for secrets and credentials
- **GCP Service Account**: Authentication for cross-cloud data access

## Prerequisites

1. **Azure CLI** installed and authenticated
2. **Google Cloud SDK** installed and authenticated
3. **Terraform** >= 1.0 installed
4. **Azure Subscription** with appropriate permissions
5. **Google Cloud Project** with billing enabled

## Environment Structure

This project follows HashiCorp best practices for environment management:

```
.
├── modules/                    # Reusable Terraform modules
│   ├── resource-group/
│   ├── adls/
│   ├── adf/
│   ├── gcs/
│   ├── gcp-service-account/
│   └── key-vault/
├── environments/              # Environment-specific configurations
│   ├── dev/                  # Development environment
│   │   ├── stack/           # Terraform configuration files
│   │   │   ├── main.tf      # Dev-specific configuration
│   │   │   ├── variables.tf # Dev variables
│   │   │   ├── outputs.tf   # Dev outputs
│   │   │   └── backend.tf   # Dev state backend
│   │   ├── variables/       # Environment-specific variable values
│   │   │   └── main.tfvars  # Dev variable values
│   │   └── deploy.sh        # Dev deployment script
│   └── prod/                # Production environment
│       ├── stack/           # Terraform configuration files
│       │   ├── main.tf      # Prod-specific configuration
│       │   ├── variables.tf # Prod variables
│       │   ├── outputs.tf   # Prod outputs
│       │   └── backend.tf   # Prod state backend
│       ├── variables/       # Environment-specific variable values
│       │   └── main.tfvars  # Prod variable values
│       └── deploy.sh        # Prod deployment script
├── deploy.sh                # Root deployment script
└── README.md               # This file
```

## Quick Start

### 1. Configure Environment Variables

Update the environment-specific `.tfvars` files:

```bash
# For development
vim environments/dev/variables/main.tfvars

# For production
vim environments/prod/variables/main.tfvars
```

Required configuration:
- `gcp_project_id`: Your Google Cloud Project ID
- `github_account_name`: Your GitHub organization/account name
- `github_repository_name`: Your GitHub repository name

### 2. Deploy Infrastructure

#### Option A: Using Root Script
```bash
# Deploy to development
./deploy.sh dev

# Deploy to production
./deploy.sh prod
```

#### Option B: Using Environment-Specific Scripts
```bash
# Deploy to development
cd environments/dev
./deploy.sh

# Deploy to production
cd environments/prod
./deploy.sh
```

## Environment Differences

### Development Environment
- **Storage Replication**: LRS (Locally Redundant Storage)
- **GCS Buckets**: `force_destroy = true` for easy cleanup
- **Deployment**: Simple confirmation prompt

### Production Environment
- **Storage Replication**: GRS (Geo-Redundant Storage) for higher availability
- **GCS Buckets**: `force_destroy = false` to protect data
- **Lifecycle Rules**: Automatic data retention policies
- **Deployment**: Extra confirmation with "yes" requirement

## Configuration

### Environment Variables

Each environment has its own configuration file:

- **Development**: `environments/dev/main.tfvars`
- **Production**: `environments/prod/main.tfvars`

### State Management

Each environment has its own Terraform state:

- **Development**: `dev.terraform.tfstate`
- **Production**: `prod.terraform.tfstate`

### Backend Configuration

Remote state storage using Azure Storage:

- **Development**: `tfstatemetricadev` storage account
- **Production**: `tfstatemetricaprod` storage account

## Security Features

- **Private networking**: All Azure resources use private endpoints
- **RBAC**: Role-based access control enabled
- **Encryption**: Data encrypted at rest and in transit
- **Secret management**: Credentials stored in Azure Key Vault
- **Service accounts**: Least-privilege access for GCP integration

## Data Flow

1. **Data Ingestion**: Google Analytics data is collected and stored in GCS
2. **Data Processing**: Azure Data Factory orchestrates data movement and transformation
3. **Data Storage**: Processed data is stored in Azure Data Lake Storage
4. **Data Access**: Data can be accessed through ADLS for analytics and reporting

## Cleanup

To destroy the infrastructure:

```bash
# Development
cd environments/dev
terraform destroy -var-file="main.tfvars"

# Production
cd environments/prod
terraform destroy -var-file="main.tfvars"
```

## Best Practices Followed

- **Environment separation**: Isolated configurations and state files
- **Modular design**: Reusable modules for each component
- **Security first**: Private networking and RBAC
- **Naming conventions**: Consistent resource naming
- **State management**: Separate state files per environment
- **Documentation**: Clear documentation and examples
- **Validation**: Input validation for all variables

## Support

For issues or questions, please refer to the troubleshooting guide or create an issue in the repository.
