1.What is needed to authorize your EC2 to retrieve secrets from the AWS Secret Manager?

To authorize your EC2 instance to retrieve secrets from AWS Secrets Manager, you need to implement the following:

      - **IAM Role for EC2**: Create an IAM role with appropriate permissions to access Secrets Manager.
      - **Attach the IAM Role to EC2**: Associate this role with your EC2 instance.
      - **Appropriate Permissions**: Ensure the role has the necessary permissions to read specific secrets by following security best practices as below.
        - **Least Privilege**: Restrict access to only the specific secrets needed by using ARNs instead of `"*"` in the resource field.
        - **Use Conditions**: Add conditions to the IAM policy to restrict access based on tags, IP ranges, etc.
        - **Enable CloudTrail**: Monitor access to your secrets.

2. Derive the IAM policy (i.e. JSON)?
   Using the secret name prod/cart-service/credentials, derive a sensible ARN as the specific resource for access
   IAM policy attached to the IAM role
   {
   "Version": "2012-10-17",
   "Statement": [
   {
   "Effect": "Allow",
   "Action": [
   "secretsmanager:GetSecretValue",
   "secretsmanager:DescribeSecret"
   ],
   "Resource": "arn:aws:secretsmanager:_:_:secret:prod/cart-service/credentials-\*"
   }
   ]
   }

Attach this policy to an IAM role which in turn can be assumed by an EC2 instance to retrieve the given secret.
IAM role for EC2 to assume.
{
"Version": "2012-10-17",
"Statement": [
{
"Effect": "Allow",
"Principal": {
"Service": "ec2.amazonaws.com"
},
"Action": "sts:AssumeRole"
}
]
}
