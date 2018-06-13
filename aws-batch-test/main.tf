

output "aws_batch_job_definition" {
  value = "${aws_batch_job_definition.test.name}"

}
output "aws_batch_compute_environment" {
  value = "${aws_batch_compute_environment.sample.compute_environment_name}"

}

