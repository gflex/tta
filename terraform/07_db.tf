
# generate passwords for root db user and store in SSM
resource "random_password" "db_root_pass" {
  length      = 16
  special     = true
  min_special = 4
  min_numeric = 3
}

resource "random_password" "db_wp_pass" {
  length      = 16
  special     = true
  min_special = 4
  min_numeric = 3
}

resource "aws_ssm_parameter" "ssm_db_root_user" {
  name  = "/${var.project}/db/mysql/db_root_user/user"
  type  = "String"
  value = var.db_root_user
  tags  = local.common_tags
}


resource "aws_ssm_parameter" "ssm_db_root_pass" {
  name  = "/${var.project}/db/mysql/db_root_user/password"
  type  = "SecureString"
  value = random_password.db_root_pass.result
  tags  = local.common_tags
}

resource "aws_ssm_parameter" "ssm_wp_db_user" {
  name  = "/${var.project}/app/wordpress/wp_db_user/user"
  type  = "String"
  value = var.db_wp_user
  tags  = local.common_tags
}

resource "aws_ssm_parameter" "ssm_wp_db_pass" {
  name  = "/${var.project}/app/wordpress/wp_db_user/password"
  type  = "SecureString"
  value = random_password.db_wp_pass.result
  tags  = local.common_tags
}



resource "aws_ssm_parameter" "ssm_wp_db_name" {
  name  = "/${var.project}/app/wordpress/db/name"
  type  = "String"
  value = var.wp_db_name
  tags  = local.common_tags
}

## write dh host to ssm
resource "aws_ssm_parameter" "ssm_wp_db_host" {
  name  = "/${var.project}/app/wordpress/db/host"
  type  = "String"
  value = aws_instance.db_host.private_dns
}

resource "aws_instance" "db_host" {
  ami                    = data.aws_ami.latest_lx_ami.id
  instance_type          = var.db_inst_type
  vpc_security_group_ids = [aws_security_group.sg_rds.id]
  subnet_id              = aws_subnet.rds_subnets[0].id
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name
  availability_zone      = data.aws_availability_zones.available.names[0]
  user_data_base64       = base64encode(data.template_file.tpl_db_user_data.rendered)
  volume_tags            = merge({ "Name" : "${var.project}_ebs_db_vol" }, local.common_tags)
  tags                   = merge({"Name" : "${var.project}_db_host"}, local.common_tags)
}

## Create persistent EBS volume for DB
resource "aws_ebs_volume" "ebs_db_data" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = "10"
  tags              = merge({ "Name" : "${var.project}_ebs_db_vol" }, local.common_tags)
}

##Attach the volume
resource "aws_volume_attachment" "attach_db_volume" {
  device_name  = "/dev/xvdh"
  instance_id  = aws_instance.db_host.id
  volume_id    = aws_ebs_volume.ebs_db_data.id
  skip_destroy = true
}

