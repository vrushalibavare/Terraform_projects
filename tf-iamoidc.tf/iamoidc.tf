# Creates an IAM OIDC role for GitHub Actions to assume

data "aws_iam_openid_connect_provider" "oidc" {
  url = "https://token.actions.githubusercontent.com"
}

# Create an IAM role for GitHub Actions to assume
resource "aws_iam_role" "github_actions_role" {
  name = "Vrush-GitHubActionsRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = data.aws_iam_openid_connect_provider.oidc.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
            StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:vrushalibavare/coaching17:*"
          }
        }
      }
    ]
  })
}


# Terraform permissions for ECS, ECR, EC2, IAM, CloudWatch
resource "aws_iam_policy" "github_oidc_terraform_policy" {
  name = "TerraformECR_ECS_FargatePolicy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # ECS, ECR, Fargate, EC2 networking
      {
        Effect = "Allow",
        Action = [
          "ecs:*",
          "ecr:*",
          "ec2:*",
          "iam:*",
          #"iam:PassRole",
          #"iam:GetRole",
          #"iam:CreateRole",
          #"iam:AttachRolePolicy",
          #"iam:PutRolePolicy",
          "logs:*"
        ],
        Resource = "*" # Use "*" for broad permissions, or specify resources as needed
      },

      # ECR Auth token (for pushing images)
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken"
        ],
        Resource = "*"
      },

      # Application Auto Scaling permissions
      {
        Effect = "Allow",
        Action = "application-autoscaling:*",
        Resource = "*"
      },

      # S3 Terraform backend
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ],
        Resource = [ 
          "arn:aws:s3:::sctp-ce10-tfstate",
           "arn:aws:s3:::sctp-ce10-tfstate/*"
           ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_oidc_policy_attachment" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_oidc_terraform_policy.arn
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "Vrush-ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

