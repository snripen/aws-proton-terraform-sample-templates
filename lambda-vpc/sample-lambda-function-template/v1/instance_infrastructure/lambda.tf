resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"]

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

data "archive_file" "lambda_zip" {
    type          = "zip"
    source_file   = "index.js"
    output_path   = "lambda_function.zip"
}

resource "aws_lambda_function" "lambda_service" {
  function_name     = var.service_instance.inputs.function_name
  filename          = "lambda_function.zip"
  role              = aws_iam_role.iam_for_lambda.arn
  source_code_hash  = "${data.archive_file.lambda_zip.output_base64sha256}"
  runtime           = "nodejs6.10"
  handler           = "index.handler"

#   vpc_config {
#     subnet_ids         = [var.environment.outputs.subnet_id]
#     security_group_ids = [var.environment.outputs.security_group_id]
#   }
  
}
