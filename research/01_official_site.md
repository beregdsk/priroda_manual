# Priroda official download site: rad.chem.msu.ru/~laikov/p_w/

Fetched 2026-10-16 with `curl` (WebFetch was not needed for the first pass). Raw copies are in
`/tmp/claude-1000/-home-egor-projects-priroda/1ef56c3b-4910-42be-b3ba-954ec62c9d15/scratchpad/raw_site/`
(`index.html`, `exe64/index.html`, `txt/*` for small text files, `txt/*.head|*.tail` for 300 KB/100 KB slices of the big data files, and `kw/*.kw`, which keeps only the non-numeric lines of each big data file, streamed in full).
Partway through, the server stopped answering: TLS handshakes timed out and WebFetch returned "Socket is closed". As a result, the executables were **not** downloaded, so no `strings`-based keyword mining was done, and the parent page `~laikov/` was **not** visited.

**Important framing.** The site is a bare file index. It has **no prose documentation, no keyword reference, no publication list, no news, no license text and no citation request.** Everything below is taken from the file listing itself, the example inputs and outputs, the helper shell scripts, and the basis and parameter data files. Items marked *(inferred)* are my reading of the evidence and are not stated by the author.

---

## 1. Source URLs visited

Main page (UTF-8, `Last-Modified: Tue, 24 Jun 2025 12:26:42 GMT`):
- https://rad.chem.msu.ru/~laikov/p_w/
- https://rad.chem.msu.ru/~laikov/p_w/exe64/index.html (Cygwin/Windows x86_64 binaries; Last-Modified 30 Sep 2020)

Every file linked from these pages was at least HEAD-checked (size and date in §2). The following were downloaded and read in full:
`H6C6.dfl6a.1a.in`, `2H6C6_n3.dfl6a.1a.in`, `2H6C6_n3.dfl6.1a.in`, `C60.qm.in`, `C60.qm.{l,w}.{1,2}.out`, `C60.df.in`, `C60.df.{l,w}.{1,2}.out`, `H10C6N2H4PtO2C2O2.df.in/.out`, `H40C20.qm.in`, `H40C20_u.in`, `5H48C94N8O6_a.qm.in/.out`, `2x_20H48C94N8O6_10H22C54N6O9.qm.d25b1.in/.out`, `...d35b1.in/.out`, `3z.bas`, `sbk.bas`, `ge`, `gm`, `grx`.

The following were read through head/tail slices plus a streamed scan of all keyword lines:
`qm.in`, `basis.in`, `basis4.in`, `b2.in`, `b2n.in`, `b2.old.in`, `b2n.old.in`, `b2u.in`, `b2un.in`, `b2u.old.in`, `b2un.old.in`, `b4s.in`, `b4sn.in`.

The following were not downloaded because they are binaries:
`p`, `p4`, `p_d`, `p4_d`, `p_l`, `p_mvs1p1`, `p_mvs10p`, `p_mvs10q`, `p_arm`, `mpiexec`, `mpiexec_arm`, `xm`, `exe64/{p1.exe,p1_190306.exe,p_190306.exe,xm.exe,cygwin1.dll}`.

External links on the page: http://www.cygwin.com, and a maploco.com visitor-counter image, which is irrelevant.

Odd text on the main page: the Russian joke line "фигология и фигистика" ("figology and figistics") sits between the Examples and Data headings. It carries no technical content.

---

## 2. Program overview (what the site shows)

### 2.1 Main page, verbatim content (HTML tags stripped)

```
Linux:
./p C60.qm.in C60.qm.l.1.out
./mpiexec -np 2 ./p C60.qm.in C60.qm.l.2.out
xm C60.qm.in
p4 for FMA/AVX2
p_d dynamically linked
p4_d dynamically linked

p
mpiexec
xm

sbatch -p test -n 16 -t 6 impi ~/bin/p_l file.{in,out}

p_mvs1p1
p_mvs10p
p_mvs10q

ge
gm
grx

p_arm
mpiexec_arm

Windows + Cygwin:
p1.exe C60.qm.in C60.qm.w.1.out
mpirun.exe -np 2 p.exe C60.qm.in C60.qm.w.2.out
xm.exe C60.qm.in

exe64

Examples:
 ... (file list, see §1)
Data:
qm.in
b2.in  b2n.in  b2.old.in  b2n.old.in  b2u.in  b2un.in  b2u.old.in  b2un.in[sic: link target b2un.old.in]  b4s.in  b4sn.in
basis.in  basis4.in
3z.bas  sbk.bas
```

Notes:
- The link texts contain small HTML errors. The second `H6C6.dfl6.1a.in` text links to `H6C6.dfl6a.1a.in`, and the `b2un.old.in` link is labelled `b2un.in`. `mpiexec_arm` is not linked, because its `<a>` element is empty.
- **Invocation syntax:** `p <input> <output>`, with the input and output file names given as two positional arguments. This is the same on Windows (`p1.exe in out`).
- **Parallel runs (MPI):** `./mpiexec -np N ./p in out` on Linux uses the bundled `mpiexec`. On Cygwin it is `mpirun.exe -np 2 p.exe in out`. Note that on Windows the **serial binary is `p1.exe`** and the **parallel binary is `p.exe`**.
- **Cluster example (SLURM + Intel MPI wrapper `impi`):** `sbatch -p test -n 16 -t 6 impi ~/bin/p_l file.{in,out}`. The binary `p_l` is "p for Lomonosov" *(inferred: MSU "Lomonosov" supercomputer, where `impi` is the site's Intel-MPI launcher script)*.
- `p_mvs1p1`, `p_mvs10p` and `p_mvs10q` are builds for specific clusters *(inferred: MVS-1P1, MVS-10P and MVS-10Q at the JSCC RAS supercomputer centre)*.
- `xm` (Windows: `xm.exe`) is a molecule viewer. It takes a Priroda **input file** as its argument (`xm C60.qm.in`) *(inferred: X11 molecular structure viewer by the same author)*.

### 2.2 Executables (sizes and dates from HTTP HEAD)

| File | Size (bytes) | Last-Modified | Description (site text or inference) |
|---|---|---|---|
| `p` | 17 086 736 | 2023-06-25 | Main Linux x86-64 executable, statically linked (implied by "p_d dynamically linked") |
| `p4` | 17 085 200 | 2023-06-25 | "for FMA/AVX2" (AVX2/FMA-optimized build) |
| `p_d` | 14 411 568 | 2021-11-12 | "dynamically linked" |
| `p4_d` | 18 707 656 | 2025-02-28 | "dynamically linked" (AVX2/FMA, newest build) |
| `p_l` | 20 383 904 | 2025-04-14 | cluster build used with `sbatch ... impi` |
| `p_mvs1p1` | 14 780 942 | 2019-10-20 | cluster build |
| `p_mvs10p` | 16 516 352 | 2023-06-28 | cluster build |
| `p_mvs10q` | 16 322 616 | 2023-06-25 | cluster build |
| `p_arm` | 11 181 148 | 2015-09-23 | ARM build |
| `mpiexec` | 67 380 | 2012-09-09 | MPI launcher shipped with `p` |
| `mpiexec_arm` | 1 325 408 | 2015-09-23 | MPI launcher for ARM |
| `xm` | 106 160 | 2025-04-24 | viewer |
| `exe64/p1.exe` | 15 053 533 | 2021-10-01 | Cygwin x86_64, serial |
| `exe64/p1_190306.exe` | 13 665 792 | 2019-03-12 | Cygwin, serial, older build (version tag 190306 = 2019-03-06) |
| `exe64/p_190306.exe` | 13 666 304 | 2019-03-12 | Cygwin, parallel, older build |
| `exe64/xm.exe` | 255 055 | 2019-03-08 | viewer for Windows |
| `exe64/cygwin1.dll` | 3 618 249 | 2021-10-01 | Cygwin runtime |

`exe64/index.html` heading: "Cygwin/Windows/x86_64". Note that `exe64` contains no current parallel `p.exe`, only `p_190306.exe`.

### 2.3 Platforms

Linux x86-64 (static and dynamic builds, plus an AVX2/FMA variant), Linux ARM (2015), Windows through Cygwin x86_64, and HPC clusters (SLURM).

### 2.4 Versions and history seen in output headers

| Output banner | Build date | Where |
|---|---|---|
| ` Priroda 13 (2013.01.10)` / ` copyright (c) D.N. Laikov` | 2013-01-10 | Linux runs of C60 (Jan 2013) |
| ` Priroda 13 (2013.01.21)` | 2013-01-21 | Windows/Cygwin runs of C60 (Jan 2013) |
| ` Priroda 13 (2013.09.13)` | 2013-09-13 | 5H48C94N8O6 QM run, 8 procs, Nov 2013 |
| ` Priroda 14 (2014.01.01)` | 2014-01-01 | 8060-atom QM run, 32 procs, Mar 2014 |
| `Priroda 15 (2015.09.14)` / `copyright (c) Dimitri N. Laikov` | 2015-09-14 | Pt complex, scalar-relativistic, Sep 2015 |

The banner text changed between versions: v13/v14 print "D.N. Laikov", while v15 prints "Dimitri N. Laikov" without the leading space. The newest binaries (2023–2025) have no example output on the site, so their version number is unknown. The input files from 2023 and 2025 (`*.dfl6*.in`) use newer keywords (§4).

Author's paths visible in the outputs: `/home/dima/work/program/basis/qm.in`, `/home/dima/work/program/basis/basis.in`, `/home/laikov/work/basis/qm.in`, `/home/dima/work/program/basis/basis4.in`. On Windows the output shows `qm file: 'qm.in'`, i.e. the file was found in the current directory.

### 2.5 Licensing and how to obtain

Nothing is stated on the site. There is no license, no registration and no contact. All binaries and data files are publicly downloadable without authentication. The source code is not offered.

### 2.6 Parallelism

MPI only, through `mpiexec -np N`. Output banner: ` parallel on  2 processors`, followed by one line per rank: ` node  0: 'a722'`. Timings are printed per rank in square brackets, e.g. `time: SCF Equations : 2179.4 [ 1089.6 1089.8 ] 99.3% 1097.0`. That line gives total CPU, per-rank CPU, efficiency, and the maximum per-rank value *(inferred)*. At the end of a run each rank prints its own `Memory used`, `Disk used` and `CPU time` lines, followed by a "Message passing statistics" table (`node  sent KB  # msg  time  received  time`), then `REAL time`, and `ratio` = total CPU / wall time (for example `ratio = 198.76%` on 2 processes, `2329.49%` on 32).
Demonstrated scale: 32 MPI processes across 4 nodes (8 per node) for an 8060-atom QM job.

---

## 3. Methods and theories seen on the site

### 3.1 `theory=` values used in the examples

| Value | Used in | Evidence for its meaning |
|---|---|---|
| `DFT` | `C60.df.in`, Pt example | Output: `Theoretical Method DFT`, `Approximation to E(xc) PBE` (PBE is the default functional). An auxiliary basis is used ("Dimension of auxiliary basis 2400"), i.e. density fitting of the Coulomb term. |
| `riDFT` | `H6C6.dfl6a.1a.in`, `2H6C6_n3.dfl6a.1a.in` (2023/2025) | Used with `$dft func=LPBEVVV` and the line `integral dir=1 $end` |
| `DFT_n4` | `2H6C6_n3.dfl6.1a.in` (2025) | New theory label, used with `func=LPBEVV`. Not in older docs. |
| `qm_n3` | `C60.qm.in`, `5H48C94N8O6_a.qm.in`, `H40C20.qm.in` | Laikov's parametrized "QM" model. Needs `basis=qm.in`. Output shows `qm file: '...qm.in'` and the SCF line `SCF: No=120,120 N=240 N1=540`. |
| `qm_n2` | `2x_...qm.d25b1.in`, `...d35b1.in` (8060 atoms) | Another variant of the QM model, here with a linear-scaling-looking density solver (`$scf d=25.0,1.0 p=1.0,1.0 dir=1`). The output prints `m=32 n=800`, `rd=25.000000,1.000000`, `D0` timings, and iterations with `Q=`/`dN=`/`c=`. *(inferred: purification/density-matrix-based solver for large systems)* |

The **energy comparison for C6H6 dimer inputs** is recorded in the files themselves, after the `$molecule ... $end` block:
- `riDFT` + `LPBEVVV`: `Energy = -464.2278506060` (dimer, C2v), `-232.1113196583` (monomer, D6h)
- `DFT_n4` + `LPBEVV`: `Energy = -464.2097220304` (dimer)

### 3.2 Functionals seen

- `PBE`: default, per output `Approximation to E(xc) PBE` when `$dft` is absent.
- `LPBEVVV`, with `theory=riDFT`.
- `LPBEVV`, with `theory=DFT_n4`.
  These two names are **new**: they are absent from all older docs. *(inferred: "L" = Laikov's variant of PBE; "VV"/"VVV" = VV10-type nonlocal (van der Waals) correlation. The examples are π-stacked benzene dimers, `2H6C6_n3` = "n3 stacking", a typical dispersion test. This is unverified.)*

### 3.3 Relativistic options

- `$control four=1 nuc=finite` together with `basis=basis4.in` (Pt complex, 2015) produces this output:
  - ` Hamiltonian: scalar-relativistic`
  - ` Speed of Light = 137.0359895000`
  - ` Scalar Relativistic Density Functional Calculation:` (the header of the SCF section)
  - ` Finite nucleus model:` followed by one line per element, `atomic number  78:  a = 1.430988e+08, c = 2.397861e+13` *(inferred: Gaussian nuclear charge distribution exp(-a r²) with normalization c)*.
  - Per-element core lines: ` atom   6 core =  1`, ` atom  78 core =  4,  3,  2,  1` and ` at.d.=0` *(inferred: number of core shells per angular momentum l = s,p,d,f, consistent with the old `$atoms core(...)` keyword)*.
  - With `four=1`, `T =` and `V =` are printed as 0 in the energy summary: `T = 0.00000000  V = 0.00000000  J = 9876.79307244`.
- Without `four`, the output prints ` Hamiltonian: non-relativistic`.
- The new basis file `b4s.in` (2019) has the global header lines `c137=137.035999173` (speed of light, CODATA 2014 value) and `nuc=2`. Its contracted functions carry **4 coefficient columns** where `b2.in` has 2. Its element tags carry `.s.` (`b1 001H_.s.C1.l.0501w12`). *(inferred: "4s" = four-component/spin-free scalar-relativistic sets; `nuc=2` = finite-nucleus model code; for each contraction the columns are probably large/small-component or two Hamiltonians)*. This makes `b4s.in`/`b4sn.in` the modern counterpart of `basis4.in`.
- `b2u.in`/`b2un.in` begin with a `$kinetic` section before `$basis`. It holds one block per element `ZZZ 15`, 15 pairs of numbers, for Z = 1–102. Element tags carry `.u.`. *(meaning not stated; possibly a model kinetic/relativistic correction table; flagged for verification.)*

### 3.4 Effective core potentials

`sbk.bas` contains a `$ECP` section with SBK-type (Stevens–Basch–Krauss) potentials for Z = 3–86. The header of each element is `Z  ncore  lmax`, for example `3 2 1` (Li: 2 core electrons), `11 10 2`, `19 18 2`, `21 10 2` (3d metals: Ne core), `32 28 3`, `37 36 3`, `39 28 3`, `50 46 3`, `55 54 3`, `57 46 3` (lanthanides: 46 core), `72 60 3`, `82 78 3`, `86 78 3`. Each projector block is `nterms`, followed by lines `coef  power  exponent`. Example:

```
$ECP

default=3z

set=3z|2z


   3   2   1

 1
    -0.73063000   1    1.34306000
 2
     1.80131000   0    0.61284000
     3.54971000   2    1.64881000
```

### 3.5 Methods not demonstrated on the site

There are no examples of MP2/CCSD, TDDFT, NMR, hessian, IRC or scans. The only task types demonstrated are `optimize`, `opt_n1`, `thermostat` and `uniq`.

---

## 4. Input groups and keywords found (exhaustive list from the site files)

General syntax as used: `$group key=value key=value $end`. A group may span several lines. Keywords are lowercase in the examples, and comma-separated values give per-process or two-part settings. A comment line, or any text outside a group, is ignored. The author **disables groups and keywords by leaving them outside a `$...$end` block**:
- `integral dir=1 $end` in both 2023/2025 riDFT inputs has **no leading `$`**, so this "group" is plain text and is ignored *(inferred)*.
- `$optimize ... $end print=-2` in `qm.in`: `print=-2` sits after `$end`.
- In `H40C20.qm.in`, ` v=500.0` and ` h=0.1` sit after `$dynamic ... $end`, so the spherical-cavity options are switched off.
- After `$molecule ... $end` the author keeps result lines such as ` Energy = ...`, ` symmetry: D6h` and `  dipole = ...`. The `gm` script appends these, and the program ignores them.

### 4.1 `$system`

| Keyword | Seen values | Evidence and meaning |
|---|---|---|
| `mem` | `64`, `128`, `256`, `1024`, `2048`; two-value forms `64,32`, `64,16`, `2048,256` | MB of memory. The output prints `Memory: <mem>m + <|disk|>m (<mem2>m + <|disk2|>m)`. **The second value applies to the slave MPI ranks (ranks ≥1); the first value applies to rank 0.** Examples: `mem=2048,256 disk=-256,-1` gives `Memory: 2048m + 256m (256m + 1m)`; `mem=64,16 disk=-256,-1` gives `64m + 256m (16m + 1m)`; `mem=1024 disk=-64,-16` gives `1024m + 64m (1024m + 16m)`, so a single value applies to all ranks. |
| `disk` | `-1`, `-16`, `-24`, `-32`, `-64`, `-80`, `-128`, `-256`, `-512`, `-2048`; pairs `-512,-1`, `-256,-1`, `-64,-16`, `-80,-24` | Negative = in-memory scratch ("RAM disk") in MB, per older docs. This matches the `+ 256m` term in the Memory line. The second value is for slave ranks, and the author typically gives slaves `-1` (1 MB). |

Anomaly: the Linux build 2013.01.10 printed `Memory: 128m + 1024m (64m + 1m)` for `mem=64,32 disk=-512,-1` (`C60.df.in`), i.e. every value except the slave disk was doubled. The Windows build 2013.01.21 printed `Memory: 64m + 512m (32m + 1m)` for the same input. Treat this as a version quirk.

### 4.2 `$control`

| Keyword | Seen values |
|---|---|
| `task` | `optimize`, `opt_n1` (new; used with `qm_n2` for 8060 atoms), `thermostat` (molecular dynamics with `$dynamic`), `uniq` (with `$uniq`), `QM` (in the header of `qm.in`: `$control task=QM $end`, the parameter-fitting run *(inferred)*) |
| `theory` | `DFT`, `riDFT`, `DFT_n4`, `qm_n3`, `qm_n2` |
| `basis` | file name of basis/parameter file: `qm.in`, `basis.in`, `basis4.in`, `b2u.in` |
| `four` | `1` turns on the scalar-relativistic Hamiltonian (see 3.3) |
| `nuc` | `finite` turns on the finite (Gaussian) nucleus model (see 3.3). Older docs spell it `nucleus`; with prefix abbreviation, `nuc=` is accepted. |

Several keywords can share one line: ` theory=qm_n3 basis=qm.in`.

### 4.3 `$dft`
- `func=LPBEVVV`, `func=LPBEVV` (abbreviation of `functional`). Default without `$dft`: PBE.

### 4.4 `$grid`
- `acc=1e-9` (abbreviation of `accuracy`). The output of a run that did not set it shows `grid: accuracy=1.0e-08,1.0e-05, cut=1.0e-10,1.0e-07`, so **default accuracy = 1e-8 (final), 1e-5 (initial/coarse); cut = 1e-10, 1e-7**. The v15 output adds `, t=0`.
- The output shows the grid growing during the SCF: `Grid: 148080 points` (coarse), then `Grid: 843600 points` (fine) for C60.

### 4.5 `$scf`
- `conv=1e-7`, `conv=1e-8` (abbreviation of `convergence`). Default output: `scf options: conv=1.0e-06, 1.0e-03; iter=16,16`, so **defaults conv = 1e-6 (energy-gradient) and 1e-3; iter = 16,16**.
- QM-specific keywords (with `qm_n2`): `d=25.0,1.0` / `d=35.0,1.0` (echoed as `rd=25.000000,1.000000`; *(inferred)* a cutoff radius in bohr for the localized density solver; the `.d25b1`/`.d35b1` file names encode it), `p=1.0,1.0` (meaning unknown), `dir=1` (direct; meaning unknown).
- The output also prints `cut-off for S,T,V integrals: 1.0e-10 (1.0e-06)`.

### 4.6 `$optimize`

| Keyword | Seen values | Output echo / meaning |
|---|---|---|
| `tol` | `1e-4`, `1e-5`, `1e-6`, `1e-7`; pair `tol=1e-5,1e-4` | `tol=1e-5` gives `Tolerance on gradient = 0.00001000` and `Tolerance on displacement = 0.00100000`, so **displacement tolerance defaults to 100× the gradient tolerance**. `tol=1e-4` gives 0.0001 / 0.01. `tol=1e-7` gives 0.0000001 / 0.00001. With two values (`tol=1e-5,1e-4`) the displacement tolerance is set explicitly. |
| `step` / `steps` | `50`, `100`, `150`, `200`, `250`, `2000` | `Maximum number of steps = 150`. Both spellings are used (prefix of `steps`). |
| `sym` | `1` | Keep symmetry during optimization *(inferred)* (2023/2025 inputs) |
| `cart` | `1` | `Coordinates: cartesian`. The default is `Coordinates: internal` (redundant internals: `180 cartesian, 956 internal coordinates, 174 independent variables` for C60). |
| `mod` | `1` | With `task=opt_n1`. The output echoes `optimize: tol=0.0000010000 Nit=2000,5 h=1` *(meaning unknown)* |
| `max` | `0.25` | In `qm.in` header: `$optimize tol=1e-5 max=0.25 iter=250,16 tim=1 diag=1 $end`. Belongs to the fitting run. |
| `iter`, `tim`, `diag` | `250,16`, `1`, `1` | Same line, fitting-run context |

Defaults from the output: `Trust radius = 0.20000000 (max), 0.01250000 (min)`, `Updated hessian used`. With `cart=1`: `Trust radius = 0.10000000 (max), 0.00625000 (min)`.

### 4.7 `$molecule`

| Keyword/line | Meaning |
|---|---|
| `cartesian` | Cartesian input: `Z  x  y  z` per line, Å by default |
| `z-matrix` | Z-matrix input: `Z  i  r  j  angle  k  dihedral`. A **negative atom index in the dihedral (or angle) slot** defines the third coordinate as a second bond angle instead of a dihedral (standard convention) *(inferred)*. Example: `1  1  1.10627910  2  108.080474  -6  109.650621`. The Pt line `78  8  2.08049124  -9  2.08048963  2  -164.922624` shows that **a negative index in the angle slot means a second distance** *(inferred: the atom is placed by two distances plus a dihedral)*. |
| `set=L1`, `set=L1a` | Basis-set name selected from the basis file, for all atoms that follow |
| `sym=1,0.01` | Use symmetry with tolerance 0.01 *(inferred)* |
| `unit=b` | Coordinates in bohr (the 2023/2025 benzene inputs; C–C distance 2.62 bohr) |

The output reports symmetry: `symmetry: C5h (10)`, `unique atoms: 146`, `symmetry: C5 (5)`. The point group was detected automatically even without `sym=` (5H48C94N8O6 example). The output echoes the molecule as `<$molecule` lines, prints `formula: H14C8N2O4Pt` and an `internuclear distances:` table.

### 4.8 `$dynamic` (with `task=thermostat`), verbatim

```
$dynamic
 e=0.001
 d=0.03
 n=1000,100
 m=10
 i=1
 file=H40C20/H40C20_%06d.qm.in
$end
 v=500.0
 h=0.1
```

New compared with older docs: `file=` takes a printf-style **pattern for writing snapshot input files** (`%06d` = frame number), written into a subdirectory. `v`/`h` (spherical cavity volume per atom and wall stiffness, per other sources) appear here as disabled lines. The other keys are not documented on the site: from other sources, e = kT in hartree, d = time step, n = steps and print interval, i = seed/index *(inferred)*.

### 4.9 `$uniq` (with `task=uniq`), new

```
$control task=uniq $end
$uniq dist=0.01 $end
$molecule
 cartesian
 ...
$end
 Energy =   -783.83738426

$molecule
 ...
```

`H40C20_u.in` (441 KB) contains **157 consecutive `$molecule ... $end` blocks**, each followed by ` Energy = ...`. These are MD snapshots of C20H40 (eicosane) after optimization. *(inferred: `task=uniq` removes duplicate structures; `dist=0.01` is the distance-based identity threshold. The multiple `$molecule` groups in one input are a feature not described in older docs.)*

### 4.10 Restart / energy block `$Energy` (output marker `eng>`)

The output contains:

```
eng>$Energy
eng> E=-2.284057276940e+03
eng> D= 4.22290114e-08 -1.82061636e-08  2.32661117e-08
eng> G= 5.13271929e-06 -5.52234429e-06 -6.15997899e-06
eng>    ...
eng>$end
```

E = energy, D = dipole (au), G = Cartesian gradient (3N values). The `ge` script appends this block to the `.in` file, after the "NUMERICAL AND ANALYTICAL GRADIENT" marker when present.

### 4.11 Basis/parameter file groups (files named by `basis=`)

| Group | Files | Content |
|---|---|---|
| `$basis` | `basis.in`, `basis4.in`, `b2*.in`, `b4s*.in` | Orbital basis. Header keys: `type=general` (`basis.in`, `basis4.in`) or `type=gc` (`b2*.in`, `b4s*.in`; *(inferred)* general contraction), `default=L1`, `c137=` and `nuc=2` (`b4s*` only). This is followed by `set=Name(contraction)|alias|alias...` blocks. |
| `$basis2` | same files | Auxiliary (density-fitting) basis, with the same `set=` naming |
| `$BASIS`, `$AUXILIARY`, `$Basis2`, `$ECP` | `3z.bas`, `sbk.bas` | Old-style files. Header `default=3z`, sets `set=2z` and `set=3z`. `$END` and `$end` are both used, so matching is case-insensitive. |
| `$kinetic` | `b2u.in`, `b2un.in`, `b2u.old.in`, `b2un.old.in` | Per-element tables (Z = 1–102), 15 pairs each |
| `$system`, `$control task=QM`, `$optimize`, `$reaction`, `$file`, `$parameter`, `$qmdata` | `qm.in` | QM-model parameter file, see §6.5 |

---

## 5. Complete input examples (verbatim)

### 5.1 `H6C6.dfl6a.1a.in` (2025-06-24): riDFT/LPBEVVV optimization of benzene, bohr, symmetry

```
$system mem=256 disk=-2048 $end
$control
 task=optimize
 theory=riDFT
 basis=b2u.in
$end
$dft func=LPBEVVV $end
$grid acc=1e-9 $end
integral dir=1 $end
$scf conv=1e-7 $end
$optimize sym=1 tol=1e-5,1e-4 $end

$molecule
 sym=1,0.01
 unit=b
 cartesian
 set=L1a
   6     2.26903801  -1.31002971   0.00000000
   6     2.26903801   1.31002971   0.00000000
   6     0.00000000   2.62005941   0.00000000
   6    -2.26903801   1.31002971   0.00000000
   6    -2.26903801  -1.31002971   0.00000000
   6     0.00000000  -2.62005941   0.00000000
   1     4.04914027  -2.33777222   0.00000000
   1     4.04914027   2.33777222   0.00000000
   1     0.00000000   4.67554445   0.00000000
   1    -4.04914027   2.33777222   0.00000000
   1    -4.04914027  -2.33777222   0.00000000
   1     0.00000000  -4.67554445   0.00000000
$end
 Energy =   -232.1113196583
 symmetry: D6h
```

### 5.2 `2H6C6_n3.dfl6a.1a.in` (2023-06-25): benzene dimer (T-shaped), riDFT/LPBEVVV

```
$system mem=256 disk=-2048 $end
$control
 task=optimize
 theory=riDFT
 basis=b2u.in
$end
$dft func=LPBEVVV $end
$grid acc=1e-9 $end
integral dir=1 $end
$scf conv=1e-7 $end
$optimize sym=1 tol=1e-5,1e-4 $end

$molecule
 sym=1,0.01
 unit=b
 cartesian
 set=L1a
   6     0.00000000   0.00000000  -2.05759694
   6     2.26731160   0.00000000  -3.37038452
   6     2.26905910   0.00000000  -5.99089100
   6     0.00000000   0.00000000  -7.30172110
   6    -2.26905910   0.00000000  -5.99089100
   6    -2.26731160   0.00000000  -3.37038452
   1     0.00000000   0.00000000  -0.00598893
   1     4.04527582   0.00000000  -2.33805482
   1     4.04914526   0.00000000  -7.01932299
   1     0.00000000   0.00000000  -9.35735842
   1    -4.04914526   0.00000000  -7.01932299
   1    -4.04527582   0.00000000  -2.33805482
   6    -2.62042343   0.00000000   4.68481961
   6    -1.31027392  -2.26978452   4.68324552
   6     1.31027392  -2.26978452   4.68324552
   6     2.62042343  -0.00000000   4.68481961
   6     1.31027392   2.26978452   4.68324552
   6    -1.31027392   2.26978452   4.68324552
   1    -4.67603679   0.00000000   4.68201127
   1    -2.33744910  -4.05000582   4.67333205
   1     2.33744910  -4.05000582   4.67333205
   1     4.67603679  -0.00000000   4.68201127
   1     2.33744910   4.05000582   4.67333205
   1    -2.33744910   4.05000582   4.67333205
$end
 Energy =   -464.2278506060
 symmetry: C2v
  dipole =   0.212931 au (  0.541220 D)
```

### 5.3 `2H6C6_n3.dfl6.1a.in` (2025-06-23): same dimer, `theory=DFT_n4`, `func=LPBEVV`

```
$system mem=256 disk=-2048 $end
$control
 task=optimize
 theory=DFT_n4
 basis=b2u.in
$end
$dft func=LPBEVV $end
$grid acc=1e-9 $end
$scf conv=1e-7 $end
$optimize sym=1 tol=1e-5,1e-4 $end

$molecule
 sym=1,0.01
 unit=b
 cartesian
 set=L1a
   6     0.00000000   0.00000000  -2.05041816
   6     2.26696121   0.00000000  -3.36310474
   6     2.26881277   0.00000000  -5.98329034
   6     0.00000000   0.00000000  -7.29399227
   6    -2.26881277   0.00000000  -5.98329034
   6    -2.26696121   0.00000000  -3.36310474
   1     0.00000000   0.00000000   0.00146855
   1     4.04460972   0.00000000  -2.33045602
   1     4.04858611   0.00000000  -7.01166941
   1     0.00000000   0.00000000  -9.34935731
   1    -4.04858611   0.00000000  -7.01166941
   1    -4.04460972   0.00000000  -2.33045602
   6    -2.62013354   0.00000000   4.67595412
   6    -1.31014406  -2.26953537   4.67484247
   6     1.31014406  -2.26953537   4.67484247
   6     2.62013354  -0.00000000   4.67595412
   6     1.31014406   2.26953537   4.67484247
   6    -1.31014406   2.26953537   4.67484247
   1    -4.67544490   0.00000000   4.67427942
   1    -2.33720534  -4.04946602   4.66737582
   1     2.33720534  -4.04946602   4.66737582
   1     4.67544490  -0.00000000   4.67427942
   1     2.33720534   4.04946602   4.66737582
   1    -2.33720534   4.04946602   4.66737582
$end
 Energy =   -464.2097220304
 symmetry: C2v
  dipole =   0.210447 au (  0.534908 D)
```

(The `DFT_n4` input has no `integral dir=1` line.)

### 5.4 `C60.qm.in` (2013): QM-model optimization of C60; the site's "hello world"

```
$system mem=64 disk=-256 $end
$control
 task=optimize
 theory=qm_n3
 basis=qm.in
$end
$optimize tol=1e-5 step=150 $end

$molecule
 cartesian
   6     2.58261339  -0.72419779   2.28278182
   6     2.58261339   0.72419779   2.28278182
   6     1.41083675   1.17177664   3.00697961
   6     0.68663896   0.00000000   3.45455846
   6     1.41083675  -1.17177664   3.00697961
   6    -0.68663896   0.00000000   3.45455846
   6    -1.41083675  -1.17177664   3.00697961
   6    -0.72419779  -2.28278182   2.58261339
   6     0.72419779  -2.28278182   2.58261339
   6     3.00697961   1.41083675   1.17177664
   6     2.28278182   2.58261339   0.72419779
   6     1.17177664   3.00697961   1.41083675
   6     0.72419779   2.28278182   2.58261339
   6    -2.58261339  -0.72419779   2.28278182
   6    -2.58261339   0.72419779   2.28278182
   6    -1.41083675   1.17177664   3.00697961
   6     0.00000000   3.45455846   0.68663896
   6    -1.17177664   3.00697961   1.41083675
   6    -0.72419779   2.28278182   2.58261339
   6    -3.00697961   1.41083675   1.17177664
   6    -2.28278182   2.58261339   0.72419779
   6    -1.17177664  -3.00697961   1.41083675
   6    -2.28278182  -2.58261339   0.72419779
   6    -3.00697961  -1.41083675   1.17177664
   6    -3.45455846  -0.68663896   0.00000000
   6    -3.45455846   0.68663896  -0.00000000
   6     1.17177664  -3.00697961   1.41083675
   6     2.28278182  -2.58261339   0.72419779
   6     3.00697961  -1.41083675   1.17177664
   6     3.45455846  -0.68663896   0.00000000
   6     3.45455846   0.68663896  -0.00000000
   6     2.28278182   2.58261339  -0.72419779
   6     1.17177664   3.00697961  -1.41083675
   6    -0.00000000   3.45455846  -0.68663896
   6    -2.28278182   2.58261339  -0.72419779
   6    -1.17177664   3.00697961  -1.41083675
   6    -3.00697961   1.41083675  -1.17177664
   6     0.00000000  -3.45455846   0.68663896
   6     3.00697961   1.41083675  -1.17177664
   6     2.58261339   0.72419779  -2.28278182
   6     2.58261339  -0.72419779  -2.28278182
   6     3.00697961  -1.41083675  -1.17177664
   6     0.72419779   2.28278182  -2.58261339
   6     1.41083675   1.17177664  -3.00697961
   6    -3.00697961  -1.41083675  -1.17177664
   6    -2.58261339  -0.72419779  -2.28278182
   6    -2.58261339   0.72419779  -2.28278182
   6    -1.41083675   1.17177664  -3.00697961
   6    -0.72419779   2.28278182  -2.58261339
   6    -0.00000000  -3.45455846  -0.68663896
   6     1.17177664  -3.00697961  -1.41083675
   6     2.28278182  -2.58261339  -0.72419779
   6    -1.17177664  -3.00697961  -1.41083675
   6    -2.28278182  -2.58261339  -0.72419779
   6     1.41083675  -1.17177664  -3.00697961
   6     0.72419779  -2.28278182  -2.58261339
   6    -0.68663896  -0.00000000  -3.45455846
   6     0.68663896   0.00000000  -3.45455846
   6    -0.72419779  -2.28278182  -2.58261339
   6    -1.41083675  -1.17177664  -3.00697961
$end
```

Result: `E=-2279.8943971004` hartree-like QM energy in 14 SCF iterations. Timings: 17.6 s on 1 process (Linux, 2013), 10.7 s on 2 processes, 13.4 s on 2 processes (Cygwin).

### 5.5 `C60.df.in` (2013): DFT (PBE default) optimization of C60 with `basis.in` (default L1)

```
$system mem=64,32 disk=-512,-1 $end
$control
 task=optimize
 theory=DFT
 basis=basis.in
$end
$optimize tol=1e-5 step=50 $end

$molecule
 cartesian
   6     2.60045444  -0.72637405   2.30595169
   ... (60 C atoms, PBE-optimized coordinates in the original file) ...
   6    -1.42515656  -1.17529793  -3.03232573
$end
 Energy =  -2284.05727695
```

Result: `E = -2284.05727694`. Timings: 2330 s on 1 process (Linux), 1339 s on 2 processes (Linux), 3046 s on 1 process (Cygwin). Basis for C: orbital 14 functions / 46 primitives `{3,2,1}/{10,7,3}`; auxiliary 40/100 `{6,4,3,1}/{10,9,7,4}`; total 840 basis functions and 2400 auxiliary.

### 5.6 `H10C6N2H4PtO2C2O2.df.in` (2015): scalar-relativistic DFT of oxaliplatin, Z-matrix

```
$system mem=64,16 disk=-256,-1 $end
$control
 task=optimize
 theory=DFT
 four=1
 nuc=finite
 basis=basis4.in
$end
$optimize tol=1e-4 steps=100 $end

$molecule
 z-matrix
 set=L1
   6
   6    1    1.53528165
   6    2    1.53063648    1    111.093880
   6    3    1.53739331    2    110.838077    1     56.073074
   6    4    1.53449415    3    111.464490    2    -55.110802
   6    5    1.53739488    4    111.463313    3     54.771542
   1    1    1.10627910    2    108.080474   -6    109.650621
   7    1    1.49981377    6    113.974682   -2    108.033377
   7    2    1.49981244    3    113.975132   -1    108.033236
   1    2    1.10627913    1    108.080182   -3    109.650796
   1    3    1.10724475    4    109.556078   -2    108.952143
   1    3    1.10376713    2    109.767448   -4    110.530588
   1    4    1.10232901    5    110.240249   -3    109.591868
   1    4    1.10552553    3    109.237593   -5    109.519036
   1    5    1.10552554    6    109.237345   -4    109.518136
   1    5    1.10232900    4    110.240551   -6    109.592247
   1    6    1.10376710    1    109.769305   -5    110.530046
   1    6    1.10724471    5    109.556346   -1    108.949470
   1    8    1.03204351    1    110.090105    2     81.368565
   1    8    1.03032043    1    110.524501   19    117.212766
   1    9    1.03204348    2    110.089679    1     81.368048
   1    9    1.03032049    2    110.524927   21    117.212564
  78    8    2.08049124   -9    2.08048963    2   -164.922624
   8   23    1.99552803    8     96.187209    9   -179.582334
   6   24    1.33841435   23    112.935260    8   -179.856221
   6   25    1.56165385   24    114.794893   23      0.684818
   8   26    1.33841442   25    114.794895   24     -0.935100
   8   25    1.21046099   26    122.199539   24   -179.615981
   8   26    1.21046101   25    122.199541   27   -179.615983
$end
 Energy = -19148.34008401
  dipole =   7.109666 au ( 18.071106 D)
```

Basis printout from `basis4.in`, `set=L1` (`Z  El : nfunc/nprim : {contracted per l}/{primitives per l}`):
- H: `5/12 : {2,1}/{6,2}` orbital; `5/15 : {2,1}/{6,3}` auxiliary (the auxiliary listing is printed second)
- C, N, O: `14/46 : {3,2,1}/{10,7,3}` orbital; `40/100 : {6,4,3,1}/{10,9,7,4}` auxiliary
- Pt: `68/315 : {8,7,5,2}/{30,29,20,14}` orbital; `427/893 : {18,17,16,14,11,5,2}/{30,27,25,22,19,16,12}` auxiliary (up to l = 6)

Run: 2 processes, 124 s, 7 SCF cycles, converged in 0 optimization steps (input already optimized).

### 5.7 `H40C20.qm.in` (2016): QM molecular dynamics with a thermostat, snapshots written to files

```
$system mem=128 disk=-128 $end
$control
 task=thermostat
 theory=qm_n3
 basis=qm.in
$end

$dynamic
 e=0.001
 d=0.03
 n=1000,100
 m=10
 i=1
 file=H40C20/H40C20_%06d.qm.in
$end
 v=500.0
 h=0.1

$molecule
 cartesian
   6    -3.64833537   0.44487382  -0.20312804
   1    -4.72874379   0.32266631  -0.05822617
   ... (60 atoms: C20H40, Å) ...
   1    -2.92166934  -2.74314576  -1.40587655
$end
 Energy =   -784.07687196
```

### 5.8 `H40C20_u.in` (2013): duplicate filtering over many structures

Header shown in §4.9. The file holds 157 `$molecule` blocks.

### 5.9 Large QM jobs

`5H48C94N8O6_a.qm.in` (780 atoms, C5h, 8 processes, 638 s):

```
$system mem=2048,256 disk=-256,-1 $end
$control
 task=optimize
 theory=qm_n3 basis=qm.in
$end
$scf conv=1e-8 $end
$optimize cart=1 tol=1e-7 step=250 $end

$molecule
 cartesian
   8    -9.13280130   0.78779642   0.00000000
   ... (780 atoms) ...
$end
 Energy = -22443.02739178
```

`2x_20H48C94N8O6_10H22C54N6O9.qm.d25b1.in` (8060 atoms, 37840 electrons, C5, 32 processes on 4 nodes, 1991 s wall time):

```
$system mem=1024 disk=-64,-16 $end
$control
 task=opt_n1
 theory=qm_n2
 basis=qm.in
$end
$scf conv=1e-7 d=25.0,1.0 p=1.0,1.0 dir=1 $end
$optimize tol=1e-6 step=2000 mod=1 $end

$molecule
 cartesian
   8    32.16925587   9.90572491  -1.35558313
   ... (8060 atoms) ...
$end
 Energy = -240937.16989170
```

The `.d35b1` variant differs only in these lines: `$system mem=2048 disk=-80,-24 $end`, `$scf ... d=35.0,1.0 ...`, `$optimize tol=1e-6 step=200 mod=1 $end`.

---

## 6. Basis sets, auxiliary bases and data files

### 6.1 File inventory

| File | Size | Date | Content |
|---|---|---|---|
| `3z.bas` | 133 KB | 2013-01-28 | Old-style all-electron basis. `$BASIS`: `set=2z` (H–Ne) and `set=3z` (H–Xe, Z = 1–54), `default=3z`. `$AUXILIARY`: 2z and 3z, H–Xe. `$Basis2`: 2z and 3z, H–Xe (the same auxiliary functions written in the explicit general format). |
| `sbk.bas` | 174 KB | 2013-02-02 | SBK ECP basis. `$BASIS`: `set=2z` (H, B–F), `set=3z` (H–Rn, Z = 1–86). `$AUXILIARY` (2z, 3z). `$ECP` (`set=3z|2z`, Z = 3–86). `$Basis2`. |
| `basis.in` | 62.7 MB | 2014-03-29 | Laikov L-family, `type=general`, `default=L1`, Z = 1–36 according to the generator script |
| `basis4.in` | 64.5 MB | 2013-01-28 | L-family for scalar-relativistic (`four=1`) use, `type=general`, `default=L1`. Includes heavy elements such as Pt (used in §5.6). No generator script is appended. |
| `b2.in` / `b2.old.in` | 48.4 / 46.3 MB | 2020-06-19 / 2018-12-20 | New L-family, `type=gc`, `default=L1`, Z = 1–36 |
| `b2n.in` / `b2n.old.in` | 3.5 / 3.4 MB | 2020-06-19 / 2018-12-20 | "n" subset (fewer sets: only the main named sets), Z = 1–36 |
| `b2u.in` / `b2u.old.in` | 162.7 / 148.5 MB | 2020-05-18 / 2018-12-16 | Z = **1–102** (H–No), `$kinetic` + `$basis` + `$basis2`, tags `.u.` |
| `b2un.in` / `b2un.old.in` | 19.7 / 17.1 MB | 2020-05-18 / 2018-12-16 | "n" subset of b2u, Z = 1–102 |
| `b4s.in` | 552 MB | 2019-01-09 | Scalar-relativistic counterpart, `c137=137.035999173`, `nuc=2`, Z = 1–102, tags `.s.` |
| `b4sn.in` | 23.8 MB | 2019-01-08 | "n" subset of b4s |
| `qm.in` | 3.5 MB | 2012-12-18 | QM-model parameter and training-set file (§6.5) |

Each `b2*`/`b4s*`/`basis.in` file ends with **its own generator shell script** (`"./c2_new.sh"`, `"./c2n_new.sh"`, `"./c2u.sh"`, `"./c4s.sh"`, `"./compile.sh"`), appended through `echo '"'$0'"'; cat $0`. The script begins with a `date` line, so the first line of each file is a timestamp such as `Fri Jun 19 13:12:22 MSK 2020`. The scripts record the set definitions and the internal atomic-basis tags, for example:

```
s 'L1(7,2)|L1_2|L11_2|L1'
# 20160804
b1 001H_.C1.l.0702w12
b1 002He.C1.l.0702w12
...
b2 036Kr.C44a.l.33292116131104w12.l{0.1714,1.1613,2.1513,3.1211,4.1009,5.07,6.05,7.02,8.01}
```

Tag syntax: `ZZZEl.<C-family>.<l|n>.<primitive counts per l>w12`, plus an optional auxiliary-shell spec. Dates in the comments (2016–2018) give the basis-optimization dates. In the `b4s` script, `s=$1` overrides the default set (`if [ -z $s ] then d=L1 else d=$s`), and the content is wrapped in `if ts N ; then` blocks.

### 6.2 Basis set names (`set=` values; usable as `$molecule set=...` / `$control basis=` default)

Naming in a `set=` line: `Name(n_s,n_p,n_d,...)|alias1|alias2...`. The parenthesized numbers give the number of **primitive** Gaussians per angular momentum (the same numbers appear in the output's `{prims}`), and the aliases select the same set. Within a file, the same alias (e.g. `L1`) is attached to different contraction patterns for different element rows, so `set=L1` picks the row-appropriate set. Suffix `_k` (b2/b4s style) or `#k` (basis.in style) means size/accuracy level *k* of the same family, and the bare name = the default level.

Families present (unique names after stripping `_k`/`#k`):

- **`basis.in`** (`$basis`): `0` (empty set; `set=0` lists `01 0 … 36 0`), `b1`, `L0`, `L0a`, `L0aa`, `L1`, `L1m`, `L1a`, `L1+1`, `L1+2`, `L11`, `L11m`, `L11a`, `L111`, `L111m`, `L111a`, `L1111`, `L1111m`, `L1111a`, `L2`, `L2m`, `L2a`, `L2+1`, `L2+12`, `L22`, `L22m`, `L22a`, `L222`, `L222m`, `L222a`, `L2222`, `L2222m`, `L2222a`, `L3`, `L3m`, `L3a`, `L3+1`, `L3+12`, `L33`(m,a), `L333`(m,a), `L3333`(m,a), `L4`, `L4a`, `L44`(a), `L444`(a), `L4444`(a), `L5`, `L5a`, `L55`(a), `L555`(a), `L5555`(a), `L6`, `L6a`, `L66`(a), `L666`, `L6666`, `L7`, `L77`, `L777`, `L7777`, `V1`.
  Examples: `set=L0(6)|L0`, `set=L1m(6)|L1m|L11m|L111m|L1111m`, `set=L1(6,2)|L1|L11|L111|L1111|V1` (H, He), `set=L1(8,4)|L1#2|...`, `set=L1a(7,3)|L1a|L11a`, `set=L1+1(8,5)|L1+1`, `set=L2(6,3,1)`, `set=L2m(8,4)|L2m|L22m|L222m|L2222m`.
- **`basis4.in`**: `L0`, `L1`, `L11`, `L111`, `L1111`, `L2`, `L22`, `L222`, `L2222`, `L3`, `L33`, `L333`, `L3333`. Examples, from light to heavy elements: `L1(6,2)` (H), `L11(10,7,3)`, `L1(10,7,3)`, … `L11(30,29,20,14)`, `L1(30,29,20,12)`, … `L111(34,33,24,18,6)|L1|L11|L111`, `L333(41,40,30,23,13,9,4)|L3|L33|L333` (heaviest rows). `$basis2` mirrors the same names.
- **`b2.in`**: `L1`, `L1a`, `L1ab`, `L11`, `L11a`, `L2`, `L2m`, `L2a`, `L2am`, `L2ab`, `L22`, `L22m`, `L22a`, `L22am`, `L3`, `L3a`, `L3ab`, `L33`, `L33a`, `L4`, `L4a`, `L4ab`, `L44`, `L44a`, `L5`, `L5a`, `L5ab`, `L55`, `L55a`, with levels `_1`…`_6`. Example: `set=L1(5,1)|L1_1|L11_1`, `set=L1(7,2)|L1_2|L11_2|L1` (default L1 for H, He = level 2), `set=L4(8,4,3,2,1)|L4_1|L44_1`, `set=L5(10,5,4,3,2,1)|L5_1|L55_1`.
- **`b2u.in`/`b2un.in`/`b4sn.in`**: adds `L111`, `L222`, `L222m`, `L333`, `L444`. b2u has up to `L4`/`L44`/`L444`; b2un and b4sn have up to `L2` families only.
- **`b4s.in`**: everything in b2 plus `L1a+`, `L11a+`, `L11ab`, `L22ab`, `L33ab`, `L44ab`, `L55ab`, and the new **`Lx` family** (`Lx1`, `Lx1a`, `Lx2`, `Lx2m`, `Lx2a`, `Lx2am`, `Lx3`, `Lx3a`, `Lx4`, `Lx4a`, `Lx5`, `Lx5a`), e.g. `set=L1(7,2)|L1_2|L11_2|Lx1_2|L1|L11|Lx1`.
- **Old-style files**: `2z`, `3z` (`3z.bas`, `sbk.bas`).

Naming pattern *(inferred, consistent across files)*: the digit after L = highest polarization angular momentum relative to the minimal set, so L1 ≈ double-zeta-polarized, L2 ≈ triple-ζ, L3 ≈ quadruple-ζ, and so on. Repeating the digit (L11, L111, L1111) indicates more core-correlation/"cc"-type functions at the same valence level. `a` = augmented (diffuse), `m` = reduced/"minus" polarization, `b` = extra functions. The examples use `set=L1` (DFT) and `set=L1a` (augmented, for the π-stacked benzene dimer).

### 6.3 Auxiliary basis format (`$AUXILIARY`, `3z.bas`)

```
$AUXILIARY

default=3z

set=2z

           1  4

   0      8.41527719e+00
   0      2.72482954e+00
   1+     8.82287754e-01
   0      2.85680873e-01
```

Each element block is `Z  nshells`, then lines of `L  exponent`. `L+` means one shell for every l' ≤ L at that exponent. The `$Basis2` section of the same file confirms this: `1+ 8.82287754e-01` there becomes `0 1 8.82287754e-01 1.0` plus `1 1 8.82287754e-01 1.0`, and `2+` expands to l = 0, 1, 2.

### 6.4 Orbital basis formats

Old style (`$BASIS`, `3z.bas`): an element header `Z  nshells`, then per shell `L  nprim  exp  coef` with continuation lines `exp coef`:

```
         3  6

 0  4   2.646791e+2   9.783377e-3
        3.987865e+1   7.214937e-2
        9.036872e+0   3.032997e-1
        2.427069e+0   7.177530e-1
 0  1   6.926590e-1   1.0
```

General-contraction style (`type=gc`, `b2.in`): an element header `Z  k`, then per angular momentum `nprim  ncontr`, then lines of `exponent  c1  c2 ...`, written in full-precision signed format:

```
set=L1(5,1)|L1_1|L11_1
        1 1
 5  2
+.299499027384386015e+02 +.120808320110853784e-01 +.864054939796567506e-02
...
 1  1
+.550359563863720805e+00 +.100000000000000000e+01
```

(In this block, s has 5 primitives contracted to 2 functions, and p has 1 primitive and 1 function.) In `b4s.in` there are 4 coefficient columns per 2 functions *(inferred: values for two Hamiltonians or components, see 3.3)*. In `basis4.in` (`type=general`), each block is `Z  nshells`, then `L  nprim`, with two coefficient columns per exponent.

### 6.5 `qm.in` (QM model parameters)

Structure, in order:
1. A run header for the parametrization program: `$system mem=1024,384 disk=-32 $end`, `$control task=QM $end`, `$optimize tol=1e-5 max=0.25 iter=250,16 tim=1 diag=1 $end print=-2`.
2. **m4 macro definitions**, e.g. ``define(`w_m0',` &hg=0 &scf=1 &w=0x1p16*e, 0x1p3*f, 0*d ')``. These are weights for energies (e), forces (f), dipoles (d), gradients (g), and so on, written in C99 hex-float notation (`0x1p16` = 65536). There are also `t_00_1_1`-type weight templates, and molecule-set definitions `n_H`, `n_Li`, …, `m_Cu_Cu` with `&path=mol/*.cc.b1.in` lines pointing at reference (coupled-cluster, "cc") molecular data.
3. `$reaction ... $end`: reaction-energy targets, e.g. `( H4B2_2 - H4B2 ) * w_r`, `( F2F2 - 2 F2 ) * w_r`, with ``define(`w_r',`0x1p22')``.
4. `$file ... $end`: the training-set lists.
5. `$parameter ... $end`: which parameters are fitted, with bounds, e.g. `afb:24:0:a @ 0.2 1.0 1000.0 0.0`.
6. **`$qmdata ... $end`**: the actual model parameters read by `theory=qm_n*`. Header `m 3 K 0 fo 0`. Element lines `n Z ...` give the valence shell structure. Elements: **H (1), Li–F (3–9), Na–Cl (11–17), Sc–Cu (21–29)**. He, Ne, Ar, K, Ca, Zn and anything heavier than Cu are absent. Then come atomic energies (`ea  6 -33.3807666`), radii (`r0  6 13.7159534`), and parameter tables `qa`, `q1a`, `ga`, `cf`, `fb`, `f1b`, `fo`, `ub`, `u1b`, `vb`, `gb`, `g10b`, and others. The two most frequent tables have about 17 800 `gb` lines and about 8 300 `g10b` lines.
**Practical consequence: the QM method can be used only for H, Li–F, Na–Cl and Sc–Cu.**

---

## 7. Output format notes (from the example outputs)

Order of sections in a DFT optimization output (`C60.df.l.2.out`):
1. Banner (` Priroda 13 (2013.01.10)`, ` copyright (c) D.N. Laikov`), ` date: ...`, ` parallel on  2 processors`, node list, ` Memory: ...`.
2. ` molecule input: ''`, ` 60 atoms, 360 electrons`, optional ` symmetry: ...`/` unique atoms: ...`, the `<$molecule` echo (v14+), ` Atomic Coordinates:` (`Z x y z`, terminated by ` #`), `  formula: C60`, `  internuclear distances:` (per atom: neighbours with distances), `     largest =    7.10138`.
3. For relativistic runs: ` Finite nucleus model:` and core definitions.
4. ` Basis set input: '<path>'` followed by one line per atom, `    1   6  C :  14/46  : {3,2,1}/{10,7,3}`. This is printed twice: orbital basis, then auxiliary basis.
5. Summary box:
```
 +---------------------------------------
 | Number of atoms                     60
 | Charge of molecule                   0
 | Spin multiplicity                    1
 | Number of alpha electrons          180
 | Number of beta  electrons          180
 | Number of core  electrons           60
 | Theoretical Method                 DFT
 | Approximation to E(xc)             PBE
 | Dimension of wavefunction basis    840
 | Dimension of   auxiliary  basis   2400
 | Hamiltonian: non-relativistic
 +---------------------------------------
```
6. ` scf options: conv=1.0e-06, 1.0e-03; iter=16,16`, ` cut-off for S,T,V integrals: 1.0e-10 (1.0e-06)`, ` grid: accuracy=1.0e-08,1.0e-05, cut=1.0e-10,1.0e-07`.
7. ` Geometry optimization options:` (`Coordinates: internal`, tolerances, trust radius, max steps, `Updated hessian used`).
8. Per step: ` Geometry Optimization Step N:`, `Initial Guess`, `SCF Equations:` table `it. energy energy change gradient time`, with micro-iterations (gradient only) between macro iterations, then ` converged!`, then the timing lines `time: <Name> : total [per-rank] eff% max`. After that: `   6 F,   21 F1` (number of Fock builds and response steps *(inferred)*), the energy components ` E = ... T = ... V = ... J = ... Ex = ... Ec = ...`, `  dipole = ... au ( ... D)`, ` One-Electron Energies (alpha)` (HOMO region: last 8 occupied and first 8 virtual), gradient timings, the `eng>` block, ` G(max) = ...  |G| = ...`.
9. Convergence: `OPTIMIZATION CONVERGED in N steps!`, then the final geometry printed as **`MOL>` lines**, which are a ready-to-paste `$molecule` group including ` Energy =` (for Z-matrix input the Z-matrix is reproduced):
```
MOL>$molecule
MOL> cartesian
MOL>   6     2.58261339  -0.72419779   2.28278182
...
MOL>$end
MOL> Energy =  -2279.89439710
```
10. The trailer: `====...`, `Memory used = ... KB`, `Disk used = ... KB, ... KB written, ... KB read` (per rank), message-passing statistics, `CPU time = ... sec = ... min = ... hr = ...%`, `REAL time`, `ratio`, the end `date:`, and a cumulative timing table.

QM-model (`qm_n3`) output is much terser. The SCF looks like:
```
 SCF: No=120,120 N=240 N1=540
it= 0: E=-2277.8974171925 g=0.1976670621 x=0.1714279456
...
converged!
it=14: E=-2279.8943971004 g=0.0000000003
 e: -0.30583 -0.02677
```
Here `e:` is most likely the HOMO/LUMO energies *(inferred)*, and the timing labels are H, R, J, K, SCF, Hx, Rx. The v13.09 output also prints ` Max. Gradient`, `    i     g(i)       h(i)       d(i)` and ` Max. Displacement` lines.

Known cosmetic bugs in the outputs: "Geomtery Optimization" is misspelled in v13 (fixed to "Geometry" in v15). The Cygwin 2-process run printed garbage for the efficiency percentage (`0.0% 4030769868570477895629...0.0`), an uninitialized timer on Windows.

---

## 8. Utility programs (bash scripts on the site, verbatim)

### `ge`: append the `eng>` (energy/gradient/hessian) block from `.out` to `.in`

```
f=${1/.out/}
f=${f/.in/}
if [ ! -e $f.out ]
  then echo 'file?'
  exit 1
fi
if grep -q 'NUMERICAL AND ANALYTICAL GRADIENT' $f.out
then
  sed -n -e '0,/NUMERICAL AND ANALYTICAL/d' -e '/eng>/s/eng>//p' $f.out >> $f.in
else
  sed -n -e '/eng>/s/eng>//p' $f.out >> $f.in
fi
```

(The marker `NUMERICAL AND ANALYTICAL GRADIENT` implies that a numerical-vs-analytical gradient check task exists; its output contains a first `eng>` block that has to be skipped.)

### `gm`: replace the `$molecule` group in `.in` with the optimized one from `.out` (keeps `.bak`)

```
f=${1/.out/}
f=${f/.in/}
if [ ! -e $f.out ]
  then echo 'file?'
  exit 1
fi
if grep -q 'MOL>' $f.out
then t=1
elif grep -q '^<$mol' $f.out
then t=2
else echo 'mol?' $f ; exit 1
fi
mv $f.{in,bak}
sed -n -e '/$molecule/q' -e p                   $f.bak  > $f.in
if [ $t = 1 ]
then
  sed -n '/MOL>/s/MOL>//p'                      $f.out >> $f.in
else
  sed -n '/^<$mol/,/^<$end/s/<//p'              $f.out >> $f.in
fi
sed -n -e '/dipole/h' -e '${g;/.*0\.000.*/d;p}' $f.out >> $f.in
diff $f.{bak,in} | tail -n 64
```

This explains the trailing ` Energy = ...` and `  dipole = ...` lines in the example inputs. The script requires the `$molecule` group to be the **last** group in the input, because everything from `$molecule` onwards is replaced. A non-zero dipole is appended; one matching `0.000` is dropped. If no `MOL>` lines exist (an unconverged job), the input echo `<$molecule ... <$end` is used instead.

### `grx`: concatenate two IRC halves

```
if [ -e $3 ]
then
  echo '?' $3
  exit
fi
if ! grep -q 'REACTION PATH' $1
then
  echo '?' $1
  exit
fi
if ! grep -q 'REACTION PATH' $2
then
  echo '?' $2
  exit
fi
sed -n '/REAC/,$p' $1  > $3
sed -n '/REAC/,$p' $2 >> $3
```

Usage: `grx forward.out backward.out irc.txt`. The IRC output section starts at the marker `REACTION PATH`, which confirms the IRC task and its output marker.

---

## 9. Citations requested by the author

**None are given anywhere on the site.** For the manual, the commonly cited Priroda references from the literature (not from this site; verify before use) are:
- D. N. Laikov, Chem. Phys. Lett. 281 (1997) 151–156: the density-fitting DFT method and the program.
- D. N. Laikov, Yu. A. Ustynyuk, Russ. Chem. Bull. 54 (2005) 820–826: the PRIRODA-04 program.
- D. N. Laikov, Chem. Phys. Lett. 416 (2005) 116–120: the L1/L2/... ("L-family") basis sets.
- D. N. Laikov, J. Chem. Phys. 135 (2011) 134120: the parametrizable QM model behind `theory=qm_n*`.

---

## 10. Things that contradict or extend older documentation

(Compared with `research/00_local_files.md` and `research/02_limor1_manual.md`.)

1. **New theories:** `riDFT` is used with `func=LPBEVVV` (older docs pair riDFT with PBE1/hybrids). `DFT_n4`, `qm_n2` and `qm_n3` are absent from `input.txt`.
2. **New functionals:** `LPBEVV`, `LPBEVVV` (2023–2025).
3. **New tasks:** `opt_n1` (large-system optimizer, `$optimize mod=1`), `uniq` with the new group `$uniq dist=`, `QM` (parametrization), plus `thermostat` with `$dynamic file=` (snapshot output pattern). The `ge` script also implies a numerical-vs-analytical gradient check.
4. **`$system` second values:** `mem=a,b` and `disk=a,b` set the master (rank 0) and slave values separately. This is shown by the `Memory:` line. Older docs describe only a single value.
5. **`$molecule` new keywords:** `unit=b` (bohr), `sym=1,0.01`. **`$optimize` new keywords:** `sym=1`, `cart=1` (older docs: `cartesian`, which is the same keyword under prefix abbreviation), `mod=1`; `tol=` takes two values (gradient, displacement), and when one value is given the displacement tolerance defaults to 100 × the gradient tolerance.
6. **Defaults confirmed from v13/v15 output:** SCF `conv=1e-6,1e-3`, `iter=16,16` (the Dft.rtf note says iterations=30, which contradicts this); grid `accuracy=1e-8,1e-5` (Dft.rtf says 1e-7, which contradicts this; `input.txt` says 1e-8, which agrees); trust radius `0.2` max / `0.0125` min (Dft.rtf says `trust=0.5`, which contradicts this); default functional PBE (agrees); default internal coordinates (agrees).
7. **Basis files:** the older docs list `3z.bas` (Z ≤ 54), which agrees. `sbk.bas` is said to cover Z ≤ 84, but the site's file has a 3z basis and ECP **up to Z = 86 (Rn)**. Newer basis families are distributed: `b2*.in` (gc format, 2018–2020), `b2u*.in` (Z up to 102), and `b4s*.in` (relativistic, `c137`/`nuc=2` inside the basis file). These are not in the older docs. The relativistic `r`-prefixed names mentioned on limor1 (`rL1` and so on) **do not appear** in the official `basis4.in`, which uses plain `L1`/`L11`/... names. The `r` prefix is probably a local renaming.
8. `four=1 nuc=finite`: the output proves that the result is a **scalar-relativistic** Hamiltonian with a Gaussian finite nucleus, with c = 137.0359895 hard-coded in v15 versus `c137=137.035999173` in the b4s files. Older docs did not explain `four`.
9. **Windows naming:** `p1.exe` is serial and `p.exe` is parallel under Cygwin `mpirun.exe`.
10. **Output:** the `MOL>` (final geometry) and `eng>` (`$Energy` restart block) markers are confirmed, and so are `REACTION PATH` (IRC) and `NUMERICAL AND ANALYTICAL GRADIENT`. Starting with v14 the input molecule is echoed with a `<` prefix (`<$molecule`), which `gm` relies on as a fallback.
11. **Commenting convention:** a group with the `$` removed (e.g. `integral dir=1 $end`) and keywords placed after `$end` are ignored. The author uses this deliberately.
