Terraform, AWS API Gateway and Lambda
=====================================

Example using one AWS API Gateway resource with two distinct methods,
each calling its own AWS Lambda function.

Also use Terraform [module](https://www.terraform.io/docs/configuration/modules.html)
to configure AWS Lambda function.


Adapted from https://andydote.co.uk/2017/03/17/terraform-aws-lambda-api-gateway/ 
([GitHub](Adapated from https://github.com/legdba/Terraform-lambda-apigateway) )



# Initialisation

    terraform init
    
    
Create the lambda bundle

     zip hello_lambda.zip hello_lambda.py
Using variables     
     
     terraform plan   -var="api_name=HelloAPI" -var="profile=dummy" -var="aws_region=eu-west-1"

Using configuration file

     terraform plan   -var-file=dev.tfvar


# Creation

     terraform apply   -var-file=dev.tfvar


# Test

    curl -X GET https://gokzq72ac2.execute-api.eu-west-1.amazonaws.com/production/hello
    {"message": "Hello, World!"}
    
    curl -X POST  https://gokzq72ac2.execute-api.eu-west-1.amazonaws.com/production/hello
    {"message": "I should have created something..."}
