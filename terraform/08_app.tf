#upload ansible wp play to SSM
resource "aws_ssm_parameter" "app_ansible_play" {
  name  = "/rbt/app/wordpress/setup/ansible"
  type  = "String"
  value = base64encode(data.template_file.tpl_ansible_app.rendered)
}

# write wp_admin username to SSM
resource "aws_ssm_parameter" "ssm_wp_admin_user" {
  name  = "/${var.project}/app/wordpress/wp_admin/user"
  type  = "String"
  value = var.wp_admin_user
  tags  = local.common_tags
}


# Generate wp_admin password
resource "random_password" "wp_admin_pass" {
  length      = 16
  special     = true
  min_special = 4
  min_numeric = 3
}
# Write wp_admin password to SSM
resource "aws_ssm_parameter" "ssm_wp_admin_pass" {
  name  = "/${var.project}/app/wordpress/wp_admin/password"
  type  = "SecureString"
  value = random_password.wp_admin_pass.result
  tags  = local.common_tags
}

# create launch template
resource "aws_launch_template" "lt_app" {
  name_prefix = "${var.project}_lt_"
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_instance_profile.name
  }
  instance_type = var.app_inst_type
  image_id      = data.aws_ami.latest_lx_ami.id
  monitoring {
    enabled = true
  }
  vpc_security_group_ids = [aws_security_group.sg_app.id]
  key_name               = aws_key_pair.deployer.key_name
  user_data              = base64encode(data.template_file.tpl_app_user_data.rendered)
  tag_specifications {
    resource_type = "volume"
    tags          = merge({ "Name" : "${var.project}_app_volume" }, local.common_tags)
  }
  tag_specifications {
    resource_type = "instance"
    tags          = merge({ "type" : "${var.project}_app_wp" }, local.common_tags)
  }
}

# create target group
resource "aws_lb_target_group" "alb_tgtGroup" {
  name     = "${var.project}-wp-tgt"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
  }
  tags = merge({ "Name" : "${var.project}-wp-tgt" }, local.common_tags)
}

# create ELB
resource "aws_alb" "alb" {
  name               = "${var.project}-alb"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg_elb.id]
  subnets            = module.public_subnets.subnets_ids
  tags               = merge({ "Name" : "${var.project}-alb" }, local.common_tags)
}

# create listener
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = 80
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tgtGroup.arn
  }
}

#s# upload the LB url to SSM (used for wp setup)
resource "aws_ssm_parameter" "dns_url" {
  name  = "/rbt/app/wordpress/wp_db_user/url"
  type  = "String"
  value = aws_alb.alb.dns_name
}


#create placement group
resource "aws_placement_group" "wp_pl_grp" {
  name     = "${var.project}-wp-pl-grp"
  strategy = "spread"
}
# create autoscaling group
## tbd
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.project}-asg"
  max_size                  = 2
  min_size                  = 1
  desired_capacity          = 2
  health_check_grace_period = 300
  health_check_type         = "ELB"
  force_delete              = true
  default_cooldown          = 120
  placement_group           = aws_placement_group.wp_pl_grp.name
  vpc_zone_identifier       = module.app_subnets.subnets_ids
  target_group_arns         = [aws_lb_target_group.alb_tgtGroup.arn]
  launch_template {
    id      = aws_launch_template.lt_app.id
    version = "$Latest"
  }
  tag {
    key = "project"
    value = var.project
    propagate_at_launch = true
  }
  tag {
    key = "applicant"
    propagate_at_launch = true
    value = var.applicant
  }
}

resource "aws_ssm_parameter" "blog_post" {
  name  = "/rbt/app/wordpress/blog/post1"
  type  = "String"
  value = file("files/blog_post.txt")
}