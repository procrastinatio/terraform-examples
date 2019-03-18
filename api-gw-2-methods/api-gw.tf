

data "aws_caller_identity" "current" { }


# Now, we need an API to expose those functions publicly
resource "aws_api_gateway_rest_api" "hello_api" {
  name = "${var.api_name}"
}

# The API requires at least one "endpoint", or "resource" in AWS terminology.
# The endpoint created here is: /hello
resource "aws_api_gateway_resource" "hello_api_res_hello" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  parent_id   = "${aws_api_gateway_rest_api.hello_api.root_resource_id}"
  path_part   = "hello"
}

# Until now, the resource created could not respond to anything. We must set up
# a HTTP method (or verb) for that!
# This is the code for method GET /hello, that will talk to the first lambda
module "hello_get" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  resource_id = "${aws_api_gateway_resource.hello_api_res_hello.id}"
  method      = "GET"
  path        = "${aws_api_gateway_resource.hello_api_res_hello.path}"
  lambda      = "${module.lambda.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

# This is the code for method POST /hello, that will talk to the second lambda
module "hello_post" {
  source      = "./api_method"
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  resource_id = "${aws_api_gateway_resource.hello_api_res_hello.id}"
  method      = "POST"
  path        = "${aws_api_gateway_resource.hello_api_res_hello.path}"
  lambda      = "${module.lambda_post.name}"
  region      = "${var.aws_region}"
  account_id  = "${data.aws_caller_identity.current.account_id}"
}

# We can deploy the API now! (i.e. make it publicly available)
resource "aws_api_gateway_deployment" "hello_api_deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.hello_api.id}"
  stage_name  = "production"
  description = "Deploy methods: ${module.hello_get.http_method} ${module.hello_post.http_method}"
}



output "api_url" {
  value = "https://${aws_api_gateway_deployment.hello_api_deployment.rest_api_id}.execute-api.${var.aws_region}.amazonaws.com/${aws_api_gateway_deployment.hello_api_deployment.stage_name}"

}

