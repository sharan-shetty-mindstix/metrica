#!/bin/bash

echo "🧹 Cleaning up Terraform files..."
echo "=================================="

# Find and remove all terraform init files
echo "🔍 Searching for Terraform files to clean up..."

# Remove .terraform directories
terraform_dirs=$(find . -name ".terraform" -type d 2>/dev/null)
if [ -n "$terraform_dirs" ]; then
    echo "🗑️  Removing .terraform directories:"
    echo "$terraform_dirs"
    find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null
else
    echo "✅ No .terraform directories found"
fi

# Remove .terraform.lock.hcl files
lock_files=$(find . -name ".terraform.lock.hcl" 2>/dev/null)
if [ -n "$lock_files" ]; then
    echo "🗑️  Removing .terraform.lock.hcl files:"
    echo "$lock_files"
    find . -name ".terraform.lock.hcl" -delete 2>/dev/null
else
    echo "✅ No .terraform.lock.hcl files found"
fi

# Remove terraform state files
state_files=$(find . -name "terraform.tfstate*" 2>/dev/null)
if [ -n "$state_files" ]; then
    echo "🗑️  Removing terraform.tfstate files:"
    echo "$state_files"
    find . -name "terraform.tfstate*" -delete 2>/dev/null
else
    echo "✅ No terraform.tfstate files found"
fi

# Remove terraform plan files
plan_files=$(find . -name "*.tfplan*" 2>/dev/null)
if [ -n "$plan_files" ]; then
    echo "🗑️  Removing .tfplan files:"
    echo "$plan_files"
    find . -name "*.tfplan*" -delete 2>/dev/null
else
    echo "✅ No .tfplan files found"
fi

# Remove crash logs
crash_files=$(find . -name "crash.log*" 2>/dev/null)
if [ -n "$crash_files" ]; then
    echo "🗑️  Removing crash.log files:"
    echo "$crash_files"
    find . -name "crash.log*" -delete 2>/dev/null
else
    echo "✅ No crash.log files found"
fi

echo ""
echo "🎉 Cleanup completed!"
echo ""
echo "💡 Remember:"
echo "   - Run this script after testing Terraform configurations"
echo "   - Never commit these files to version control"
echo "   - Use ./deploy.sh for fresh deployments"
