#!/usr/bin/env python3
"""Write vercel.json with permanent (301/308) redirects for every old URL.

Hugo turns each `aliases:` entry into a small HTML page with a meta refresh.
Google follows those, but a real server-side permanent redirect passes ranking
signals faster and more reliably. This script reads the built site, finds every
alias page, and writes one redirect per alias into vercel.json.

Run after every build that adds or changes aliases:

    hugo --gc --minify
    python3 scripts/make-vercel-json.py
"""
import json
import pathlib
import re
import sys

root = pathlib.Path(__file__).resolve().parent.parent
public = root / (sys.argv[1] if len(sys.argv) > 1 else "public")
import tomllib
base = tomllib.loads((root / "hugo.toml").read_text())["baseURL"].rstrip("/")
host = base.split("//", 1)[1]
refresh = re.compile(r'http-equiv=["\']?refresh["\']?\s+content=["\']0; url=([^"\']+)["\']', re.I)

redirects = []
if host.startswith("www."):
    # One host only: send the bare domain to www.
    redirects.append({"source": "/:path*", "has": [{"type": "host", "value": host[4:]}],
                      "destination": f"{base}/:path*", "permanent": True})
# Extra redirects that are not Hugo aliases (for example a section moved to another site).
extra = root / "data" / "redirects.json"
if extra.exists():
    for rule in json.loads(extra.read_text()):
        redirects.append({**rule, "permanent": True})
seen = set()
for page in sorted(public.rglob("index.html")):
    html = page.read_text(encoding="utf-8", errors="ignore")
    if len(html) > 600:
        continue
    m = refresh.search(html)
    if not m:
        continue
    old = "/" + str(page.parent.relative_to(public)).replace("\\", "/").strip("/") + "/"
    new = m.group(1).replace(base, "") or "/"
    if old in seen or old == new:
        continue
    seen.add(old)
    for src in (old, old.rstrip("/")):
        redirects.append({"source": src, "destination": new, "permanent": True})

config = {
    "$schema": "https://openapi.vercel.sh/vercel.json",
    "trailingSlash": True,
    "framework": "hugo",
    "buildCommand": "hugo --gc --minify --cleanDestinationDir --environment production --baseURL https://www.dart-tutorial.dev/",
    "outputDirectory": "public",
    "build": {"env": {"HUGO_VERSION": "0.168.0", "HUGO_ENV": "production"}},
    "redirects": redirects,
    "headers": [
        {"source": "/(css|js|fonts)/(.*)", "headers": [{"key": "Cache-Control", "value": "public, max-age=31536000, immutable"}]},
        {"source": "/images/(.*)", "headers": [{"key": "Cache-Control", "value": "public, max-age=604800"}]},
        {"source": "/(.*)", "headers": [
            {"key": "X-Content-Type-Options", "value": "nosniff"},
            {"key": "Referrer-Policy", "value": "strict-origin-when-cross-origin"},
            {"key": "Strict-Transport-Security", "value": "max-age=63072000"},
        ]},
        {"source": "/(css|js|fonts)/(.*)", "headers": [
            {"key": "Cache-Control", "value": "public, max-age=31536000, immutable"},
        ]},
        {"source": "/(images/.*|favicon.svg|favicon.png|site.webmanifest)", "headers": [
            {"key": "Cache-Control", "value": "public, max-age=604800"},
        ]},
    ],
}
out = root / "vercel.json"
out.write_text(json.dumps(config, indent=2) + "\n", encoding="utf-8")
print(f"{out}: {len(seen)} old URLs redirected ({len(redirects)} rules)")
