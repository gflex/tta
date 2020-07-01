resource "aws_security_group" "sg_elb" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.project}_sg_elb"
  description = "ELB security group"
  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access from everywhere"
  }
  ingress {
    from_port   = 443
    protocol    = "tcp"
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access from everywhere"
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Outbound connections to Internet"
  }
  revoke_rules_on_delete = true
  tags                   = merge({ "Name" = "${var.project}_sg_web" }, local.common_tags)
}


resource "aws_security_group" "sg_app" {
  vpc_id      = aws_vpc.vpc.id
  name        = "${var.project}_sg_app"
  description = "web servers security group"
  ingress {
    from_port       = 80
    protocol        = "tcp"
    to_port         = 80
    security_groups = [aws_security_group.sg_elb.id]
    description     = "Allow access to port 80 from ELB"
  }
  ingress {
    from_port       = 443
    protocol        = "tcp"
    to_port         = 443
    security_groups = [aws_security_group.sg_elb.id]
    description     = "Allow access to port 443 from ELB"
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound connection to Internet"
  }
  revoke_rules_on_delete = true
  tags                   = merge({ "Name" = "${var.project}_sg_app" }, local.common_tags)

}

resource "aws_security_group" "sg_rds" {
  name        = "${var.project}_sg_rds"
  description = "DB server security group"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    security_groups = [aws_security_group.sg_app.id]
    description     = "Allow access to DB net from web servers"
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  revoke_rules_on_delete = true
  tags                   = merge({ "Name" = "${var.project}_sg_rds" }, local.common_tags)
}