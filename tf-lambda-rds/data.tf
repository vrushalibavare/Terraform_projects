data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vrush*-vpc"]
  }
}

data "aws_subnets" "database" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-db-*"]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-private-*"]
  }
}

data "aws_db_subnet_group" "database" {
  name = data.aws_vpc.selected.tags["Name"]
}
