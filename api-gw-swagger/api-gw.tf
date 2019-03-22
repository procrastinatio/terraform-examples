resource "aws_api_gateway_rest_api" "example" {
  # Name is from swagger.yaml
  name        = "${var.project_name}-api"
  description = "Demo API generated from Swagger"
  body        = "${data.template_file.example_api_swagger.rendered}"
}


data "template_file" example_api_swagger{
  template = "${file("swagger.yaml")}"

  vars {
      get_lambda_arn = "${aws_lambda_function.example.invoke_arn}"
      post_lambda_arn = "${aws_lambda_function.example.invoke_arn}"
  }

}

resource "aws_api_gateway_deployment" "swagger-api-gateway-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.example.id}"
  stage_name  = "test"

}

output "url" {
  value = "${aws_api_gateway_deployment.swagger-api-gateway-deployment.invoke_url}/positions"
}
