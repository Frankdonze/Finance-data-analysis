import os
import json

ticker = ["AAPL", "AMZN", "NVDA", "TSLA"]

json_files = ["AAPLinfo.json", "AMZNinfo.json", "NVDAinfo.json", "TSLAinfo.json"]

company_dict_keys = [ "symbol", "companyName", "sector", "industry","country","exchange", "currency", "ceo", "fullTimeEmployees"]

market_data_keys = ["symbol", "timestamp", "price", "marketCap", "volume", "changePercentage", "isActivelyTrading"]

for file in json_files:
    temp_dict = {}

    with open("/home/frank/fin-da/data/bronze/" + file, "r") as f:
        data = json.load(f)
        data = data[0]
        
    if data["symbol"] == "AAPL":
            ticker = "AAPL"
    elif data["symbol"] == "AMZN":
            ticker = "AMZN"
    elif data["symbol"] == "NVDA":
            ticker = "NVDA"
    elif data["symbol"] == "TSLA":
            ticker = "TSLA"

    for key in data:
        for x in company_dict_keys:
            if key == x:
                    temp_dict[key] = data[key]      
    print("\n\n\n\n"+ str(temp_dict))

    with open("/home/frank/fin-da/data/silver/" + ticker + "_compinfo_clean.json", "w") as f:
        json.dump(temp_dict, f)

    temp_dict = {}

    for key in data:
        for x in market_data_keys:
            if key == x:
                temp_dict[key] = data[key]
    
    with open("/home/frank/fin-da/data/silver/" + ticker + "_compinfo_to_market_data.json", "w") as f:
        json.dump(temp_dict, f)

    print("\n\n\n\n"+ str(temp_dict))
