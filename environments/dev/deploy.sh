#!/bin/bash

# Development Environment Deployment Script
set -e

echo "🚀 Deploying Data Pipeline Infrastructure - Development Environment"

# Check prerequisites
echo "📋 Checking prerequisites..."
command -v terraform >/dev/null 2>&1 || { echo "❌ Terraform is required but not installed. Aborting." >&2; exit 1; }
command -v az >/dev/null 2>&1 || { echo "❌ Azure CLI is required but not installed. Aborting." >&2; exit 1; }
command -v gcloud >/dev/null 2>&1 || { echo "❌ Google Cloud SDK is required but not installed. Aborting." >&2; exit 1; }

# Check authentication
echo "🔐 Checking authentication..."
az account show >/dev/null 2>&1 || { echo "❌ Azure CLI not authenticated. Run 'az login' first." >&2; exit 1; }
gcloud auth list --filter=status:ACTIVE --format="value(account)" | head -1 >/dev/null 2>&1 || { echo "❌ Google Cloud not authenticated. Run 'gcloud auth login' first." >&2; exit 1; }

# Initialize Terraform
echo "🔧 Initializing Terraform..."
cd stack
terraform init

# Plan deployment
echo "📋 Planning deployment..."
terraform plan -var-file="../variables/main.tfvars" -out="dev.tfplan"

# Confirm deployment
read -p "🤔 Do you want to apply this plan? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🚀 Applying Terraform configuration..."
    terraform apply "dev.tfplan"
    echo "✅ Development deployment completed successfully!"
    cd ..
else
    echo "❌ Deployment cancelled."
    cd ..
    exit 0
fi
