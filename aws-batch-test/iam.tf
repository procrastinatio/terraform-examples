
resource "aws_iam_role" "ecs_instance_role" {
  name = "ecs_instance_role_for_aws_batch"
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
# New
resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.ecs_instance_role.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "ecs_instance_role" {
  name  = "ecs_instance_role_for_batch"
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

# ---- IAM for S3 access -------------


resource "aws_iam_role" "s3-test-role" {
  name               = "aws-batch-test-role"
  assume_role_policy = "${file("assume-role-policy.json")}"

}

resource "aws_iam_policy" "policy" {
  name        = "aws-batch-test-policy"
  description = "AWS Batch S3 test policy"
  policy      = "${file("policy-s3-bucket.json")}"

}

# resource "aws_iam_policy_attachment" "test-attach" {
#   name       = "test-attachment"
#   roles      = ["${aws_iam_role.s3-test-role.name}"]
#   policy_arn = "${aws_iam_policy.policy.arn}"
# 
# }
# 
# resource "aws_iam_instance_profile" "test_profile" {
#   name  = "batch_profile"
#   roles = ["${aws_iam_role.s3-test-role.name}"]
# 
#}
