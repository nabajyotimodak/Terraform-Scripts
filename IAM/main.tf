# SERVICE TO SERVICE COMMUNICATION ROLE

# Role for AWS-Lambda-DynamoDB Access

resource "aws_iam_role" "lambda_execution_role" {
  name        = "lambda_execution_role"
  description = "Role for accessing services from Lambda"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
  tags = {
    name = "lambda read from dynamodb"
  }
}

resource "aws_iam_role_policy_attachment" "SecretsManagerReadWrite_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_role_policy_attachment" "AmazonDynamoDBFullAccess_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "AWSXRayDaemonWriteAccess_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaDynamoDBExecutionRole_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaDynamoDBExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaVPCAccessExecutionRole_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "AWSLambdaRole_attach" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaRole"
}

# IAM role "EventBridge_Schedular_execution_Role"

resource "aws_iam_role" "EventBridge_Schedular_execution_Role2" {
  name = "EventBridge_Schedular_execution_Role2"
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Statement1",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "scheduler.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
  tags = {
    Name    = "EventBridge_Schedular_execution_Role2"
    Purpose = "For creating the EventBridge Schedules"
  }
}

# The "EventBridge_Schedular_Policy" creation and attaching in the "EventBridge_Schedular_execution_Role2" role

resource "aws_iam_role_policy" "EventBridge_Schedular_Policy" {
  name = "EventBridge_Schedular_Policy"
  role = aws_iam_role.EventBridge_Schedular_execution_Role2.id
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "VisualEditor0",
          "Effect" : "Allow",
          "Action" : "lambda:InvokeFunction",
          "Resource" : "*"
        }
      ]
    }
  )
}
