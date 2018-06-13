
resource "aws_iam_role" "ecs_instance_role" {
  name = "aws_batch_ecs_instance_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "ec2.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_instance_role" {
  role       = "${aws_iam_role.ecs_instance_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name  = "aws_batch_ecs_instance_role"
  role = "${aws_iam_role.ecs_instance_role.name}"
}

resource "aws_iam_role" "aws_batch_service_role" {
  name = "aws_batch_service_role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
        "Service": "batch.amazonaws.com"
        }
    }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "aws_batch_service_role" {
  role       = "${aws_iam_role.aws_batch_service_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBatchServiceRole"
}

resource "aws_security_group" "aws_batch_demo" {
  name = "aws_batch_compute_environment_security_group"
}

resource "aws_vpc" "aws_batch_demo" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "aws_batch_demo"
  }
}

resource "aws_subnet" "aws_batch_demo" {
  vpc_id = "${aws_vpc.aws_batch_demo.id}"
  cidr_block = "10.1.1.0/24"
  tags = {
    Name = "aws_batch_demo"
  }
}

resource "aws_batch_compute_environment" "aws_batch_demo" {
  compute_environment_name = "aws_batch_demo"
  compute_resources {
    instance_role = "${aws_iam_instance_profile.ecs_instance_role.arn}"
    instance_type = [
      "c4.large",
    ]
    max_vcpus = 1024
    min_vcpus = 0
    security_group_ids = [
      "${aws_security_group.aws_batch_demo.id}"
    ]
    subnets = [
      "${aws_subnet.aws_batch_demo.id}"
    ]
    type = "EC2"
  }
  service_role = "${aws_iam_role.aws_batch_service_role.arn}"
  type = "MANAGED"
  depends_on = ["aws_iam_role_policy_attachment.aws_batch_service_role"]
}


output "aws_batch_compute_environment" {
  value = "${aws_batch_compute_environment.aws_batch_demo.compute_environment_name}"
}

