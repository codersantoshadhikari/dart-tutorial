#!/usr/bin/env python3
"""Rebuild LESSONS.md and the lesson counts in README.md from the live sites.

Both sites publish /index.json (title, chapter and URL of every lesson).
The GitHub Action runs this once a week; it only commits when a lesson was
added, renamed or removed, so the history stays honest and useful.
"""
import json
import pathlib
import re
import sys
import urllib.request
from collections import OrderedDict

SITES = [
    ("Dart", "https://www.dart-tutorial.dev"),
    ("Flutter", "https://flutter.dart-tutorial.dev"),
]
ROOT = pathlib.Path(__file__).resolve().parent.parent


def load(base):
    req = urllib.request.Request(base + "/index.json", headers={"User-Agent": "lesson-list-updater"})
    with urllib.request.urlopen(req, timeout=30) as r:
        return json.load(r)


def main():
    out = ["# All lessons", "",
           "Every lesson of the free Dart and Flutter courses, in reading order. "
           "This file is updated automatically when a lesson is added.", ""]
    counts = {}
    for name, base in SITES:
        try:
            lessons = load(base)
        except Exception as e:  # keep the old file if a site is down
            print(f"Could not load {base}: {e}", file=sys.stderr)
            return 0
        chapters = OrderedDict()
        for item in lessons:
            chapter = item["s"].split(": ", 1)[-1]
            chapters.setdefault(chapter, []).append(item)
        counts[name] = len(lessons)
        out += [f"## {name} course ({len(lessons)} lessons)", "", f"Course home: {base}/", ""]
        for chapter, items in chapters.items():
            out += [f"### {chapter}", ""]
            out += [f"- [{i['t']}]({base}{i['u']})" for i in items]
            out.append("")
    (ROOT / "LESSONS.md").write_text("\n".join(out), encoding="utf-8")

    readme = ROOT / "README.md"
    text = readme.read_text(encoding="utf-8")
    new = (f"<!-- counts:start -->**{counts['Dart']} Dart lessons** and "
           f"**{counts['Flutter']} Flutter lessons**<!-- counts:end -->")
    text = re.sub(r"<!-- counts:start -->.*?<!-- counts:end -->", new, text, flags=re.S)
    readme.write_text(text, encoding="utf-8")
    print(counts)
    return 0


if __name__ == "__main__":
    sys.exit(main())
