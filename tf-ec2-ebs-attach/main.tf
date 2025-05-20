module "ec2" {
  source              = "../tf-ec2-example"
  name                = var.name_prefix
  instance_type       = var.instance_type
  key_name            = var.key_name
  
}

resource "aws_ebs_volume" "ebs_example_volume" {
  availability_zone = module.ec2.instance_az
  size              = 1
  tags = {
    Name = "${var.name_prefix}-ebs-volume"
  }
  
}

resource "aws_volume_attachment" "ebs_example_attachment" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.ebs_example_volume.id
  instance_id = module.ec2.instance_id
 
}