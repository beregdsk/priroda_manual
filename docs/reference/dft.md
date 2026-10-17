<!-- Generated from keywords/dft.yaml by docs/_ext/priroda_keywords.py. Do not edit. -->


(group.dft)=
# `$dft`

```{index} single: $dft
```

Exchange–correlation functional.

(dft.functional)=
## `functional`

```{index} single: functional ($dft)
```

**Type:** enum\
**Default:** `PBE`\
**Status:** current · not verified\
**Sources:** input.txt; 01 §3.2; 03 §5 (strings); 04 §0

Default: `PBE` (the default GGA); `PBE1` for `theory=ridft`.

Exchange–correlation approximation for DFT methods.

```{tabularcolumns} \Y{0.3}\Y{0.7}
```

| Value | Meaning |
|---|---|
| `PBE` | Perdew–Burke–Ernzerhof, Phys. Rev. Lett. 77 (1996) 3865. (**default**) |
| `mPBE` | Adamo–Barone modification of PBE, J. Chem. Phys. 116 (2002) 5933. |
| `BLYP` | Becke–Lee–Yang–Parr, Phys. Rev. A 38 (1988) 3098; Phys. Rev. B 37 (1988) 785. |
| `OLYP` | Handy–Cohen exchange + LYP correlation, J. Chem. Phys. 117 (2002) 1441. |
| `PBE1` | PBE hybrid with 1/4 exact exchange, J. Chem. Phys. 110 (1999) 6158. Default for `theory=ridft`. |
| `B3LYP_PW` | Becke three-parameter hybrid with PW local correlation (see notes). |
| `B3LYP` | Becke three-parameter hybrid (see notes). |
| `LPBEVV` | Newer functional used by the author with `theory=DFT_n4` (2025). *(undocumented)* |
| `LPBEVVV` | Newer functional used by the author with `theory=ridft` (2023–2025). *(undocumented)* |

```{note}
The B3LYP form in Priroda is
Exc = 0.2·Ex(HF) + 0.8·(0.9·Ex(B) + 0.1·Ex(S)) + 0.81·Ec(LYP) + 0.19·Ec(LSD).
Ec(LSD) is the local correlation of either Phys. Rev. B 45 (1992) 13244 (PW) or Can. J. Phys. 58 (1980) 1200 (VWN).
`input.txt` points out that some commercial programs use VWN, although Becke himself used PW
(J. Chem. Phys. 98 (1993) 5648).

**Hybrids (`PBE1`, `B3LYP`, `B3LYP_PW`) require `theory=ridft`.** With `theory=dft` or `tddft` they either
run silently without exact exchange or abort; see `$control theory`.

No empirical dispersion correction (D3 or similar) is available. The v6 binary contains further functional
names (`VWN5`, `SLYP0`, `BPBE`, `HFLSD`, `HFPBE`, `B2PBE`, `B3PBE`, `HFLYP`, `B1LYP`, `B2LYP`), none of
them documented or tested.
```

**See also:** {ref}`theory ($control) <control.theory>`
