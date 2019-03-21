# api-gw-cors

AWS API Gatewa and CORS

See https://rogerwelin.github.io/aws/serverless/terraform/lambda/2019/03/18/build-a-serverless-website-from-scratch-with-lambda-and-terraform.html


    curl -X OPTIONS -v https://xp2ijyuwn5.execute-api.eu-west-1.amazonaws.com/test/resources
    < HTTP/1.1 200 OK
    < Content-Type: application/json
    < Content-Length: 0
    < Date: Thu, 21 Mar 2019 16:25:52 GMT
    < Access-Control-Allow-Origin: *
    < Access-Control-Allow-Headers: Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token
    < Access-Control-Allow-Methods: DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT
    < X-Cache: Miss from cloudfront

    curl -X POST https://xp2ijyuwn5.execute-api.eu-west-1.amazonaws.com/test/resources
    {
        "resource": "/resources",
            "path": "/resources",
                "httpMethod": "POST",
    
    }
