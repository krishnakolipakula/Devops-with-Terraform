provider "aws" {
  region = "us-west-2"
}

# S3 Bucket for Artifacts
resource "aws_s3_bucket" "ci_artifacts" {
  bucket = "ci-artifacts-bucket-${random_id.bucket_suffix.hex}"
  acl    = "private"
  tags = {
    Name = "CI Artifacts Bucket"
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# IAM Role for CodeBuild
resource "aws_iam_role" "codebuild_role" {
  name = "CodeBuildRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_policy" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# CodeBuild Project
resource "aws_codebuild_project" "ci_build" {
  name          = "CI-Build-Project"
  service_role  = aws_iam_role.codebuild_role.arn
  source {
    type      = "GITHUB"
    location  = "https://github.com/your-repo/your-project"
  }
  artifacts {
    type = "S3"
    location = aws_s3_bucket.ci_artifacts.bucket
  }
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }
}

# CodePipeline
resource "aws_codepipeline" "ci_pipeline" {
  name = "CI-Pipeline"

  role_arn = aws_iam_role.codebuild_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.ci_artifacts.bucket
  }

  stage {
    name = "Source"

    action {
      name            = "Source"
      category        = "Source"
      owner           = "AWS"
      provider        = "GitHub"
      version         = "1"
      output_artifacts = ["source_output"]
      configuration = {
        Owner      = "your-github-username"
        Repo       = "your-repo"
        Branch     = "main"
        OAuthToken = "your-github-oauth-token"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.ci_build.name
      }
    }
  }
}

