terraform {
  backend "s3" {
    bucket         = "sctp-ce10-tfstate"
    key            = "vrush-dynamodb-tfstate"
    region         = "ap-southeast-1"
   
  }
}