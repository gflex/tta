output "Wordpress_URL" {
  value = aws_alb.alb.dns_name
}

output "wp_admin_user" {
  value = var.wp_admin_user
}

output "wp_admin_password" {
  value = random_password.wp_admin_pass.result
}