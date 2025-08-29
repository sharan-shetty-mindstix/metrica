#!/bin/bash

# Production Environment Deployment Script
set -e

echo "🚀 Deploying Data Pipeline Infrastructure - Production Environment"

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
terraform init

# Plan deployment
echo "📋 Planning deployment..."
terraform plan -var-file="main.tfvars" -out="prod.tfplan"

# Confirm deployment with extra warning for production
echo "⚠️  WARNING: You are about to deploy to PRODUCTION environment!"
echo "⚠️  This will create/modify production resources that may affect live systems."
read -p "🤔 Are you absolutely sure you want to proceed? Type 'yes' to continue: " -r
echo
if [[ $REPLY == "yes" ]]; then
    echo "🚀 Applying Terraform configuration to production..."
    terraform apply "prod.tfplan"
    echo "✅ Production deployment completed successfully!"
else
    echo "❌ Production deployment cancelled."
    exit 0
fi
