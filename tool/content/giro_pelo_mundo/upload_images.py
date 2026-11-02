#!/usr/bin/env python3
"""Upload local Giro images to the public knowledge-gallery bucket and write URL mapping."""

from __future__ import annotations

import json
import os
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent
PROJECT_REF = "mizgtuwtuaculchwizkm"
BUCKET = "knowledge-gallery"
REPO_ENV = ROOT.parents[2] / ".env"


def load_dotenv(path: Path) -> None:
    if not path.exists():
        return
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        os.environ.setdefault(key.strip(), value.strip().strip('"').strip("'"))


def service_role_key() -> str:
    token = os.environ.get("SUPABASE_ACCESS_TOKEN")
    if not token:
        raise SystemExit("SUPABASE_ACCESS_TOKEN is required (Management API token)")
    req = urllib.request.Request(
        f"https://api.supabase.com/v1/projects/{PROJECT_REF}/api-keys",
        headers={"Authorization": f"Bearer {token}"},
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        keys = json.loads(resp.read().decode())
    for key in keys:
        if key.get("name") == "service_role" and key.get("api_key"):
            return key["api_key"]
    raise SystemExit("service_role key not found via Management API")


def content_type_for(data: bytes) -> str:
    if data[:3] == b"\xff\xd8\xff":
        return "image/jpeg"
    if data[:8] == b"\x89PNG\r\n\x1a\n":
        return "image/png"
    if data[:4] == b"RIFF" and data[8:12] == b"WEBP":
        return "image/webp"
    return "application/octet-stream"


def upload(service_key: str, storage_path: str, data: bytes) -> None:
    url = (
        f"https://{PROJECT_REF}.supabase.co/storage/v1/object/"
        f"{BUCKET}/{storage_path}"
    )
    req = urllib.request.Request(
        url,
        data=data,
        method="POST",
        headers={
            "Authorization": f"Bearer {service_key}",
            "Content-Type": content_type_for(data),
            "x-upsert": "true",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=120) as resp:
            if resp.status not in (200, 201):
                raise SystemExit(f"upload failed {storage_path}: {resp.status}")
    except urllib.error.HTTPError as err:
        body = err.read()[:500]
        raise SystemExit(f"upload failed {storage_path}: {err.code} {body!r}") from err


def main() -> None:
    load_dotenv(REPO_ENV)
    manifest = json.loads((ROOT / "prompts" / "manifest.json").read_text(encoding="utf-8"))
    images_root = ROOT / "images"
    service_key = service_role_key()
    public_base = manifest["public_base"].rstrip("/")

    mapping: dict[str, dict[str, str]] = {}
    missing: list[str] = []
    uploaded = 0

    for item in manifest["items"]:
        local = images_root / item["relpath"]
        # GenerateImage may save .jpg even when relpath says .png
        if not local.exists():
            for alt in (local.with_suffix(".jpg"), local.with_suffix(".jpeg"), local.with_suffix(".webp")):
                if alt.exists():
                    local = alt
                    break
        if not local.exists():
            missing.append(item["relpath"])
            continue

        data = local.read_bytes()
        upload(service_key, item["storage_path"], data)
        public_url = f"{public_base}/{item['storage_path']}"
        entry = mapping.setdefault(item["slug"], {})
        if item["kind"] == "flag":
            entry["flag_url"] = public_url
        elif item["kind"] == "landmark":
            entry["landmark_url"] = public_url
        elif item["kind"] == "silhouette":
            entry["silhouette_url"] = public_url
        uploaded += 1
        print(f"uploaded {item['kind']} {item['slug']}")

    out_dir = ROOT / "out"
    out_dir.mkdir(parents=True, exist_ok=True)
    out_path = out_dir / "url_mapping.json"
    out_path.write_text(
        json.dumps(mapping, ensure_ascii=False, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )

    print(json.dumps({"uploaded": uploaded, "missing": len(missing), "slugs": len(mapping)}, indent=2))
    if missing:
        print("missing local files:")
        for path in missing:
            print(f"  - {path}")
        raise SystemExit(1)
    print(f"wrote {out_path}")


if __name__ == "__main__":
    main()
