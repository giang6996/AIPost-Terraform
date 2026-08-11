resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = var.security_group_ids

  iam_instance_profile = var.instance_profile_name

  associate_public_ip_address = false

  user_data = templatefile(
    "${path.module}/user-data.sh.tftpl",
    {}
  )

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 30
    encrypted             = true
    delete_on_termination = true
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(
    var.common_tags,
    {
      Name    = "${var.name_prefix}-jenkins"
      Purpose = "cicd"
    }
  )
}
