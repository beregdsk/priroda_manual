<!-- Generated from keywords/dynamic.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.dynamic)=
# `$dynamic`

```{index} single: $dynamic
```

Molecular dynamics with a thermostat.

**Relevant when:** `task = thermostat`

Known from the official example inputs, a third-party input generator, the names in the version 25 executable
and one version 25 test. Only the meaning of `n` and `file` is shown by output; the rest is inferred.

In version 25, `task=thermostat` with `e=0.001 d=0.03 n=20,5 m=10 i=1` ran with every tested theory (`dft`,
`ridft`, `rimp2`, `ccsd`, `tddft`, `qm_n3`). The header echoes `e = 0.00100000` and
`dx = 0.03000000 L = 20,-5;10`. The output has one line per step, `point N: s … E … g …`, where
negative point numbers are equilibration steps (the second value of `n`) and positive ones the production steps
(the first value). The official example (below) writes `d=` and the generator script writes `h=` and `v=`;
these are prefixes of the full names `dx`, `hb` and `v1`.

```text
$dynamic
 e=0.001
 d=0.03
 n=1000,100
 m=10
 i=1
 file=H40C20/H40C20_%06d.qm.in
$end
```

(dynamic.e)=
## `e`

```{index} single: e ($dynamic)
```

**Type:** real\
**Default:** *none stated*\
**Units:** hartree\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2; 08 t69; 09

Thermostat temperature as kT (inferred: a generator script sets e = T/315775). Version 25 echoes it as `e = 0.00100000`.

(dynamic.dx)=
## `dx`

```{index} single: dx ($dynamic)
```

**Type:** real\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2; 08 t69; 09

Time step (inferred). The examples write the prefix `d=`; version 25 echoes it as `dx = 0.03000000`.

(dynamic.n)=
## `n`

```{index} single: n ($dynamic)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · verified on 25 (2025.02.28)\
**Sources:** 01 §4.8; 02 §3.2; 08 t69; 09

Two values: the number of production steps, then the number of equilibration steps. In version 25, `n=20,5`
gave 26 points, `point -5` … `point 20`, and the echo `L = 20,-5;10`.

(dynamic.m)=
## `m`

```{index} single: m ($dynamic)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2; 08 t69; 09

Meaning not known. With `m=10`, version 25 printed `;10` at the end of the echo `L = 20,-5;10`.

(dynamic.i)=
## `i`

```{index} single: i ($dynamic)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2; 08 t69; 09

Run index or random seed (inferred). Version 25 does not echo it.

(dynamic.v1)=
## `v1`

```{index} single: v1 ($dynamic)
```

**Type:** real\
**Default:** *none stated*\
**Units:** bohr³ per atom\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2; 09

Volume per atom of a spherical confining cavity, e.g. for simulating a liquid (inferred). Written as the prefix `v=` in the generator script.

(dynamic.hb)=
## `hb`

```{index} single: hb ($dynamic)
```

**Type:** real\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2; 09

Stiffness of the cavity wall (inferred). Written as the prefix `h=` in the generator script.

(dynamic.file)=
## `file`

```{index} single: file ($dynamic)
```

**Type:** string\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8

printf-style pattern for snapshot files, which are written as ready-to-run inputs; `%06d` is the frame number.
