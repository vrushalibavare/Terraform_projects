#!/bin/bash

# Script to upload data from local downloads/static-web-hosting folder to S3 bucket
# Usage: ./upload_to_s3.sh

# Get the bucket name from Terraform state
BUCKET_NAME=$(terraform output -raw bucket_name 2>/dev/null)

if [ -z "$BUCKET_NAME" ]; then
  # If output not available, use the variable from variables.tf
  BUCKET_NAME="$(grep -o 'default.*=.*\"[^\"]*\"' variables.tf | cut -d'"' -f2)"
  
  if [ -z "$BUCKET_NAME" ]; then
    echo "Error: Could not determine bucket name from Terraform output or variables.tf"
    exit 1
  fi
fi

# Source directory - path to the static website files
SOURCE_DIR="/Users/apple/Documents/Project Data/static-website-example"

# Check if source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory $SOURCE_DIR does not exist."
  echo "Please update the SOURCE_DIR variable in this script to point to your static website files."
  exit 1
fi

echo "Uploading contents from $SOURCE_DIR to S3 bucket: $BUCKET_NAME"

# Upload to S3 with public-read ACL
aws s3 sync "$SOURCE_DIR" "s3://$BUCKET_NAME" 

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo "Upload completed successfully!"
  echo "Your website should be accessible at: http://$BUCKET_NAME.s3-website-$(aws configure get region).amazonaws.com"
else
  echo "Upload failed. Please check your AWS credentials and permissions."
fi