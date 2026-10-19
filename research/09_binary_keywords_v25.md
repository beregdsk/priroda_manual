# Keywords in the Priroda 25 executable

Source: the Linux build `p4_d` from <https://rad.chem.msu.ru/~laikov/p_w/>, downloaded 2026-10-17 (18 707 656 bytes,
ELF x86-64, dynamically linked, **not stripped**, with debug info). Its banner string is `Priroda 25 (2025.02.28)`,
the same as in the test runs (`08`). For this note the file was only read (`strings`, `objdump`, `readelf`); from round 13 on the same file was also run
for tests in the cloud session (see `08`).

Cite as `09`. This is the program's own code, so it settles **which names exist**. It says nothing about what a
keyword does; meanings below come from other sources or are marked *(unknown)*.

## Method

Priroda reads each input group with one function, `namelist(file, "group", n, "kw1", type, count, ptr, "kw2", …)`
(93 call sites), and finds `$name` headers with `keyword(file, "name", …)` (55 call sites). For each `namelist` call
the group name and keyword names were read from the string addresses loaded just before the call, and checked
against the keyword count `n`. Where they disagreed, the call was read by hand. Task names are compared inline in
the function `Task` (byte and 8-byte constants), and theory names in `ntheory`, `Input0` and `Input1`.

Limits:
- `$molecule` is parsed character by character (`mol_input`, `inp_coord`), not by `namelist`, so its keywords
  (`charge`, `mult`, `cartesian`, `z-matrix`, `set`, `unit`, `sym`, mass) could not be listed from the code.
- Short theory names (`dft`, `hf`, `mp2`, …) are compared as constants and were not all recovered; the test runs
  (`08 t17`, `t31`–`t39`) confirm the common ones.
- A few calls take the group name from the caller (`inpfix`, `inpeng`, `mbf_*`); those were traced to their callers
  where it mattered.

## Groups and keywords read with `namelist`

Groups an ordinary user meets (function in brackets):

| Group | Keywords in v25 |
|---|---|
| `$system` (prepare) | memory path disk |
| `$control` (Input0) | task theory four a137 state weight basis nucleus field derivative fit wavelength save print |
| `$d2edr2` (Input0) | length steps displace |
| `$grid` (inpgrid) | accuracy type cutoff nradial nadd use43 |
| `$scf` (inpscf) | restrict convergence iterations procedure d1small core occupation fraction temperature ttype diagm xmax n1 fitxc eemin mab aw wv |
| `$integral` (inpscf) | direct routine storage invert cutij vcut |
| `$dft` (inpscf) | functional zero n p |
| `$atoms` (inpatm) | core mcore nc no active mocc occupation diagonalize |
| `$guess` (inpguess) | read mix na nb n a type gradient localize |
| `$optimize` (inpopt) | saddle tolerance trust steps follow points back down radius fix value coordinates cartesian symmetry gradient print exact bend local circle weight massweight minimize maximize cubicfit energy de0 fragment noise state |
| `$thermo` (vibran) | sigma temperature mass project localize diagonalize |
| `$nmr` (DFNMR) | standard points |
| `$energy` (inpeng) | e g h d a dx ax r; also numbered groups `$energy001`, `$energy002`, … (`energy%03d`) |
| `$uniq` (Uniq) | distance file |
| `$dynamic` (Thermostat, `task=thermostat`) | t e n m a b c i o z y dx kd lw hb rb pb v1 frag file fprint |

Groups for undocumented tasks and methods:

| Group | Keywords | Read by / task |
|---|---|---|
| `$mcscf` | core occupied virtual excitation program convergence iterations diagonalize | inpmcscf (MCSCF) |
| `$ci` | iterations ndiis ecut v4 | inpci |
| `$espmap` | d n | inpesp (electrostatic-potential map) |
| `$optimize` (second reader) | function model h0 fragment steps trust tolerance delta print, plus fix/value | Optim1 (`task=opt_n1`) |
| `$path` | distance points; spring steps trust tolerance tension | Path0, PathN1 (`task=path0`, `path`) |
| `$chain` | points | Chain (`task=chain`) |
| `$walk` | n m e i b dx lw hb v1 fp | Walk (`task=walk`) |
| `$dynamic` (other readers) | t e dt box print; t e dt; t e dt v r nt nit file print | Dynamic, DynamicN2, Dynamic1p |
| `$orient`, `$mol1`, `$mol2` | orient: r lz nr e d0 amax set list path file text print; mol1/mol2: e z x q m n (+1 unresolved) | Orient (`task=orient`) |
| `$press` | nadd radius steps trust tolerance sign energy vector | Press (`task=press`) |
| `$coord` | index | ForceConst (`task=forceconst`) |
| `$steric` | g v w n r e i | Steric (`task=steric`) |
| `$dimer` | job order distance radius step trust gradient energy iterations tolerance delta analytic file print | Dimer (`task=dimer`) |
| `$anchor`, `$confine` | anchor: u k (+2 unresolved; o h likely); confine: p h o k m *(inferred)* | inpcon (restraints for dynamics) |
| `$r_n` | r m n d q file list | mol_r_n |
| `$surface` | vx x nx mv r h vo nv | Anharmonic (`task=anharmonic`) |
| `$fmatrix`, `$ce`, `$ca`, `$cb` | fmatrix: n f s fa fb; ce: n c e ca cb ea eb; ca/cb: n c e | guess and vector input |
| `$scf` (QM model) | restrict convergence iterations direct print mc amix ijmix cut nf nmax nb bond penalty distance option | qm_inc (`theory=qm_n*`) |
| `$integral` (AM model) | tolerance atom angular radial distance term | am_Integral (`task=am_integral`) |
| `$isogrid` | d s c r m n e p iter | IsoGrid (`task=isogrid`) |
| `$hferror` | angular radial | HFError |
| `$molbf`, `$moldf`, `$mbf`, `$mdf`, `$esp`, `$bond`, `$e2r6`, `$geometry`, `$dmtype`, `$mm`, `$order`, `$bf`, `$c6p` | (parametrization of the model Hamiltonians) | Parametrize, MolBFn, MolDF, DMType, … |
| `$mpitest`, `$multiply`, `$gtest` | (developer tests) | mpitest, test_multiply, test_ps |

## Groups found with `keyword()`

In basis-set and parameter files: `$basis`, `$ecp`, `$kinetic`, `$am`, `$am1`, `$am2`, `$am3`, `$reaction`,
`$parameter`, `$function`, `$file`. Every group ends with `$end`. The basis-file reader (`inpbset`) also understands
`c137 = …`, `nuc = …`, `type = …` (`general`, `canonic`), `default = …` and `set = …` header lines.

## Task names (`$control task=`)

Compared in `Task`, in code order:
`energy`, `gradient`, `hessian`, `optimize`, `optimize+hessian`, `irc`, `irc4`, `scan`, `nmr`, `dipole`, `dipole1`,
`dipole1x`, `dipole2`, `polarizability`, `numeric`, `anharmonic`, `conical`, `loop`, `stretch`, `saddle`, `transit`,
`extremal`, `extremal2`, `path`, `path0`, `pathr`, `pathx`, `chain`, `press`, `forceconst`, `potential`, `opt_n1`,
`thermostat`, `dynamic`, `dynamicn2`, `dynamic1p`, `walk`, `mm0dimer`, `dimer`, `uniq`, `orient`, `guess`,
`fragment_guess`, `nss_num`, `steric`, `compare`, `isogrid`, `functional`, `d1fit`, `df1_n4`, `df2_n4`,
`df2_e_n4`, `mbf2`, `molbf`, `moldf`, `dmtype`, `am_integral`, `multiply`, `mpitest`, `etest`, `fmtest`, `ritest`,
`riopt`, `test_v`, and short parametrization codes (`Parametrize` modes).

**`check` is not among them.** In `08 t18`, `task=check` stopped after the setup, which is presumably what any
unrecognized task does *(inferred; round-4 test t50)*.

## Theory names (`$control theory=`)

Long names recovered from `ntheory`, `Input0`, `Input1`: `TDDFT`, `RIDFT`, `DFT_N4`, `DFT_CNO`, `OSDFT`, `LEDFT`,
`LE1DFT`, `DFCIS`, `RIHFDF`, `MP4D`, `MP4DQ`, `MP4SDQ`, `MP4SDTQ`, `PT4DQ`, `PT4SDQ`, `PT4SDTQ`, `CISD`, `CCD4S`,
`CCD4ST`, `CCSD`, `CCSD4T`, `CCSDSD`, `CCD&MP2`, `LCCD+MP2`, `SN_CCD&MP2`, `SN_CCSD&MP2`, `LEHF`, `LEHF_N3`,
`LEMP2_N3`, `LE2HF_N3`, `LE2MP2_N3`, `MCSCF`, `CASSCF`, `GSCI`, the model Hamiltonians `QM_N3`, `QM_N2`, `QM_N2D`,
`QM_N2B`, `QM_N2B3`, `QM_N2C`, `QM_N2C0`, `QM_N2F`, `AM_N1`, `MM0_N2`, `DM_1`, `BM_1`, `MM_1`, `6-12`, `FREP`,
`SCRIPT`, and test entries (`TEST_VMNN`, `TEST_VNNNN`). Short names confirmed by runs: `dft`, `ridft`, `tddft`,
`rimp2`, `hf`, `rihf`, `cis`, `mp2`, `mp3`, `mp4dq`, `mp4sdq`, `mp4sdtq`, `ccs`, `ccd`, `ccsd`, `ccsd4t`,
`DFT_n4`, `qm_n3`.

Other `$control` values seen in `Input0`: `nucleus=FINITE` or `DUAL` (plus point), `derivative=ANALYTIC` or
`NUMERIC`.

## Comparison with `keywords/*.yaml` (before this note)

Names in the YAML that are really **prefixes** of the binary's names (they work only because unique prefixes are
accepted): `$optimize sym` = `symmetry`; `$optimize mod` = `model` (second `$optimize` reader, `task=opt_n1`);
`$uniq dist` = `distance`; `$dynamic d` = `dx`, `$dynamic h` = `hb`.

Names in the binary but not in the YAML, for the user groups: `$control` a137 weight field derivative fit
wavelength; `$scf` occupation fraction temperature ttype diagm xmax n1 fitxc eemin mab aw wv; `$integral` cutij
invert storage vcut; `$grid` type cutoff nradial nadd use43; `$dft` zero n p; `$atoms` nc no active mocc occupation
diagonalize; `$guess` n a type gradient localize; `$optimize` exact bend local circle weight massweight minimize
maximize cubicfit energy de0 fragment noise state down; `$thermo` project localize diagonalize; `$energy` ax r.
Their meanings are unknown unless another source describes them.
