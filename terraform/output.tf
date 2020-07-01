output "lb_url" {
  value = aws_alb.alb.dns_name
}