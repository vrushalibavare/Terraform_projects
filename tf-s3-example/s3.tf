resource "aws_s3_bucket" "bucket1" {
  bucket = "vrush-tf-state-bucket"  #Use a globally unique name
  force_destroy = true
}