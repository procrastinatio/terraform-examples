

# Here is a first lambda function that will run the code `hello_lambda.handler`
module "lambda" {
  source  = "./lambda"
  name    = "hello_lambda"
  handler = "handler"
  runtime = "python2.7"
  role    = "${aws_iam_role.iam_role_for_lambda.arn}"
}

# This is a second lambda function that will run the code
# `hello_lambda.post_handler`
module "lambda_post" {
  source  = "./lambda"
  name    = "hello_lambda"
  handler = "post_handler"
  runtime = "python2.7"
  role    = "${aws_iam_role.iam_role_for_lambda.arn}"
}
