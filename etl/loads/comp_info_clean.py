import os
import psycopg
import json
from datetime import date

conn = psycopg.connect(os.getenv("PGCON"))

json_files = ["AAPL_compinfo_clean.json", "AMZN_compinfo_clean.json", "NVDA_compinfo_clean.json", "TSLA_compinfo_clean.json"]

for file in json_files:

    with open("/home/frank/fin-da/data/silver/" + file, "r") as f:
        data = json.load(f)
    
    print(type(data))
    print(data)

    cur = conn.cursor()

    
    columns = ', '.join(data.keys())
    placeholders = ', '.join(['%s'] * len(data))
    sql = f"INSERT INTO companies ({columns}) VALUES ({placeholders})"
    cur.execute(sql, tuple(data.values()))
         


    conn.commit()
    cur.close()

conn.close()
print(f"Loaded {len(data)} records into raw_compnay_info")

