#!/bin/bash

echo "🚀 Deploying DEV Environment..."
echo "================================"

# Source environment variables
if [ -f "../variables/.env" ]; then
    echo "📁 Loading environment variables from .env file..."
    export $(cat ../variables/.env | grep -v '^#' | xargs)
else
    echo "⚠️  Warning: .env file not found. Using system environment variables."
fi

# Change to stack directory
cd stack

# Initialize Terraform
echo "🔧 Initializing Terraform..."
terraform init

# Import existing resources if they exist
echo "🔍 Checking for existing resources to import..."

# Import Azure Resource Group if it exists
if az group show --name metrica-mvp-rg-dev01 >/dev/null 2>&1; then
    echo "📦 Importing existing Azure Resource Group..."
    terraform import -var-file="../variables/terraform.tfvars" module.resource_group.azurerm_resource_group.rg /subscriptions/db86071b-e936-4caf-8cf4-455b661615a2/resourceGroups/metrica-mvp-rg-dev01 2>/dev/null || echo "Resource group already in state"
fi

# Import GCP Service Account if it exists
if gcloud iam service-accounts describe adf-ga4-integration@decent-terra-470507-j1.iam.gserviceaccount.com --project=decent-terra-470507-j1 >/dev/null 2>&1; then
    echo "🔑 Importing existing GCP Service Account..."
    terraform import -var-file="../variables/terraform.tfvars" module.gcp_service_account.google_service_account.adf_service_account projects/decent-terra-470507-j1/serviceAccounts/adf-ga4-integration@decent-terra-470507-j1.iam.gserviceaccount.com 2>/dev/null || echo "Service account already in state"
fi

# Import Workload Identity Pool if it exists
if gcloud iam workload-identity-pools describe azure-adf-pool --location=global --project=decent-terra-470507-j1 >/dev/null 2>&1; then
    echo "🔐 Importing existing Workload Identity Pool..."
    terraform import -var-file="../variables/terraform.tfvars" module.gcp_service_account.google_iam_workload_identity_pool.azure_pool[0] projects/decent-terra-470507-j1/locations/global/workloadIdentityPools/azure-adf-pool 2>/dev/null || echo "Workload identity pool already in state"
fi

# Import BigQuery Dataset if it exists
if bq show --project_id=decent-terra-470507-j1 ga4_data >/dev/null 2>&1; then
    echo "📊 Importing existing BigQuery Dataset..."
    terraform import -var-file="../variables/terraform.tfvars" module.bigquery_ga4.google_bigquery_dataset.ga4_dataset projects/decent-terra-470507-j1/datasets/ga4_data 2>/dev/null || echo "BigQuery dataset already in state"
fi

# Import BigQuery Tables if they exist
for table in events sessions users; do
    if bq show --project_id=decent-terra-470507-j1 ga4_data.$table >/dev/null 2>&1; then
        echo "📋 Importing existing BigQuery Table: $table..."
        terraform import -var-file="../variables/terraform.tfvars" module.bigquery_ga4.google_bigquery_table.ga4_${table}[0] projects/decent-terra-470507-j1/datasets/ga4_data/tables/$table 2>/dev/null || echo "Table $table already in state"
    fi
done

# Plan deployment
echo "📋 Planning deployment..."
terraform plan -var-file="../variables/terraform.tfvars"

# Ask for confirmation
echo ""
read -p "Do you want to proceed with the deployment? (y/N): " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled."
    exit 1
fi

# Apply deployment
echo "🚀 Applying deployment..."
terraform apply -auto-approve -var-file="../variables/terraform.tfvars"

echo ""
echo "✅ DEV Environment deployment completed!"
echo ""
echo "📊 Resources created:"
terraform output
