terraform {
  backend "s3" {
    bucket         = "vrush-tfstate-bucket"
    key            = "vrush-workflow-tfstate"
    region         = "ap-southeast-1"
   
  }
}