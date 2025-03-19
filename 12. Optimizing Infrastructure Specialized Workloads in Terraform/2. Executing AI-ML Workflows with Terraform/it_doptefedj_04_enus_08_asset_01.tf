provider "aws" {
  region = "us-east-1"
}

# S3 Bucket for Model Artifacts
resource "aws_s3_bucket" "model_bucket" {
  bucket = "ai-ml-model-artifacts"
  acl    = "private"
}

# CodePipeline for CI/CD
resource "aws_codepipeline" "ci_cd_pipeline" {
  name     = "ai-ml-cicd-pipeline"
  role_arn = aws_iam_role.pipeline_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.model_bucket.bucket
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration = {
        RepositoryName = aws_codecommit.repository.name
        BranchName     = "main"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["BuildArtifact"]

      configuration = {
        ProjectName = aws_codebuild.project.name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name             = "Deploy"
      category         = "Deploy"
      owner            = "AWS"
      provider         = "Lambda"
      version          = "1"
      input_artifacts  = ["BuildArtifact"]

      configuration = {
        FunctionName = aws_lambda_function.inference_lambda.function_name
      }
    }
  }
}

# CodeCommit Repository
resource "aws_codecommit_repository" "repository" {
  repository_name = "ai-ml-repo"
  description     = "Repository for AI/ML application code"
}

# CodeBuild Project
resource "aws_codebuild_project" "project" {
  name          = "ai-ml-build-project"
  description   = "Build project for AI/ML CI/CD pipeline"
  service_role  = aws_iam_role.build_role.arn
  source {
    type      = "CODECOMMIT"
    location  = aws_codecommit_repository.repository.clone_url_http
  }
  artifacts {
    type = "CODEPIPELINE"
  }
  environment {
    compute_type                = "BUILD_GENERAL1_LARGE"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
  }
}

# Lambda Function for Model Deployment
resource "aws_lambda_function" "inference_lambda" {
  filename         = "lambda-deploy.zip"
  function_name    = "inference-deploy"
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.9"

  environment {
    variables = {
      BUCKET_NAME = aws_s3_bucket.model_bucket.bucket
    }
  }
}

# IAM Roles
resource "aws_iam_role" "pipeline_role" {
  name               = "ci-cd-pipeline-role"
  assume_role_policy = data.aws_iam_policy_document.pipeline_assume_role.json
}

resource "aws_iam_role" "build_role" {
  name               = "ci-cd-build-role"
  assume_role_policy = data.aws_iam_policy_document.build_assume_role.json
}

resource "aws_iam_role" "lambda_execution_role" {
  name               = "lambda-execution-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

