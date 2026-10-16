#!/usr/bin/env python3
"""Check that an extracted document numbers its labels as the full book does.

usage: check-extract-labels.py EXTRACT.aux BOOK.aux
"""

import re
import sys
from pathlib import Path

NEWLABEL = re.compile(r"^\\newlabel\{([^}]+)\}\{\{([^}]*)\}", re.MULTILINE)


def numbers(path):
    return dict(NEWLABEL.findall(Path(path).read_text()))


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: check-extract-labels.py EXTRACT.aux BOOK.aux")
    extract, book = numbers(sys.argv[1]), numbers(sys.argv[2])
    errors = [
        f"{label}: {number} here, {book.get(label, 'missing')} in the book"
        for label, number in sorted(extract.items())
        if book.get(label) != number
    ]
    for error in errors:
        print(error)
    print(f"{len(extract)} labels checked, {len(errors)} mismatched")
    if errors:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
