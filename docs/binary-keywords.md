(binary-keywords)=
# Keywords in the program

This page lists the keyword names that the Priroda 25 (2025.02.28) executable reads, found by examining the
program file itself. Names that this manual documents are links into the {doc}`input reference <reference/index>`;
the others are only known to exist. Their meaning is unknown, so do not use them in production work.
<!-- src: 09 (p4_d, namelist call sites) -->

A name listed here is accepted by the program; a name that is not listed stops the run with
`*** error in '$group' : unknown name …`, as long as the task reads that group. Any unique prefix of a name is
accepted, so `sym=1` in `$optimize` means `symmetry=1` and `dist=` in `$uniq` means `distance=`.
<!-- src: 09; 08 t06, t40b, t40c -->

## Groups for everyday work

| Group | Keywords |
|---|---|
| {ref}`$system <group.system>` | {ref}`memory <system.memory>`, {ref}`path <system.path>`, {ref}`disk <system.disk>` |
| {ref}`$control <group.control>` | {ref}`task <control.task>`, {ref}`theory <control.theory>`, {ref}`four <control.four>`, `a137`, {ref}`state <control.state>`, `weight`, {ref}`basis <control.basis>`, {ref}`nucleus <control.nucleus>`, `field`, {ref}`derivative <control.derivative>`, `fit`, `wavelength`, {ref}`save <control.save>`, {ref}`print <control.print>` |
| {ref}`$scf <group.scf>` | {ref}`restrict <scf.restrict>`, {ref}`convergence <scf.convergence>`, {ref}`iterations <scf.iterations>`, {ref}`procedure <scf.procedure>`, {ref}`d1small <scf.d1small>`, {ref}`core <scf.core>`, `occupation`, `fraction`, `temperature`, `ttype`, `diagm`, `xmax`, `n1`, `fitxc`, `eemin`, `mab`, `aw`, `wv` |
| {ref}`$dft <group.dft>` | {ref}`functional <dft.functional>`, `zero`, `n`, `p` |
| {ref}`$grid <group.grid>` | {ref}`accuracy <grid.accuracy>`, `type`, `cutoff`, `nradial`, `nadd`, `use43` |
| {ref}`$integral <group.integral>` | {ref}`direct <integral.direct>`, {ref}`routine <integral.routine>`, `storage`, `invert`, `cutij`, `vcut` |
| {ref}`$atoms <group.atoms>` | {ref}`core <atoms.core>`, {ref}`mcore <atoms.mcore>`, `nc`, `no`, `active`, `mocc`, `occupation`, `diagonalize` |
| {ref}`$guess <group.guess>` | {ref}`read <guess.read>`, {ref}`mix <guess.mix>`, {ref}`na <guess.na>`, {ref}`nb <guess.nb>`, `n`, `a`, `type`, `gradient`, `localize` |
| {ref}`$optimize <group.optimize>` | {ref}`saddle <optimize.saddle>`, {ref}`tolerance <optimize.tolerance>`, {ref}`trust <optimize.trust>`, {ref}`steps <optimize.steps>`, {ref}`follow <optimize.follow>`, {ref}`points <optimize.points>`, {ref}`back <optimize.back>`, `down`, {ref}`radius <optimize.radius>`, {ref}`fix <optimize.fix>`, {ref}`value <optimize.value>`, {ref}`coordinates <optimize.coordinates>`, {ref}`cartesian <optimize.cartesian>`, {ref}`symmetry <optimize.symmetry>`, {ref}`gradient <optimize.gradient>`, {ref}`print <optimize.print>`, `exact`, `bend`, `local`, `circle`, `weight`, `massweight`, `minimize`, `maximize`, `cubicfit`, `energy`, `de0`, `fragment`, `noise`, `state` |
| {ref}`$d2edr2 <group.d2edr2>` | {ref}`length <d2edr2.length>`, {ref}`steps <d2edr2.steps>`, {ref}`displace <d2edr2.displace>` |
| {ref}`$thermo <group.thermo>` | {ref}`sigma <thermo.sigma>`, {ref}`temperature <thermo.temperature>`, {ref}`mass <thermo.mass>`, `project`, `localize`, `diagonalize` |
| {ref}`$nmr <group.nmr>` | {ref}`standard <nmr.standard>`, {ref}`points <nmr.points>` |
| {ref}`$Energy <group.Energy>` | {ref}`e <Energy.E>`, {ref}`g <Energy.G>`, {ref}`h <Energy.H>`, {ref}`d <Energy.D>`, {ref}`a <Energy.A>`, {ref}`dx <Energy.Dx>`, {ref}`ax <Energy.Ax>`, `r` |
| {ref}`$uniq <group.uniq>` | {ref}`distance <uniq.distance>`, `file` |
| {ref}`$dynamic <group.dynamic>` | `t`, {ref}`e <dynamic.e>`, {ref}`n <dynamic.n>`, {ref}`m <dynamic.m>`, `a`, `b`, `c`, {ref}`i <dynamic.i>`, `o`, `z`, `y`, {ref}`dx <dynamic.dx>`, `kd`, `lw`, {ref}`hb <dynamic.hb>`, `rb`, `pb`, {ref}`v1 <dynamic.v1>`, `frag`, {ref}`file <dynamic.file>`, `fprint` |

`$molecule` is read differently from the other groups, so its keywords (`charge`, `mult`, `cartesian`, `z-matrix`,
`set`, `unit`, `sym`) could not be listed from the program; see {ref}`$molecule <group.molecule>`.
Group names are case-insensitive: the program looks for `$energy`, which is the same group as `$Energy`. It is
also read as `$energy001`, `$energy002` and so on, for tasks with several structures.
<!-- src: 09 -->

## Groups of little-documented tasks

These groups belong to tasks and methods that no source describes in detail. They are listed only so that a name
met in an example input can be recognized.

| Group | Keywords | Task or method |
|---|---|---|
| `$mcscf` | `core`, `occupied`, `virtual`, `excitation`, `program`, `convergence`, `iterations`, `diagonalize` | MCSCF methods |
| `$ci` | `iterations`, `ndiis`, `ecut`, `v4` | CI methods |
| `$espmap` | `d`, `n` | electrostatic-potential map |
| `$optimize` (second reader) | `function`, {ref}`model <optimize.model>`, `h0`, `delta`, `fragment`, `steps`, `trust`, `tolerance`, `print`, `fix`, `value` | `task=opt_n1` |
| `$path` | `distance`, `points`, `spring`, `steps`, `trust`, `tolerance`, `tension` | `task=path`, `path0` |
| `$chain` | `points` | `task=chain` |
| `$dynamic` (other readers) | `t`, `e`, `dt`, `box`, `print`; `t`, `e`, `dt`; `t`, `e`, `dt`, `v`, `r`, `nt`, `nit`, `file`, `print` | `task=dynamic`, `dynamicn2`, `dynamic1p` |
| `$walk` | `n`, `m`, `e`, `i`, `b`, `dx`, `lw`, `hb`, `v1`, `fp` | `task=walk` |
| `$orient`, `$mol1`, `$mol2` | orient: `r`, `lz`, `nr`, `e`, `d0`, `amax`, `set`, `list`, `path`, `file`, `text`, `print`; mol1, mol2: `e`, `z`, `x`, `q`, `m`, `n` | `task=orient` |
| `$press` | `nadd`, `radius`, `steps`, `trust`, `tolerance`, `sign`, `energy`, `vector` | `task=press` |
| `$coord` | `index` | `task=forceconst` |
| `$steric` | `g`, `v`, `w`, `n`, `r`, `e`, `i` | `task=steric` |
| `$dimer` | `job`, `order`, `distance`, `radius`, `step`, `trust`, `gradient`, `energy`, `iterations`, `tolerance`, `delta`, `analytic`, `file`, `print` | `task=dimer` |
| `$anchor`, `$confine` | anchor: `u`, `k` and two more; confine: probably `p`, `h`, `o`, `k`, `m` (not certain) | restraints in molecular dynamics |
| `$r_n` | `r`, `m`, `n`, `d`, `q`, `file`, `list` | not known |
| `$surface` | `vx`, `x`, `nx`, `mv`, `r`, `h`, `vo`, `nv` | `task=anharmonic` |
| `$fmatrix`, `$ce`, `$ca`, `$cb` | fmatrix: `n`, `f`, `s`, `fa`, `fb`; ce: `n`, `c`, `e`, `ca`, `cb`, `ea`, `eb`; ca, cb: `n`, `c`, `e` | starting orbitals given in the input |
| `$scf` (QM model) | `restrict`, `convergence`, `iterations`, `direct`, `print`, `mc`, `amix`, `ijmix`, `cut`, `nf`, `nmax`, `nb`, `bond`, `penalty`, `distance`, `option` | `theory=qm_n*` |
| `$integral` (AM model) | `tolerance`, `atom`, `angular`, `radial`, `distance`, `term` | `task=am_integral` |
| `$isogrid` | `d`, `s`, `c`, `r`, `m`, `n`, `e`, `p`, `iter` | `task=isogrid` |

Further groups (`$molbf`, `$moldf`, `$mbf`, `$mdf`, `$esp`, `$bond`, `$e2r6`, `$geometry`, `$dmtype`, `$mm`, `$order`,
`$bf`, `$c6p`, `$hferror` (`angular`, `radial`), `$mpitest`, `$multiply`, `$gtest`) serve the parametrization of
the model Hamiltonians or the developer's own tests.
<!-- src: 09 -->

## Task names

The program recognizes these values of {ref}`task <control.task>`. Only the first group is documented or tested.

- Documented: `energy`, `gradient`, `hessian`, `optimize`, `optimize+hessian`, `irc`, `scan`, `nmr`, `dipole`,
  `anharmonic`, `thermostat`, `uniq`, `opt_n1`, `saddle`, `transit`, `extremal`, `conical`, `path`.
- Not documented: `irc4`, `dipole1`, `dipole1x`, `dipole2`, `polarizability`, `numeric`, `loop`, `stretch`,
  `extremal2`, `path0`, `pathr`, `pathx`, `chain`, `press`, `forceconst`, `potential`, `dynamic`, `dynamicn2`,
  `dynamic1p`, `walk`, `mm0dimer`, `dimer`, `orient`, `guess`, `fragment_guess`, `nss_num`, `steric`, `compare`,
  `isogrid`, `functional`, `d1fit`, `df1_n4`, `df2_n4`, `df2_e_n4`, `mbf2`, `molbf`, `moldf`, `dmtype`,
  `am_integral`, and developer tests (`mpitest`, `multiply`, `etest`, `fmtest`, `ritest`, `riopt`, `test_v`).

`check` is not a task name. Like any unknown task name, `task=check` sets up the run and stops quietly, which is
why it seems to work. An unknown `theory=` name is worse: the program runs Hartree–Fock without a message.
<!-- src: 09; 08 t18, t50, t50b -->

## Theory names

Besides the methods described in {ref}`theory <control.theory>`, the program contains these method names, none of
which is documented: `OSDFT`, `DFT_CNO`, `LEDFT`, `LE1DFT`, `DFCIS`, `RIHFDF`, `MP4D`, `PT4DQ`, `PT4SDQ`, `PT4SDTQ`,
`CISD`, `CCD4S`, `CCD4ST`, `CCD&MP2`, `LCCD+MP2`, `SN_CCD&MP2`, `SN_CCSD&MP2`, `LEHF`, `LEHF_N3`,
`LEMP2_N3`, `LE2HF_N3`, `LE2MP2_N3`, `MCSCF`, `CASSCF`, `GSCI`, the model Hamiltonians `QM_N2`, `QM_N2D`, `QM_N2B`,
`QM_N2B3`, `QM_N2C`, `QM_N2C0`, `QM_N2F`, `AM_N1`, `MM0_N2`, `DM_1`, `BM_1`, `MM_1`, and `6-12`, `FREP`, `SCRIPT`.
<!-- src: 09 -->
