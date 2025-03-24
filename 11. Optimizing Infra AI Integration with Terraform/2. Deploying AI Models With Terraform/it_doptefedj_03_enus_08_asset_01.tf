provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "model_storage" {
  bucket_prefix = "ai-model-bucket-"
  acl           = "private"

  tags = {
    Project = "AI Model Deployment"
  }
}

resource "aws_lambda_function" "model_inference" {
  function_name    = "model-inference"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  filename         = "lambda.zip" # Pre-packaged Lambda deployment artifact
  source_code_hash = filebase64sha256("lambda.zip")

  environment {
    variables = {
      MODEL_BUCKET = aws_s3_bucket.model_storage.id
    }
  }

  tags = {
    Environment = "Production"
  }
}

resource "aws_api_gateway_rest_api" "api" {
  name = "Model API"

  tags = {
    Project = "AI Model Deployment"
  }
}

resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "predict"
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.model_inference.invoke_arn
}

resource "aws_iam_role" "lambda_exec" {
  name               = "lambda_exec_role"
  assume_role_policy = file("lambda_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

