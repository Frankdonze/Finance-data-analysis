import requests
import os
import json
from datetime import date

api_key = os.getenv("APIKEY")
tickers = ["AAPL", "NVDA", "TSLA", "AMZN"]

for tick in tickers:
    url = "https://financialmodelingprep.com/stable/profile?symbol=" + tick + "&apikey=" + api_key
    response = requests.get(url)
    data = response.json()


    if response.status_code == 200:
        with open("/home/frank/fin-da/data/bronze/" + tick + "info_" + str(date.today()) + ".json", "w") as f:
            json.dump(data, f, indent=4)
    else:
        print("Error:", response.status_code)

