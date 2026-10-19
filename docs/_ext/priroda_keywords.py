"""Render keywords/*.yaml into the input-reference pages.

Runs on Sphinx's builder-inited event and writes docs/reference/<group>.md.
Also runnable standalone (`python docs/_ext/priroda_keywords.py`) to validate
and regenerate without a full build.

Record schema (one YAML file per $group):

  group: optimize                 # name without "$"
  order: 10                       # position in the reference (input-writing order)
  summary: {en: ...}
  relevant_when: "task = optimize | irc | scan"   # optional
  body: {en: ...}                 # optional free Markdown after the summary
  keywords:
    - name: steps
      type: integer               # see TYPES
      default: 50                 # null when no source states one
      default_note: {en: ...}     # optional: conditional defaults, multi-value meaning
      units: null
      values:                     # optional, for enum/flags/switch
        - {value: "0", en: ..., default: true, status: undocumented}   # status optional
      description: {en: ...}
      notes: {en: ...}            # optional
      example: "$optimize steps=100 $end"   # optional
      see_also: [optimize.tolerance]        # anchors group.keyword
      status: current             # see STATUSES
      sources: ["input.txt"]      # research refs, e.g. "04 #324"
      verified_against: null      # program version string once checked

Prose fields are dicts keyed by language ({en: ...}). Only English is written for now;
another language can be added later as a sibling key without changing the schema.
"""

import re
from pathlib import Path

import yaml

ROOT = Path(__file__).resolve().parents[2]
KEYWORD_DIR = ROOT / "keywords"
OUT_DIR = ROOT / "docs" / "reference"

TYPES = {"integer", "real", "string", "switch", "enum", "flags", "list", "indexed-array", "data"}
STATUSES = {"current", "undocumented", "deprecated", "removed"}
REQUIRED_GROUP = {"group", "order", "summary", "keywords"}
REQUIRED_KEYWORD = {"name", "type", "default", "description", "status", "sources", "verified_against"}

GENERATED_HEADER = "<!-- Generated from keywords/{file} by docs/_ext/priroda_keywords.py. Do not edit. -->\n\n"

LABELS = {
    "en": {
        "type": "Type", "default": "Default", "units": "Units", "status": "Status",
        "sources": "Sources", "unverified": "not verified", "verified": "verified on",
        "value": "Value", "meaning": "Meaning", "example": "Example", "see_also": "See also",
        "relevant": "Relevant when", "notes": "Note", "default_note": "About the default", "none": "none stated",
        "groups": "Group", "purpose": "Purpose",
    },
}


# Research-note prefixes in `sources` and the names the Sources page uses for them, in the evidence
# order of CLAUDE.md. The page shows these names only: note numbers, sections and post numbers mean nothing to a reader.
SOURCE_NAMES = {
    "08": "version 25 test runs",
    "09": "version 25 executable",
    "01": "official site files",
    "input.txt": "input.txt",
    "06": "KNC wiki",
    "Dft.rtf": "Dft.rtf",
    "04": "chemport.ru forum",
    "05": "chemport.ru forum",
    "03": "qchem.ru forum",
    "02": "LIMOR page",
}


def source_names(sources):
    out = []
    for s in sources:
        key = s.strip().split()[0].split("(")[0]
        if key not in SOURCE_NAMES:
            raise SchemaError(f"unknown source prefix {key!r} in {s!r}; add it to SOURCE_NAMES")
        name = SOURCE_NAMES[key]
        name = f"`{name}`" if name.endswith((".txt", ".rtf")) else name
        if name not in out:
            out.append(name)
    order = list(dict.fromkeys(SOURCE_NAMES.values()))  # evidence order, strongest first
    out.sort(key=lambda n: order.index(n.strip("`")))
    return ", ".join(out)


class SchemaError(ValueError):
    pass


def text(field, lang):
    if field is None:
        return ""
    if isinstance(field, str):
        return field
    return field.get(lang) or field.get("en", "")


def validate(data, file):
    missing = REQUIRED_GROUP - data.keys()
    if missing:
        raise SchemaError(f"{file}: group missing {sorted(missing)}")
    seen = set()
    for kw in data["keywords"]:
        where = f"{file}: {data['group']}.{kw.get('name', '?')}"
        missing = REQUIRED_KEYWORD - kw.keys()
        if missing:
            raise SchemaError(f"{where}: missing {sorted(missing)}")
        if kw["type"] not in TYPES:
            raise SchemaError(f"{where}: type {kw['type']!r} not in {sorted(TYPES)}")
        if kw["status"] not in STATUSES:
            raise SchemaError(f"{where}: status {kw['status']!r} not in {sorted(STATUSES)}")
        if not kw["sources"]:
            raise SchemaError(f"{where}: at least one source is required")
        for v in kw.get("values", []):
            if v.get("status", "current") not in STATUSES:
                raise SchemaError(f"{where}: value {v['value']!r} status {v['status']!r} not in {sorted(STATUSES)}")
        if kw["name"] in seen:
            raise SchemaError(f"{where}: duplicate keyword")
        seen.add(kw["name"])


def load_groups():
    groups = []
    for path in sorted(KEYWORD_DIR.glob("*.yaml")):
        try:
            data = yaml.safe_load(path.read_text(encoding="utf-8"))
        except yaml.YAMLError as e:
            raise SchemaError(f"{path.name}: {e}") from None
        validate(data, path.name)
        data["_file"] = path.name
        groups.append(data)
    groups.sort(key=lambda g: g["order"])
    anchors = {f"{g['group']}.{kw['name']}" for g in groups for kw in g["keywords"]}
    for g in groups:
        for kw in g["keywords"]:
            for ref in kw.get("see_also", []):
                if ref not in anchors:
                    raise SchemaError(f"{g['_file']}: {g['group']}.{kw['name']} see_also {ref!r} is unknown")
    return groups


def fmt_default(kw, lab):
    d = kw["default"]
    if d is None:
        out = f"*{lab['none']}*"
    elif isinstance(d, list):
        out = "`" + ",".join(str(x) for x in d) + "`"
    else:
        out = f"`{d}`"
    return out


def render_keyword(group, kw, lang, lab):
    anchor = f"{group}.{kw['name']}"
    status = kw["status"]
    status += f" · {lab['verified']} {kw['verified_against']}" if kw["verified_against"] else f" · {lab['unverified']}"
    lines = [
        f"({anchor})=",
        "{.kw}",  # section class for the HTML theme (needs the attrs_block MyST extension)
        f"## `{kw['name']}`",
        "",
        "```{index} single: " + f"{kw['name']} (${group})",
        "```",
        "",
    ]
    # Plain labelled lines (backslash = hard line break), not a table: a two-column field table
    # renders with an empty header row and a cramped label column in the PDF.
    fields = [(lab["type"], kw["type"]), (lab["default"], fmt_default(kw, lab))]
    if kw.get("units"):
        fields.append((lab["units"], kw["units"]))
    fields += [(lab["status"], status), (lab["sources"], source_names(kw["sources"]))]
    lines += [f"**{k}:** {v}" + ("\\" if i < len(fields) - 1 else "") for i, (k, v) in enumerate(fields)]
    lines.append("")
    lines += [text(kw["description"], lang).strip(), ""]
    if kw.get("default_note"):
        lines += [f"**{lab['default_note']}:** {text(kw['default_note'], lang)}", ""]
    if kw.get("values"):
        # Fixed column widths for LaTeX; automatic sizing truncates long values such as optimize+hessian.
        lines += ["```{tabularcolumns} \\Y{0.3}\\Y{0.7}", "```", "",
                  f"| {lab['value']} | {lab['meaning']} |", "|---|---|"]
        for v in kw["values"]:
            mark = f" (**{lab['default'].lower()}**)" if v.get("default") else ""
            if v.get("status", "current") != "current":
                mark += f" *({v['status']})*"
            meaning = text(v, lang).replace("\n", " ").replace("|", "\\|")
            lines.append(f"| `{v['value']}` | {meaning}{mark} |")
        lines.append("")
    if kw.get("notes"):
        lines += ["```{note}", text(kw["notes"], lang).strip(), "```", ""]
    if kw.get("example"):
        # A fragment without a group (e.g. one atom line) would be lexed as text outside a group.
        lang = "priroda" if re.search(r"\$\w", kw["example"]) else "text"
        lines += [f"**{lab['example']}:**", "", f"```{lang}", kw["example"].rstrip(), "```", ""]
    if kw.get("see_also"):
        refs = ", ".join(
            f"{{ref}}`{r.split('.', 1)[1]} (${r.split('.', 1)[0]}) <{r}>`" for r in kw["see_also"]
        )
        lines += [f"**{lab['see_also']}:** {refs}", ""]
    return "\n".join(lines)


def render_group(g, lang):
    lab = LABELS.get(lang, LABELS["en"])
    name = g["group"]
    parts = [
        GENERATED_HEADER.format(file=g["_file"]),
        f"(group.{name})=",
        f"# `${name}`",
        "",
        "```{index} single: " + f"${name}",
        "```",
        "",
        text(g["summary"], lang).strip(),
        "",
    ]
    if g.get("relevant_when"):
        parts += [f"**{lab['relevant']}:** `{g['relevant_when']}`", ""]
    if g.get("body"):
        parts += [text(g["body"], lang).strip(), ""]
    parts += [render_keyword(name, kw, lang, lab) for kw in g["keywords"]]
    return "\n".join(parts).rstrip() + "\n"


def render_index(groups, lang):
    lab = LABELS.get(lang, LABELS["en"])
    rows = "\n".join(
        f"| {{ref}}`${g['group']} <group.{g['group']}>` | {text(g['summary'], lang).strip().splitlines()[0]} |"
        for g in groups
    )
    toc = "\n".join(g["group"] for g in groups)
    return (
        GENERATED_HEADER.format(file="*.yaml")
        + "# Input reference\n\n"
        + "One page per input group, in the order groups are usually written. Each keyword entry gives its type, "
        "default, status and sources. For an alphabetical list of all keywords, see the {ref}`index <genindex>`.\n\n"
        + f"| {lab['groups']} | {lab['purpose']} |\n|---|---|\n{rows}\n\n"
        + f"```{{toctree}}\n:hidden:\n\n{toc}\n```\n"
    )


def write_if_changed(path, content):
    if not path.exists() or path.read_text(encoding="utf-8") != content:
        path.write_text(content, encoding="utf-8")


def generate(lang="en"):
    groups = load_groups()
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    for g in groups:
        write_if_changed(OUT_DIR / f"{g['group']}.md", render_group(g, lang))
    write_if_changed(OUT_DIR / "index.md", render_index(groups, lang))
    return groups


def _on_builder_inited(app):
    generate(app.config.language or "en")


def setup(app):
    app.connect("builder-inited", _on_builder_inited)
    return {"parallel_read_safe": True, "parallel_write_safe": True}


if __name__ == "__main__":
    import sys

    gs = generate(sys.argv[1] if len(sys.argv) > 1 else "en")
    print(f"ok: {len(gs)} groups, {sum(len(g['keywords']) for g in gs)} keywords")
