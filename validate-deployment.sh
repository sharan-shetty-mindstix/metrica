#!/bin/bash

echo "🔍 GA4 Analytics Infrastructure Validation"
echo "=========================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
    fi
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "environments/dev/stack/main.tf" ]; then
    echo -e "${RED}❌ Please run this script from the project root directory${NC}"
    exit 1
fi

echo "📋 Validating Terraform Configuration..."

# Check Terraform syntax
cd environments/dev/stack
terraform validate
print_status $? "Terraform configuration validation"

# Check if terraform.tfvars exists
if [ -f "../variables/terraform.tfvars" ]; then
    print_status 0 "terraform.tfvars file exists"
else
    print_status 1 "terraform.tfvars file missing"
fi

# Check for placeholder values in terraform.tfvars
echo ""
echo "🔍 Checking for placeholder values in terraform.tfvars..."
if grep -q "YOUR_" ../variables/terraform.tfvars; then
    print_warning "Found placeholder values in terraform.tfvars - please update with actual values"
    grep "YOUR_" ../variables/terraform.tfvars
else
    print_status 0 "No placeholder values found in terraform.tfvars"
fi

# Check Azure CLI authentication
echo ""
echo "🔍 Checking Azure CLI authentication..."
az account show > /dev/null 2>&1
print_status $? "Azure CLI authentication"

# Check GCP authentication
echo ""
echo "🔍 Checking GCP authentication..."
gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -1 > /dev/null 2>&1
print_status $? "GCP authentication"

# Check if GCP project is set
echo ""
echo "🔍 Checking GCP project configuration..."
if [ -n "$(gcloud config get-value project 2>/dev/null)" ]; then
    print_status 0 "GCP project is configured"
    echo "   Project: $(gcloud config get-value project)"
else
    print_status 1 "GCP project not configured"
fi

# Check Terraform providers
echo ""
echo "🔍 Checking Terraform providers..."
terraform init > /dev/null 2>&1
print_status $? "Terraform providers initialization"

# Check for required environment variables
echo ""
echo "🔍 Checking environment variables..."
required_vars=("AZURE_SUBSCRIPTION_ID" "AZURE_TENANT_ID" "GCP_PROJECT_ID")
missing_vars=()

for var in "${required_vars[@]}"; do
    if [ -z "${!var}" ]; then
        missing_vars+=("$var")
    fi
done

if [ ${#missing_vars[@]} -eq 0 ]; then
    print_status 0 "Required environment variables are set"
else
    print_status 1 "Missing required environment variables: ${missing_vars[*]}"
fi

# Check GA4 configuration
echo ""
echo "🔍 Checking GA4 configuration..."
if grep -q "ga4_property_id" ../variables/terraform.tfvars && ! grep -q "YOUR_GA4_PROPERTY_ID" ../variables/terraform.tfvars; then
    print_status 0 "GA4 property ID is configured"
else
    print_warning "GA4 property ID needs to be configured"
fi

if grep -q "ga4_data_stream_id" ../variables/terraform.tfvars && ! grep -q "YOUR_GA4_DATA_STREAM_ID" ../variables/terraform.tfvars; then
    print_status 0 "GA4 data stream ID is configured"
else
    print_warning "GA4 data stream ID needs to be configured"
fi

# Check BigQuery API
echo ""
echo "🔍 Checking BigQuery API..."
gcp_project=$(gcloud config get-value project 2>/dev/null)
if [ -n "$gcp_project" ]; then
    gcloud services list --enabled --filter="name:bigquery.googleapis.com" --format="value(name)" | grep -q "bigquery.googleapis.com"
    print_status $? "BigQuery API is enabled"
else
    print_warning "Cannot check BigQuery API - GCP project not configured"
fi

# Check Azure provider registration
echo ""
echo "🔍 Checking Azure provider registration..."
az provider show --namespace Microsoft.DataFactory --query "registrationState" --output tsv 2>/dev/null | grep -q "Registered"
print_status $? "Azure Data Factory provider is registered"

az provider show --namespace Microsoft.KeyVault --query "registrationState" --output tsv 2>/dev/null | grep -q "Registered"
print_status $? "Azure Key Vault provider is registered"

az provider show --namespace Microsoft.Storage --query "registrationState" --output tsv 2>/dev/null | grep -q "Registered"
print_status $? "Azure Storage provider is registered"

# Summary
echo ""
echo "📊 Validation Summary"
echo "===================="
echo "✅ Configuration validation completed"
echo ""
echo "📝 Next Steps:"
echo "1. Update placeholder values in terraform.tfvars"
echo "2. Configure GA4 property ID and data stream ID"
echo "3. Ensure all required environment variables are set"
echo "4. Run 'terraform plan' to review the deployment"
echo "5. Run 'terraform apply' to deploy the infrastructure"
echo ""
echo "📚 For detailed setup instructions, see:"
echo "   - GA4_SECURE_SETUP_GUIDE.md"
echo "   - environments/README.md"
echo ""
echo "🔐 Security Note: Store sensitive credentials in Azure Key Vault"
