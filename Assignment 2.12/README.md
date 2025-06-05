1. What is the purpose of the execution role on the Lambda function?
   Establishes a trust relationship with the Lambda service through the assume role policy
   Grant permissions to Lambda to access AWS services and resources needed for function execution.

2. What is the purpose of the resource-based policy on the Lambda function?
   To allow the S3 service to invoke the Lambda function when specific events occur.

3. If the function is needed to upload a file into an S3 bucket, describe (i.e no need for the actual policies)

   - What is the needed update on the execution role?
     A new resource based policy will need to be attached to the execution role.

   - What is the new resource-based policy that needs to be added (if any)?
     A S3 policy should be attached to the Lambda execution role to allow the following.
     "s3:PutObject",
     "s3:PostObject",
     "s3:CopyObject",
     "s3:CompleteMultipartUpload"
