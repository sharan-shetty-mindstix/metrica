# Azure Data Infrastructure with Terraform

This Terraform configuration provisions a complete data processing and analytics infrastructure in Azure with GCP BigQuery integration. The infrastructure includes Azure Data Factory, Azure Data Lake Storage Gen2, Azure Key Vault, and connections to GCP BigQuery.

## 🏗️ **Architecture Overview**

```
GCP BigQuery → Azure Data Factory → Azure Data Lake Storage → Power BI
     ↓                    ↓                    ↓
  Data Source      Data Processing      Data Storage
  (External)       (ETL/ELT)          (RAW/Bronze/Silver/Gold)
```

**Data Flow:**
1. **BigQuery**: Source data from Google Cloud Platform
2. **Azure Data Factory**: Extract data from BigQuery and load into ADLS
3. **Azure Data Lake Storage**: Store raw data and processed data
4. **Power BI**: Consume data for analytics and reporting

## 🌍 **Environments**

- **DEV**: Development environment with basic security
- **STAGE**: Staging environment with enhanced security compliance

## 📁 **Project Structure**

```
├── environments/
│   ├── dev/
│   │   ├── deploy.sh
│   │   ├── stack/
│   │   │   ├── main.tf
│   │   │   └── variables.tf
│   │   └── variables/
│   │       └── terraform.tfvars
│   └── stage/
│       ├── deploy.sh
│       ├── stack/
│       │   ├── main.tf
│       │   └── variables.tf
│       └── variables/
│           └── terraform.tfvars
├── modules/
│   ├── resource-group/
│   ├── storage/
│   ├── key-vault/
│   ├── data-factory/
│   └── bigquery-connection/
└── README.md
```

## 🔐 **Required Credentials**

### **Azure Credentials:**
- Azure Subscription ID
- Azure Tenant ID
- Azure CLI authentication (Contributor or Owner role)

### **GCP Credentials:**
- GCP Project ID
- GCP Service Account Key File
- Service Account with BigQuery permissions

## 🚀 **Deployment Instructions**

### **Prerequisites:**
1. **Azure CLI** installed and authenticated
2. **Google Cloud SDK** installed and authenticated
3. **Terraform** (version >= 1.0)

### **Step 1: Azure Authentication**
```bash
# Login to Azure
az login

# Set your subscription
az account set --subscription "your-subscription-id"

# Get your tenant ID
az account show --query tenantId -o tsv
```

### **Step 2: GCP Authentication**
```bash
# Login to GCP
gcloud auth login

# Set your project
gcloud config set project your-project-id

# Create service account key (if needed)
gcloud iam service-accounts create terraform-sa \
    --display-name="Terraform Service Account"

gcloud projects add-iam-policy-binding your-project-id \
    --member="serviceAccount:terraform-sa@your-project-id.iam.gserviceaccount.com" \
    --role="roles/bigquery.admin"

gcloud iam service-accounts keys create ~/.gcp/credentials.json \
    --iam-account=terraform-sa@your-project-id.iam.gserviceaccount.com
```

### **Step 3: Configure Environment Variables**

#### **For DEV Environment:**
```bash
cd environments/dev
```

Edit `variables/terraform.tfvars`:
```hcl
azure_location        = "East US"
azure_subscription_id = "your-actual-subscription-id"
azure_tenant_id       = "your-actual-tenant-id"
gcp_project_id        = "your-actual-gcp-project-id"
gcp_service_account_email = "your-service-account@your-project.iam.gserviceaccount.com"
gcp_private_key       = "your-actual-private-key"
gcp_client_id         = "your-actual-client-id"
```

#### **For STAGE Environment:**
```bash
cd environments/stage
```

Edit `variables/terraform.tfvars`:
```hcl
azure_location        = "East US"
azure_subscription_id = "your-actual-subscription-id"
azure_tenant_id       = "your-actual-tenant-id"
gcp_project_id        = "your-actual-gcp-project-id"
gcp_service_account_email = "your-service-account@your-project.iam.gserviceaccount.com"
gcp_private_key       = "your-actual-private-key"
gcp_client_id         = "your-actual-client-id"
```

### **Step 4: Deploy Infrastructure**

#### **Deploy DEV Environment:**
```bash
cd environments/dev
./deploy.sh
```

#### **Deploy STAGE Environment:**
```bash
cd environments/stage
./deploy.sh
```

## 🔒 **Security Features**

### **DEV Environment:**
- Standard security settings
- Basic RBAC
- Standard Key Vault SKU

### **STAGE Environment:**
- Enhanced security compliance
- Purge protection enabled
- SOC2 compliance tags
- Enhanced monitoring

## 📊 **Resources Created**

- **Resource Group**: Organized resource management
- **Storage Account**: Azure Data Lake Storage Gen2 with tiered containers
- **Key Vault**: Secure secrets and certificate management
- **Data Factory**: Data orchestration and processing with BigQuery integration
- **BigQuery Connection**: Secure connection to GCP BigQuery as data source

## 🔄 **Data Pipeline**

The Azure Data Factory pipeline performs the following operations:

1. **CopyFromBigQuery**: Extracts data from BigQuery tables and loads into ADLS raw folder
2. **ProcessDataInADLS**: Processes the raw data and stores in ADLS processed folder

**Pipeline Activities:**
- **Source**: Google BigQuery (using BigQuery linked service)
- **Processing**: Azure Data Factory
- **Destination**: Azure Data Lake Storage (raw → processed)

## 🧹 **Cleanup**

To remove all resources:
```bash
terraform destroy
```

## 🆘 **Troubleshooting**

### **Common Issues:**
1. **Provider Registration**: Use `skip_provider_registration = true`
2. **Authentication**: Ensure both Azure and GCP are authenticated
3. **Permissions**: Verify Contributor/Owner role on Azure subscription
4. **Resource Names**: Ensure names meet Azure naming requirements

### **Useful Commands:**
```bash
# Check Azure context
az account show

# Check GCP context
gcloud config list

# Validate Terraform
terraform validate

# Check plan
terraform plan
```

## 💡 **Pro Tips**

- **Environment Separation**: Keep dev and stage configurations separate
- **State Management**: Consider using Azure Storage for Terraform state
- **Cost Monitoring**: Set up cost alerts in Azure Portal
- **Security**: Use managed identities where possible
- **BigQuery Integration**: Ensure proper IAM permissions for BigQuery access

---

**Happy Data Engineering! 🚀📊**
