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
    "priroda_lexer",
    "sphinx.ext.graphviz",
]

source_suffix = {".md": "markdown"}
exclude_patterns = ["_build"]
myst_enable_extensions = ["colon_fence", "deflist", "dollarmath", "attrs_inline", "attrs_block"]
myst_heading_anchors = 3

language = "en"

bibtex_bibfiles = ["refs.bib"]

html_theme = "furo"
html_title = "Priroda Unofficial Manual"
html_static_path = ["_static"]
html_css_files = ["priroda.css"]
html_theme_options = {
    # Moss green for links and headings, amber as the accent: "priroda" is Russian for "nature".
    "light_css_variables": {
        "color-brand-primary": "#2f5d3a",
        "color-brand-content": "#2f6b42",
        "color-brand-visited": "#5a4a7a",
        "font-stack": "'Source Sans 3', 'Segoe UI', sans-serif",
        "font-stack--monospace": "'JetBrains Mono', 'SFMono-Regular', Menlo, monospace",
        "font-stack--headings": "'Fraunces', Georgia, serif",
    },
    "dark_css_variables": {
        "color-brand-primary": "#9fd3a8",
        "color-brand-content": "#a9dbb2",
        "color-brand-visited": "#c4b5e8",
    },
}

# Diagrams: SVG on the web, PDF in the LaTeX build (sphinx.ext.graphviz picks the format per builder).
graphviz_output_format = "svg"
graphviz_dot_args = ["-Gfontname=Helvetica", "-Nfontname=Helvetica", "-Efontname=Helvetica"]

latex_engine = "pdflatex"
latex_documents = [("index", "priroda-manual.tex", project, author, "manual")]
# pdflatex with Computer Modern (OT1) only: this machine's TeX Live lacks texlive-xetex/-luatex
# (Unicode engines) and texlive-fontsrecommended (Times/T1 fonts). With texlive-xetex installed,
# switch to latex_engine = "xelatex" and drop latex_elements.
latex_elements = {
    # One-sided layout: chapters start on the next page, not the next right-hand page, so no blank pages.
    "extraclassoptions": "openany,oneside",
    # Sphinx titles the contents page with the first toctree caption ("Part I. ..."); the parts themselves are
    # \part commands in index.md.
    "tableofcontents": r"\renewcommand{\contentsname}{Contents}\sphinxtableofcontents",
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
% Inline classes from attrs_inline: front-page card titles, capability-matrix marks.
\expandafter\def\csname DUrolepath-title\endcsname#1{\textbf{#1.}}
""",
}
