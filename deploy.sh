#!/bin/bash

# Data Pipeline Infrastructure Deployment Script
# Usage: ./deploy.sh [dev|prod]

set -e

ENVIRONMENT=${1:-dev}

if [[ ! "$ENVIRONMENT" =~ ^(dev|prod)$ ]]; then
    echo "Error: Environment must be 'dev' or 'prod'"
    echo "Usage: ./deploy.sh [dev|prod]"
    exit 1
fi

echo "🚀 Deploying Data Pipeline Infrastructure for environment: $ENVIRONMENT"

# Navigate to environment directory
cd "environments/$ENVIRONMENT"

# Run environment-specific deployment script
./deploy.sh

echo "✅ Deployment completed for $ENVIRONMENT environment!"
