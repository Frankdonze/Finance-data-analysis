import requests
import os
import json
from datetime import date, timedelta

api_key = os.getenv("APIKEY")
tickers = ["AAPL", "NVDA", "TSLA", "AMZN"]
date = date.today()
week = date - timedelta(days=7)

print(week)

for tick in tickers:
    url = "https://financialmodelingprep.com/stable/historical-price-eod/light?symbol=" + tick + "&from=" + str(week) + "&to=" + str(date) + "&apikey=" + api_key
    response = requests.get(url)
    data = response.json()

    if response.status_code == 200:
        with open("/home/frank/fin-da/data/bronze/" + tick + "_" + str(date.today()) +".json", "w") as f:
            json.dump(data, f, indent=4)
    else:
        print("Error:", response.status_code)

