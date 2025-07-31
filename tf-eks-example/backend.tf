terraform {
  backend "s3" {
    bucket = "sctp-ce10-tfstate"
    key    = "vrush-eks-example"
    region = "ap-southeast-1"
  }
    
  }
