variable "name" {
  type        = string
  description = "Name prefix for the DynamoDB table"
}

variable "hash_key" {
  type        = string
  description = "Hash key for the DynamoDB table"
  
}

variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
  description = "List of attributes for the DynamoDB table"
  default = [
    {
      name = "Genre"
      type = "S"
    },
    {
      name = "Title"
      type = "S"
    },
    {
      name = "Author"
      type = "S"
    },
    {
      name = "Stock"
      type = "N"
    }
  ]
}

variable "table_items" {
  description = "List of items to add to the DynamoDB table"
  type        = list(map(any))
  default     = [
    {
      "ISBN"   = { S = "978-0134685991" }
      "Genre"  = { S = "Technology" }
      "Title"  = { S = "Effective Java" }
      "Author" = { S = "Joshua Bloch" }
      "Stock"  = { N = "1" }
    },
    {
      "ISBN"   = { S = "978-0062316097" }
      "Genre"  = { S = "Non-Fiction" }
      "Title"  = { S = "Sapiens" }
      "Author" = { S = "Yuval Noah Harari" }
      "Stock"  = { N = "3" }
    },
    {
      "ISBN"   = { S = "978-0451524935" }
      "Genre"  = { S = "Fiction" }
      "Title"  = { S = "1984" }
      "Author" = { S = "George Orwell" }
      "Stock"  = { N = "7" }
    }
  ]
}