variable "region" {
    default = "eu-west-1"
}

variable "profile" {
    description = "AWS credentials profile you want to use"
}

variable "job_queue" {
    default = "aws_demo_batch_job-queue"
    description = "AWS BAtch job queue to use"
}

variable "job_defn" {
  default="arn:aws:batch:eu-west-1:050475232797:job-definition/aws_batch_demo_job:10"
  description="AWS Batch job definition do use"
}

variable "aws_ce_ami_id" {
    default = "ami-947e627e"
    description="AMI to use for the AWS Batch computing environment. This is a custom one with 500GB on /mnt"
}
variable "ce_keypair" {
    default = "mm_newest_c2c"
    description="keypair to access instance which runs the batch job (debug only)"
}
