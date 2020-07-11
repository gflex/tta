data "aws_vpc" "default" {
  default = true
}

#obtain available availability zones in the reqion
data "aws_availability_zones" "available" {
  state         = "available"
}

data "template_file" "tmpl_role_ec2_ssm" {
  template = file("files/role_ec2_assume_role.json")
}

data "template_file" "iam_policy_ec2_tag" {
  template = file("files/policy_ec2_tagging.json")
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

data template_file "tpl_db_user_data" {
  template = file("files/db_user_data.sh")
  vars = {
    REGION         = var.aws_region
    PROJECT        = var.project
    DB_ROOT_DIR    = var.db_root_dir
    DB_ROOT_SSM    = "/${var.project}/db/mysql/db_root_user"
    WP_DB_SSM      = "/${var.project}/app/wordpress/wp_db_user"
    WP_DB_NAME_SSM = "/${var.project}/app/wordpress/db"
  }
}


data "template_file" "tpl_app_user_data" {
  template = file("files/app_user_data.sh")
  vars = {
    REGION         = var.aws_region
    WPDIR          = var.wp_root_dir
    PROJECT        = var.project
    ADMIN_MAIL     = "noreply@noreply.com"
    WP_DB_SSM      = "/${var.project}/app/wordpress/wp_db_user"
    WP_DB_NAME_SSM = "/${var.project}/app/wordpress/db"
    WP_ADMIN_SSM   = "/${var.project}/app/wordpress/wp_admin"
    WP_BLOG_SSM    = "/${var.project}/app/wordpress/blog"
  }
}
