import csv
import random
import os
import sys

NUM_ROWS = 50


COLUMNS = ["item_id", "price", "quantity", "category"]

def generate_row():

    return {
        "item_id": random.randint(1000, 9999),
        "price": round(random.uniform(1.5, 99.9), 2),
        "quantity": random.randint(0, 100),
        "category": random.choice(["books", "home", "tech"]),
    }


OUTPUT_DIR = sys.argv[1] if len(sys.argv) > 1 else "/data"
OUTPUT_FILE = os.path.join(OUTPUT_DIR, "data.csv")

os.makedirs(OUTPUT_DIR, exist_ok=True)

rows = [generate_row() for _ in range(NUM_ROWS)]

with open(OUTPUT_FILE, "w", newline="", encoding="utf-8") as f:
    writer = csv.DictWriter(f, fieldnames=COLUMNS)
    writer.writeheader()
    writer.writerows(rows)
