from flask import Flask, request
import boto3
import time
import os
from botocore.exceptions import ClientError

app = Flask(__name__)

# Fetch the DynamoDB table name, region, and port from environment variables
DYNAMODB_TABLE = os.getenv("DYNAMODB_TABLE")
AWS_REGION = os.getenv("AWS_REGION")
PORT = int(os.getenv("PORT", 5000))  # Default to port 5000 if not set

# Initialize DynamoDB resource using IAM role
dynamodb = boto3.resource('dynamodb', region_name=AWS_REGION)

def wait_for_db():
    """Wait until the DynamoDB table is available."""
    while True:
        try:
            table = dynamodb.Table(DYNAMODB_TABLE)
            table.load()
            print("Connected to the database.")
            return
        except ClientError as e:
            if e.response['Error']['Code'] == 'ResourceNotFoundException':
                print("Table not found. Waiting for database...")
            else:
                print(f"An error occurred: {e}")
            time.sleep(2)

def store_ip(ip):
    """Store the reversed IP address in the DynamoDB table."""
    table = dynamodb.Table(DYNAMODB_TABLE)
    table.put_item(
        Item={
            'id': str(time.time()),  # Unique ID based on current timestamp
            'ip': ip
        }
    )

@app.route('/')
def reverse_ip():
    """Reverse the client's IP address and store it."""
    client_ip = request.remote_addr
    reversed_ip = ".".join(client_ip.split(".")[::-1])
    store_ip(reversed_ip)
    return reversed_ip

if __name__ == '__main__':
    wait_for_db()
    app.run(host='0.0.0.0', port=PORT)
