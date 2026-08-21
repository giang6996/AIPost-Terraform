resource "aws_iam_role" "this" {
  name               = "${var.name_prefix}-lb-controller-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json

  tags = var.common_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_policy" "this" {
  name = "${var.name_prefix}-lb-controller-policy"

  policy = file(
    "${path.module}/iam-policy.json"
  )

  tags = var.common_tags
}

resource "aws_eks_pod_identity_association" "this" {
  cluster_name = var.cluster_name

  namespace = "kube-system"

  service_account = "aws-load-balancer-controller"

  role_arn = aws_iam_role.this.arn
}

data "aws_iam_policy_document" "assume_role" {
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