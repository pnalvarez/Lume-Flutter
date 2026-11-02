#!/usr/bin/env python3
"""HEAD-check every URL in out/url_mapping.json for 200 + image content-type."""

from __future__ import annotations

import json
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent


def main() -> None:
    mapping = json.loads((ROOT / "out" / "url_mapping.json").read_text(encoding="utf-8"))
    failures: list[str] = []
    checked = 0
    for slug, urls in sorted(mapping.items()):
        for key in ("flag_url", "landmark_url", "silhouette_url"):
            url = urls.get(key)
            if not url:
                failures.append(f"{slug}.{key}: missing")
                continue
            checked += 1
            req = urllib.request.Request(url, method="HEAD")
            try:
                with urllib.request.urlopen(req, timeout=30) as resp:
                    ctype = (resp.headers.get("content-type") or "").split(";")[0].strip()
                    if resp.status != 200 or not ctype.startswith("image/"):
                        failures.append(f"{slug}.{key}: status={resp.status} ctype={ctype}")
            except urllib.error.HTTPError as err:
                failures.append(f"{slug}.{key}: HTTP {err.code}")
            except Exception as err:  # noqa: BLE001 - report any network failure
                failures.append(f"{slug}.{key}: {err}")

    print(json.dumps({"checked": checked, "failures": len(failures), "slugs": len(mapping)}, indent=2))
    if failures:
        for line in failures:
            print(line)
        raise SystemExit(1)
    print("all urls ok")


if __name__ == "__main__":
    main()
