provider "aws" {
  region = "us-west-2"
}

# Create a DynamoDB table
resource "aws_dynamodb_table" "example" {
  name           = "example-table"
  billing_mode   = "PROVISIONED"  # Use provisioned mode to enable auto-scaling
  hash_key       = "id"
  range_key      = "timestamp"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "id"
    type = "S"
  }

  attribute {
    name = "timestamp"
    type = "N"
  }

  tags = {
    Name = "example-dynamodb-table"
  }
}

# Enable auto-scaling for read capacity
resource "aws_appautoscaling_target" "read_target" {
  max_capacity       = 20
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.example.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "read_scaling_policy" {
  name               = "read-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "table/${aws_dynamodb_table.example.name}"
  scalable_dimension = "dynamodb:table:ReadCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    target_value       = 70
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBReadCapacityUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

# Enable auto-scaling for write capacity
resource "aws_appautoscaling_target" "write_target" {
  max_capacity       = 20
  min_capacity       = 5
  resource_id        = "table/${aws_dynamodb_table.example.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"
}

resource "aws_appautoscaling_policy" "write_scaling_policy" {
  name               = "write-scaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "table/${aws_dynamodb_table.example.name}"
  scalable_dimension = "dynamodb:table:WriteCapacityUnits"
  service_namespace  = "dynamodb"

  target_tracking_scaling_policy_configuration {
    target_value       = 70
    predefined_metric_specification {
      predefined_metric_type = "DynamoDBWriteCapacityUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

