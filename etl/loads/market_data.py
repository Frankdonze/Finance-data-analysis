import os
import psycopg
import json
from datetime import date

conn = psycopg.connect(os.getenv("PGCON"))

json_files = ["AAPL_compinfo_to_market_data.json", "AMZN_compinfo_to_market_data.json", "NVDA_compinfo_to_market_data.json", "TSLA_compinfo_to_market_data.json"]

for file in json_files:

    with open("/home/frank/fin-da/data/silver/" + file, "r") as f:
        data = json.load(f)
    
    print(type(data))
    print(data)

    cur = conn.cursor()

    
    columns = ', '.join(data.keys())
    placeholders = ', '.join(['%s'] * len(data))
    sql = f"INSERT INTO market_data ({columns}) VALUES ({placeholders})"
    cur.execute(sql, tuple(data.values()))
         


    conn.commit()
    cur.close()

conn.close()
print(f"Loaded {len(data)} records into raw_compnay_info")

