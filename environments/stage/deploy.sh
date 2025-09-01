#!/bin/bash

echo "🚀 Deploying STAGE Environment..."
echo "================================="

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

# Plan deployment
echo "📋 Planning deployment..."
terraform plan -var-file="../variables/terraform.tfvars"

# Ask for confirmation
echo ""
read -p "Do you want to proceed with the deployment? (y/N): " -n 0 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Deployment cancelled."
    exit 1
fi

# Apply deployment
echo "🚀 Applying deployment..."
terraform apply -auto-approve -var-file="../variables/terraform.tfvars"

echo ""
echo "✅ STAGE Environment deployment completed!"
echo ""
echo "📊 Resources created:"
terraform output
