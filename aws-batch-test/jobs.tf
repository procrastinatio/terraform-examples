
resource "aws_batch_job_queue" "test_queue" {
  name = "aws_demo_batch_job-queue"
  state = "ENABLED"
  priority = 1
  compute_environments = ["${aws_batch_compute_environment.aws_batch_demo.arn}"]
}

resource "aws_batch_job_definition" "test" {
    name = "aws_batch_demo_job"
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



output "aws_batch_job_definition" {
  value = "${aws_batch_job_definition.test.name}"

}


