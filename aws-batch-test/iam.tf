


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
