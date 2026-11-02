#!/usr/bin/env python3
"""Extract Giro pelo Mundo image prompts from the content xlsx into manifest.json."""

from __future__ import annotations

import html
import json
import re
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

NS = {"m": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}
REL_NS = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}"

ROOT = Path(__file__).resolve().parent
DEFAULT_XLSX = Path.home() / "Documents/Lume/Games/giro_pelo_mundo_conteudo (1).xlsx"
FLAG_PLACEHOLDER = "— usa a bandeira (image_url do país)"
PUBLIC_BASE = (
    "https://mizgtuwtuaculchwizkm.supabase.co/storage/v1/object/public/knowledge-gallery"
)


def col_row(ref: str) -> tuple[int, int]:
    match = re.match(r"([A-Z]+)(\d+)", ref)
    if not match:
        raise ValueError(f"bad cell ref: {ref}")
    col_letters, row_s = match.group(1), match.group(2)
    col = 0
    for char in col_letters:
        col = col * 26 + (ord(char) - 64)
    return col, int(row_s)


def cell_value(cell: ET.Element, shared_strings: list[str]) -> str | None:
    cell_type = cell.attrib.get("t")
    if cell_type == "inlineStr":
        return html.unescape(
            "".join(node.text or "" for node in cell.findall(".//m:t", NS))
        )
    value_node = cell.find("m:v", NS)
    if value_node is None:
        return None
    raw = value_node.text or ""
    if cell_type == "s":
        return shared_strings[int(raw)]
    return html.unescape(raw)


def normalize_sheet_path(target: str) -> str:
    while target.startswith("/"):
        target = target[1:]
    if not target.startswith("xl/"):
        target = "xl/" + target
    while "xl/xl/" in target:
        target = target.replace("xl/xl/", "xl/")
    return target


def load_sheet(archive: zipfile.ZipFile, target: str, shared_strings: list[str]) -> list[dict]:
    root = ET.fromstring(archive.read(normalize_sheet_path(target)))
    rows: dict[int, dict[int, str | None]] = {}
    for cell in root.findall(".//m:c", NS):
        col, row = col_row(cell.attrib["r"])
        rows.setdefault(row, {})[col] = cell_value(cell, shared_strings)
    headers = [rows[1].get(i) for i in range(1, max(rows[1]) + 1)]
    data: list[dict] = []
    for row_idx in range(2, max(rows) + 1):
        data.append({headers[i]: rows[row_idx].get(i + 1) for i in range(len(headers))})
    return data


def extract(xlsx: Path) -> dict:
    with zipfile.ZipFile(xlsx) as archive:
        shared_strings: list[str] = []
        if "xl/sharedStrings.xml" in archive.namelist():
            root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
            for si in root.findall("m:si", NS):
                shared_strings.append(
                    "".join(node.text or "" for node in si.findall(".//m:t", NS))
                )
        workbook = ET.fromstring(archive.read("xl/workbook.xml"))
        sheets = [
            (sheet.attrib["name"], sheet.attrib[f"{REL_NS}id"])
            for sheet in workbook.find("m:sheets", NS)
        ]
        relationships = {
            rel.attrib["Id"]: rel.attrib["Target"]
            for rel in ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
        }
        by_name = {
            name: load_sheet(archive, relationships[rel_id], shared_strings)
            for name, rel_id in sheets
        }

    flags = []
    for row in by_name["visual_content"]:
        slug = row["slug"]
        flags.append(
            {
                "slug": slug,
                "title": row["title"],
                "kind": "flag",
                "prompt": row["prompt_imagem"],
                "relpath": f"flags/{slug}.png",
                "storage_path": f"giro_pelo_mundo/{slug}/flag.png",
                "aspect_ratio": "4:3",
            }
        )

    landmarks: list[dict] = []
    silhouettes: list[dict] = []
    for row in by_name["visual_questions"]:
        prompt = (row.get("prompt_imagem") or "").strip()
        if not prompt or prompt == FLAG_PLACEHOLDER:
            continue
        slug = row["content_slug"]
        question_type = row["question_type"]
        if question_type == "identify_landmark":
            landmarks.append(
                {
                    "slug": slug,
                    "title": row.get("correct_answer") or slug,
                    "kind": "landmark",
                    "prompt": prompt,
                    "relpath": f"landmarks/{slug}.png",
                    "storage_path": f"giro_pelo_mundo/{slug}/landmark.png",
                    "aspect_ratio": "4:3",
                }
            )
        elif question_type == "identify_silhouette":
            silhouettes.append(
                {
                    "slug": slug,
                    "title": row.get("correct_answer") or slug,
                    "kind": "silhouette",
                    "prompt": prompt,
                    "relpath": f"silhouettes/{slug}.png",
                    "storage_path": f"giro_pelo_mundo/{slug}/silhouette.png",
                    "aspect_ratio": "1:1",
                }
            )

    items = flags + landmarks + silhouettes
    return {
        "source": str(xlsx),
        "bucket": "knowledge-gallery",
        "public_base": PUBLIC_BASE,
        "counts": {
            "flags": len(flags),
            "landmarks": len(landmarks),
            "silhouettes": len(silhouettes),
            "total": len(items),
        },
        "items": items,
    }


def main() -> None:
    xlsx = Path(
        __import__("os").environ.get("GIRO_XLSX", str(DEFAULT_XLSX))
    ).expanduser()
    if not xlsx.exists():
        raise SystemExit(f"xlsx not found: {xlsx}")
    manifest = extract(xlsx)
    out = ROOT / "prompts" / "manifest.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(manifest["counts"], indent=2))
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
