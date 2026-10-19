<!-- Generated from keywords/uniq.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.uniq)=
# `$uniq`

```{index} single: $uniq
```

Duplicate-structure filtering over several `$molecule` blocks.

**Relevant when:** `task = uniq`

In version 25, `task=uniq` with `dist=0.01` and several `$molecule` blocks in one input did no SCF. It listed each
structure as new (`1 =>     1`) or as a copy of an earlier one with a distance (`2 =      1     0.0060421693`),
printed `2 unique`, and wrote the `Atomic Coordinates` of each unique structure. A copy of a water molecule that
was rotated and translated counted as identical (distance 0), and so did a copy with one H moved by 0.004 Å; a
copy with one H moved by 0.043 Å counted as a new structure.

(uniq.distance)=
## `distance`

```{index} single: distance ($uniq)
```

**Type:** real\
**Default:** *none stated*\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** version 25 test runs, version 25 executable, official site files

Threshold for treating two structures as identical: structures closer than this count as copies. The official
example uses `dist=0.01` on 157 MD snapshots, each in its own `$molecule` block. How the distance is measured
and in which units is not known. `dist` is a prefix of the full name `distance`; the group also reads `file`.
