# Getting the DNS of load balancer
output "app_lb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.app_alb.dns_name
}
