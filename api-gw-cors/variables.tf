variable "region" {
  default = "eu-west-1"
}

variable "profile" {
  description = "AWS credentials profile you want to use"
}

variable "project_name" {
  default     = "tf-gw-cors"
  description = "Prefix to use"
}

