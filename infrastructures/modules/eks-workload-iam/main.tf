resource "aws_iam_role" "backend" {
  name = "${var.name_prefix}-backend-pod-role"

  assume_role_policy = data.aws_iam_policy_document.aipost_pod_assume_role.json

  tags = var.common_tags
}

resource "aws_iam_policy" "backend" {
  name   = "${var.name_prefix}-backend-pod-policy"
  policy = data.aws_iam_policy_document.backend.json
}

resource "aws_iam_role_policy_attachment" "backend" {
  role       = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.backend.arn
}

resource "aws_eks_pod_identity_association" "backend" {
  cluster_name = var.cluster_name

  namespace = var.namespace

  service_account = var.service_account

  role_arn = aws_iam_role.backend.arn
}


data "aws_iam_policy_document" "aipost_pod_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

data "aws_iam_policy_document" "backend" {
  statement {
    sid    = "MediaBucketAccess"
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
    sid    = "MediaBucketList"
    effect = "Allow"

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      var.media_bucket_arn
    ]
  }

  statement {
    sid    = "ReadBackendParameters"
    effect = "Allow"

    actions = [
      "ssm:GetParameter",
      "ssm:GetParameters"
    ]

    resources = var.parameter_arns
  }
}