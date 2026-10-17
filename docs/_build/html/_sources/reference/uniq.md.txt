<!-- Generated from keywords/uniq.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.uniq)=
# `$uniq`

```{index} single: $uniq
```

Duplicate-structure filtering over several `$molecule` blocks.

**Relevant when:** `task = uniq`

(uniq.distance)=
## `distance`

```{index} single: distance ($uniq)
```

**Type:** real\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.9; 09

Threshold for treating two structures as identical (inferred from the official example `dist=0.01`, run on 157
MD snapshots, each in its own `$molecule` block). `dist` is a prefix of the full name `distance`; the group
also reads `file`.
