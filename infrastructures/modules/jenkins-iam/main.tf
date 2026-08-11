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
    sid    = "UpdateBackendReleaseTag"
    effect = "Allow"

    actions = [
      "ssm:PutParameter"
    ]

    resources = [
      var.backend_image_tag_parameter_arn
    ]
  }

  statement {
    sid    = "StartBackendInstanceRefresh"
    effect = "Allow"

    actions = [
      "autoscaling:StartInstanceRefresh"
    ]

    resources = [
      var.backend_asg_arn
    ]
  }

  statement {
    sid    = "DescribeBackendDeployment"
    effect = "Allow"

    actions = [
      "autoscaling:DescribeInstanceRefreshes",
      "autoscaling:DescribeAutoScalingGroups"
    ]

    resources = ["*"]
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