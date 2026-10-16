#!/usr/bin/env python3
"""Extract chapter PDFs using the chapter bookmarks in the full book."""

import re
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path


def output(*args):
    return subprocess.check_output(args, text=True)


def main():
    if len(sys.argv) != 3:
        raise SystemExit("usage: split-chapter-pdfs.py FULL_BOOK.pdf OUTPUT_DIR")

    root = Path(__file__).resolve().parent.parent
    book = Path(sys.argv[1]).resolve()
    destination = Path(sys.argv[2]).resolve()
    book_in_container = book.relative_to(root)
    destination_in_container = destination.relative_to(root)
    destination.mkdir(parents=True, exist_ok=True)

    chapter_pages = {}
    integrals_page = None
    for line in output("pdfinfo", "-dests", str(book)).splitlines():
        match = re.search(r'^\s*(\d+)\s+\[.*\]\s+"(chapter\.(\d+)|integrals)"$', line)
        if not match:
            continue
        page = int(match.group(1))
        if match.group(3):
            chapter_pages[int(match.group(3))] = page
        else:
            integrals_page = page

    if sorted(chapter_pages) != list(range(1, 14)) or integrals_page is None:
        raise SystemExit("expected chapter 1-13 and integrals bookmarks in the full PDF")

    boundaries = [chapter_pages[number] for number in range(1, 14)] + [integrals_page]
    if boundaries != sorted(set(boundaries)):
        raise SystemExit(f"chapter page boundaries are not increasing: {boundaries}")

    def extract(number):
        first = boundaries[number - 1]
        last = boundaries[number] - 1
        combined = destination / f".{number:02d}.pdf"
        combined_in_container = destination_in_container / f".{number:02d}.pdf"
        result = subprocess.run(
            [str(root / "texlive.sh"), "gs", "-q", "-dBATCH", "-dNOPAUSE", "-sDEVICE=pdfwrite",
             f"-dFirstPage={first}", f"-dLastPage={last}",
             f"-sOutputFile={combined_in_container}", str(book_in_container)],
            capture_output=True,
            text=True,
            cwd=root,
        )
        if result.returncode:
            raise SystemExit(result.stderr or f"Ghostscript failed on chapter {number}")
        combined.replace(destination / f"{number:02d}.pdf")
        discarded = result.stderr.count("Outline has invalid link that was discarded")
        noun = "link" if discarded == 1 else "links"
        return f"chapter {number:02d}: pages {first}-{last}; {discarded} {noun} outside chapter discarded"

    # Each Ghostscript run re-parses the whole book, so run the chapters concurrently.
    with ThreadPoolExecutor(max_workers=os.cpu_count() or 1) as pool:
        for message in pool.map(extract, range(1, 14)):
            print(message)


if __name__ == "__main__":
    main()
