
resource "aws_security_group" "sample" {
  name = "aws_batch_compute_environment_security_group"
  vpc_id   = "${aws_vpc.sample.id}"
  tags {
      Name = "aws_batch_demo"
  }
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

resource "aws_batch_compute_environment" "sample" {
  compute_environment_name = "aws_batch_demo"
   compute_resources {
     instance_role = "${aws_iam_instance_profile.ecs_instance_role.arn}"
     instance_type = [
       "optimal"
     ]
     max_vcpus = 1024
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

resource "aws_batch_job_queue" "test_queue" {
  name = "tf-test-batch-job-queue"
  state = "ENABLED"
  priority = 1
  compute_environments = ["${aws_batch_compute_environment.sample.arn}"]
}

resource "aws_batch_job_definition" "test" {
    name = "tf_test_batch_job_definition"
    type = "container"
    container_properties = <<CONTAINER_PROPERTIES
{
    "command": ["myjob.sh"],
    "image": "procrastinatio/aws-batch",
    "memory": 256,
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
            {   
                "name": "BATCH_FILE_S3_URL",
                "value": "s3://ltmom-aws-batch-test/mapjob.sh"
            },  
            {   
                "name": "BATCH_FILE_TYPE",
                "value": "script"
            }   
        
],
"mountPoints": [
{
          "sourceVolume": "tmp",
          "containerPath": "/tmp",
          "readOnly": false
        
}
    
    
]

}
CONTAINER_PROPERTIES

}

