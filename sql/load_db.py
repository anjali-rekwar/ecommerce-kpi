import sqlite3, pandas as pd

df = pd.read_csv("data/clean/cleaned_sales.csv", parse_dates=["InvoiceDate"])
con = sqlite3.connect("data/ecommerce.db")
df.to_sql("sales", con, if_exists="replace", index=False)
con.close()
print("Loaded", len(df), "rows into sales")



