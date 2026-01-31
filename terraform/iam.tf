data "aws_iam_policy_document" "external_secrets" {
  statement {
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      "arn:aws:secretsmanager:${var.region}:*:secret:/dev/*",
      "arn:aws:secretsmanager:${var.region}:*:secret:/staging/*"
    ]
  }
}

resource "aws_iam_role" "external_secrets" {
  name = "external-secrets-role"

  assume_role_policy = module.eks.oidc_provider_arn != "" ? jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = module.eks.oidc_provider_arn
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${replace(module.eks.oidc_provider_arn, "https://", "")}:sub" =
          "system:serviceaccount:kube-system:external-secrets-sa"
        }
      }
    }]
  }) : ""
}