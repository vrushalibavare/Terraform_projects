module "dynamodb_table" {
  source   = "terraform-aws-modules/dynamodb-table/aws"

  name     = var.dynamodb_table_name
  hash_key = "short_id"

  attributes = [
    {
      name = "short_id"
      type = "S"
    }
  ]

  tags = {
    Terraform   = "true"
  }
}