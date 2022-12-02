#!/usr/bin/env python
import sys

import pyarrow.parquet as pq

if __name__ == "__main__":
    # Usage:
    #   poetry run python diff_files.py {PATH} {PATH2}
    table1 = pq.read_table(sys.argv[1])
    table2 = pq.read_table(sys.argv[2])

    assert table1.num_rows == table2.num_rows
    assert table1.num_columns == table2.num_columns
    assert table1.equals(table2)
