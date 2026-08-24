output "instance_id" {
  description = "ID of the Jenkins EC2 instance."
  value       = aws_instance.jenkins.id
}

output "private_ip" {
  description = "Private IP address of the Jenkins EC2 instance."
  value       = aws_instance.jenkins.private_ip
}

output "private_dns" {
  description = "Private DNS name of the Jenkins EC2 instance."
  value       = aws_instance.jenkins.private_dns
}
