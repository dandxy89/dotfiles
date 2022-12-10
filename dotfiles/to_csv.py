#!/usr/bin/env python3
import sys

from fastparquet import ParquetFile


if __name__ == "__main__":
    pf = ParquetFile(sys.argv[1])
    df = pf.to_pandas()
    df.to_csv(sys.argv[2], index=False)
