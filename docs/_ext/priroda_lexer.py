"""Pygments lexer for Priroda input files, registered with Sphinx as ``priroda``.

Use ```` ```priroda ```` for input examples. Highlighted: group names (``$control``, ``$end``), keyword names
before ``=``, numbers, quoted strings, ``+flag``/``-flag`` print options, and the coordinate-type words of
``$molecule``. Text outside a group is ignored by the program, so it is shown as a comment.
"""

from pygments.lexer import RegexLexer, bygroups
from pygments.token import Comment, Keyword, Name, Number, Operator, String, Text, Whitespace

NUMBER = r"[+-]?(\d+\.\d*|\.\d+|\d+)([eEdD][+-]?\d+)?(?![\w.])"


class PrirodaLexer(RegexLexer):
    name = "Priroda input"
    aliases = ["priroda"]
    filenames = ["*.in"]

    tokens = {
        "root": [
            (r"\$(?!end\b)[A-Za-z_][\w]*", Keyword.Namespace, "group"),
            (r"[^$\n]+", Comment),
            (r"\$", Comment),
            (r"\n", Whitespace),
        ],
        "group": [
            (r"\$end\b", Keyword.Namespace, "#pop"),
            (r"\s+", Whitespace),
            (r"([A-Za-z_][\w]*(?:\(\d+\))?)(\s*)(=)", bygroups(Name.Attribute, Whitespace, Operator)),
            (r"(?i)\b(cartesian|z-matrix)\b", Keyword.Type),
            (r'"[^"\n]*"', String),
            (NUMBER, Number),
            (r"[+-][A-Za-z]\w*", Name.Builtin),
            (r"[,]", Operator),
            (r"[^\s,=$]+", Name.Constant),
            (r"\$", Text),
        ],
    }


def setup(app):
    app.add_lexer("priroda", PrirodaLexer)
    return {"version": "1.0", "parallel_read_safe": True, "parallel_write_safe": True}
