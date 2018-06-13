resource "aws_s3_bucket" "bucket" {
  bucket = "ltmom-aws-batch-test"
  acl    = "private"

  tags {
      Name        = "My bucket"
      Environment = "Dev"
  }
}


resource "aws_iam_role" "test" {
  name               = "test-role"
  assume_role_policy = "${file("assume-role-policy.json")}"

}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = "${file("policy-s3-bucket.json")}"

}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.test.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"

}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "batch_profile"
  roles = ["${aws_iam_role.test.name}"]

}
