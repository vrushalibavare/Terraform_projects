resource "aws_dynamodb_table" "table" {
  name           = "${var.name}-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key

  # Define primary key attribute
  attribute {
    name = var.hash_key
    type = "S"  # Assuming hash key is always a string
  }
  
  # Define additional attributes dynamically
  dynamic "attribute" {
    for_each = [for attr in var.attributes : attr if attr.name != var.hash_key]
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name = "${var.name}-dynamodb"
  }
}

resource "aws_dynamodb_table_item" "table_items" {
  count      = length(var.table_items)
  table_name = aws_dynamodb_table.table.name
  hash_key   = var.hash_key
  item       = jsonencode(var.table_items[count.index])
}