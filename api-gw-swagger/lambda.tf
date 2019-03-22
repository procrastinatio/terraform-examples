variable "app_version" {
}

data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "./code"
  output_path = "v${var.app_version}-lambda.zip"
}

resource "aws_lambda_function" "example" {
  function_name    = "${var.project_name}_lambda"
  filename         = "${data.archive_file.lambda.output_path}"
  handler          = "lambda.handler_echo"
  runtime          = "python3.6"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  publish          = true
  role             = "${aws_iam_role.lambda_exec.arn}"
}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.example.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  # aws_api_gateway_rest_api !!!!!
  source_arn    = "${aws_api_gateway_rest_api.example.execution_arn}/*/*"

}

output "lambda_arn" {
  value = "${aws_lambda_function.example.arn}"
}
