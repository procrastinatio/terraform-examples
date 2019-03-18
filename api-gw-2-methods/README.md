Terraform, AWS API Gateway and Lambda
=====================================

Example using one AWS API Gateway resource with two distinct methods,
each calling its own AWS Lambda function.

Also use Terraform [module](https://www.terraform.io/docs/configuration/modules.html)
to configure AWS Lambda function.

1/ Initialisation

    terraform Initialisation
    
    
Create the lambda bundle

     zip hello_lambda.zip hello_lambda.py
     
     
     
     -var "aws_region=eu-west-1"

