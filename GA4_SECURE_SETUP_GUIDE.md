# GA4 Secure Integration Setup Guide

## 🔐 Security-First GA4 to BigQuery Integration

This guide provides a comprehensive, secure setup for integrating Google Analytics 4 (GA4) with Azure Data Factory and BigQuery, following security best practices.

## 🏗️ Architecture Overview

```
GA4 Property → BigQuery → Azure Data Factory → Azure Data Lake Storage
     ↓              ↓              ↓                    ↓
  Analytics    Data Export    ETL Processing    Data Storage
   Platform    (Automatic)    (Scheduled)      (Raw/Bronze/Silver/Gold)
```

## 🔒 Security Features Implemented

### 1. **Workload Identity Federation**
- ✅ No long-lived service account keys
- ✅ Azure-managed identity integration
- ✅ Automatic credential rotation
- ✅ Zero-trust authentication

### 2. **Azure Key Vault Integration**
- ✅ Secure credential storage
- ✅ Access policies and RBAC
- ✅ Audit logging
- ✅ Secret versioning

### 3. **Network Security**
- ✅ Private endpoints (configurable)
- ✅ Network access rules
- ✅ VNet integration

### 4. **Data Protection**
- ✅ Encryption at rest and in transit
- ✅ Data retention policies
- ✅ Access logging and monitoring

## 📋 Prerequisites

### 1. **Azure Requirements**
- Azure subscription with Contributor/Owner access
- Azure CLI installed and authenticated
- Terraform >= 1.0 installed

### 2. **GCP Requirements**
- GCP project with billing enabled
- Google Cloud SDK installed and authenticated
- GA4 property configured
- BigQuery API enabled

### 3. **GA4 Setup**
- GA4 property with data collection active
- BigQuery export enabled
- Data stream configured

## 🚀 Step-by-Step Setup

### Step 1: Configure GA4 BigQuery Export

1. **Enable BigQuery Export in GA4:**
   ```bash
   # Go to GA4 Admin → Data Streams → BigQuery Link
   # Follow the setup wizard to link to BigQuery
   # Ensure the dataset is created in your GCP project
   ```

2. **Get GA4 Property Information:**
   ```bash
   # Get Property ID from GA4 Admin → Property Settings
   # Get Data Stream ID from GA4 Admin → Data Streams
   ```

### Step 2: Configure Environment Variables

Create a `.env` file in `environments/dev/variables/`:

```bash
# Azure Configuration
AZURE_LOCATION="eastus"
AZURE_SUBSCRIPTION_ID="your-azure-subscription-id"
AZURE_TENANT_ID="your-azure-tenant-id"

# GCP Configuration
GCP_PROJECT_ID="decent-terra-470507-j1"
GCP_REGION="us-central1"

# GA4 Configuration
GA4_PROPERTY_ID="your-ga4-property-id"
GA4_DATA_STREAM_ID="your-ga4-data-stream-id"

# GCP Service Account (will be created by Terraform)
GCP_SERVICE_ACCOUNT_EMAIL="adf-ga4-integration@decent-terra-470507-j1.iam.gserviceaccount.com"
GCP_CLIENT_ID="your-gcp-client-id"
GCP_PRIVATE_KEY_ID="your-private-key-id"
GCP_PRIVATE_KEY="your-private-key-from-key-vault"
```

### Step 3: Deploy Infrastructure

```bash
# Navigate to dev environment
cd environments/dev

# Run deployment script
./deploy.sh
```

### Step 4: Configure GA4 Data Export

After deployment, configure GA4 to export data to your BigQuery dataset:

1. **In GA4 Admin:**
   - Go to Data Streams
   - Select your web stream
   - Click "BigQuery Link"
   - Select your GCP project
   - Choose the `ga4_data` dataset created by Terraform

2. **Verify Data Export:**
   ```bash
   # Check if GA4 data is being exported
   bq ls decent-terra-470507-j1:ga4_data
   
   # Check for events table
   bq ls decent-terra-470507-j1:ga4_data.events_*
   ```

## 🔧 Configuration Details

### Terraform Variables

The following variables need to be configured in `terraform.tfvars`:

```hcl
# GA4 Configuration
ga4_dataset_id       = "ga4_data"
ga4_property_id      = "YOUR_GA4_PROPERTY_ID"
ga4_data_stream_id   = "YOUR_GA4_DATA_STREAM_ID"

# Security Configuration
enable_workload_identity = true
key_vault_purge_protection_enabled = true
```

### Data Factory Pipelines

Three pipelines are created:

1. **GA4DataExtractionPipeline**: Extracts data from BigQuery to ADLS Raw layer
2. **GA4DataProcessingPipeline**: Processes data from Bronze to Silver layer
3. **GA4AnalyticsPipeline**: Creates analytics and KPI tables in Gold layer

## 🔍 Monitoring and Validation

### 1. **Check Data Factory Status**
```bash
# List pipelines
az datafactory pipeline list \
  --factory-name wgacamp-dapi-an-adf-dev01 \
  --resource-group wgacamp-dapi-an-rg-dev01

# Check pipeline runs
az datafactory pipeline-run list \
  --factory-name wgacamp-dapi-an-adf-dev01 \
  --resource-group wgacamp-dapi-an-rg-dev01
```

### 2. **Verify BigQuery Access**
```bash
# Test BigQuery access
bq query --use_legacy_sql=false \
  "SELECT COUNT(*) as event_count FROM \`decent-terra-470507-j1.ga4_data.events_*\`"
```

### 3. **Check ADLS Data**
```bash
# List containers
az storage container list \
  --account-name wgacanpdapianstblobdev01 \
  --auth-mode login

# Check raw data
az storage blob list \
  --account-name wgacanpdapianstblobdev01 \
  --container-name raw \
  --prefix ga4/ \
  --auth-mode login
```

## 🛡️ Security Best Practices

### 1. **Credential Management**
- ✅ Store all secrets in Azure Key Vault
- ✅ Use Workload Identity Federation
- ✅ Rotate credentials regularly
- ✅ Monitor access patterns

### 2. **Access Control**
- ✅ Principle of least privilege
- ✅ RBAC for all resources
- ✅ Network security groups
- ✅ Private endpoints where possible

### 3. **Monitoring**
- ✅ Enable audit logging
- ✅ Set up alerts for failed authentications
- ✅ Monitor data access patterns
- ✅ Regular security reviews

## 🚨 Troubleshooting

### Common Issues

#### 1. **Authentication Errors**
```bash
# Check service account permissions
gcloud projects get-iam-policy decent-terra-470507-j1 \
  --flatten="bindings[].members" \
  --format="table(bindings.role)" \
  --filter="bindings.members:adf-ga4-integration@decent-terra-470507-j1.iam.gserviceaccount.com"
```

#### 2. **BigQuery Access Issues**
```bash
# Verify dataset permissions
bq show --format=prettyjson decent-terra-470507-j1:ga4_data
```

#### 3. **Data Factory Pipeline Failures**
- Check linked service configuration
- Verify network connectivity
- Review activity logs in Azure portal

## 📊 Data Flow

### 1. **Raw Layer** (`/raw/ga4/`)
- Direct GA4 data from BigQuery
- Minimal processing
- Full data retention

### 2. **Bronze Layer** (`/bronze/ga4/`)
- Cleaned and validated data
- Schema standardization
- Data quality checks

### 3. **Silver Layer** (`/silver/ga4/`)
- Business logic applied
- Enriched data
- Aggregated metrics

### 4. **Gold Layer** (`/gold/ga4/`)
- KPI tables
- Business reports
- Analytics datasets

## 🔄 Maintenance

### Regular Tasks

1. **Weekly:**
   - Review pipeline execution logs
   - Check data quality metrics
   - Monitor storage costs

2. **Monthly:**
   - Rotate service account keys
   - Review access permissions
   - Update security policies

3. **Quarterly:**
   - Security audit
   - Performance optimization
   - Cost optimization review

## 📞 Support

For issues or questions:

1. Check Azure Data Factory monitoring logs
2. Review BigQuery query logs
3. Check Azure Key Vault access logs
4. Review Terraform deployment logs

## 🔗 Resources

- [GA4 BigQuery Export Documentation](https://support.google.com/analytics/answer/9358801)
- [Azure Data Factory Documentation](https://docs.microsoft.com/en-us/azure/data-factory/)
- [GCP Workload Identity Documentation](https://cloud.google.com/iam/docs/workload-identity-federation)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

---

**🔐 Security Note**: This setup follows enterprise security best practices. Always review and customize security settings based on your organization's requirements.
