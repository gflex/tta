output "Wordpress_URL" {
  value = "http://${aws_alb.alb.dns_name}"
}

output "wp_admin" {
  value = var.wp_admin_user
}

output "wp_admin_password" {
  value     = nonsensitive(random_password.wp_admin_pass.result)
  sensitive = false
}
