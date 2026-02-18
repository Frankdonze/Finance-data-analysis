import os
import json
from datetime import date
import boto3

ticker = ["AAPL", "AMZN", "NVDA", "TSLA"]

json_files = ["AAPLinfo_" + str(date.today()) + ".json", "AMZNinfo_"+str(date.today())+".json", "NVDAinfo_"+str(date.today())+".json", "TSLAinfo_"+str(date.today())+".json"]

company_dict_keys = [ "symbol", "companyName", "sector", "industry","country","exchange", "currency", "ceo", "fullTimeEmployees"]

market_data_keys = ["symbol", "timestamp", "price", "marketCap", "volume", "changePercentage", "isActivelyTrading"]

s3 = boto3.client("s3")

def transform():

    for file in json_files:
        temp_dict = {}

        bronze_data = s3.get_object(Bucket="bron-silv-data", Key="bronze/" + file)
        data = json.load(bronze_data["Body"])
        data = data[0]
        print(data)
        
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
        print("\n\n\n\nhere"+ str(temp_dict))

        s3.put_object(Bucket="bron-silv-data", Key="silver/" + ticker + "_compinfo_clean_" + str(date.today()) + ".json", Body=json.dumps(temp_dict))

        temp_dict = {}

        for key in data:
            for x in market_data_keys:
                if key == x:
                    temp_dict[key] = data[key]
 
        s3.put_object(Bucket="bron-silv-data", Key="silver/" + ticker + "_compinfo_to_market_data_" + str(date.today()) + ".json", Body=json.dumps(temp_dict))
        

        print("\n\n\n\n"+ str(temp_dict))

def lambda_handler(event, context):
    transform()


if __name__ == "__main__":
    transform()

