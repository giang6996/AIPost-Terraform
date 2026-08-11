resource "aws_ecr_repository" "backend" {
  name                 = "${var.name_prefix}-backend"
  image_tag_mutability = var.image_tag_mutability
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = merge(
    var.common_tags,
    {
      Name    = "${var.name_prefix}-backend"
      Purpose = "backend-container"
    }
  )
}