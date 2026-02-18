import requests
import os
import json
from datetime import date, timedelta
import boto3

api_key = os.getenv("APIKEY")
tickers = ["AAPL", "NVDA", "TSLA", "AMZN"]
date = date.today()
week = date - timedelta(days=7)
s3 = boto3.client("s3")

def extract():
    for tick in tickers:
        url = "https://financialmodelingprep.com/stable/historical-price-eod/light?symbol=" + tick + "&from=" + str(week) + "&to=" + str(date) + "&apikey=" + api_key
        response = requests.get(url)
        data = response.json()

        if response.status_code == 200:
            s3.put_object(Bucket="bron-silv-data", Key="bronze/" + tick + "_" + str(date.today()) + ".json", Body=json.dumps(data))
        else:
            print("Error:", response.status_code)

def lambda_handler(event, context):
    extract()

if __name__ == "__main__":
    extract()
