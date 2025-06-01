data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vrush*"]
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name = "tag:Name"
    values = ["*public*"]
  }
}
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
  filter {
    name = "tag:Name"
    values = ["*private*"]
  }
}

data aws_ami "latest_amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}

