resource "aws_s3_bucket" "bucket" {
  bucket = "ltmom-aws-batch-test"
  acl    = "public-read"

  tags {
      Name        = "Test bucket fro AWS batch"
      Environment = "Testing"
  }
}

