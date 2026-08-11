output "alb_arn" {
  value = aws_lb.backend.arn
}

output "alb_dns_name" {
  value = aws_lb.backend.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.backend.arn
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}

output "alb_zone_id" {
  value = aws_lb.backend.zone_id
}