# About Priroda

Priroda (Russian for "nature") is a quantum-chemistry program for molecules written by Dimitri N. Laikov.
It began as a fast program for GGA density-functional calculations and grew to cover hybrid DFT, RI-MP2,
coupled-cluster methods, TDDFT, a scalar-relativistic Hamiltonian, NMR, and Laikov's own semiempirical model.
<!-- src: 06 §1; 03 §1; 04 #331 -->

The program is closed-source and has no official manual. The official site offers executables, basis-set files and
example inputs, but no prose documentation. The other documents in circulation are unofficial: keyword lists such as
the English "Input Summary" (`input.txt`), and a keyword page and beginner FAQ on a computing-centre wiki. This
manual collects those texts, the example files on the official site, test runs of version 25, and twenty years of
user experience from Russian-language forums. It is not an official document: the developer has not written or
reviewed it. {ref}`sources` lists what it is based on. To download the program, see {ref}`obtaining-priroda`.
<!-- src: 04 #151, #327; 00; 01 §2 -->

## Main features

Density-functional theory
: GGA DFT in which the Coulomb and exchange–correlation terms are evaluated with an auxiliary (fitting) basis.
  This is the source of Priroda's speed. Every orbital basis comes with a matched fitting basis.
  GGA DFT has analytic second derivatives.
  <!-- src: 06 §1, §3; Laikov CPL 281 (1997) -->

: Hybrid functionals with exact exchange evaluated by the resolution of the identity, under
  {ref}`theory=ridft <control.theory>`.
  <!-- src: 06 §3 (hybrid RI DFT implemented November 2004) -->

Correlated methods
: RI-MP2 and, as undocumented or less-used options, conventional MP2–MP4, CCSD and CCSD(T). Gradients exist for
  MP2, CCSD and CCSD(T).
  <!-- src: 06 §3; 03 §1 (2011 gradient bug fix names these methods); 04 #146 -->

Excited states
: GGA TDDFT with excited-state gradients, so excited-state geometries can be optimized.
  <!-- src: 03 §11 -->

Relativistic calculations
: A scalar-relativistic Hamiltonian ({ref}`four=1 <control.four>`) with all-electron basis sets and a finite-nucleus
  model. The user FAQ of one computing centre names this, together with basis sets for the whole periodic table, as
  what sets Priroda apart. Effective core potentials (SBK) are also available.
  <!-- src: 06 §1; 01 §3.3, §3.4 -->

Geometry and dynamics
: Minimization in redundant internal coordinates, transition-state search, IRC, relaxed scans, Hessians with
  vibrational analysis and thermochemistry, and molecular dynamics with a thermostat.
  <!-- src: input.txt; 01 §4.8 -->

Properties
: NMR shielding tensors and chemical shifts (also at points in space, for NICS), Hirshfeld and Mulliken charges, bond
  orders, ESR parameters, critical points of the electron density, Raman intensities, and orbitals and normal modes
  for Molden.
  <!-- src: input.txt; 04 #381, #499 -->

Semiempirical model
: Laikov's parametrized "QM" model ({ref}`theory=qm_n3 <control.theory>`), used for systems of thousands of atoms.
  <!-- src: 01 §3.1, §5.9; 04 #480 -->

Parallel execution
: MPI parallelism. In practice it scales well within one node and poorly beyond it; see {doc}`running`.
  <!-- src: 04 #343, #344, #462 -->

Experienced users report that Priroda is markedly faster than general-purpose programs for routine GGA work. One
2018 comparison found it about three times faster per optimization step than ORCA 4.0 (PBE/cc-pVDZ, one core).
<!-- src: 04 #415-#417; 06 §1 -->

## Capability matrix

The table shows which `task=` values are known to work with each `theory=` value. It is assembled from example inputs,
user reports and the test runs on version 25, not from a statement by the developer.

- ✓: shown to work in an example input, a user report or a test run.
- –: not available, according to the sources.
- ?: unverified. No source shows it working or failing.

| Task | `dft` | `ridft` | `tddft` | `rimp2` | `ccsd` / `ccsd4t` | `qm_n3` |
|---|:-:|:-:|:-:|:-:|:-:|:-:|
| `energy` | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| `gradient` | ✓ | ✓ | ✓ | ✓ | ✓ (1) | ✓ |
| `hessian` | ✓ (2) | ✓ (3) | ? | ✓ (3) | ✓ (3) | ? |
| `optimize` | ✓ | ✓ | ✓ (4) | ✓ | ✓ (1) | ✓ |
| TS (`saddle=1`) | ✓ | ? | ? | ? | ? | ? |
| `irc` | ✓ | ? | ? | ? | ? | ? |
| `scan` | ✓ | ? | ? | ? | ? | ? |
| `nmr` | ✓ (5) | – | – | – | – | – |
| TDDFT excited states | – | – (6) | ✓ | – | – (7) | – |
| MD (`thermostat`) | ? | ? | ? | ? | ? | ✓ |

<!-- src: energy: 06 §3, 05 §15, 04 #158, 01 §5.4; gradient/optimize: 01 §5.1 (ridft), 06 §3 (riMP2 example), 04 #146 (CCSD), 03 §11 (tddft), 01 §5.4 (qm_n3); hessian: 05 §10, 04 #255, #291, 08 t32a, t32b; TS/IRC/scan: 06 §3, 02 §4, 03 §9, 08 t25, t26, t37; nmr: input.txt, 04 #96, 08 t34; tddft: 08 t33; qm_n3 energy: 08 t39; MD: 01 §5.7 -->
<!-- verify: the ? cells are tests/ round 7 (t65-t69) -->

Notes to the table:

1. A CCSD optimization is shown in a user input. CCSD(T) gradients are implied by the developer's 2011 note on a bug
   fix that names the CCSD(T) gradient. <!-- src: 04 #146; 03 §1 -->
2. Analytic second derivatives. <!-- src: 06 §3; 05 §10 -->
3. Computed by finite differences of the gradient (`NUMERICAL COMPUTATION OF SECOND DERIVATIVES`), which takes
   many gradient calculations. Shown for `ridft` and `rimp2` in version 25 tests; users report CCSD and CCSD(T)
   Hessians. <!-- src: 04 #255, #291; 08 t32a, t32b -->
4. Excited-state optimization works, but Priroda has no root following, so the state can switch during the
   optimization. <!-- src: 03 §11 -->
5. NMR works only with `theory=dft` and a non-hybrid functional; with `ridft`, version 25 silently computes only the
   energy. Users report that relativistic (`four=1`) NMR runs hang. <!-- src: input.txt; 04 #96; 03 §12; 08 t57a -->
6. There is no hybrid TDDFT. See {ref}`what-priroda-does-not-do`.
7. Excited states at the coupled-cluster level use a different `theory=` value, `ccsdsd` (linear-response CCSD, RHF
   only), whose status is undocumented. <!-- src: 06 §3; 03 §11 -->

The scalar-relativistic option `four=1` has been used with `dft`, `ridft` and `rimp2`. The full list of `theory=`
values, including the undocumented ones, is in {ref}`$control theory <control.theory>`.
<!-- src: 01 §5.6; 06 §3 (UO2F2 riDFT, O2 riMP2 examples); 05 §14 -->

:::{warning}
Hybrid functionals work only with `theory=ridft`. With `theory=dft`, older versions silently drop the exact
exchange, and newer versions, including version 25, stop right after printing the basis sets with no error message
in the output. With `theory=tddft`, version 25 still runs a hybrid without its exact exchange and gives wrong
energies with no warning. See {ref}`$control theory <control.theory>`.
:::
<!-- src: 03 §11; 04 #96, #99, #307-#310; 08 t08, t46 -->

(what-priroda-does-not-do)=
## What Priroda does not do

Check this list before planning a project around Priroda.

No use of point-group symmetry in older versions
: Older versions always run in C1. A symmetric starting structure stays symmetric during optimization, so a
  Hessian is needed to show whether it is a minimum. Newer outputs (v13 onwards) print a detected point group, and
  the official 2023–2025 example inputs use `sym=1` in `$molecule` and `$optimize`. These options are not documented.
  In version 25 tests, `$molecule sym=1,0.01` symmetrized the structure and `$optimize sym=1` kept the symmetry
  during the optimization; each option alone does only half of this. See {ref}`$molecule sym <molecule.sym>` and
  {ref}`$optimize symmetry <optimize.symmetry>`.
  <!-- src: 04 §0, #251, #254; 01 §4.7; 08 t15, t30a, t30b -->

No continuum solvation
: No version has a continuum solvent model. Solvent can only be included as explicit molecules.
  <!-- src: 04 #75, #76, #348, #417 -->

No D3 or other empirical dispersion correction
: The developer has declined to add one (relayed from correspondence). Users add Grimme's D3 a posteriori with the
  external `dftd3` program. The 2023–2025 functionals `LPBEVV` and `LPBEVVV` may include dispersion, but this is
  inferred from their test systems and not documented.
  <!-- src: 04 #347, #348, #417, #512; 01 §3.2 -->

No periodic systems
: Priroda handles molecules and clusters only.
  <!-- src: 04 §0, #482 -->

No dummy atoms, so no counterpoise (BSSE) correction
: Ghost centres cannot be placed in `$molecule`. For NICS, give the probe points in
  {ref}`$nmr points <nmr.points>` instead.
  <!-- src: 04 #146; input.txt -->

No hybrid TDDFT
: TDDFT is GGA only. A hybrid functional with `theory=tddft` does not give hybrid TDDFT: version 25 drops the exact
  exchange without a warning, and the energies are wrong. <!-- src: 08 t46 -->
  <!-- src: 03 §11 -->

Other gaps reported by users:

- no spin–orbit coupling, so no phosphorescence calculations; <!-- src: 03 §11 -->
- no multireference methods (CASSCF, MRCI, CASPT2) that users could get working; <!-- src: 04 #156; control.yaml theory notes -->
- no freezing of atoms in Cartesian space; only internal coordinates can be fixed
  ({ref}`$optimize fix <optimize.fix>`); <!-- src: 04 #372-#373; 03 §5 -->
- no general job chaining in one input: `task=optimize+hessian` is the only combined task, and two `task=` lines run
  only the first. <!-- src: 04 #69, #70, #145 -->

## Version history

Priroda numbers its versions with integers and prints the build date in the output banner, for example
`Priroda 13 (2013.01.10)`. Energies differ slightly between versions, so keep every calculation you compare on one
version.
<!-- src: 01 §2.4; 04 #513, #514 -->

| Version | Build dates seen | Notes |
|---|---|---|
| 2 | 2002.01.14 (v2.10) | Banner `program Priroda version 2.10`. Had `task=optimize+hessian`. |
| 4 | 2004.09.14 (v4.07) | The finite-nucleus model changed between versions 3 and 4, so pre-v4 relativistic basis sets must not be used with v4 and later. |
| 5 | — | Version described by the keyword reference on the KNC wiki. Introduced the systematic L basis sets. Hybrid RI-DFT was implemented in November 2004. |
| 6 | 2006.08.20 | Long the most widely used version: 32- and 64-bit Linux builds with MPI, and a Windows build (`p6.exe`). `optimize+hessian` was removed. Parallel Hessians use at most 2 cores. |
| 7 | — | Sent as object files for linking against a local MPI library. |
| 8 | 2008.09.05 | Built on request for a Myrinet cluster. |
| 9 | 2009–2011 | `optimize+hessian` returned. In mid-2011 the developer fixed a long-standing bug that in rare cases gave wrong gradients for MP2, MP4, CCSD, CCSD(T), CIS(2) and EOM-CCSD. |
| 10 | 2011.04.14 | Linux build `p` with a bundled `mpiexec`. |
| 11 | — | Contains the semiempirical QM model. |
| 13 | 2013.01.10, 2013.01.21, 2013.09.13 | Builds behind the example outputs on the official site. |
| 14 | 2014.01.01 | Input geometry echoed with a `<` prefix (`<$molecule`). 8060-atom QM-model run on 32 processes. |
| 15 | 2015.09.14 | Scalar-relativistic example (Pt complex). |
| 16, 17 | 2016–2018 | The Windows build runs in parallel from version 16. Version 17 runs Hessians on 4 or more cores. Around 2016 the developer removed limits on SCF memory allocation and on the system size for Hessians. |
| 23 | 2023.06.22 | Newest numbered version reported by users (2024). New functionals `LPBEVV` and `LPBEVVV`. |
| 25 | 2025.02.28 | Banner `Priroda 25 (2025.02.28)`. The version used for the test runs behind this manual. Its date matches the `p4_d` build on the official site; `p_l` is dated 2025-04-14. The 2025 example inputs use `theory=DFT_n4`. |

<!-- src: v2/v4 banners: 02 §3.3; v2/v6/v9 optimize+hessian: 04 #145, 03 §8; v3→v4 nucleus: 06 §1; v5: 06 header, §1, §3; v6: 03 §1, 04 #401; v7/v8: 03 §1; v9 bug fix: 03 §1; v10: 04 #152; v11: 02 §2.1, §5.10; v13–v15: 01 §2.4; v14 echo: 01 §10; v16/17: 04 #401, #339; v23: 04 #509, #512; v25: 08; 2025: 01 §2.2, §5.3 -->

Version numbers missing from the table (3, 12, 18–22, 24) do not appear in any source. The Russian file `Dft_ansi.txt`
describes Priroda's predecessor, which used different group names (`$coordinates`, `$SCF`, `$search`, `$force`).
Those names are not part of the current keyword list.
<!-- src: 00 (Dft_ansi.txt) --> <!-- verify -->

(how-to-cite)=
## How to cite

Priroda has no single program paper for the current version. Users cite the papers below; the first three are the
list given by the KNC wiki FAQ and repeated in the forums.

Program:

- D. N. Laikov, Yu. A. Ustynyuk. PRIRODA-04: a quantum-chemical program suite. New possibilities in the study of
  molecular systems with the application of parallel computing. *Russ. Chem. Bull., Int. Ed.* **54** (2005) 820–826.
  Russian original: *Izv. Akad. Nauk, Ser. Khim.* 2005, No. 3, 804–810. <!-- src: 06 §11; 04 #302; 01 §9 -->

Density-fitting DFT (cite for any DFT calculation):

- D. N. Laikov. Fast evaluation of density functional exchange-correlation terms using the expansion of the electron
  density in auxiliary basis sets. *Chem. Phys. Lett.* **281** (1997) 151–156. <!-- src: 06 §11; 04 #303; 01 §9 -->

L-family basis sets (`L1`, `L2`, `L11`, …):

- D. N. Laikov. A new class of atomic basis functions for accurate electronic structure calculations of molecules.
  *Chem. Phys. Lett.* **416** (2005) 116–120. <!-- src: 06 §11; 04 #303; 01 §9 -->

The `3z` basis set, which has no journal paper:

- D. N. Laikov. "Development of an economical approach to the density functional calculation of molecules and its
  application to complex chemical problems". PhD dissertation, Moscow State University, 2000 (in Russian).
  <!-- src: 06 §11; 03 §1 -->

Scalar-relativistic DFT (`four=1`):

- D. N. Laikov. An implementation of the scalar relativistic density functional theory for molecular calculations
  with Gaussian basis sets. DFT2000 Conference, Menton, France, 2000. <!-- src: 06 §11 -->

Semiempirical QM model (`theory=qm_n*`):

- D. N. Laikov. *J. Chem. Phys.* **135** (2011) 134120. <!-- src: 01 §9 (from the literature, not from the site) -->
  <!-- verify -->

For version 6, users cited the program itself as "D. N. Laikov, PRIRODA, Electronic Structure Code, Version 6, 2006".
A 2014 forum suggestion adds Laikov's home page, <http://rad.chem.msu.ru/~laikov/>, as the reference for the current
version.
<!-- src: 03 §1; 04 #302 -->

Also cite the original papers for the functional, and for the Hamiltonian and nuclear model if you use `four=1`.
{ref}`$dft functional <dft.functional>` and {ref}`$control four <control.four>` give them.
