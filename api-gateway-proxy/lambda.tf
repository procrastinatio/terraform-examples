variable "app_version" {
}

data "archive_file" "lambda" {
    type = "zip"
    source_dir = "./code"
    output_path = "v${var.app_version}-lambda.zip"
}

resource "aws_lambda_function" "example" {
  function_name = "${var.project_name}_lambda"
  filename = "${data.archive_file.lambda.output_path}"
  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "lambda.handler_echo"
  runtime = "python3.6"
  source_code_hash = "${base64sha256(file("${data.archive_file.lambda.output_path}"))}"
  publish = true

  role = "${aws_iam_role.lambda_exec.arn}"

}

resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.example.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_deployment.example.execution_arn}/*/*"

}

output "api_gw_base_url" {
  value = "${aws_api_gateway_deployment.example.invoke_url}"
}
output "lambda_arn" {
  value = "${aws_lambda_function.example.arn}"
}
