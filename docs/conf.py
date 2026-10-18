import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent / "_ext"))

project = "Priroda Unofficial Manual"
author = "Program by Dimitri Laikov"
copyright = "2026. Program by Dimitri Laikov"

extensions = [
    "myst_parser",
    "sphinxcontrib.bibtex",
    "priroda_keywords",
]

source_suffix = {".md": "markdown"}
exclude_patterns = ["_build"]
myst_enable_extensions = ["colon_fence", "deflist", "dollarmath", "attrs_inline"]
myst_heading_anchors = 3

language = "en"

bibtex_bibfiles = ["refs.bib"]

html_theme = "furo"
html_title = "Priroda Unofficial Manual"

latex_engine = "pdflatex"
latex_documents = [("index", "priroda-manual.tex", project, author, "manual")]
# pdflatex with Computer Modern (OT1) only: this machine's TeX Live lacks texlive-xetex/-luatex
# (Unicode engines) and texlive-fontsrecommended (Times/T1 fonts). With texlive-xetex installed,
# switch to latex_engine = "xelatex" and drop latex_elements.
latex_elements = {
    # One-sided layout: chapters start on the next page, not the next right-hand page, so no blank pages.
    "extraclassoptions": "openany,oneside",
    "fontenc": "\\usepackage[OT1]{fontenc}",
    "fontpkg": "",
    "preamble": r"""
\usepackage{amssymb}
\DeclareUnicodeCharacter{2713}{\checkmark}
\DeclareUnicodeCharacter{2717}{\ensuremath{\times}}
\DeclareUnicodeCharacter{039B}{\ensuremath{\Lambda}}
\DeclareUnicodeCharacter{03C3}{\ensuremath{\sigma}}
\DeclareUnicodeCharacter{03C0}{\ensuremath{\pi}}
\DeclareUnicodeCharacter{21C4}{\ensuremath{\rightleftarrows}}
\DeclareUnicodeCharacter{2264}{\ensuremath{\le}}
\DeclareUnicodeCharacter{2212}{\ensuremath{-}}
\DeclareUnicodeCharacter{207A}{\textsuperscript{+}}
\DeclareUnicodeCharacter{207B}{\textsuperscript{\ensuremath{-}}}
\DeclareUnicodeCharacter{00BB}{\ensuremath{\gg}}
""",
}
