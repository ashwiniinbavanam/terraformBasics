locals {
  lambda_functions = {
    helloWorld = "lambda-functions-python/helloWorld"
    anotherFn  = "lambda-functions-python/helloPerson"
  }
}


resource "aws_iam_role" "lambda_role" {
 name   = "terraform_aws_lambda_role"
 assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# IAM policy for logging from a lambda

resource "aws_iam_policy" "iam_policy_for_lambda" {

  name         = "aws_iam_policy_for_terraform_aws_lambda_role"
  path         = "/"
  description  = "AWS IAM Policy for managing aws lambda role"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Policy Attachment on the role.

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role        = aws_iam_role.lambda_role.name
  policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}



#data "archive_file" "zip_the_python_code" {
# type        = "zip"
# source_dir  = "${path.module}/lambda-functions-python/"
# output_path = "${path.module}/lambda-functions-python/helloWorld.zip"
#}

data "archive_file" "lambda_zips" {
  for_each    = local.lambda_functions
  type        = "zip"
  source_dir  = "${path.module}/${each.value}"
  output_path = "${path.module}/${each.value}.zip"
}

resource "aws_lambda_function" "terraform_lambda_func1" {
 filename                       = "${path.module}/lambda-functions-python/helloWorld.zip"
 function_name                  = "Jhooq-Lambda-Function"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "helloWorld.lambda_handler"
 runtime                        = "python3.8"
 depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}


resource "aws_lambda_function" "terraform_lambda_func2" {
 filename                       = "${path.module}/lambda-functions-python/helloPerson.zip"
 function_name                  = "Person-Lambda-Function"
 role                           = aws_iam_role.lambda_role.arn
 handler                        = "helloPerson.lambda_handler"
 runtime                        = "python3.8"
 depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}


output "teraform_aws_role_output" {
 value = aws_iam_role.lambda_role.name
}

output "teraform_aws_role_arn_output" {
 value = aws_iam_role.lambda_role.arn
}

output "teraform_logging_arn_output" {
 value = aws_iam_policy.iam_policy_for_lambda.arn
}