<!-- Generated from keywords/dynamic.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.dynamic)=
# `$dynamic`

```{index} single: $dynamic
```

Molecular dynamics with a thermostat.

**Relevant when:** `task = thermostat`

Known only from the official example inputs and a third-party input generator. Every meaning below is
inferred, except `file`.

In version 25, `task=thermostat` with `e=0.001 d=0.03 n=20,5 m=10 i=1` ran with every tested theory (`dft`,
`ridft`, `rimp2`, `ccsd`, `tddft`, `qm_n3`). The output has one line per step, `point N: s … E … g …`, where
negative point numbers are equilibration steps (the second value of `n`) and positive ones the production steps
(the first value). In the program, `d` and `h` are prefixes of the keywords `dx` and `hb`.

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
**Sources:** 01 §4.8; 02 §3.2

Thermostat temperature as kT (inferred: a generator script sets e = T/315775).

(dynamic.d)=
## `d`

```{index} single: d ($dynamic)
```

**Type:** real\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2

Time step (inferred).

(dynamic.n)=
## `n`

```{index} single: n ($dynamic)
```

**Type:** list\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2

Number of steps and print interval (inferred).

(dynamic.m)=
## `m`

```{index} single: m ($dynamic)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2

Meaning not known.

(dynamic.i)=
## `i`

```{index} single: i ($dynamic)
```

**Type:** integer\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2

Run index or random seed (inferred).

(dynamic.v)=
## `v`

```{index} single: v ($dynamic)
```

**Type:** real\
**Default:** *none stated*\
**Units:** bohr³ per atom\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2

Volume per atom of a spherical confining cavity, e.g. for simulating a liquid (inferred).

(dynamic.h)=
## `h`

```{index} single: h ($dynamic)
```

**Type:** real\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8; 02 §3.2

Stiffness of the cavity wall (inferred).

(dynamic.file)=
## `file`

```{index} single: file ($dynamic)
```

**Type:** string\
**Default:** *none stated*\
**Status:** undocumented · not verified\
**Sources:** 01 §4.8

printf-style pattern for snapshot files, which are written as ready-to-run inputs; `%06d` is the frame number.
