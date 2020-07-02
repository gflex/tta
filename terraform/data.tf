data "aws_vpc" "default" {
  default = true
}

#obtain available availability zones in the reqion
data "aws_availability_zones" "available" {
  state             = "available"
  blacklisted_names = ["*c"]
}

data "template_file" "tmpl_role_ec2_ssm" {
  template = file("files/role_ec2_assume_role.json")
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
    REGION = var.aws_region
    ANS_APP_SSM = "/rbt/db/setup/ansible"
  }
}

data "template_file" "tpl_ansible_db" {
  template = file("files/db_playbook.yml")
  vars = {
    REGION = var.aws_region
    DB_ROOT_DIR = var.db_root_dir
    DB_ROOT_SSM = "/rbt/db/mysql/db_root_user"
    WP_DB_SSM = "/rbt/app/wordpress/wp_db_user"
    WP_DB_NAME_SSM = "/rbt/app/wordpress/db"
  }
}

data "template_file" "tpl_app_user_data" {
  template = file("files/app_user_data.sh")
  vars = {
    REGION = var.aws_region
    ANS_APP_SSM = "/rbt/app/wordpress/setup/ansible"
  }
}

data "template_file" "tpl_ansible_app" {
  template = file("files/app_wp_playbook.yml")
  vars = {
    WPDIR = var.wp_root_dir
    REGION = var.aws_region
    ADMIN_MAIL = "noreply@noreply.com"
    WP_DB_SSM = "/rbt/app/wordpress/wp_db_user"
    WP_DB_NAME_SSM = "/rbt/app/wordpress/db"
    WP_ADMIN_SSM = "/rbt/app/wordpress/wp_admin"
    WP_BLOG_SSM = "/rbt/app/wordpress/blog"
  }
}