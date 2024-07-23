import json
from datetime import datetime
import boto3
from boto3.dynamodb.conditions import Attr


ddb_table = boto3.resource("dynamodb").Table("coastdemo-demo-tracker")
logs = boto3.client("logs")


def lambda_handler(event, context):
    global ddb_table
    global logs

    body = json.loads(event["body"])

    if "email" not in body:
        return json.dumps({"statusCode": 400, "body": {"message": "Missing email"}})

    email = body["email"].lower()

    response = ddb_table.scan(FilterExpression=Attr("UserId").eq(email))

    return json.dumps({"statusCode": 200, "body": (json.dumps(response))})
