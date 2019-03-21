resource "aws_api_gateway_rest_api" "example" {
  name        = "${var.project_name}-api"
  description = "Demo API with proxy"
}


resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  parent_id   = "${aws_api_gateway_rest_api.example.root_resource_id}"
  path_part   = "{proxy+}"

}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_resource.proxy.id}"
  http_method   = "GET"
  authorization = "NONE"

}


resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  # http_method - (Required) The HTTP method (GET, POST, PUT, DELETE,

  # HEAD, OPTION, ANY) when calling the associated resource.
  resource_id = "${aws_api_gateway_method.proxy.resource_id}"
  http_method = "${aws_api_gateway_method.proxy.http_method}"

  # integration_http_method - (Optional) The integration HTTP method (GET, 
  # POST, PUT, DELETE, HEAD, OPTION) specifying how API Gateway will 
  # interact with the back end. Required if type is AWS, AWS_PROXY, HTTP 
  # or HTTP_PROXY. Not all methods are compatible with all AWS integrations.
  # e.g. Lambda function can only be invoked via POST.
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.example.invoke_arn}"

}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = "${aws_api_gateway_rest_api.example.id}"
  resource_id   = "${aws_api_gateway_rest_api.example.root_resource_id}"
  http_method   = "ANY"
  authorization = "NONE"

}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  resource_id = "${aws_api_gateway_method.proxy_root.resource_id}"
  http_method = "${aws_api_gateway_method.proxy_root.http_method}"

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "${aws_lambda_function.example.invoke_arn}"

}



resource "aws_api_gateway_deployment" "example" {
depends_on = [
    "aws_api_gateway_integration.lambda",
    "aws_api_gateway_integration.lambda_root",
  
]

  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  stage_name  = "test"

}

