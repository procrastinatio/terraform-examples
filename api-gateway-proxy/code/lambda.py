import json

def handler_hello(event, context):
    return { "message": "Hello, World!" }

def handler_echo(event, context):
    return { "statusCode" : 200,
            "body": json.dumps(event, indent=4)
            }
