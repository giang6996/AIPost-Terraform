output "launch_template_id" {
  value = aws_launch_template.backend.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.backend.name
}