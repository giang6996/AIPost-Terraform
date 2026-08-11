data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "backend" {
  name               = "${var.name_prefix}-backend-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-backend-role"
      Tier = "application"
    }
  )
}

resource "aws_iam_instance_profile" "backend" {
  name = "${var.name_prefix}-backend-profile"
  role = aws_iam_role.backend.name

  tags = merge(
    var.common_tags,
    {
      Name = "${var.name_prefix}-backend-profile"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.backend.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "backend_access" {
  statement {
    sid    = "ReadAIPostParameters"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]

    resources = var.parameter_arns
  }

  statement {
    sid    = "ListMediaBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.media_bucket_arn
    ]
  }

  statement {
    sid    = "ManageMediaObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${var.media_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "WriteBackendLogs"
    effect = "Allow"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "${var.cloudwatch_log_group_arn}:*"
    ]
  }

  statement {
    sid    = "AuthenticateToECR"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "PullBackendImage"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer"
    ]

    resources = [
      var.ecr_repository_arn
    ]
  }
}

resource "aws_iam_policy" "backend_access" {
  name        = "${var.name_prefix}-backend-access"
  description = "Least-privilege access required by the AIPost backend"
  policy      = data.aws_iam_policy_document.backend_access.json

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "backend_access" {
  role       = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.backend_access.arn
}