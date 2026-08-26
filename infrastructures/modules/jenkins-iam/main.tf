data "aws_iam_policy_document" "jenkins_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole"
    ]
  }
}

data "aws_iam_policy_document" "jenkins_deploy" {

  // Netify deployment config parameter
  dynamic "statement" {
    for_each = (
      var.netlify_site_id_parameter_arn != null &&
      var.netlify_auth_token_parameter_arn != null
    ) ? [1] : []

    content {
      sid = "ReadNetlifyDeploymentConfig"

      actions = [
        "ssm:GetParameter"
      ]

      resources = [
        var.netlify_site_id_parameter_arn,
        var.netlify_auth_token_parameter_arn
      ]
    }
  }

  # Shared policy (EC2 + EKS)
  statement {
    sid    = "ECRAuthentication"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  statement {
    sid    = "PushBackendImages"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage"
    ]

    resources = [
      var.ecr_repository_arn
    ]
  }

  statement {
    sid    = "ListFrontendBucket"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.frontend_bucket_arn
    ]
  }

  statement {
    sid    = "DeployFrontendObjects"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "${var.frontend_bucket_arn}/*"
    ]
  }

  statement {
    sid    = "ReadProductionDatabaseUrl"
    effect = "Allow"

    actions = [
      "ssm:GetParameter"
    ]

    resources = [
      var.database_url_parameter_arn
    ]
  }

  # EC2 Environment only
  dynamic "statement" {
    for_each = var.initial_backend_image_tag_parameter_arn != null ? [1] : []

    content {
      sid    = "UpdateBackendReleaseTag"
      effect = "Allow"

      actions = [
        "ssm:PutParameter"
      ]

      resources = [
        var.initial_backend_image_tag_parameter_arn
      ]
    }
  }

  dynamic "statement" {
    for_each = var.backend_asg_arn != null ? [1] : []

    content {
      sid    = "StartBackendInstanceRefresh"
      effect = "Allow"

      actions = [
        "autoscaling:StartInstanceRefresh"
      ]

      resources = [
        var.backend_asg_arn
      ]
    }
  }

  dynamic "statement" {
    for_each = var.backend_asg_arn != null ? [1] : []

    content {
      sid    = "DescribeBackendDeployment"
      effect = "Allow"

      actions = [
        "autoscaling:DescribeInstanceRefreshes",
        "autoscaling:DescribeAutoScalingGroups"
      ]

      resources = ["*"]
    }
  }

  # EKS Environment only
  dynamic "statement" {
    for_each = var.eks_cluster_arn != null ? [1] : []

    content {
      sid    = "DescribeEksCluster"
      effect = "Allow"

      actions = [
        "eks:DescribeCluster"
      ]

      resources = [
        var.eks_cluster_arn
      ]
    }
  }
}

resource "aws_iam_role" "jenkins" {
  name               = "${var.name_prefix}-jenkins-role"
  assume_role_policy = data.aws_iam_policy_document.jenkins_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name    = "${var.name_prefix}-jenkins-role"
      Purpose = "jenkins-cicd"
    }
  )
}

resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.name_prefix}-jenkins-instance-profile"
  role = aws_iam_role.jenkins.name
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.jenkins.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "jenkins_deploy" {
  name   = "${var.name_prefix}-jenkins-deploy"
  policy = data.aws_iam_policy_document.jenkins_deploy.json

  tags = merge(
    var.common_tags,
    {
      Name    = "${var.name_prefix}-jenkins-deploy"
      Purpose = "jenkins-cicd"
    }
  )
}

resource "aws_iam_role_policy_attachment" "jenkins_deploy" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_deploy.arn
}