#!/usr/bin/env python
import json
from pathlib import Path
import sys


def remove_bom(file_path: Path) -> None:
    s = open(file_path, encoding="utf-8-sig").read()
    open(file_path, mode="w", encoding="utf-8").write(s)


if __name__ == "__main__":
    path_to_file = Path(sys.argv[1])
    remove_bom(path_to_file)
