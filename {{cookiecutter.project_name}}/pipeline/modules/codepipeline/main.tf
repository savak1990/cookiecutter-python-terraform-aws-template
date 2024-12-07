data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "${var.service_name}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = { Service = "codebuild.amazonaws.com" },
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# S3 Access Policy
resource "aws_iam_policy" "s3_access_policy" {
  name        = "${var.service_name}-s3-access-policy"
  description = "Policy to allow S3 access for CodeBuild"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::${var.root_bucket}",
          "arn:aws:s3:::${var.root_bucket}/${var.service_name}/*"
        ]
      }
    ]
  })
}

# Secrets Manager access policy
resource "aws_iam_policy" "codebuild_secrets_policy" {
  name        = "codebuild-secrets-access"
  description = "Policy to allow CodeBuild to read specific secrets"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = ["secretsmanager:GetSecretValue"],
        Resource = "arn:aws:secretsmanager:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:secret:${var.secret_name}*"
      }
    ]
  })
}

# Attach S3 Access Policy
resource "aws_iam_role_policy_attachment" "attach_s3_access_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.s3_access_policy.arn
}

# Attach CloudWatch Logs Policy
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Attach SecretsManager Policy
resource "aws_iam_role_policy_attachment" "codebuild_custom_secrets_access" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_secrets_policy.arn
}

# CodeBuild Project
resource "aws_codebuild_project" "build_project" {
  name         = var.service_name
  service_role = aws_iam_role.codebuild_role.arn

  source {
    type            = "GITHUB"
    location        = "https://github.com/${var.github_repo}"
    git_clone_depth = 1
  }

  artifacts {
    type      = "S3"
    location  = var.root_bucket
    packaging = "NONE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:5.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = false
  }
}
