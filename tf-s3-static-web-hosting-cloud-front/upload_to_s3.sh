#!/bin/bash

# Script to upload data from local folder to S3 bucket
# Usage: ./upload_to_s3.sh

# Get the bucket name from Terraform state
BUCKET_NAME=$(terraform output -raw bucket_name 2>/dev/null)

if [ -z "$BUCKET_NAME" ]; then
  # If output not available, use the variable from variables.tf
  BUCKET_NAME="$(grep -o 'default.*=.*\"[^\"]*\"' variables.tf | cut -d'"' -f2).sctp-sandbox.com"
  
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

# Upload to S3 without public-read ACL
aws s3 sync "$SOURCE_DIR" "s3://$BUCKET_NAME"

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo "Upload completed successfully!"
else
  echo "Upload failed. Please check your AWS credentials and permissions."
  echo "Make sure you have the AWS CLI installed and configured with appropriate credentials."
  echo "Error code: $?"
fi