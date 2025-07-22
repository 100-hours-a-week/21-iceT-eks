output "alb_dns" {
  value = data.aws_lb.argocd_alb.dns_name
}