data "aws_vpc" "default" {
  default = true
}

#obtain available availability zones in the reqion
data "aws_availability_zones" "available" {
  state = "available"
}


data "aws_ami" "latest_lx_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
