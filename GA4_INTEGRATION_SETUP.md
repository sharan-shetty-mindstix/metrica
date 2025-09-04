# GA4 Integration Setup Guide

## Overview

This guide explains how to set up Google Analytics 4 (GA4) integration with Azure Data Factory (ADF) to extract data from GCP and load it into Azure Data Lake Storage (ADLS) Gen2.

## Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│       GA4       │    │   Azure Data     │    │   Azure Data    │    │   Data Lake     │
│  (Google        │───▶│    Factory       │───▶│   Lake Storage  │───▶│   Layers        │
│   Analytics)    │    │   (ADF)          │    │   (ADLS Gen2)   │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘    └─────────────────┘
```

## Prerequisites

### 1. GCP Setup
- Google Analytics 4 property configured
- BigQuery project with GA4 data export enabled
- Service account with appropriate permissions
- GA4 API access enabled

### 2. Azure Setup
- Azure subscription with Data Factory and Storage services
- Resource group created
- Azure CLI configured and authenticated

### 3. Required Permissions

#### GCP Service Account Permissions
```json
{
  "role": "roles/bigquery.dataViewer",
  "role": "roles/bigquery.jobUser",
  "role": "roles/storage.objectViewer",
  "role": "roles/analyticsdata.reader"
}
```

#### Azure Permissions
- Contributor access to resource group
- Storage Account Contributor
- Data Factory Contributor

## Configuration Steps

### 1. Environment Variables Setup

Create a `.env` file or set the following environment variables:

```bash
# Azure Configuration
export AZURE_LOCATION="East US"
export AZURE_SUBSCRIPTION_ID="your-azure-subscription-id"
export AZURE_TENANT_ID="your-azure-tenant-id"

# GCP Configuration
export GCP_PROJECT_ID="your-gcp-project-id"
export GCP_REGION="us-central1"
export GCP_CREDENTIALS_FILE="~/.gcp/credentials.json"

# GCP Service Account Credentials
export GCP_SERVICE_ACCOUNT_EMAIL="your-service-account@your-project.iam.gserviceaccount.com"
export GCP_CLIENT_ID="your-client-id"
export GCP_PRIVATE_KEY_ID="your-private-key-id"
export GCP_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"

# GA4 Configuration
export GA4_PROPERTY_ID="123456789"
export GA4_DATA_STREAM_ID="1234567890"
export GA4_BIGQUERY_TABLE="ga4_events"

# GCP Service Account for Data Factory
export GCP_SERVICE_ACCOUNT_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----\n"
export GCP_TENANT_ID="your-gcp-tenant-id"

# BigQuery Configuration
export BIGQUERY_DATASET="wgaca_data"
export BIGQUERY_TABLE="sales_data"
```

### 2. GA4 Property and Data Stream Setup

#### Get GA4 Property ID
1. Go to [Google Analytics](https://analytics.google.com/)
2. Select your GA4 property
3. Go to Admin → Property Settings
4. Copy the Property ID (format: 123456789)

#### Get GA4 Data Stream ID
1. In GA4 Admin, go to Data Streams
2. Select your web stream
3. Copy the Stream ID (format: 1234567890)

#### Enable BigQuery Export
1. In GA4 Admin, go to Data Streams
2. Select your stream and click "BigQuery Link"
3. Follow the setup wizard to link to BigQuery
4. Ensure the `ga4_events` table is created

### 3. GCP Service Account Setup

#### Create Service Account
```bash
# Create service account
gcloud iam service-accounts create adf-ga4-integration \
    --display-name="ADF GA4 Integration" \
    --description="Service account for Azure Data Factory GA4 integration"

# Get the service account email
gcloud iam service-accounts list --filter="displayName:ADF GA4 Integration"
```

#### Grant Permissions
```bash
# Grant BigQuery permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:adf-ga4-integration@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/bigquery.dataViewer"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:adf-ga4-integration@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/bigquery.jobUser"

# Grant Storage permissions (if using GCS)
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:adf-ga4-integration@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.objectViewer"

# Grant GA4 API permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:adf-ga4-integration@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/analyticsdata.reader"
```

#### Create and Download Key
```bash
# Create service account key
gcloud iam service-accounts keys create ~/.gcp/adf-ga4-key.json \
    --iam-account=adf-ga4-integration@YOUR_PROJECT_ID.iam.gserviceaccount.com

# Convert to base64 for environment variable
cat ~/.gcp/adf-ga4-key.json | base64 -w 0
```

### 4. Deploy Infrastructure

#### Initialize Terraform
```bash
cd environments/dev
terraform init
```

#### Plan Deployment
```bash
terraform plan -var-file="variables/terraform.tfvars"
```

#### Apply Changes
```bash
terraform apply -var-file="variables/variables/terraform.tfvars"
```

## Data Pipeline Workflow

### 1. Data Ingestion Pipeline
- **Trigger**: Daily at 2 AM UTC
- **Source**: BigQuery GA4 events table
- **Destination**: ADLS Raw layer
- **Frequency**: Daily

### 2. Data Processing Pipelines
- **Raw → Bronze**: Data cleaning and validation
- **Bronze → Silver**: Business logic application
- **Silver → Gold**: KPI generation and aggregation

### 3. Data Quality Pipeline
- **Purpose**: Monitor data quality across all layers
- **Frequency**: After each processing step
- **Output**: Quality reports and alerts

## Data Lake Structure

```
/raw/ga4/
├── /api/           # Direct GA4 API data
├── /bigquery/      # BigQuery exported data
└── /metadata/      # Schema and API information

/bronze/ga4/
├── /events/        # Cleaned event data
├── /users/         # User dimension data
└── /sessions/      # Session dimension data

/silver/ga4/
├── /fact_tables/   # Business fact tables
├── /dimension_tables/ # Business dimension tables
└── /aggregated/    # Pre-aggregated metrics

/gold/ga4/
├── /kpis/          # Key Performance Indicators
├── /reports/       # Business reports
└── /analytics/     # Advanced analytics datasets
```

## Monitoring and Troubleshooting

### 1. Data Factory Monitoring
- Pipeline execution status in Azure portal
- Activity logs and error details
- Performance metrics and bottlenecks

### 2. Data Quality Monitoring
- Schema validation results
- Data completeness checks
- Business rule compliance

### 3. Common Issues

#### Authentication Errors
- Verify service account permissions
- Check service account key format
- Ensure proper role assignments

#### Data Extraction Issues
- Verify GA4 property ID and data stream ID
- Check BigQuery table permissions
- Validate API quotas and limits

#### Storage Issues
- Verify ADLS container permissions
- Check storage account network rules
- Ensure proper folder structure

## Security Considerations

### 1. Data Encryption
- Data encrypted at rest in ADLS
- Data encrypted in transit between services
- Service account keys stored securely

### 2. Access Control
- RBAC implemented for Azure resources
- Service account with minimal required permissions
- Network security rules for storage accounts

### 3. Compliance
- Data retention policies configurable
- Audit logging enabled
- Data lineage tracking

## Cost Optimization

### 1. Storage Costs
- Use appropriate storage tiers
- Implement lifecycle management policies
- Archive old data to cheaper storage

### 2. Data Factory Costs
- Optimize pipeline execution frequency
- Use appropriate integration runtime
- Monitor and optimize data movement

### 3. BigQuery Costs
- Optimize query patterns
- Use appropriate table partitioning
- Monitor slot usage

## Next Steps

1. **Test the Integration**: Run a small data extraction to verify connectivity
2. **Implement Data Quality Rules**: Define validation rules for each data layer
3. **Set up Monitoring**: Configure alerts and dashboards
4. **Optimize Performance**: Tune pipeline performance based on data volumes
5. **Implement Error Handling**: Add robust error handling and retry logic

## Support and Resources

- [Azure Data Factory Documentation](https://docs.microsoft.com/en-us/azure/data-factory/)
- [Google Analytics 4 API Documentation](https://developers.google.com/analytics/devguides/reporting/data/v1)
- [BigQuery Documentation](https://cloud.google.com/bigquery/docs)
- [Terraform Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)

