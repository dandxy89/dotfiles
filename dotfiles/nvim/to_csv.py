#!/usr/bin/env python3
import sys

# from pyarrow import csv
# import pyarrow.parquet as pq
from fastparquet import ParquetFile


if __name__ == "__main__":
    # table = pq.read_table(sys.argv[1])
    # csv.write_csv(table, sys.argv[2])

    pf = ParquetFile(sys.argv[1])
    df = pf.to_pandas()
    df.to_csv(sys.argv[2], index=False)
