#!/bin/bash

echo "🚀 Deploying DEV Environment..."
echo "================================"

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
