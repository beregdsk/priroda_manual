<!-- Generated from keywords/uniq.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.uniq)=
# `$uniq`

```{index} single: $uniq
```

Duplicate-structure filtering over several `$molecule` blocks.

**Relevant when:** `task = uniq`

(uniq.dist)=
## `dist`

```{index} single: dist ($uniq)
```

**Type:** real\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.9

Threshold for treating two structures as identical (inferred from the author's example `dist=0.01`, run on 157
MD snapshots, each in its own `$molecule` block).
