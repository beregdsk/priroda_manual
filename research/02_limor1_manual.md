# limor1.nioch.nsc.ru: Priroda page, scripts and basis files

This note collects the Priroda-related material on the site of the Laboratory for the Study of Organic Reaction Mechanisms (ЛИМОР / LMR), Novosibirsk Institute of Organic Chemistry (НИОХ СО РАН). The site's main contact is genaev@nioch.nsc.ru (A. Genaev). The site is a user-written resource, not documentation from D.N. Laikov.

Provenance and reliability:
- **Live site.** The live site answered on 2026-10-16 (HTTP 200). Every page and file was fetched with `curl -sL` into `scratchpad/raw_limor/`. The Wayback Machine CDX API reported "Temporarily Offline", so no archived versions were compared.
- **Encodings.** HTML pages are UTF-8. `basis.in_sets`, `basis4.in_sets` and `pribas` are cp1251. `molden_change_parameter` is KOI8-R.
- **What the site contains.** The Priroda page itself is short: links, basis-set notes and a Molden patch. Most technical detail about Priroda input and output was reverse-engineered from the Perl scripts the lab publishes: `priin`, `pri`, `pri2mol`, `conformers`, `g2i`, `hess`, `priIR` and others. Statements derived from script source are marked **[src: script]**. Interpretations that are not stated explicitly anywhere are marked **(inferred)**.

---

## 1. Source URLs visited

| URL | What it is |
|---|---|
| http://limor1.nioch.nsc.ru/priroda.html | Main Priroda page (Russian, UTF-8) |
| http://limor1.nioch.nsc.ru/file/Priroda/ | Redirects (meta refresh) to `/priroda.html`; no directory listing |
| /file/Priroda/NH3_optimize-fix.txt | Example input: optimization with 2 frozen internal coordinates |
| /file/Priroda/NH3_scan-fix.txt | Example input: dihedral scan with a frozen bond length |
| /file/Priroda/NH3_scan-scan.txt | Example input: simultaneous scan of 2 coordinates |
| /file/Priroda/basis.in_sets | Table of basis-set names/synonyms in Priroda `basis.in`, by element (cp1251) |
| /file/Priroda/basis4.in_sets | Same for `basis4.in` (relativistic, elements 1–102) |
| /file/Priroda/Lbasis.zip (26.6 MB) | Individual basis files (one set per file), taken from basis.in/basis4.in |
| /file/Priroda/common_basis.tar.gz (2.8 MB) | "Standard" basis sets (def2, cc-pVnZ, Pople, …) with auxiliary sets, converted for Priroda |
| /file/Priroda/20+sbk.bas | Combined basis: 3z (H–Ca) + SBK ECP (Sc–Rn), 86 elements |
| /file/Priroda/20+St-rsc-97.bas | Combined basis: 3z (H–Ca) + Stuttgart RSC-97 ECP, 80 elements |
| /file/Priroda/molden_change_parameter | Shell script that patches Molden sources (KOI8-R comments) |
| /file/Priroda/molden4.4_bin_sge_patch.rar | Patched Molden 4.4 Windows build (not downloaded) |
| http://limor1.nioch.nsc.ru/quant/program/ | Index of all lab scripts (Perl), plus the xyz-format description |
| /quant/program/limor_programs.zip | All scripts in one archive (downloaded, read as text, never executed) |
| /quant/program/{priin,pri2mol,pri,steps,g2pri_basis,…}/ | Per-script help pages (60 subpages fetched) |
| /quant/program/mldn-gif/animation.html | "How I make animations" (IRC to animated GIF workflow) |
| /quant.html, /quant1.html, /quant/conformers/, /quant/map.html, /index.html, /info.html | Context pages; they mention that most calculations are DFT/PBE/3z or L1 runs with Priroda |

External links listed on priroda.html, **not fetched** because they are on other hosts. They are useful leads for other notes:
- wt.knc.ru wiki: "Priroda для самых маленьких" ("Priroda for the very youngest") — http://wt.knc.ru/wiki/index.php/Priroda_для_самых_маленьких
- wt.knc.ru wiki: "Priroda Documentation" — http://wt.knc.ru/wiki/index.php/Priroda_Documentation
- qchem.ru tutorial "ПРИРОДА. Знакомство с основами расчёта на примере конформационного анализа NH2-OH" — https://www.qchem.ru/theory_and_practice/priroda_conf_anlz/ (older URL http://www.qchem.ru/practice/priroda/conf/)
- qchem.ru forum message on the combined ECP bases: http://www.qchem.ru/f/kvantovo-khimicheskie-programmy/kvantovo-khimicheskaya-programma-priroda/msg653/#msg653
- qchem.ru topics: "Квантовохимическая программа ПРИРОДА", "Лямбда-базисы (Priroda 06)", "Разные методы - разные значения", "Визуализация Prirod'ных орбиталей"
- chemport.ru forum threads (f=11 / f=71), with titles as given on the page:

  | Thread title | Note | Thread id |
  |---|---|---|
  | Природа | — | t=28803 |
  | imaginary frequencies in PRIRODA | — | t=26858 |
  | Насколько Природой можно учесть сольватацию? | solvation | t=24810 |
  | Базисные наборы в Priroda 6 | — | t=9884 |
  | Priroda и расчёт хим.сдвигов ЯМР | NMR chemical shifts | t=12725 |
  | GIAO и ресурсы машины | GIAO and machine resources | t=11440 |
  | priroda-frequencies calculation | — | t=24024 |
  | PRIRODA: Dipole Polarizability | — | t=34407 |
  | Химсдвиги в Природе | chemical shifts in Priroda | t=30846 |
  | моделирование ЯМР спектров | NMR spectrum simulation | t=28585 |
  | Любителям полуэмпирики | Priroda 11 | t=80217 |
  | Сравнение "быстрых методов" с DFT | Priroda 11 | t=85507 |
  | Релятивистские базисы и порядок связи | Bader analysis | t=82248 |
  | Координата реакции | scan, TS, IRC, bifurcation | t=82513 |
  | Формула для стандартной теплоты образования (PBE/L1) + "Методика получения" | — | t=70978, p579737 / p762200 |
  | Вопрос по природе | failed optimization of a high-spin metal cluster | t=22586 |
  | Сходимость SCF в PRIRODA | Ru complex | t=63223 |
  | PRIRODA: оптимизация геометрии переходного состояния | TS optimization | t=61079 |
  | Расчет термодинамических параметров Firefly (Природа) | — | t=104136 |
  | scan Priroda | — | t=39234 |
  | priroda и поиск ПС | TS search | t=56945 |
  | RI-MP2 in Priroda | computational cost of methods | t=47454 |
  | Priroda - Raman Intensities | — | t=116231 |
  | Природа-MD | molecular dynamics | t=115891 |
  | freq4parts discussion | — | t=49893 |
  | conformational analysis discussion | — | t=50468 |

---

## 2. Content of priroda.html (translated summary)

- Most quantum-chemical calculations whose animations are shown on the site were run with Priroda ("Природа", author Д.Н. Лайков / D.N. Laikov). Calculations are visualized and animated with **Molden**. Input preparation and output-to-Molden conversion use the lab's scripts (section 7).
- **Sample inputs** ("Образцы … некоторые не совсем тривиальные случаи", i.e. some not-quite-trivial cases): three NH3 examples (section 4).
- **Basis sets for Priroda 6 and later as separate files** (`Lbasis.zip`):
  - Quote: "В «родных» природовских базисах basis.in и basis4.in имеется множество базисных наборов, в которых легко запутаться, некоторые из них, к тому же, только для отдельных элементов и/или не имеют соответствующего вспомогательного базиса и поэтому не работоспособны для DFT." Translation: the native files basis.in and basis4.in contain many sets that are easy to confuse. Some sets cover only some elements, and some have no matching auxiliary basis, so they cannot be used for DFT.
  - The archive therefore has one file per set, covering all elements. Each file is just a small part of basis.in or basis4.in:
    ```
    basis.in:  V1 L1 L11 L2 L2m L22 L22m L3 L33 (элементы 1..36, H-Kr)
               L1a L11a L2a L22a L3a L33a (с диффузными функциями, элементы H,He,B-Ne)
    basis4.in:             L1 L11 L2 L22 L3 L33 (элементы 1..102)
    ```
  - Each file starts with a short description of the basis. The description does not disturb Priroda.
  - **Relativistic bases (from basis4.in) start with the letter `r`.** Quote: "не забывайте указывать four=1 при их использовании" (do not forget to specify `four=1` when using them).
  - Older synonym and element-availability tables: `basis.in_sets` and `basis4.in_sets`. Sets that have no auxiliary basis were removed from these tables.
- **Combined bases.** These use 3z on the first 20 elements and an ECP on the rest; the auxiliary basis comes from 3z.
  - `20+sbk.bas`: "3z + SBK", by D. Laikov, 86 elements.
  - `20+St-rsc-97.bas`: "3z + Штуттгартский ECP" (Stuttgart ECP), 80 elements. Elements 31–36, 49–54 and 57–71 are missing.
  - Quote: "Эти базисы можно использовать для расчета хим.сдвигов легких атомов в соединениях, содержащих тяжелые элементы." Use them to compute chemical shifts of light atoms in compounds that contain heavy elements.
- **"Standard" bases** (`common_basis.tar.gz`):
  - Quote: "Базисы серии L достаточны для решения многих (практически любых) задач, но они нигде, кроме как в Природе не используются." The L-series is enough for many (practically any) tasks, but no program other than Priroda uses it. Standard bases are occasionally needed, for example to reproduce a calculation done in another program.
  - The bases were generated by `g2pri_basis` from ORCA output run with keyword `PrintBasis`. Gaussian `GFInput` was also tried, "но генерируемые им дополнительные базисы оказались хуже для Природы" (the auxiliary bases it generated turned out worse for Priroda).
  - Sets included:
    ```
    SV(P) SVP TZVP TZVPP QZVPP def2-SVP def2-TZVP def2-TZVPP def2-QZVPP
    cc-pVDZ cc-pVTZ cc-pVQZ aug-cc-pVDZ aug-cc-pVTZ aug-cc-pVQZ
    cc-pCVDZ cc-pCVTZ cc-pCVQZ aug-cc-pCVDZ aug-cc-pCVTZ aug-cc-pCVQZ
    EPRII EPRIII IGLO-II IGLO-III VDZ VTZ QZV DZ PC-1 PC-2 PC-3
    6-31G(d) 6-31G(d,p) 6-31G(2d) 6-31G(2d,2p) 6-31G(2df) 6-31G(2df,2pd)
    6-31+G(d) 6-31+G(d,p) 6-31+G(2d) 6-31+G(2df) 6-31++G(d,p) 6-31++G(2d,2p) 6-31++G(2df,2pd)
    6-311G(d) 6-311G(d,p) 6-311G(2d) 6-311G(2d,2p) 6-311G(2df) 6-311G(2df,2pd) 6-311G(3df) 6-311G(3df,3pd)
    6-311+G(d) 6-311+G(2d) 6-311+G(2df) 6-311+G(3df) 6-311++G(d,p) 6-311++G(2d,2p) 6-311++G(2df,2pd) 6-311++G(3df,3pd)
    ```
  - Each file begins with the available elements and contraction schemes.
  - `common_basis.in` holds all of them in one file, with set names equal to the basis names. In that file `(d)` has the synonym `*` and `(d,p)` has the synonym `**`.
  - `common_basis.info` lists the bases and the elements available for each.
- **Molden tips**: see section 6.5.
- **Most important scripts**: `priin` (xyz/mop/gjc/mrv to Priroda input) and `pri2mol` (Priroda output to xyz and other Molden files).

---

## 3. Input file syntax (as used on the site and parsed by the scripts)

General syntax:
- **Groups.** The input is a sequence of groups `$name … $end`. Group and keyword names are case-insensitive: the `pri` script reads `$Energy`, `$molecule` and others with the `/i` flag, and its help says "В отличие от «Природы» регистр символов важен" (unlike Priroda, letter case matters [in the script's task string]).
- **Layout.** Keywords are `key=value` pairs separated by whitespace or newlines. A whole group may sit on one line, e.g. `$system mem=128 disk=1 $end`.
- **Abbreviated keywords are accepted.**
  - The site's inputs use `accur=` (= `accuracy`), `tol=` (= `tolerance`), `mem=` (= `memory`) and `cart=1` (= `cartesian`).
  - The `pri` script expands an abbreviation to the shortest matching full keyword of the group (its `$extended_word` routine) **[src: pri]**.
- **Keywords with an index in parentheses.** Example: `$guess na(85)=86,85 $end`. The `pri` comment parses this as `na` with parameter `(85)` and value `86,85` **[src: pri]**. *(inferred)* It sets the occupation or ordering of alpha orbitals, e.g. swapping orbitals 85 and 86.
- **Values.**
  - Lists use commas and/or spaces: `fix=1,1,2,0,0 3,2,1,4,3`.
  - Strings may be quoted: the `pri` regex for a string is `"[^"]*"|\S+`, so a basis path containing special characters goes in double quotes.

### 3.1 Complete keyword inventory known to the `pri` script **[src: pri, `read_in`/`print_in`]**

| Group | Keywords (value type) |
|---|---|
| `$system` | `memory` (int), `disk` (int), `path` (string) |
| `$control` | `task` (string), `theory` (string), `state` (int[,int]), `basis` (string), `four` (int), `nucleus` (string), `print` (string), `save` (string) |
| `$guess` | `read` (0/1), `na` (int list), `nb` (int list) |
| `$dft` | `functional` (string) |
| `$scf` | `restrict` (0/1), `convergence` (float[,float]), `iterations` (int[,int]), `procedure` (string), `d1small` (0/1), `core` (int) |
| `$atoms` | `core` (int list), `mcore` (int) |
| `$grid` | `accuracy` (float) |
| `$optimize` | `saddle` (0/1), `tolerance` (float[,float]), `trust` (1–3 floats), `follow` (int), `steps` (int), `cartesian` (0/1), `back` (0/1), `points` (int), `radius` (float), `coordinated` (int list), `fix` (int list), `value` (float list), `gradient` (int), `print` (0/1) |
| `$thermo` | `sigma` (int), `temperature` (float list) |
| `$d2edr2` | `length` (float), `displace` (int), `steps` (int[,int]) |
| `$nmr` | `standard` (float list), `points` (triples of floats) |
| `$molecule` | `charge` (signed int), `mult` (int), then `cartesian` or `z-matrix` followed by the geometry |
| `$Energy` | `E=`, `D=`, `A=`, `G=`, `Dx=`, `H=` (numeric arrays). This is restart data pasted from a previous output (see 3.3) |

Groups that `pri` does not know are passed through unchanged; it warns "Unknown group". Other groups exist in Priroda that the script ignores. `priin` writes `$dynamic` (section 3.2.9), and the QM method uses `basis=qm.in`.

### 3.2 Meaning of each group/keyword as evidenced on the site

#### `$system`
- **`mem` / `memory`.** Memory amount.
  - Values seen: `mem=128` (NH3 examples), `mem=64` (g2i), `mem=256` (conformers QM runs), `mem=2000` (priin default).
  - *(inferred)* The unit is megabytes: Priroda output prints `Memory: N MB` (g2i parses `^ *Memory: +(\d+) MB$`).
- **`disk`.** Scratch disk amount.
  - Values seen: `disk=1` (examples, g2i), `disk=-256` (conformers), `disk=-4000` (priin default).
  - `priin` writes `path=` only if `disk > 0`. *(inferred)* A negative `disk` means no scratch files are written to disk (data kept in memory, up to |disk|), and a positive `disk` uses scratch files in `path`.
  - The end-of-run summary prints `Memory used = …` and `Disk  used = …`. `pri` divides these by 1024 to get "M", and the disk value by 1024² to get "G", so they appear to be in KB.
- **`path`.** Directory for temporary files.
  - Quote from `pri`: "Директория для временных файлов Природы (на разделе, где много места) … если и $path_tmp не задана, то Priroda default (/tmp)". Translation: the directory for Priroda's temporary files should be on a partition with plenty of space; if nothing else is set, Priroda's default is `/tmp`.
  - Temporary files are named `tmpNNN.NNN` (`pri` deletes `$path/tmp\d+\.\d+` leftovers before each run).
  - `priin` picks the first writable directory among `/disk2/tmp/$USER`, `/disk2/tmp`, `/tmp`, falling back to `.`.

#### `$control`
- **`task`.** Values seen on the site: `optimize`, `scan`, `hessian`, `nmr`, `irc`, `energy`, `gradient`, `dipole`, `thermostat` (MD). `pri` notes that the **Priroda default task is `gradient`** (`$in->{control}{task} ||= 'gradient'; # Priroda default task`).
- **`theory`.**
  - `dft` is the default used by `pri` (`'DFT'`).
  - `qm_n3` is Laikov's new semiempirical "QM" method in Priroda 11/14. It needs `basis=qm.in`, which is shipped in Priroda's basis directory, e.g. `/usr/local/lib/priroda/basis/qm.in`.
  - Elements supported by the QM method according to `conformers`: H; Li Be B C N O F; Na Mg Al Si P S Cl; Sc Ti V Cr Mn Fe Co Ni Cu.
  - `pri` also allows a `(method/functional/basis)` override per task; a method that needs no functional is written `(method//basis)`. The forum link "RI-MP2 in Priroda" shows that MP2-type theories exist.
- **`basis`.** File name or path of the basis file.
  - Forms seen: `basis=3z.bas`, `basis=L1` (a file from Lbasis.zip), `basis=rL1` (relativistic), `basis=qm.in`, `basis=/usr/local/lib/priroda/basis/basis.in`.
  - Older Priroda (2/4) used `*.bas` files: `3z.bas`, `L1.bas`, `L2.bas`, `L22.bas`, `iglo.bas`, `II-3z.bas`, `III-3z.bas`, `IV-3z.bas`, `ccpv3z.bas`, `ccpv4z.bas`, `3z_sbk.bas`, `iglo3z.bas`, `II-ccpv3z.bas`; the names come from pri2mol's TMS table.
  - Basis lookup used by `pri`: current directory first, then a basis directory (`/usr/local/lib/priroda/basis`).
- **`four`.**
  - The site never says what `four` means. priroda.html only says "не забывайте указывать four=1" (do not forget `four=1`) for the `r*` (scalar-relativistic, basis4.in) bases. *(inferred)* It switches on the relativistic Hamiltonian that basis4.in needs.
  - `pri` sets `four=1` automatically if the basis name starts with `rL` or the basis is `basis4.in`.
  - The rL basis files are labelled "Scalar-relativistic basis for Priroda from basis4.in, D.N. Laikov. Chemical Physics Letters 416 (2005) 116-120".
- **`state`.** Format `int[,int]`. *(inferred)* Selects an electronic state.
- **`nucleus`.** String. *(inferred)* Nuclear model, relevant for relativistic runs.
- **`print`.** Additive flags with `+`.
  - Seen: `print=+charges` (g2i inputs) and `print=+molden`. `pri` adds `+molden` to `task=hessian` so the output contains a Molden-format frequency block (`freq>` lines).
  - `pri` has a commented-out `print=+vectors`/`+molden` for energy runs. With `+molden`, the output also carries MO coefficients in Molden format on `mos>` lines.
- **`save`.** File name for saving the vectors (MO coefficients). `pri` sets `save=$path/$output.vec` during its "smart optimize" so it can restart from the last vectors.

#### `$guess`
- `read=1` reads the initial vectors from a previous run, used together with `save=` (the file named in `save`).
- `na`, `nb`: alpha/beta orbital specification, e.g. `na(85)=86,85`.

#### `$dft`
- `functional`: the default is `PBE` (in `pri`: `$in->{dft}{functional} || 'PBE'`). The output line `Approximation to E(xc)  PBE` is parsed by pri2mol. B3LYP also appears in pri2mol's TMS table, so hybrid functionals exist.

#### `$scf`
- **`iterations`.** Maximum number of SCF cycles.
  - Quote from the `pri` help: "Говорят, в сложных случаях помогает умеренное кол-во циклов (iterations=10) с последующим перезапуском". Translation: they say a moderate number of cycles (`iterations=10`) followed by a restart helps in difficult cases.
- **`convergence`.** Threshold; format `float[,float]`.
- **`restrict`.** 0/1: restricted or unrestricted.
- **`procedure`.** String (SCF algorithm).
- **`d1small`.** 0/1.
- **`core`.** int.
- The meanings of `procedure`, `d1small` and `core` are not explained on the site.

#### `$atoms`
- `core` (list), `mcore` (int). *(inferred)* Frozen-core or ECP-core specification per atom.

#### `$grid`
- `accur=1e-8` (= `accuracy`) is the DFT integration grid accuracy. It is used in every site input except the MD ones.

#### `$optimize` (geometry optimization, scan, TS, IRC)
- **`steps`.** Maximum number of optimization steps. `pri` says the default is 50 ("steps= в группе $optimize, 50 by default"). The site uses `steps=300`, and g2i uses 100.
- **`tol` / `tolerance`.** Convergence tolerance on the gradient: `tol=1e-5` in the examples, `tol=1e-6` in the QM conformer runs. Format `float[,float]`.
- **`trust`.** Trust radius: `trust=0.5` in the examples; up to 3 values allowed.
- **`saddle=1`.** Transition-state search. `pri` turns the pseudo-task `saddle`/`TS` into `task=optimize` with `saddle=1`.
- **`follow`.** int. *(inferred)* Which Hessian mode to follow in the TS search.
- **`cartesian` / `cart=1`.** Optimize in Cartesian coordinates. Used in the conformers QM runs: `$optimize tol=1e-6 steps=300 cart=1 $end`.
- **`back`.** 0/1, the IRC direction. `pri` runs `irc` as two jobs: `irc0` (`back=0`) and `irc1` (`back=1`).
- **`points`.**
  - For `task=scan`: the number of scan points (`points=4` in the examples).
  - For `task=irc`: the number of IRC points; `pri` sets a default of `points=100` if not given.
- **`radius`.** float. *(inferred)* IRC step size or hypersphere radius.
- **`coordinated`.** int list.
- **`fix=`.** Frozen or scanned internal coordinates. Each coordinate is 5 integers `type,i,j,k,l`:
  - `1,i,j,0,0` is the bond length i–j.
  - `2,i,j,k,0` is the valence angle i–j–k.
  - `3,i,j,k,l` is the dihedral angle i–j–k–l.
  - `4,i,j,k,l` is a "bend": per molgeom, "угол между прямой l-k и нормалью к плоскости k-j-i (в Природе это bend-1 4,i,j,k,l)", i.e. the angle between line l–k and the normal to plane k–j–i.
  - Several coordinates are separated by spaces.
  - `priin` converts frozen MOPAC z-matrix flags (0 instead of 1) to the matching `fix=` entries: for atom i with z-matrix references k,l,m it writes bond `1,i,k,0,0`, angle `2,i,k,l,0`, dihedral `3,i,k,l,m`.
- **`value=`.**
  - With `task=optimize`: the target values of the `fix` coordinates, one per coordinate. Example: `value=1.1 170` sets the bond to 1.1 Å and the dihedral to 170°.
  - With `task=scan`: the start set and end set of values, each comma-separated, in `fix` order. `value=1.1,-180 1.1,-150` scans from (1.1 Å, −180°) to (1.1 Å, −150°); the first coordinate stays constant, so it is effectively frozen.
- **`gradient`.** int.
- **`print`.** 0/1.

#### `$thermo`
- **`sigma`.** Rotational symmetry number used in thermochemistry. `priin` writes `$thermo sigma=N $end` for `task=hessian`. N comes from the string `sigma N` on the second line of the source xyz file (default 1).
- **`temperature`.** List of temperatures. The output prints a block for every `T = … K`; see section 5.

#### `$d2edr2`
- `length` (float), `displace` (int), `steps` (int[,int]). *(inferred)* Numerical second derivatives: finite-difference step length, displacement mode and number of steps.

#### `$nmr`
- **`standard=`.** Reference shieldings, as a list. Quote from pri2mol: "file.ppm хим. сдвиги (sigma и, если посчитан стандарт, то и delta)". The .ppm file holds sigma and, if a standard was computed, delta too.
- **`points=`.** Extra points (x y z triples, Å) where shielding is computed (NICS). `priin` writes them automatically when the xyz file contains dummy atoms `XX` (made by `addXX`). In that case `task=nmr` and:
  ```
  $nmr
   points=
        0.00000000    0.00000000    0.00000000
        0.00000000    0.00000000    1.00000000
  $end
  ```
  The output then contains "Calculation of NMR Chemical Shifts", then "additional points", then the coordinates. Each point's result is on an `isotropic=` line; NICS = −isotropic.

#### `$molecule`
- `charge=` (default 0) and `mult=` (default 1); `pri` supplies these defaults.
- Then the keyword `cartesian` followed by lines `Z  x  y  z` (atomic number, coordinates in Å), or `z-matrix` followed by MOPAC-like lines:
  ```
   z-matrix
     Z1
     Z2  k  r
     Z3  k  r  l  angle
     Z4  k  r  l  angle  m  dihedral
  ```
  The format is `%4d%6d%10.6f%6d%10.4f%6d%10.4f`, as written by priin from MOPAC input.
- **No symmetry is used.** g2i quote: "Priroda supports no symmetry" (it sets C1).

#### `$Energy` (restart block)
- After `task=hessian` the output contains an `eng>` block. pri2mol saves it to `file.MOL` (optimized geometry plus Hessian, "которые можно вставить в след. расчет"), i.e. it can be pasted into the next run.
- Keys: `E=` (energy), `G=` (gradient), `H=` (Hessian, lower triangle, 3N(3N+1)/2 numbers per hess), `D=`, `Dx=`, `A=`. *(inferred)* `D`/`Dx`/`A` are dipole, dipole derivatives and polarizability.
- `pri` copies the last Hessian into the input of the following `optimize`, `saddle` or `irc` tasks. It refuses saddle/IRC if the Hessian has no imaginary frequency ("Перед irc и saddle д.б. посчитан hessian и в нем д.б. мнимая частота (или в input-файле д.б. группа с $Energy)"; before irc and saddle a hessian with an imaginary frequency must be computed, or the input must contain a `$Energy` group).

#### `$dynamic` (molecular dynamics, `task=thermostat`) **[src: priin]**
- `priin -md` writes:
  ```
  $dynamic
   e=0.001 d=0.03
   v=500 h=0.1        (only with spherical cavity, -vol / -md_v / -md_h)
   n=1000,100 m=10
   i=1
  $end
  ```
- **`e`** *(inferred)* is the thermostat temperature kT in hartree. `-md_T=T` sets `e = T/315775`, and 315775 K ≈ 1 hartree/k_B.
- **`d`** (default 0.03) *(inferred)* is the time step.
- **`v`** is the volume per atom in bohr³ for a spherical cavity. priin computes it from a liquid density (`-vol=0.89` g/cm³): `v = (M/N_A)/ρ·1e24/0.52917721³/N_atoms`.
- **`h`** (default 0.1) *(inferred)* is the wall stiffness.
- **`n=1000,100`** *(inferred)* is the number of steps and the print interval.
- **`m=10`**: meaning not stated.
- **`i`** *(inferred)* is the run index or random seed. `-md_i=1-9` produces 9 inputs with different `i`.
- MD output contains `THERMOSTAT`, ` point …` trajectory lines and `Atomic Coordinates:` blocks. pri2mol writes `file.xyz` (frames annotated `Energy … point … s … g …`) and `file.trj`.

### 3.3 Output markers useful for post-processing **[src: pri2mol, pri, hess, priIR, g2i, conformers]**

**Header and system information**

| Marker | Meaning |
|---|---|
| `program  Priroda  version 4.07 (14.09.2004)`, `program  Priroda  version 2.10 (14.01.2002)`, `Priroda 6 (2006.08.20)` | Version banner. The next line matches `copyright (c) … Laikov`. |
| `Basis set input: '<file>'` | Basis file used |
| `N atoms, M electrons`, `Number of atoms N` | Molecule size |
| `Charge of molecule N`, `Spin multiplicity N` | Charge and multiplicity. The charge line is printed as `| Charge of molecule N`. |
| `formula: C2H6O` | No real title is printed |
| `Memory: N MB` | Memory |
| `Approximation to E(xc)  PBE` | Functional |

**Geometry, energy and properties**

| Marker | Meaning |
|---|---|
| `Atomic Coordinates:` | Followed by N lines `Z x y z` (Å) |
| `  E  = …`, `eng> E=…` | Energy. The QM method prints `Energy: …`. |
| ` dipole = … D` | Dipole moment |
| `atom    charge    spin` | Mulliken-type charges and spins, N lines |
| `Critical Points of the Density` | Lines `r= x, y, z f= value` (Bader analysis) |

**Optimization and SCF progress**

| Marker | Meaning |
|---|---|
| `Geometry Optimization Step N` | Optimization step |
| ` max. gradient = …` | Gradient |
| ` OPTIMIZATION CONVERGED` (also `OPTIMIZATION CONVERGED in …`) | Convergence. For scan and IRC it is printed once per point. |
| SCF header ` it.       energy       energy change    gradient     time` | Followed by lines of 1 integer and 4 floats |
| ` converged!` / ` no convergence!` | SCF result |
| ` SCF is far from convergence` | Priroda stops |

**Restart blocks**

| Marker | Meaning |
|---|---|
| `MOL>` lines | Optimized `$molecule … $end` block |
| `mol>` lines | Current `$molecule` |
| `eng>` lines | `$Energy` block |
| `mos>` | Molden orbitals |
| `freq>` | Molden frequencies |

**Task-specific sections**

| Marker | Meaning |
|---|---|
| `SCAN>` or `task=scan` | Scan run |
| `Intrinsic Reaction Coordinate`, `IRC> point … g = …` | IRC run |
| `COMPUTATION OF SECOND DERIVATIVES`, ` VIBRATIONAL ANALYSIS and THERMOCHEMISTRY` | Hessian run |
| `freq.` lines with `i` | Imaginary frequencies |
| Table header ` \| Mode \| Freq.   \| Mass. \| IR Int.` (v4+, `\|`-separated) | Frequencies and IR intensities. Priroda 2 printed lines ` freq.` and ` ir i.`. |
| `ZPVE = …` | Zero-point vibrational energy |
| `T = 298.15 K` | Five lines later comes a row whose columns 2–6 are lnQ, S, U, H, G (kcal/mol for U/H/G per pri2mol) |
| `NMR Shielding Tensors` | Per atom `Atom  n  El: … sigma(iso) principal values…`, followed by 3 tensor lines |
| `qm file:` | Run uses the QM semiempirical method |
| `THERMOSTAT` | MD run |
| Final summary after ` ===========` | `Memory used =`, `Disk  used =`, `REAL time =`, ending at ` ratio` |

---

## 4. Complete input examples (verbatim from the site)

### 4.1 Optimization with two frozen geometric parameters (`NH3_optimize-fix.txt`)
Quote: "оптимизация с замораживанием двух геометрических параметров". Bond N1–H2 is fixed at 1.1 Å and dihedral H2–N1–H4–H3 at 170°.
```
$system mem=128 disk=1 $end
$control
 task=optimize
 basis=3z.bas
$end
$grid accur=1e-8 $end
$optimize
 fix=1,1,2,0,0 3,2,1,4,3  value=1.1 170
 steps=300
 tol=1e-5
 trust=0.5
$end
$molecule
 charge=0 mult=1
 cartesian
   7    0.00000000    0.00000000    0.00000000
   1    0.00000000    0.00000000    1.00800000
   1    0.87295400    0.00000000   -0.50400000
   1   -0.87295400    0.00000000   -0.50400000
$end
```

### 4.2 Dihedral scan with a frozen bond length (`NH3_scan-fix.txt`)
Quote: "сканирование по диэдральному углу с замороженной длиной связи". The bond stays at 1.1 while the dihedral goes from −180 to −150 in 4 points.
```
$system mem=128 disk=1 $end
$control
 task=scan
 basis=3z.bas
$end
$grid accur=1e-8 $end
$optimize
 fix=1,1,2,0,0 3,2,1,4,3
 value=1.1,-180 1.1,-150
 points=4
 steps=300
 tol=1e-5
 trust=0.5
$end
$molecule
 charge=0 mult=1
 cartesian
   7    0.00000000    0.00000000    0.00000000
   1    0.00000000    0.00000000    1.00800000
   1    0.87295400    0.00000000   -0.50400000
   1   -0.87295400    0.00000000   -0.50400000
$end
```

### 4.3 Simultaneous scan of two parameters (`NH3_scan-scan.txt`)
Quote: "сканирование одновременно двух геометрических параметров". Bond 1.0 to 1.1 and dihedral −180 to −150, 4 points.
```
$system mem=128 disk=1 $end
$control
 task=scan
 basis=3z.bas
$end
$grid accur=1e-8 $end
$optimize
 fix=1,1,2,0,0 3,2,1,4,3
 value=1.0,-180 1.1,-150
 points=4
 steps=300
 tol=1e-5
 trust=0.5
$end
$molecule
 charge=0 mult=1
 cartesian
   7    0.00000000    0.00000000    0.00000000
   1    0.00000000    0.00000000    1.00800000
   1    0.87295400    0.00000000   -0.50400000
   1   -0.87295400    0.00000000   -0.50400000
$end
```

### 4.4 Default input produced by `priin` (reconstructed from source; defaults mem=2000, disk=-4000, basis L1, task optimize)
```
$system mem=2000 disk=-4000 $end
$control
 task=optimize
 theory=dft
 basis=L1
$end
$grid accur=1e-8 $end
$optimize
 steps=300 tol=1e-5
$end
$molecule
 charge=0 mult=1
 cartesian
   6    0.00000000    0.00000000    0.00000000
   ...
$end
```
priin's choices:
- **Charge.** If no charge is known, the charge is set to `sum(Z) mod 2` (0 or 1) so the system is a closed-shell singlet or a cation.
- **Relativistic basis.** With an L basis and any atom heavier than Kr (Z > 36), the basis becomes `rL…` (the user must still set `four=1`; `pri` does this automatically).
- **Basis options.** `-basis=…`, `-z` gives the `3z` basis, `-qm` gives `theory=qm_n3 basis=qm.in`.
- **Task options.** `-H` gives `task=hessian` plus `$thermo sigma=N $end`.
- **Output name.** `name.<basis>.in` (e.g. `mol.L1.in`, `mol.rL1.in`, `mol.qm.in`).

### 4.5 QM (semiempirical, Priroda 14) optimization as written by `conformers -method=QM`
```
$system mem=256 disk=-256 $end
$control task=optimize theory=qm_n3 basis=/usr/local/lib/priroda/basis/qm.in $end
$optimize tol=1e-6 steps=300 cart=1 $end
$molecule charge=0 mult=1 cartesian
    6   0.00000000   0.00000000   0.00000000
 ...
$end
```
Run as `/usr/local/lib/priroda/mpiexec -np N /usr/local/lib/priroda/p file.in`. Output goes to stdout and is parsed for `Atomic Coordinates:`, `Energy:`, `max. gradient` and `OPTIMIZATION CONVERGED`.

### 4.6 NMR input template produced by `g2i -o p` (old Priroda 2/4 style)
```
Input for Priroda from <file> by g2i     <formula>
$system mem=64 disk=1 $end
$control
 task=nmr
basis=3z.bas
 print=+charges
$end
$grid accur=1e-8 $end
$optimize
 steps=100
 tol=1e-5
$end
$molecule
 charge=1 mult=1
 cartesian
  6   0.00000000   0.00000000   0.00000000
...
$end
```
Text before the first `$group` (the comment line) is evidently ignored by Priroda.

### 4.7 Multi-step task strings for the `pri` driver (not native Priroda)
```
task=optimize+hessian+nmr(L22)
task=hessian(b1)+optimize(b1)+optimize
task=hessian(b1)+saddle+hessian+irc
```
b1 and L22 are the "light" and "heavy" bases. Overrides take the form `(method/functional/basis)`, `(functional/basis)` or `(basis)`.

---

## 5. Practical advice found on the site

### 5.1 Running the program
- **Executables named on the site:**
  - `p6_32`: Priroda 6, 32-bit, at `/usr/local/lib/priroda/p6_32`.
  - `p9`.
  - `p1`: Priroda 11, at `/usr/local/lib/priroda/p1`.
  - `p` plus a bundled `mpiexec`: Priroda 14, at `/usr/local/lib/priroda/p` and `/usr/local/lib/priroda/mpiexec`.
  - Versions verified with pri2mol: p210, p407, p6 and p11 on Linux, p202 on Windows.
- **Command lines:**
  - `p6_32 input.in output` (from the `steps` launcher config: `run => '/usr/local/lib/priroda/p6_32 !INPUT! !OUTPUT!'`).
  - `priroda -np N input.in output` (the `pri` driver calls `($priroda, '-np', $np, $tmp_input, $output)`), and `priroda -np N input.in` writing to stdout (smart optimize).
  - Priroda 14 runs through MPI: `mpiexec -np N p input.in`. The `-np=N` option of `pri` and `conformers` sets the number of cores (default 1).
- **stderr.** Quote from `pri`: "Также на консоль попадают сообщения Природы в stderr, если их не перенаправить". Priroda's stderr messages reach the console unless redirected.
- **Output naming by `pri`.**
  - If the input ends in `.in` or `.inp`, the output has no extension; otherwise the output is `<input>.out`.
  - Per-task suffixes: `Optimize→Opt`, `optimize→O`, `hessian→H`, `saddle→TS`, `nmr→NMR`, `scan→SCAN`, `irc0→IRC0`, `irc1→IRC1`, `energy→E`, `gradient→G`, `dipole→D`.
  - A suffix that repeats gets an incremented number.
- **Batch launcher `steps`.** Processes a folder of inputs: the oldest file is taken first and moved to a run folder, and new inputs can be added while it runs. A lock file `~/.steps.run` prevents a second launcher. The input extension selects the program: `.in` is Priroda, `.inp` is (PC)GAMESS, `.gjf` is Gaussian, `.ino` is ORCA.

### 5.2 Memory/disk
- Use a scratch directory on a large partition (`path=`; e.g. `/disk2/tmp/$USER`). Delete leftover `tmp*.*` files there (`pri` does this automatically).
- See 3.2 `$system` for the sign convention of `disk` *(inferred)*. Values used in practice: `mem=128 disk=1` (small NH3 jobs), `mem=2000 disk=-4000` (priin default), `mem=256 disk=-256` (QM conformer runs).
- The end-of-run summary reports memory and disk used and REAL time; `pri` prints "memory X M, disk Y G, time Z h".

### 5.3 SCF convergence troubleshooting
- Save vectors (`$control save=file.vec`) and restart from them with `$guess read=1`.
- Quote from `pri`: "Если за заданное количество циклов (iterations= в группе $scf) градиент SCF остается слишком большим (SCF is far from convergence) и Природа вылетает, то она перезапускается с текущей геометрией и последними векторами (read=1 в группе $guess). Говорят, в сложных случаях помогает умеренное кол-во циклов (iterations=10) с последующим перезапуском." Translation: if the SCF gradient stays too large after the allowed `iterations=` and Priroda aborts with "SCF is far from convergence", restart with the current geometry and the last vectors (`$guess read=1`); a moderate number of cycles (`iterations=10`) followed by a restart reportedly helps in hard cases.
- Forum threads (not fetched) cover SCF convergence for a Ru complex and a failed optimization of a high-spin metal cluster.

### 5.4 Geometry optimization troubleshooting
- Raise `steps` from the default 50 to 300 (the site's standard), with `tol=1e-5` and `trust=0.5`.
- Quote from `pri`: "Если оптимизация геометрии не сходится за заданное количество шагов …, то перестартовывает Природу с последней геометрией. Это полезно, когда оптимизация не сходится даже за 300 шагов, «зацикливаясь» около некоторой геометрии." Translation: if the optimization does not converge within the given steps, restart Priroda from the last geometry; this helps when the optimization cycles around some geometry even after 300 steps. On restart, the old `$Energy`/Hessian is dropped.
- Use `cart=1` (Cartesian optimization) for robust automated runs; conformers does this. conformers also notes that Cartesian optimization in MOPAC is slower than in a z-matrix but more reliable for automatic work.
- A pre-computed Hessian, pasted as the `$Energy` block from `task=hessian`, speeds up `optimize`. `pri` reuses it unless it is stale, e.g. `hessian(b1)+optimize(b1)+optimize`.

### 5.5 TS search, IRC, scans
- **TS search.** Set `$optimize saddle=1` with `task=optimize`. First compute a Hessian with an imaginary frequency and paste its `eng>` block as `$Energy` (pri: "Перед irc и saddle д.б. посчитан hessian и в нем д.б. мнимая частота"). A typical sequence is `hessian(b1)+saddle+hessian+irc`: a cheap Hessian, TS optimization, a Hessian to verify one imaginary frequency, then IRC in both directions.
- **IRC.** Use `task=irc` with `$optimize back=0` for one direction and `back=1` for the other, and `points=N` (`pri` uses 100). Each IRC point ends with `OPTIMIZATION CONVERGED`; the line `IRC> point … g = …` gives the gradient.
- **IRC step metric.** The square root of the mass-weighted difference measure computed by `coord` "совпадает с параметром, характеризующим шаг IRC (по крайней мере, в Природе)", i.e. it matches Priroda's IRC step parameter. The unit is sqrt(amu)·Å.
- **Scan.** Use `task=scan` with `fix=` and `value=start… end…` plus `points=`; see the examples in section 4. A relaxed scan prints `OPTIMIZATION CONVERGED` per point, and pri2mol extracts only the converged geometries. With `-all`, it extracts every step.
- **Animations (mldn-gif/animation.html).** Scanning often gives geometry jumps. For smooth animations, find the TS and descend along IRC. Join the branches by reversing one with `reverse`. For a symmetric TS, compute only one IRC branch and then apply `reflect` and `renum`. Fix numbering with `renum`/`tenzor -sort` and orientation with `smooth`/`reflect`/`tenzor`, render frames in Molden, and assemble them with gifsicle (commands in section 7).
- **Forum topic "Координата реакции".** Covers scans, TS, IRC and bifurcations (not fetched).

### 5.6 Frequencies and thermochemistry
- `task=hessian` gives a vibrational analysis and thermochemistry. Use `$thermo sigma=` for the symmetry number and `temperature=` for the temperature list.
- Output contains `ZPVE =` and, per temperature, lnQ, S, U, H, G. pri2mol writes into the xyz comment line `ZPE <ZPVE>` and `G(<T>) <G>`. The site's level-diagram tools state that G is in kcal/mol and ZPE in hartree ("ZPE 0.095000 (a.e.)", "G(298.25) 33.98 (kcal/mol)"). The thermal correction G already includes ZPE.
- **IR intensities.** The v4+/v6 table is `| Mode | Freq. | Mass. | IR Int. |`. pri2mol appends `[INT]` to the Molden `.freq` file. `priIR` builds a spectrum: Lorentz or Gauss line shape, width 10 cm⁻¹, range 20–4000 cm⁻¹, JCAMP-DX output.
- **Moving the Hessian to other programs.** `hess` converts a Priroda Hessian (`eng> H=` lower triangle) into a GAMESS `$HESS` group or an ORCA `.hess` file.
- **Heat of formation (PBE/L1).** pri2mol's empirical increments, in hartree per atom:
  - C −38.0843685585
  - H −0.5872542349
  - N −54.7271355293
  - O −75.1115133857

  HoF (kcal/mol) = (E_total − Σ nᵢ·incrementᵢ) × 627.5, written as `HoF … kcal`. The method is described in chemport t=70978.
- **Dispersion.** Not built into the scripts. The `Edisp` script runs Grimme's `dftd3` with BJ damping (`-finc=pbe` by default) and adds `Edisp` (kcal/mol) to the xyz comment line.

### 5.7 NMR
- Use `task=nmr`; the output has an "NMR Shielding Tensors" section. Old threads mention GIAO and the resources it needs.
- **Bases for shielding.** In the TMS tables these are 3z, L22, iglo, II/III/IV-3z and ccpv3z/4z. The combined bases `20+sbk.bas` and `20+St-rsc-97.bas` give light-atom shifts in heavy-element compounds.
- **Reference shieldings (TMS etc.) used by pri2mol** to convert σ to δ (δ = σ_ref − σ). PBE values:

  | Basis | Reference shieldings |
  |---|---|
  | iglo / II-ccpv3z | C 181.7934, H 31.567, Si 332.2421 |
  | iglo3z / II-3z | C 182.088, H 31.599, Si 334.1568 |
  | L1, L2 | C 182.94−7.16, H 31.179−0.031, Si 352.9499 |
  | L22 | C 182.94−10 (TMS-empirical), H 31.179−0.031, Si 352.9499, N 228.74 ("THEOCHEM"), O 186.57+77.3 (PhOH, OMR 1993, 31, 489) |
  | 3z | C 182.000, H 31.392, Si 328.8347, F 318.91, N −134.594, O 327.9538, Al 555.98, Ti −1085, Cl −20.2; B linear δ = −0.935433·σ + 92.888; P 353.96+(−62) (σ(PMe3)+δ(PMe3); an alternative is 277.08 = σ(H3PO4)) |
  | 3z_sbk | same as 3z, but B 93.90 (σ(BF3·Et2O)) |
  | ccpv3z | C 183.089, H 31.199, Si 335.1516 |
  | ccpv4z | C 180.54, H 31.116, Si 344.3229 |
  | III-3z | C 188.0585+2.1, H 31.288+0.233 |
  | IV-3z | C 188.1792+2.1, H 31.1894+0.233 |

  B3LYP/3z: C 166.214, H 29.602, Si 289.219.
- **Anisotropy correction.** Optional (`pri2mol -asymm`): σ += (σ22−σ11)/(σ33−σ), citing J. Mol. Struct. THEOCHEM 953 (2010) 83-90.
- **NICS.** Add dummy atoms `XX` with `addXX`, e.g. at ring centres and ±1 Å above and below. `priin` then creates `task=nmr` with `$nmr points=`. In `.xyzppm`, `XX` atoms carry −σ_iso.
- **Related scripts.** `average` (averaging of equivalent or Boltzmann-weighted shifts), `xyz2ppm` (table for Excel), `xyz2jmod` (13C/1H spectrum plots), `mskxyz` (shifts shown in MarvinSketch).

### 5.8 Solvation
- The only material on the site is the forum link "Насколько Природой можно учесть сольватацию?" ("To what extent can solvation be accounted for with Priroda?", chemport t=24810).
- `priin`'s MD mode offers a spherical cavity (`-vol=density` gives `$dynamic v= h=`) for cluster or "liquid-droplet" MD.
- No continuum solvation keywords appear anywhere on the site.

### 5.9 Molecular dynamics
- `task=thermostat` with a `$dynamic` group (section 3.2). See also the forum topic "Природа-MD".

### 5.10 Other capabilities mentioned
- RI-MP2 (forum).
- Dipole polarizability (forum).
- Raman intensities (forum).
- Bader / critical points of the density: output section "Critical Points of the Density", turned into xyz `XX` points by pri2mol. The related forum topic is "Релятивистские базисы и порядок связи" ("Relativistic bases and bond order").
- Priroda 11 semiempirical methods (forum "Любителям полуэмпирики", i.e. "For semiempirics fans").
- Orbital visualization (qchem.ru topic).

---

## 6. Basis-set files: formats and contents

### 6.1 Format of Priroda basis files (basis.in style, Priroda 6+)
```
<free text description lines – ignored>

$basis
type=general
default=L1

set=L1                       <- set name; synonyms separated by |, e.g. set=6-311G(d)|6-311G*
        1   3                <- element Z, number of contracted shells
0  5                         <- l (0=s,1=p,2=d,...), number of primitives
+.829217781466606002e+002 +.347543337951346026e-002   <- exponent, coefficient
...
1  2
...
        2   3
...
$end
$basis2                      <- auxiliary (density-fitting) basis, same layout
type=general
default=L1

set=L1
...
$end
```
Format notes:
- The `default=` line names the set used for all elements unless overridden. The `pribas` script rewrites it as `default=$set`.
- The scalar-relativistic files (`rL*`, from basis4.in) have **two coefficient columns per primitive**, e.g. `+.831066e+002 +.347087e-002 +.346912e-002`. *(inferred)* These are separate large- and small-component or two-variant coefficients.
- The original basis.in can contain a `compile` section after the sets; `pribas` stops reading at a line matching `compile`.
- `pribas` (cp1251 source) has three modes:
  - list the sets available for given elements: `pribas '1 6 8' < basis.in`;
  - print contraction summaries for basis/basis2: `pribas -c`;
  - extract one set into a standalone file: `pribas SETNAME < basis.in > file`.

### 6.2 Older `.bas` format (the 20+sbk.bas and 20+St-rsc-97.bas combined bases, and 3z.bas era)
```
$ECP

  21  10   2          <- Z, number of core electrons replaced, lmax
 1                    <- number of terms in the first block
    -3.66956000   1    9.95712000      <- coefficient, power of r, exponent
 3
     3.71885000   0    1.46409000
   178.26066000   2    3.59217000
  -161.78394000   2    3.32583000
 2
     3.93048000   0   23.53849000
    45.69140000   2    6.58415000
  ...
$END

$BASIS
         1  4          <- Z, number of shells
 0  3   2.951830e+1   2.663542e-2     <- l, nprim, then exponent coefficient (first on same line)
        4.459397e+0   1.992677e-1
        1.020214e+0   8.443136e-1
 0  1   2.789184e-1   1.0
 ...
$END

$Basis2
           1  7
 0  1   2.04937577e-01  1.0
 ...
$end
```
- SBK ECP blocks cover Z = 21–86, with `lmax` blocks plus a local block.
- The Stuttgart file starts at Z = 21 with `lmax` 3 (header `21  10   3`).
- `20+sbk.bas` has CRLF line endings.

### 6.3 L-family contents (from the headers of the Lbasis.zip files)
Header format: `N_contracted/N_primitive : (contracted per l)/(primitive per l)` for basis and basis2. Examples:

| Set | H | C | Si | Fe | Br |
|---|---|---|---|---|---|
| V1 | 5/12 (2,1)/(6,2) | 14/46 (3,2,1)/(10,7,3) | 18/62 (4,3,1)/(14,11,3) | 27/119 (5,4,2)/(19,15,11) | 27/119 |
| L1 | 5/12 (2,1)/(6,2) | 14/46 (3,2,1)/(10,7,3) | 18/62 (4,3,1)/(14,11,3) | 43/154 (6,5,3,1)/(19,15,11,5) | 27/119 (5,4,2)/(19,15,11) |
| L11 | 5/12 | 18/46 (4,3,1)/(10,7,3) | 27/77 (5,4,2)/(14,11,6) | 43/154 | 43/154 (6,5,3,1) |
| L2 | 14/30 (3,2,1)/(8,4,2) | 30/70 (4,3,2,1)/(12,8,4,2) | 34/96 (5,4,2,1) | 84/234 (8,7,5,3,1) | 43/156 (6,5,3,1) |
| L2m | 9/20 (3,2)/(8,4) | 23/56 (4,3,2)/(12,8,4) | 27/82 (5,4,2) | 68/191 (8,7,5,2) | 36/142 (6,5,3) |
| L22 | 14/30 | 43/75 (6,5,3,1)/(12,8,5,2) | 59/139 (7,6,4,2) | 84/234 | 84/234 |
| L22m | 9/20 | 31/56 (6,5,2) | 45/97 (7,6,4) | 68/191 | 68/191 |
| L3 | 30/54 (4,3,2,1)/(10,5,3,2) | 55/124 (5,4,3,2,1)/(14,10,5,4,3) | 59/154 | 145/359 (10,9,7,5,3,1) | 68/228 |
| L33 | 30/54 | 84/141 (8,7,5,3,1) | 109/233 | 145/359 | 145/352 |
| L1a / L11a | H 9/16 (3,2)/(7,3) | C 23/55 (4,3,2) / 27/55 (5,4,2) | – | – | – |
| L2a / L22a | H 23/39 (4,3,2)/(9,5,3) | C 46/86 / 59/91 | – | – | – |
| L3a / L33a | H 46/70 (5,4,3,2) | C 80/149 / 109/166 | – | – | – |

How to read the names:
- L1 is roughly double-zeta polarized, the "3z-like" family; L2 is triple-zeta quality, L3 quadruple.
- A doubled digit (L11, L22, L33) uses the larger contraction on the heavier p-block atoms as well.
- The `m` variants (L2m, L22m) drop the highest polarization (e.g. no f on C, no d on H).
- The `a` suffix adds diffuse functions (H, He, B–Ne only).

Element coverage:
- basis.in: V1, L1, L11, L2, L2m, L22, L22m, L3 and L33 cover H–Kr (1–36). b1 covers 1–36 except Ca.
- basis.in also contains sets for elements 1–10 only: L111, L1111, L222, L2222, L222m, L2222m, L333, L3333, L4, L44, L444, L4444, L5, L55, L555, L5555. L6 and L7 cover H/He (and B–Ne for L7) only.
- L4 and L5 cover H–Zn; L44 and L55 cover H–Mg and K–Kr.

Relativistic (basis4.in, rL*, elements 1–102):
- Files are labelled "Scalar-relativistic basis for Priroda from basis4.in".
- Example rL1 (basis / basis2):

  | Range | Basis | Basis2 |
  |---|---|---|
  | H–He | {6s2p}/[2s1p] | {6s3p}/[2s1p] |
  | B–Ne | {10s7p3d}/[3s2p1d] | {10s9p7d4f}/[6s4p3d1f] |
  | Sc–Zn | {21s16p11d5f}/[6s5p3d1f] | {19s18p17d14f11g6h}/[13s12p11d6f4g1h] |
  | Ce–Yb | {30s29p20d14f6g}/[9s8p6d3f1g] | {30s27p25d22f19g16h13i7j}/[18s17p16d14f11g7h4i1j] |
  | Th–No | {34s33p24d18f6g}/[10s9p7d4f1g] | {32s30p28d25f23g20h17i8j}/[21s20p19d16f14g9h6i2j] |

- In basis4.in, L111, L222 and L333 cover 1–10, 49–54, 58–86 and 90–102.
- The non-relativistic b1 file is labelled "Non-relativistic basis for Priroda from basis.in, D.N. Laikov. Chemical Physics Letters 416 (2005) 116-120": H,He {4s}/[2s]; B–Ne {7s4p}/[3s2p]; Sc–Ga {13s10p7d}/[5s4p1d].

Synonym tables (`basis.in_sets`):
- Notation `L1(10,7,3)` means the number of primitives per l (s,p,d) for that element group. For example, element 6 lists `L1(10,7,3)|L1 L11(10,7,3)|L11|L111|L1111`, so for C the same contraction answers to L1, L11, L111 and L1111.
- Within the L1 family, H–He use `L1(6,2)`, Al–Ar use `L1(14,11,3)` and Ga–Kr use `L1(19,15,11)`.

### 6.4 "Standard" bases (common_basis.tar.gz)
- Each file has a header `Basis and auxiliary basis sets for PRIRODA generated by g2pri_basis script from ORCA program outputs` and a contraction table. Example def2-SVP: H {4s1p}/[2s1p] with aux {5s2p1d}/[3s1p1d]; C {7s4p1d}/[3s2p1d] with aux {12s5p4d2f1g}/[6s4p3d1f1g].
- `common_basis.in` (7.5 MB) contains 118 `set=` entries with `default=cc-pVDZ`.
- Element coverage (from common_basis.info):

  | Basis family | Elements |
  |---|---|
  | def2-SVP, def2-TZVP(P) | H–I plus Hf–Hg (TZVP/TZVPP) |
  | def2-QZVPP, QZVPP | H–Xe, Cs, Ba, Hf–Hg |
  | cc-pVnZ | H–Ne, Al–Ar, Ga–Kr (plus Sc–Zn for TZ/QZ) |
  | cc-pCVnZ | adds Na, Mg |
  | Pople 6-31G(d) | H–Zn |
  | Other Pople sets | H–Br |
  | EPRII/III | H, B–F |
  | IGLO-II/III | H, B–F, Al–Cl |
  | PC-1/2/3 | H–Ar |
  | DZ | H–Kr |
  | VDZ/VTZ, SV(P), SVP, TZVP | H–I |

- Generated with `g2pri_basis` (section 7).

### 6.5 Molden patches (for viewing Priroda results)
- **Windows.** Molden needs an X server, e.g. Xming. A patched Windows build is provided (`molden4.4_bin_sge_patch.rar`).
- **Linux.** Recompile from source with two changes:
  1. Increase the maximum number of bonds per atom, which matters for organometallics such as ferrocene: change `#define MXCON` in `xwin.c` and `mxcon=` in `*.f` (the script sets 15).
  2. Show chemical shifts of 100 or more in the "charge" (5th xyz column) labels. In `plmol.f`, replace
     ```
           elseif (iqon.eq.3) then

              if (ipost.eq.1) then
                 write(str,'(a2,a1,f7.4)') elemnt(ianz),' ',qat
              endif
              nstr = 10

           elseif (iqon.eq.4) then
     ```
     with
     ```
           elseif (iqon.eq.3) then

              if (qat.gt.-10.and.qat.lt.100) then
                 write(str,'(a2,a1,f7.4)') elemnt(ianz),' ',qat
              elseif (qat.gt.-100.and.qat.lt.1000) then
                 write(str,'(a2,a1,f7.3)') elemnt(ianz),' ',qat
              else
                 write(str,'(a2,a1,f7.2)') elemnt(ianz),' ',qat
              endif
              nstr = 10

           elseif (iqon.eq.4) then
     ```
- `molden_change_parameter` applies both patches with `perl -i`; run it from the unpacked molden source directory.
- pri2mol notes that `.mos` files (orbitals) are processed "почему-то … очень медленно" by Molden (for some reason very slowly).

---

## 7. Utilities/scripts (all Perl unless noted; every script prints help with `-h`; archive `limor_programs.zip` about 0.2–0.4 MB)

Common xyz convention ("молденовский формат"):
- Line 1 holds the number of atoms.
- Line 2 is a comment, and the first number in it is taken as the energy. Tokens such as `Energy`, `Charge`, `Mult`, `Dipole`, `ZPE`, `G(T)`, `HoF`, `Edisp` and `sigma` are recognized by the scripts.
- Then come `El x y z [charge or chemical shift]` lines.
- Several molecules are concatenated with no blank lines between them.

Example:
```
 4
 Energy -114.42514408   H2CO  Symmetry C2v    ppm
 C    0.00000000   0.00000000   0.00171470  196.6914
 O    0.00000000   0.00000000   1.20764898
 H    0.94265994   0.00000000  -0.60468184   10.4554
 H   -0.94265994   0.00000000  -0.60468184   10.4554
```

### 7.1 Priroda-specific scripts
- **priin** — `priin [-gjc|-mop|-xyz|-mrv] file…`.
  - Converts Gaussian input (*.gjc/gjf, e.g. from Chem3D), MOPAC (*.mop/dat/arc), xyz/xyzppm or MarvinSketch *.mrv into a Priroda `*.in` file.
  - Options:

    | Option | Effect |
    |---|---|
    | `-qm` | `theory=qm_n3 basis=qm.in` |
    | `-md` | `task=thermostat` plus `$dynamic` |
    | `-md_e`, `-md_d`, `-md_v`, `-md_h`, `-md_n`, `-md_m`, `-md_i` | Set the matching `$dynamic` parameters |
    | `-md_T` | Temperature in K |
    | `-vol=ρ` | Spherical cavity |
    | `-mem=`, `-disk=`, `-basis=`, `-task=`, `-theory=` | Override defaults |
    | `-H` | Hessian |
    | `-z` | 3z basis |

  - Frozen MOPAC parameters become `fix=`. XX dummy atoms give `task=nmr` plus `$nmr points=`.
  - The charge and multiplicity can be read from `Charge n` / `Mult n` on xyz line 2, and `sigma n` gives `$thermo sigma`.
  - Last modified Nov 2021.
- **pri2mol** — `pri2mol file…` (tested with p210, p407, p6, p11 on Linux and p202 on Windows). It creates:

  | File | Contents |
  |---|---|
  | `file.xyz` | All optimization steps, or the converged point of each scan/IRC point, with Mulliken charges and spins as extra columns. The comment line carries Energy, Charge, Mult, Dipole, Gradient (IRC), ZPE, G(T) and HoF. |
  | `file.mos` | Molden orbitals |
  | `file.freq` | Molden vibrations, plus `[INT]` IR intensities |
  | `file.MOL` | Optimized geometry plus Hessian (the `MOL>`/`eng>` blocks), for pasting into the next run |
  | `file.ppm` | σ and δ |
  | `file.xyzppm` | Geometry with δ as the 5th column, including XX NICS points |

  - Options: `-all` writes every IRC/scan step, `-asymm` applies the anisotropy correction, `-debug`.
  - It also handles QM runs and MD (THERMOSTAT) runs: `file.trj` holds point, s, E, g.
- **pri** — `pri [-np=N] [-log] input.in…`. A sequential multi-task driver; see 4.7, 5.1, 5.3 and 5.4.
  - Configure first: Priroda path, basis directory, temporary directory, pri2mol path, and whether to delete temporary inputs.
  - Pseudo-tasks: `irc` = `irc0+irc1`; `TS` = `saddle` = `task=optimize saddle=1`; `Optimize` = optimize with automatic restarts (SCF and step-limit restarts, all outputs concatenated into one `.Opt` file separated by `#` lines).
  - The latest optimized geometry is always used. The Hessian is reused by later optimize/saddle/irc steps. `pri2mol` runs on each output.
  - Planned special handling of scan+saddle, scan+nmr and irc+nmr was never implemented.
  - Last modified 2010.
- **steps** — batch launcher for folders of inputs; config `%CONFIG`, with Priroda `.in` mapped to `/usr/local/lib/priroda/p6_32 !INPUT! !OUTPUT!`. Last modified 2019.
- **g2pri_basis** — `g2pri_basis [-gen=orca|g09] [-atom=1,4..9] [-no_del] [-file=list] basis_name`.
  - Generates Priroda basis plus auxiliary basis per element from ORCA or Gaussian.
  - The ORCA input is `! PBE basis_name PrintBasis NoIter MiniPrint` for the element at (0,0,0), with charge chosen so that the atom is a singlet or doublet.
  - The Gaussian input is `# test BLYP/basis_name DenFit GFInput Guess=Only Pop=None`.
  - The default is ORCA, because its auxiliary bases were better for Priroda.
- **pribas** — analyses `basis.in`/`basis4.in` (sets per element, contraction summaries, extraction of one set). See 6.1.
- **g2i** — `g2i [-b basis] [-m mem] [-o type] [-s] [in] [out]`.
  - Reads GAMESS or Priroda outputs and writes the last geometry, or every stationary point of a scan/IRC, as Molden xyz (`-o m`), CLOPPA (`c`), Dalton (`d`), IGLO (`i`) or a Priroda NMR input (`p`, default basis 3z; see 4.6).
- **inp2xyz** — converts GAMESS (`.inp`) and Priroda (`.in`, Cartesian only) inputs to xyz on stdout.
- **hess** — converts a Priroda (task=hessian), GAMESS or ORCA Hessian into a GAMESS `$HESS` group or an ORCA `.hess` file (`-orca`). For Priroda it reads `Atomic Coordinates:`, `Number of atoms`, `eng> E=` and the `eng> H=`…`eng>$end` lower triangle.
- **priIR** — builds IR spectra from Priroda 2 or 6 outputs, GAMESS outputs or Molden `.freq` files.
  - Options: `-maxfreq=4000`, `-minfreq=20`, `-linewidth=10`, `-points=10`, `-lineshape=lorentz|gauss|sticks`, `-terminal=x11`, `-label`, `-level=80`, `-yaxis`, `-jcamp`.
  - Draws with gnuplot, or writes JCAMP-DX `.dx`.
- **conformers** — conformer pipeline. An MM generator (Marvin cxcalc, Vconf, Tinker scan or confab) feeds MOPAC2009 (RM1 by default, PM6 if elements are missing), obminimize, Tinker, or **Priroda QM (`-method=QM`, Priroda 14 qm_n3)**; duplicates are removed by RMSD after alignment on inertia axes.
  - Options: `-np`, `-charge`, `-mult`, `-energy`, `-RMS=0.1`, `-ellips`, `-QM_SP`, `-keep_out`, and others.
  - The /quant/conformers/ workflow is MM, then semiempirical (RM1/PM6), then DFT with Priroda, with duplicates removed after each stage.

### 7.2 General xyz and analysis tools (used with Priroda results)

| Tool | Purpose |
|---|---|
| addXX | Add dummy atoms at ring centres for NICS. `-Z` reorients. Syntax e.g. `addXX '1-6(0,-1,1)' f.xyz` |
| align | Align IRC frames; adds step in sqrt(amu)·Å |
| average | Average chemical shifts (`-auto` for methyls/equivalent atoms, `-B` Boltzmann with `-T`, `-kkal`/`-kJ`) |
| cfxyz | Compare structures independently of numbering (`-RMS`, `-chiral`, `-dih`, `-dist`, `-renum`) |
| cif2xyz | CIF to xyz; unit cell/supercell options |
| coord | C program (G. Salnikov). Optimal superposition of two geometries; sqrt of the measure = Priroda IRC step |
| dih_list | List dihedrals |
| Edisp | DFT-D3(BJ) via dftd3, adds `Edisp` to xyz |
| EEEvsEEE | Energy statistics, DFT vs PM7/xTB |
| formula_xyz, mm, raschet | Brutto-formula search, molecular weight |
| freq2xyz | Animate a vibration from a Molden `.freq` (from pri2mol): `-v=mode`, `-n=20` points, `-f` amplitude. `-n=±1` gives a single displaced geometry, useful to step off a saddle point |
| freq4parts | Contribution of molecular fragments to each normal mode |
| join_IRC | Stitch IRC branches (uses cfxyz, xyz, reflect, renum, align) |
| levels2html, xyz2levels, xyz2PES | Energy-level / PES diagrams from xyz files; `-ZPE`, `-G`, `-Edisp` read from the comment line |
| mgp2xyz | AIMAll sum/mgp to xyz with critical points |
| mldn | Molden launcher, accepts piped input |
| mldn-gif | Overlay an energy plot on Molden GIFs |
| molgeom | Geometry parameters along a trajectory; `-b` = Priroda bend-type coordinate 4 |
| portion | Boltzmann populations |
| qfold | Fold repetitive output blocks |
| reflect | Rotate, reflect, invert |
| renum | Renumber atoms |
| reorient, tenzor | Reorientation |
| reverse | Reverse frame order |
| smooth | Remove jumps between frames via coord |
| symm, symmetry | Symmetrization and point group (C, S. Pachkovsky and G. Salnikov). Priroda does not use symmetry, so it is useful to symmetrize geometries externally |
| xyz | Swiss-army tool: last frame, `-n`, `-symm`, `-irc=RMS` (turn an optimization trajectory into an IRC-like path), `-G_from=file.H.xyz` (pull G/ZPE from the hessian run's xyz), `-ppm_from`, `-split`, and more |
| xyz2inp | GAMESS input from xyz; `-basis=priL1` copies the Priroda L1 basis from basis.in into `$DATA` |
| xyz2jmod, xyz2ppm, mskxyz | NMR presentation |
| gmsv, gms-scan, fchk2xyz, gulp2xyz, txyz2xyz, sort_by_smi, subst, rotepi, mask, a2j, tBu+ | Non-Priroda helpers |

### 7.3 Animation recipe (verbatim commands from mldn-gif/animation.html)
```
# 1.
mldn file.xyz
#Геометрию 480х480, кнопка с фотоаппаратом, кнопка Movie, снова кнопка с фотоаппаратом
rm mol001.gif
# 2.
molgeom -G file.xyz | mldn-gif -p 5
# 3.
convert -loop 0 -delay 10 \
-fill 'rgb(0,0,132)' -draw 'color 0,0 replace' \
Gmol*.gif file480x480.gif
# 3'.
gifsicle --delay 5 --loopcount=0 \
--optimize=2 \
--colors 16 --dither \
--change-color 0,0,0 0,0,132 \
Gmol*.gif > file480x480.gif
```
Molden command for frames: `molden -l -geom 800x600 -j 300`. `-l` drops the logo; `-j` raises the 99-frame limit. Molden usually creates one extra (duplicate) first GIF; delete it.

---

## 8. Context facts
- Typical levels of theory on the site:
  - DFT/PBE/3z for IRCs of carbocation rearrangements ("IRC (concatenated xyz) by DFT/PBE/3z (PRIRODA program)").
  - PBE/L1 for heat-of-formation work.
  - L22 for NMR.
- The site says that "все анимации «честные»" (all animations are "honest"): they follow real IRC or PES paths.
- The site's development was funded by RFBR (РФФИ) grant 13-03-00427a.
