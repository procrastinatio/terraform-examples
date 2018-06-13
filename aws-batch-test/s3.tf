resource "aws_s3_bucket" "bucket" {
  bucket = "ltmom-aws-batch-test"
  acl    = "private"

  tags {
      Name        = "Test bucket fro AWS batch"
      Environment = "Testing"
  }
}

