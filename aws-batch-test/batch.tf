
resource "aws_security_group" "sample" {
  name = "aws_batch_compute_environment_security_group"
}

resource "aws_vpc" "sample" {
  cidr_block = "10.1.0.0/16"
  tags {
    Name = "aws_batch_demo"
  }
}

resource "aws_subnet" "sample" {
  vpc_id = "${aws_vpc.sample.id}"
  cidr_block = "10.1.1.0/24"
  tags {
    Name = "aws_batch_demo"
  }
}


resource "aws_batch_job_queue" "test_queue" {
  name = "tf-test-batch-job-queue"
  state = "ENABLED"
  priority = 1
  compute_environments = ["${aws_batch_compute_environment.sample.arn}"]

}

resource "aws_batch_compute_environment" "sample" {
  compute_environment_name = "mom_sample"
  compute_resources {
    instance_role = "${aws_iam_instance_profile.ecs_instance_role.arn}"
    instance_type = [
      "m4.large",
    ]
    max_vcpus = 4
    min_vcpus = 0
    desired_vcpus = 2
    security_group_ids = [
      "${aws_security_group.sample.id}"
    ]
    subnets = [
      "${aws_subnet.sample.id}"
    ]
    type = "EC2"
  }
  service_role = "${aws_iam_role.aws_batch_service_role.arn}"
  type = "MANAGED"
  depends_on = ["aws_iam_role_policy_attachment.aws_batch_service_role"]
}


resource "aws_batch_job_definition" "test" {
    name = "tf_test_batch_job_definition"
    type = "container"
    container_properties = <<CONTAINER_PROPERTIES
{
    "command": ["ls", "-la"],
    "image": "busybox",
    "memory": 1024,
    "vcpus": 1,
"volumes": [
{
"host": {
          "sourcePath": "/tmp"
        
},
        "name": "tmp"
      
}
    
],
"environment": [
        {"name": "VARNAME", "value": "VARVAL"}
    
],
"mountPoints": [
{
          "sourceVolume": "tmp",
          "containerPath": "/tmp",
          "readOnly": false
        
}
    
],
"ulimits": [
{
        "hardLimit": 1024,
        "name": "nofile",
        "softLimit": 1024
      
}
    
]

}
CONTAINER_PROPERTIES

}

