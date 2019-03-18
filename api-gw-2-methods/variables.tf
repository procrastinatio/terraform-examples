variable "aws_region" {
  description = "AWS region"
  default     = "eu-west-1"
}
variable "profile" {
    description = "AWS profile to use (as in .aws/credentials)"
}

variable "api_name" {
    description = "AWS Api Gateway name"
}


output "aws_region" {
    value = "${var.aws_region}"
}
