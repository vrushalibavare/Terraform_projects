data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["vrushali-vpc"]
  }
}

data "aws_ami" "latest_amazon_linux" {
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

data "aws_subnet" "selected" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["*public*-1a"]
  }
}