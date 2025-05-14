resource "aws_dynamodb_table" "book_inventory" {
  name           = "vrush-bookinventory"
  billing_mode   = "PAY_PER_REQUEST"  # On-demand capacity mode
  hash_key       = "ISBN" # Partition key

  attribute {
    name = "ISBN"
    type = "S"  # String type
  }
}

resource "aws_dynamodb_table_item" "book_inventory_item_1" {
  table_name = aws_dynamodb_table.book_inventory.name
  hash_key   = aws_dynamodb_table.book_inventory.hash_key

  item = jsonencode({
    ISBN     = { S = "978-0134685991" }
    Genre    = { S = "Technology" }
    Title    = { S = "Effective Java" }
    Author   = { S = "Joshua Bloch" }
    Stock    = { N = "1" }
  })
}

resource "aws_dynamodb_table_item" "book_inventory_item_2" {
  table_name = aws_dynamodb_table.book_inventory.name
  hash_key   = aws_dynamodb_table.book_inventory.hash_key

  item = jsonencode({
    ISBN     = { S = "978-0134685009" }
    Genre    = { S = "Technology" }
    Title    = { S = "Learning Python" }
    Author   = { S = "Mark Lutz" }
    Stock    = { N = "2" }
  })
}

resource "aws_dynamodb_table_item" "book_inventory_item_3" {
  table_name = aws_dynamodb_table.book_inventory.name
  hash_key   = aws_dynamodb_table.book_inventory.hash_key

  item = jsonencode({
    ISBN     = { S = "974-0134789698" }
    Genre    = { S = "Fiction" }
    Title    = { S = "The Hitchhiker" }
    Author   = { S = "Douglas Adams" }
    Stock    = { N = "10" }
  })
}

resource "aws_dynamodb_table_item" "book_inventory_item_4" {
  table_name = aws_dynamodb_table.book_inventory.name
  hash_key   = aws_dynamodb_table.book_inventory.hash_key

  item = jsonencode({
    ISBN     = { S = "982-01346653457" }
    Genre    = { S = "Fiction" }
    Title    = { S = "Dune" }
    Author   = { S = "Frank Herbert" }
    Stock    = { N = "8" }
  })
}

resource "aws_dynamodb_table_item" "book_inventory_item_5" {
  table_name = aws_dynamodb_table.book_inventory.name
  hash_key   = aws_dynamodb_table.book_inventory.hash_key

  item = jsonencode({
    ISBN     = { S = "978-01346854325" }
    Genre    = { S = "Technology" }
    Title    = { S = "System Design" }
    Author   = { S = "Mark Lutz" }
    Stock    = { N = "1" }
  })
}
