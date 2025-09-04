# GA4 Analytics Data Infrastructure with Terraform

This Terraform configuration provisions a secure, enterprise-grade data processing and analytics infrastructure for Google Analytics 4 (GA4) data. The infrastructure includes Azure Data Factory, Azure Data Lake Storage Gen2, Azure Key Vault, and secure connections to GCP BigQuery with Workload Identity Federation.

## 🏗️ **Architecture Overview**

```
GA4 Property → BigQuery → Azure Data Factory → Azure Data Lake Storage → Analytics
     ↓              ↓              ↓                    ↓                    ↓
  Analytics    Data Export    ETL Processing    Data Storage        Business
   Platform    (Automatic)    (Scheduled)      (Raw/Bronze/Silver/  Intelligence
                                                      Gold)
```

## 🔐 **Security Features**

- **Workload Identity Federation**: No long-lived service account keys
- **Azure Key Vault Integration**: Secure credential storage
- **Encryption**: Data encrypted at rest and in transit
- **Access Control**: RBAC and network security
- **Audit Logging**: Comprehensive monitoring and logging

## 🌍 **Environments**

- **DEV**: Development environment with basic security
- **STAGE**: Staging environment with enhanced security compliance

## 📁 **Project Structure**

```
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── stage/
│       ├── main.tf
│       ├── variables.tf
│       └── terraform.tfvars
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

## 📚 **Documentation**

- **[GA4 Secure Setup Guide](GA4_SECURE_SETUP_GUIDE.md)**: Comprehensive guide for secure GA4 integration
- **[Environment Setup](environments/README.md)**: Environment configuration and deployment

## 🚀 **Deployment Instructions**

### **Prerequisites:**
1. **Azure CLI** installed and authenticated
2. **Google Cloud SDK** installed and authenticated
3. **Terraform** (version >= 1.0)
4. **GA4 Property** configured with BigQuery export enabled

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

Edit `terraform.tfvars`:
```hcl
azure_location        = "East US"
azure_subscription_id = "your-actual-subscription-id"
azure_tenant_id       = "your-actual-tenant-id"
gcp_project_id        = "your-actual-gcp-project-id"
```

#### **For STAGE Environment:**
```bash
cd environments/stage
```

Edit `terraform.tfvars`:
```hcl
azure_location        = "East US"
azure_subscription_id = "your-actual-subscription-id"
azure_tenant_id       = "your-actual-tenant-id"
gcp_project_id        = "your-actual-gcp-project-id"
```

### **Step 4: Deploy Infrastructure**

#### **Deploy DEV Environment:**
```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

#### **Deploy STAGE Environment:**
```bash
cd environments/stage
terraform init
terraform plan
terraform apply
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
- **Storage Account**: Azure Data Lake Storage Gen2 with tiered containers (Raw/Bronze/Silver/Gold)
- **Key Vault**: Secure secrets and certificate management with GCP credentials
- **Data Factory**: GA4 data orchestration and processing pipelines
- **BigQuery Connection**: Secure connection to GCP BigQuery with Workload Identity
- **GCP Service Account**: Dedicated service account for Azure Data Factory
- **BigQuery Dataset**: GA4 analytics dataset with proper IAM permissions
- **Workload Identity Pool**: Secure authentication between Azure and GCP

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

---

**Happy Data Engineering! 🚀📊**
