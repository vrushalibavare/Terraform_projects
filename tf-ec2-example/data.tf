data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = ["c10_learner_vpc"]
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

data aws_subnet "selected" {
  vpc_id = data.aws_vpc.selected.id

  filter {
    name   = "tag:Name"
    values = ["c10_learner_vpc-public-ap-southeast-1a"]
  }
}