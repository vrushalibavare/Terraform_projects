terraform {
  backend "s3" {
    bucket         = "vrush-tf-state-bucket"
    key            = "vrush-dynamodb-tfstate"
    region         = "ap-southeast-1"
   
  }
}