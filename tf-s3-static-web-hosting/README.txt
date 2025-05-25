This project creates a S3 project to host a static website
The s3 bucket allows public access
This peoject tests on the already created domain name sctp-sandbox.com for the CE10 learners
An A record is added to the route 53 service to point to the domain and an alias is created to point to the s3 service 
in the region 
A script has been added to allow upload of files from local directory to S3