import boto3 as bt
import pandas as pd
from dotenv import load_dotenv
import os

def upload():
    load_dotenv()

    s3 = bt.client(
        's3',
        aws_access_key_id=os.getenv('AWS_ACCESS_KEY_ID'),
        aws_secret_access_key=os.getenv('AWS_SECRET_ACCESS_KEY'),
        region_name=os.getenv('AWS_DEFAULT_REGION')
    )

    bucket = 'credit-risk-pipeline-cmorera'
    local_file = '../data/cleaned/loans_clean.csv'
    path = 'cleaned/loans_clean.csv'

    s3.upload_file(local_file,bucket, path)

    response = s3.head_object(Bucket=bucket, Key='cleaned/loans_clean.csv')
    print(f"Upload successful. File size: {response['ContentLength']} bytes")

upload()
