import os
import psycopg
import json
from datetime import date

conn = psycopg.connect(os.getenv("PGCON"))

json_files = ["AAPLinfo.json", "AMZNinfo.json", "NVDAinfo.json", "TSLAinfo.json"]

for file in json_files:

    with open("/home/frank/fin-da/data/bronze/" + file, "r") as f:
        data = json.load(f)
    
    cur = conn.cursor()
    
    for record in data:
        cur.execute("insert into raw_company_info (symbol, payload, ingested_date) values (%s, %s, %s)", (record["symbol"], json.dumps(record), date.today())) 
    

    conn.commit()
    cur.close()
    
conn.close()
print(f"Loaded {len(data)} records into raw_compnay_info")
