data "aws_vpc" "default" {
  default = true
}

#obtain available availability zones in the reqion
data "aws_availability_zones" "available" {
  state         = "available"
  exclude_names = ["eu-central-1c"]

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
    REGION = var.aws_region
    #ANS_APP_SSM    = "/rbt/db/setup/ansible"
    PROJECT        = var.project
    DB_ROOT_DIR    = var.db_root_dir
    DB_ROOT_SSM    = "/rbt/db/mysql/db_root_user"
    WP_DB_SSM      = "/rbt/app/wordpress/wp_db_user"
    WP_DB_NAME_SSM = "/rbt/app/wordpress/db"
  }
}


data "template_file" "tpl_app_user_data" {
  template = file("files/app_user_data.sh")
  vars = {
    REGION = var.aws_region
    //ANS_APP_SSM    = "/rbt/app/wordpress/setup/ansible"
    WPDIR          = var.wp_root_dir
    PROJECT        = var.project
    ADMIN_MAIL     = "noreply@noreply.com"
    WP_DB_SSM      = "/rbt/app/wordpress/wp_db_user"
    WP_DB_NAME_SSM = "/rbt/app/wordpress/db"
    WP_ADMIN_SSM   = "/rbt/app/wordpress/wp_admin"
    WP_BLOG_SSM    = "/rbt/app/wordpress/blog"
  }
}
