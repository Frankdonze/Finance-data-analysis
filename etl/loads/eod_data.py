import os
import psycopg
import json
from datetime import date

conn = psycopg.connect(os.getenv("PGCON"))

json_files = ["AAPL.json", "AMZN.json", "NVDA.json", "TSLA.json"]

for file in json_files:

    with open("/home/frank/fin-da/data/silver/" + file, "r") as f:
        data = json.load(f)

    cur = conn.cursor()

    for x in data:
        columns = ', '.join(x.keys())
        placeholders = ', '.join(['%s'] * len(x))
        sql = f"INSERT INTO eod_market_data ({columns}) VALUES ({placeholders})"
        cur.execute(sql, tuple(x.values()))
         


    conn.commit()
    cur.close()

conn.close()
print(f"Loaded {len(data)} records into raw_compnay_info")

