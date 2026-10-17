# KNC wiki (wt.knc.ru) – Priroda beginner FAQ and related pages

Source: KNCWiki of the Kazan Scientific Centre RAS computing centre (KazNC RAN, "СЦКП" / "КФ МСЦ РАН"), MediaWiki at `http://wt.knc.ru/wiki/`, recovered from the Wayback Machine. All text is Russian except the Documentation page and the Tutorial, which are English. Translations below are mine; input snippets, commands, keywords and key quotes are verbatim.

Pages recovered (raw HTML and text are in `/tmp/claude-1000/-home-egor-projects-priroda/1ef56c3b-4910-42be-b3ba-954ec62c9d15/scratchpad/raw_knc/`):

| Page | Snapshot(s) | Content |
|---|---|---|
| `Priroda_для_самых_маленьких` ("Priroda for the very little ones") | 20120203160605, 20120414110759, 20120518030034, 20120622193122 (all identical in content) | The beginner FAQ (main subject of this note) |
| `Priroda_Documentation` | 20100421164530 … 20120622202410 (identical); wiki source via `?action=edit` 20100423014058 | Laikov's v5 keyword reference, mirrored, with KNC admin comments |
| `Priroda_Tutorial` | 20120203195608 | Stub for v6: only "About" and "Running Priroda" are filled in. The other 13 section headings are empty |
| `Xyz2pri` | 20080407233043 | The `xyz2pri` / `xyz2pri1` helper scripts |
| `Формат_XYZ` (XYZ format) | 20080409144858 | The XYZ/XMol format, as accepted by `xyz2pri` |
| `PBS_Scripts` | 20100315040454 | `pbspriroda5`, `pbspriroda5-mpi`, `pbspriroda6` queue-submission wrappers |
| `PBS_Tutorial`, `Interactive_PBS_Jobs`, `Linux_command_prompt`, `Документация_пользователя` (user documentation), `WT`, `BT`, `MVS-1000` | 2008–2010 | Cluster context, generic PBS, shell one-liners that use Priroda output |

Pages linked from the FAQ but **never archived** (CDX shows no captures): `Pri2xyz`, `Using_Priroda_as_an_External_program_for_Gaussian`. No page for the `lastgeo` / `lastMOL` / `lasteng` scripts ever existed. They appear only as command names in the FAQ. The Priroda citation PDFs under `/wiki/images/...` were not captured either. A CDX domain search of `knc.ru` for `[Pp]riroda` turned up nothing else.

Page history of `Priroda_Documentation`: created 30 June 2006 by users KNCSysop and Grigory, last edited 13 May 2008 by Grigory (the `$guess` section). Header: "By Dr. D.N.Laikov. [Corresponds to the version 5 of the code -- Grigory]".

---

## 1. What Priroda is (FAQ section 1.1–1.4)

- "Priroda это программа для GGA DFT вычислений, написанная Дмитрием Лайковым; в последних ее версиях появились также гибридные DFT и MP2." In English: a program for GGA DFT calculations by Dimitri Laikov. Recent versions also have hybrid DFT and MP2.
- What makes it unique, according to the FAQ: **relativistic calculations** (scalar-relativistic, four-component-based) and **basis sets for every element of the periodic table**.
- Where to get it: from the author (`http://www.physto.se/~laikov/`, the link given in 2012).
- Why use it: it is "10–50 times faster" than older-generation programs, so large molecules become feasible. The FAQ's author (KNC admin Grigory) holds a strong opinion: for routine GGA DFT optimizations, TS searches and frequency calculations "имеет смысл использовать только Priroda. Все остальное устарело" ("only Priroda makes sense; everything else is obsolete"). He also calls it "очень надежный и хорошо протестированный код с широкой пользовательской базой" ("a very reliable, well-tested code with a broad user base").
- It can also be used as an external program for Gaussian. That page is linked but was not archived.

### Version differences and basis sets (FAQ section 1.4)

- The speed comes from **resolution-of-identity (density fitting)** for both the Coulomb and the exchange-correlation integrals. Each orbital basis therefore has a matching, optimized **fitting basis**.
- "Поскольку базис должен соответствовать fitting базису, просто так изменить его нельзя." In English: because the orbital basis has to match its fitting basis, you cannot simply swap basis sets.
- Different levels of theory need different fitting bases. **Older basis files must not be used with riMP2.**
- **Point-nucleus bases must not be used with the finite-nucleus model.** The finite-nucleus model itself **changed between version 3 and versions 4+**.
- "новые систематические базисы в версии 5 достаточны для всего, и изменять их обычно незачем." In English: the new systematic basis sets of version 5 are sufficient for everything and normally need no changes. (These are the Laikov 2005 "new class of atomic basis functions", such as L1, L2, L11.)
- Basis set names in the examples: `B11`, `L2`, `L1`, `L11`, `B1`, `B2`. Basis files in the examples: `basis1.bas` (non-relativistic), `basis4.bas` / `basis4.in` (scalar-relativistic, used with `four=1`), `/usr/local/bin/basis1.bas`. Per the examples, the scheme is: `basis=` names the file, and `set=` inside `$molecule` picks a named set from that file.

## 2. Input format (FAQ section 1.5 plus Documentation "Input Summary")

- GAMESS-US style, but more flexible. Data and keywords live in **groups**. A group begins with `$group_name` and ends with `$end`. Inside a group you set `keyword=value`.
- **The order of groups and of keywords does not matter**, except for `$molecule` and `$Energy`, whose contents are ordered data.
- **Case does not matter**, except for file names (for example in `save=`), because Linux file names are case-sensitive.
- Documentation adds: it is "a kind of NAMELIST free format input". Variable names **can be abbreviated** (`mem` for `memory`; the examples also use `tol`, `conv`, `iter`, `acc`, `mult`, `val`, `disp`). Arrays can be modified element-wise, for example `$guess na(85)=86,85 $end` sets element 85 to 86 and element 86 to 85.
- Defaults "обычно очень разумны" ("usually very sensible"), so only a few keywords need changing. There are "always many undocumented features", but you should use them only after consulting the author.

### FAQ input example 1: NH3, optimization, non-relativistic, Z-matrix

```
$control task=optimize theory=DFT basis=basis1.bas four=0 $end
$grid acc=1e-8 $end
$scf conv=1e-6 iterations=100 $end
$optimize tol=1e-5 steps=100 $end
$molecule
 z-matrix
 set=B11
   7
   1    1    1.02672223
   1    1    1.02672140    2    104.150240
   1    1    1.02671372    2    104.144601   -3    104.150290
 $end
```

(The third H uses the "distance and two angles" form, with `-3` meaning angle H–N–atom3.)

### FAQ input example 2: NpO2(2+), scalar-relativistic frequencies, Cartesian

```
$control  task=hessian theory=DFT four=1 basis=basis4.bas
 print=charges+bonds save=/home/username/npo2.vec $end
$dft functional=PBE $end
$scf iterations=300 $end
$guess read=1 $end
$molecule charge=2 mult=2
  cartesian
  set=L2
   93     0.00000003  -0.00000001  -0.00000007
    8    -0.00000002   0.00000001   1.71247831
    8    -0.00000002   0.00000001  -1.71247823
$end
```

Notes: `save=` gives an absolute path for the SCF-vector file. `$guess read=1` restarts from that file. A `$control` group can span several lines.

## 3. Keyword reference (Documentation page, v5, verbatim key text)

The format specifiers (`%d` integer, `%f` real, `%s` string) are Laikov's own notation.

### Performance notes from the "Methods" section

- **GGA DFT**: the fastest methods, with analytic second derivatives. Recommended strategy: "use a GGA DFT for preliminary structure optimizations and for generating starting hessians to speed up further calculations using other more expensive methods like hybride DFT, RI-MP2 ... We highly recommend this strategy."
- Memory: "approximately 8*N*N*3 bytes for energy and gradient, and twice this amount for analytic hessian calculation, where N is the basis set dimension." Disk use is modest and grows cubically for Hessians, "up to some few gigabytes in largest cases".
- In a parallel run, most of the memory and all disk storage are on the master node. "WARNING: make sure that temporary files are written to a fast local disk, and not to a network drive."
- **Hybrid RI DFT**: implemented at the end of November 2004 and needs special auxiliary bases. The rate-limiting step is forming the exchange matrix from three-center integrals, so memory and disk settings matter.
- **RI-MP2**: `(ij|kl) ~= (ij|m) [m|n] (n|kl)`. RI-HF comes first, then MP2 energy, density matrices and CPHF. Memory scales quadratically and disk cubically, in the worst case. "It is highly IMPORTANT to use separate disk drives for each running process during parallel runs". KNC comment: "Unfortunately, for our clusters it is not possible". Scalability limit: `Nproc = min (Nat, Nocc)`. Nocc should be close to a multiple of Nproc: "if Nocc=14 then Nproc=2, 7 or 14 would be the best choice, Nproc=3 or 5 is acceptable, Nproc=6 is quite poor, and Nproc=13 a very bad choice." RAM-disks are recommended when there is only one disk per two CPUs.
- **CC/MPn**: scalable up to the number of correlated beta electrons. Memory scales cubically and disk as the 4th power. For CCSD/MP4SDQ with many virtual orbitals, the particle-particle term dominates, so more memory helps.

### `$system`

KNC comment: do **not** put this group in your input when you submit with a `pbsprirodaX` script. The script generates it from the `-mem` and `-disk` options.

```
 memory=%d    memory limit in megabytes
 disk=%d      positive: disk space in gigabytes
              negative: amount of memory in megabutes
              to use as disk emulation
 path=%s      directory path for temporary disk files.
              Colon-separated list of paths for each processor
              (optional for parallel execution) can be used,
              for example path=/tmpa:/tmpb:/tmpc:/tmpd
              ...
              **NOTE**: For all methods except GGA DFT the performance will be
              degraded terribly if more than one process read and write
              large files on the same physical drive!
              By defaul the program uses the TMPDIR environment variable,
              or the current working directory.
              **NOTE**: one should NEVER use an NFS (network file system)
              for temporary files.
```

Example from the Documentation: `$System mem=200 disk=500 $end`.

### `$control`

- `task=` takes `energy`, `gradient`, `hessian`, `optimize` (see `$optimize`), `irc`, `scan` (relaxed PES scan), `nmr` (DFT only), `dipole` ("numeric evaluation of dipole polarizabilities and their first derivatives w.r.t. nuclear coordinates").
- `theory=` takes `dft` (GGA DFT with density fitting), `ridft` (hybrid DFT with RI exact exchange), `tddft` (GGA TDDFT), `rimp2`, `hf`, `cis` (RHF/UHF), `mp2` (RHF, UHF, ROHF), `mp3`, `mp4dq`, `mp4sdq`, `mp4sdtq` (RHF), `ccd`, `ccsd` (RHF/UHF), `ccsdsd` ("linear-response CCSD for excited states, for RHF"). Other values are "undocumented".
- `state=%d,%d`: for excited-state methods, the n-th excited state whose properties are computed, and the number of states N included in the iterative solution.
- `basis=%s`: the basis-set file. "if not specified - basis set data are read from the input file".
- `four=%d`: `0` non-relativistic (default), `1` scalar-relativistic.
- `nucleus=%s`: `finite` (Gaussian nucleus, the default for four-component theory) or `point` (the default for non-relativistic theory).
- `print=%s` takes appendable options:
  - `+charges`: Hirshfeld charges (DFT).
  - `+bonds`: Mulliken populations and bond orders (SCF).
  - `+esr`: ESR parameters.
  - `+vectors`: SCF vectors.
  - `+molden`: MOLDEN input. For `task=hessian` this gives the vibrations. With `+vectors+molden` it also gives the orbitals.
- `save=%s`: the file name for saving and reading SCF vectors (see `$guess`).

### `$guess`

- `read=1`: read vectors from the `save=` file. `read=0`: extended Hückel guess.
- `mix=1`: mix HOMO and LUMO for broken-spin UHF. It is "Only sensible for unrestrichted HF (restrict=0 in $scf for singlets)". The default is `0`.
- `na(%d)=...` and `nb(%d)=...` reorder the starting alpha and beta vectors. Example: `na(25)=26,25` swaps vectors 25 and 26.

### `$dft`

- `functional=` takes:
  - `PBE` (the default GGA).
  - `mPBE` (Adamo–Barone).
  - `BLYP`.
  - `OLYP`.
  - `PBE1` (PBE0, 1/4 exact exchange; the default for `theory=riDFT`).
  - `B3LYP`, defined as `Exc = 0.2*Ex(HF) + 0.8*(0.9*Ex(B) + 0.1*Ex(S)) + 0.81*Ec(LYP) + 0.19*Ex(PW)`, with PW92 local correlation rather than VWN. Note the doc's typo: `Ex(PW)` should be `Ec(PW)`. Laikov notes that "some comercial programs use Ec(VWN) instead of Ec(PW), even though A.D. Becke himself used Ec(PW)".

### `$scf`

- `restrict=`: `1` restricted (the default for an even electron count), `0` unrestricted (the default otherwise). Restricted is "available only for few methods".
- `convergence=%f,%f`: SCF and CP-SCF thresholds. The defaults `1e-6, 1e-3` are recommended. You can loosen to 1e-5 during preliminary optimizations in difficult cases.
- `iterations=%d,%d`: iterations and microiterations.
- `procedure=`: `nr` (Newton–Raphson, quadratically convergent, the GGA DFT default) or `bfgs`. "If one procedure fails you may want to try another..."
- `d1small=`:
  - `0` (the default) discards small-component density in the quadratically-convergent SCF linear equations. This is faster, but "may fail to converge for molecules with heaviest atoms".
  - `1` includes it. This applies to scalar-relativistic pure DFT.
- `core=%d`: the number of core electrons for HF-based methods. By default it is computed from the `$atoms` table.

### `$atoms`

- `core=...`: core shells for L=0,1,2,3, per atomic number. Example: `core(280)=2,1,0,0` puts Ni 1s, 2s and 2p (10 electrons) in the core.
- `mcore=%d`: includes outer-core shells in the correlation treatment.

### `$grid`

- `accuracy=%f`: target accuracy of the xc energy per atom for the adaptive grid. The default `1e-8` is a fine grid. Use `1e-7` to speed up optimizations with tolerance <= 1e-4, and `1e-9` for very accurate work.

### `$optimize`

- `saddle=1`: TS search. `saddle=0`: minimum (default).
- `tolerance=%f,%f`: gradient and displacement thresholds in au. The default is `0.0001,0.01`. If only the first is given, the second is set to 100 times the first (recommended).
- `trust=max,min,initial`: if only max is given, min = max/16 and initial = max/4.
- `follow=%d`: the eigenvector to follow in a saddle search.
- `steps=%d`: the number of cycles (default **50**).
- `cartesian=`: `0` redundant internal coordinates (default), `1` Cartesian ("last resort").
- `back=1`: trace the IRC backwards. `0`: forwards.
- `points=%d`: the number of IRC points, or the number of constrained optimizations in a scan.
- `radius=%f`: the IRC step in mass-weighted coordinates. Adjacent points end up about 2× this far apart.
- `coordinates=` (the doc misspells it `coordinated=`): explicit redundant internals, 5 integers each:
  - `1,i,j,0,0`: distance.
  - `2,i,j,k,0`: angle.
  - `3,i,j,k,l`: torsion.
  - `4,…` and `5,…`: special coordinates for linear fragments.
- `fix=`: internal coordinates to freeze, in the same format.
- `value=`: target values for the frozen coordinates, in Å and degrees. By default they are taken from the input geometry. For `task=scan`, list all initial values followed by all final values.
- `gradient=0`: excludes gradient terms in the internal-to-Cartesian transformation at the first geometry. Use it when the Hessian came from a different method or basis.
- `print=0|1`: minimal or detailed output.

Scan example (verbatim):

```
$optimize
 fix   =1,7,9,0,0, 1,8,10,0,0, 3,8,7,9,0, 3,10,9,7,0
 val(1)=1.6,       1.7
 val(5)=2.0,       2.1
 points=5
$end
```

This runs 5 optimizations: distance 7–9 = 1.6…2.0 and distance 8–10 = 1.7…2.1, with angles 8-7-9 and 10-9-7 held at their input values. (The doc says "angles", but the fix codes are `3,…`, which by the scheme above mean torsions.)

### `$thermo`

- `sigma=%d`: the rotational symmetry number.
- `temperature=%f,...`: up to 50 temperatures in K.

### `$d2edr2` (numerical Hessian)

- `length=%f`: the step length.
- `displace=1|2`: one or two displacements per coordinate. The default is 2, which is more accurate. "in some cases you may want to increase SCF convergence to get more accurate numerical hessians."
- `steps=%d,%d`: the first and last displacement indices for this run. The default `0,-1` means all of them.

Distributed numerical Hessian, for example a 12-atom molecule with `disp=1`:

```
$d2edr2 disp=1 steps= 0, 9 $end - for file mol.in1
$d2edr2 disp=1 steps=10,18 $end - for file mol.in2
$d2edr2 disp=1 steps=19,27 $end - for file mol.in3
$d2edr2 disp=1 steps=28,36 $end - for file mol.in4
```

Run the four inputs on different machines, then collect the results:

```
grep "num>" mol.out{1,2,3,4} | sed "s/\.*num>//g" >> mol.in
```

Finally add `$d2edr2 steps=-1 $end` and run once more to assemble the Hessian. This reveals a third output-marker prefix, `num>`.

### `$nmr`

- `standard(Z)=...`: reference shieldings for chemical shifts, for example `standard(1)=31.3915` and `standard(6)=181.9921` (computed for Si(CH3)4).
- `points=x,y,z,...`: extra points in space (Å) where shielding tensors are computed (NICS-type).

### `$molecule` (ordered data)

- `charge=%d` and `mult=%d`, then the keyword `cartesian` or `z-matrix`.
- Cartesian lines: `Z x y z`, in Å, with an optional `mass=%f` for isotopes.
- Z-matrix lines: `%d %d %f %d %f %d %f mass=%f`, in four forms:
  - `q_i j r_ij  k a_ijk  l b_ijkl`: distance, angle, torsion.
  - `q_i j r_ij  k a_ijk -l a_ijl`: distance and two angles.
  - `q_i j r_ij -k r_ik   l b_ijkl`: two distances and a torsion.
  - `q_i j r_ij -k r_ik  -l r_il`: three distances.
- You can mix the two formats: the first atoms in Cartesian, the rest in Z-matrix. This is "handy for modifying stuctures".
- `set=NAME` applies to the atoms that follow it, and the name must exist in the basis file. Example:

```
$molecule
 z-matrix
 set=B2
   8
 set=B1
   1    1    0.96252725
   1    1    0.96252725    2    102.943872
$end
```

### Documentation input examples (verbatim)

O2 triplet, riMP2, relativistic optimization:

```
 $control
  task=optimize
  theory=riMP2
  basis=basis4.in
  four=1
 $end
 $optimize tol=1e-5 $end
 $molecule
  mult=3
  z-matrix
  set=L1
    8
    8    1    1.25017467
 $end
```

UO2F2, relativistic PBE0 energy, L2 basis, orbitals printed:

```
 $control
  task=energy
  theory=riDFT
  basis=basis4.in
  four=1
  print=charges+bonds+vectors+molden
 $end
 $scf iter=100 conv=1e-6 $end
 $dft functional=PBE1 $end
 $molecule
  z-matrix
  set=L2
   92
    9    1    2.06303279
    9    1    2.06303314    2    111.520778
    8    1    1.78032783    2     92.742191   -3     92.742194
    8    1    1.78032789    3     92.742132   -2     92.742273
 $end
```

Alder-ene TS, Hessian, non-relativistic, broken-spin (the 31-atom geometry is abbreviated here; the full block is in the raw file `txt/doc_edit_20100423.txt`):

```
 $control four=0 task=hessian theory=DFT basis=/usr/local/bin/basis1.bas
  print=molden $end
 $guess mix=1 $end
 $dft functional=PBE $end
 $scf iterations=300 procedure=NR restrict=0 $end
 $System mem=200 disk=500 $end
 $optimize steps=100 tol=5.0e-5 saddle=1 $end
 $molecule cartesian
  set=L11
    6     1.01645147   2.27475539  -1.17198568
    6     1.26836007   0.73274534  -1.20793578
    ...
    1    -1.26038281  -5.24826177   0.71104928
 $end
```

## 4. Output format and restart information (FAQ section 1.6)

- The idea is the same as GAMESS-US: results are written as **groups of formatted text**, which the user cuts out and pastes into a new input. Unlike GAMESS, they go into the **main output file** rather than a separate punch file, and each line is tagged with a **prefix marker**. That makes post-processing scripts simple.
- Known prefixes:
  - `MOL>`: geometry.
  - `eng>`: the `$Energy` group.
  - `freq>`: vibrations in MOLDEN format, from the Linux page.
  - `num>`: partial numerical-Hessian data, from the Documentation.

Final optimized geometry fragment (verbatim):

```
 [....skip....]
   9  -0.000000 100.000000   0.000000 
 Max. Displacement = 0.0000040
    
 OPTIMIZATION CONVERGED in 4 steps!
MOL>$molecule
MOL> charge=2 mult=2
MOL> cartesian
MOL> set=L2
MOL>  93     0.00000003  -0.00000001  -0.00000007
MOL>   8    -0.00000002   0.00000001   1.71247831
MOL>   8    -0.00000002   0.00000001  -1.71247823
MOL>$end
MOL> Energy = -28944.57077327 

 ============================================================
 [....skip....]
```

`$Energy` group: E, dipole (`D=`), gradient (`G=`), and the Hessian if `task=hessian` was run (verbatim):

```
[....skip....]
 time: Coulomb-type Gradient            :    57.9 ( 99.9%)
 time: Ex. - Corr.  Gradient            :     5.6 (100.0%)
 
eng>$Energy
eng> E=-2.894457077327e+04
eng> D= 0.00000000e+00  0.00000000e+00  0.00000000e+00
eng> G= 3.53877831e-09  1.65504544e-08 -3.64771621e-07
eng>   -1.31128901e-07 -6.73350427e-09 -2.19780956e-06
eng>    1.27590122e-07 -9.81695012e-09  2.56258122e-06
eng>$end

 G(max) = 0.00000256
 [....skip....]
```

"Очевидно, что нужно вырезать из файла все строки начинающиеся на MOL> и eng>, и освободится от самих символов MOL> и eng>; после чего получатся группы, пригодные для файла ввода Priroda." In English: take all lines starting with `MOL>` / `eng>`, strip the prefix, and you get groups ready for a Priroda input. Pasting `$Energy` into the input gives the optimizer a starting Hessian (see the workflow below).

Also visible in the output:
- `OPTIMIZATION CONVERGED in N steps!`
- `Max. Displacement = ...`
- `G(max) = ...`
- per-step timing lines such as `time: Coulomb-type Gradient`

Other strings the FAQ tells you to search for: `Normal Mode` (start of the frequency table) and `ZPVE` (thermochemistry block).

Tutorial (v6), on files: Priroda uses an input file, an output file, a vectors file, and temporary integral files. "Human-readable results and restart information goes to the output file. There is an option to store converged SCF orbitals to a binary vectors file for subsequent restart. The only thing to worry about temporary files is free disk space; they are deleted by Priroda right after the end of calculations."

## 5. Beginner workflow: optimize, then verify a minimum (FAQ section 2, full translation)

The task is to minimize the energy of a molecule.

1. Prepare its coordinates in **XYZ format**. The correct XYZ format is "the one MOLDEN reads".
2. Turn the XYZ file into a file containing a `$molecule` group with the **`xyz2pri`** script.
3. Append the groups with the keywords you need. You can keep them ready in a file such as `header.txt` and glue it on each time with `cat` and output redirection. The first run is usually `task=optimize`.
4. Check the file and set the correct `charge=` and `multiplicity=` (`mult=`). Set `set=` if needed.
5. Submit the job to the queue with **`pbspriroda6`**.
6. When you have the output file, search it for **`OPTIMIZATION CONVERGED`**.
7. If it is **not** found, extract the last geometry from the output with **`lastgeo`**, append it to the input, and delete the old `$molecule` group from the input. Go back to step 4.
8. If it **is** found, extract the final geometry with **`lastMOL`**, append it to the input, and delete the old `$molecule` group.
9. Change `task=optimize` to **`task=hessian`** in the input.
10. Submit with `pbspriroda6`.
11. In the output, search for **`Normal Mode`**.
12. The normal-mode frequencies follow that line. Check that **all are positive**.
13. If some are not, extract the last `$Energy` group with **`lasteng`** and append it to the input, which supplies the Hessian. Change `task=hessian` back to `task=optimize` and go back to step 5.
14. If they are all positive, you have a minimum ("Ура!"). Search the file for **`ZPVE`**: next to it are the electronic energy, entropy, and the enthalpy and free-energy corrections. Convert the last geometry to XYZ for viewing in MOLDEN with **`pri2xyz`**. "Писать статьи, защищать диссертации, получать гранты и премии." ("Write papers, defend theses, win grants and prizes.")

The same text in compact form:

```
xyz → xyz2pri → +header.txt (task=optimize) → set charge/mult/set= → pbspriroda6
  → grep "OPTIMIZATION CONVERGED"
      no  → lastgeo >> input, delete old $molecule, resubmit
      yes → lastMOL >> input, delete old $molecule, task=hessian, pbspriroda6
            → grep "Normal Mode": all freqs > 0 ?
                no  → lasteng >> input ($Energy with Hessian), task=optimize, resubmit
                yes → minimum; read thermochemistry near "ZPVE"; pri2xyz → MOLDEN
```

## 6. Helper scripts (KNC site-local tools)

| Script | Purpose | Status of documentation |
|---|---|---|
| `xyz2pri file.xyz file.inp` | XYZ to `$molecule` group | Documented (below) |
| `xyz2pri1 file.xyz file.inp set_name` | Same, but adds `set=set_name` for all atoms | Documented |
| `lastgeo` | Extracts the last (unconverged) geometry from the output | Name only; arguments unknown |
| `lastMOL` | Extracts the final converged `MOL>` geometry | Name only |
| `lasteng` | Extracts the last `$Energy` group (E, gradient, Hessian) | Name only |
| `pri2xyz` | Priroda geometry to XYZ for MOLDEN | Page linked but never archived |
| `pbspriroda5`, `pbspriroda5-mpi`, `pbspriroda6` | PBS submission wrappers | Documented (section 7) |

`xyz2pri` notes (verbatim usage):

```
xyz2pri  имя_файла_xyz имя_файла_inp
xyz2pri1  имя_файла_xyz имя_файла_inp имя_seta
```

(The Russian placeholders mean xyz_file_name, inp_file_name and set_name.)

- The script is "primitive". It sets charge 0 and multiplicity 1 by default, and leaves the `set=` keywords to the user.
- Caveat (KNCSysop, 13 July 2006, "to be fixed"): **lone pairs** in the XYZ file become lines without an atomic number and must be deleted by hand.

XYZ ("XMol") format as accepted, from the `Формат_XYZ` page:
- line 1: the number of atoms NA (integer)
- line 2: a title (string)
- then NA lines of `Symbol X Y Z`

Example from that page (truncated here):

```
  18 
 uo2aq5.1.out 
 O  0.01346071 -0.04536106 -1.77771885 
 U  -0.01652392 -0.00972355 -0.00194565 
 ...
 H  -1.57872158 -2.52960136 -1.02508914
```

Batch-convert every `.xyz` file in a directory and append `header.txt`, from the `Linux_command_prompt` page (verbatim):

```bash
 #!/bin/bash
 
 declare -a list
 
 list=(` ls *.xyz `)
 
 for i in ${list[*]}
 do
   j=(` basename $i .xyz `)
   xyz2pri $i $j.inp
   echo "  " >>  $j.inp
   cat header.txt >> $j.inp
 done
```

Hand-rolled equivalents of the missing scripts follow from the marker scheme. These are **my reconstructions**, not wiki text:

```bash
# last geometry (like lastMOL/lastgeo): last $molecule block tagged MOL>
grep '^MOL>' job.out | sed 's/^MOL>//' | awk '/\$molecule/{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}' | grep -v 'Energy ='
# last $Energy group (like lasteng)
grep '^eng>' job.out | sed 's/^eng>//' | awk '/\$Energy/{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}'
```

## 7. Running: stand-alone, on PBS, and in parallel

### Stand-alone (Tutorial, v6)

```
p6 input_file_name output_file_name
```

(The v6 binary is called `p6` on that system. "Within HPC cluster environment you should use a proper script for your batch queue system".)

### KNC PBS wrappers (`PBS_Scripts` page)

Common rules for all wrappers:

- **`file_name`** (required): the input file. Use Latin characters only, the first character must be a letter, and case matters.
- **`-time hh:mm:ss`**: requested walltime, for example `-time 73:00:00`.
- **`-queue queue`**: the target queue. `qstat -q` lists the queues; the default is usually `short`. Give both `-time` and `-queue` for long jobs, or the job may be killed before it finishes.
- **`-mem memory_size`**: in MB. A cluster-specific default is preset; change it only after consulting the admins.

Priroda v5, serial:

```
pbspriroda5 file_name [-time time] [-queue queue] [-mem memory_size] [-disk disk_size] [-procs num_nodes]
```

- `-disk disk_size`: a positive integer means GB of local scratch disk. A negative number means "the program will create a RAM-disk of that many MB". This mirrors `$system disk=`.
- `-procs`: the default is 1. Other values are pointless for the serial build.

Priroda v5, parallel (SMP within one node):

```
pbspriroda5-mpi file_name [-time time] [-queue queue] [-mem memory_size] [-disk disk_size] [-procs 1:ppn=2]
```

- `-procs 1:ppn=2` means two processors on one node.
- The special high-priority "parallel" queues require at least two nodes, "so there is no point submitting the SMP-parallel Priroda there".

Priroda v6:

```
pbspriroda6 file_name [-time time] [-queue queue] [-mem memory_size] [-disk disk_size] [-procs 1:ppn=2]
```

- "Поскольку в наличии есть только вариант SMP-параллельной Природы 6, то указание параметра [-procs 1:ppn=2] (либо [-procs 1:ppn=1] или [-procs 1:ppn=4]) обязательно." In English: only the SMP-parallel build of v6 exists, so `-procs 1:ppn=N` (N = 1, 2 or 4) is **mandatory**.
- The same remark applies about the parallel queues.

When using a wrapper, **omit `$system`**: the wrapper generates it from `-mem` and `-disk` (KNC comment on the Documentation page).

### Generic PBS knowledge relevant to writing your own Priroda job script (`PBS_Tutorial`)

- Put resource requests on `#PBS` lines in the script, or pass them to `qsub -l`:
  - `qsub -l nodes=1:ppn=1,mem=100mb,walltime=1:30:00 -q short sleep.job`
  - inside the script: `#PBS -q`, `#PBS -l nodes=..:ppn=..,mem=..,walltime=..`, `#PBS -S /bin/bash`, `#PBS -o`, `#PBS -e`, `#PBS -N`, `#PBS -m be`, `#PBS -r n`
- Parallel jobs must read the node list from **`$PBS_NODEFILE`**.
- Large temporary files must go to **`/store/$USER/$PBS_JOBID`** on the node's local disk. PBS creates it before the job starts and deletes it afterwards.
- Never use `/home` for scratch: it is NFS. This matches Laikov's "NEVER use an NFS ... for temporary files", so set `TMPDIR` or `$system path=` to the local scratch directory.
- MPI programs are launched with `mpiexec` (OSC, through the PBS API), for example `/common/bin/mpiexec -kill -nostdout -nostdin -comm p4 prog`, or with MPICH `mpirun -machinefile $PBS_NODEFILE -np 4 prog`.
- Job management:
  - `qstat -a`: status R = running, Q = queued, H = held.
  - `qstat -q`: queue limits. On WT in 2010: `short` 36 h, `long` 144 h, `parallel` 144 h, `workq`.
  - `qdel JobID`, `qhold JobID`, `qrls JobID`, `qalter`.
- Interactive session for quick input checks or for running MOLDEN: `qsub -I -l nodes=1:ppn=2,walltime=8:00:00`.

### Cluster context (2006–2012)

| Cluster | Nodes | CPUs | Memory | Interconnect | Notes |
|---|---|---|---|---|---|
| WT | 4 dual-CPU | Intel Xeon 2.6/2.8 GHz | 1 GB/node | Gigabit Ethernet | 80 GB local disks; 32-bit IA32 software |
| BT | 9 dual-CPU | Opteron 2 GHz, some dual-core | 1–16 GB | Gigabit Ethernet | CentOS 4.6, OSCAR 5.0; Intel Fortran recommended |
| MVS-1000 (KazNC) | 64 UP2000 nodes | DEC Alpha 667 MHz | 2 GB/node | Myrinet | Very slow disks; later decommissioned |

These numbers explain the `-disk` RAM-disk option and the warnings about memory and disk.

## 8. Extracting results

- **Energy**: the `MOL> Energy = ...` line after the final geometry, or `eng> E=` in `$Energy`.
- **Convergence check**: `grep "OPTIMIZATION CONVERGED"`.
- **Final geometry**: the last `MOL>` block. Use `lastMOL`/`lastgeo` (KNC) or strip the prefix by hand.
- **Gradient and Hessian**: the `$Energy` group (`eng>`), with lines `E=`, `D=` (dipole) and `G=` (gradient); after `task=hessian` it also contains the Hessian. It is reusable as a starting Hessian for the optimizer.
- **Frequencies**: after the `Normal Mode` line. All must be positive for a minimum. A TS (`saddle=1`) should have exactly one imaginary frequency; that is standard practice and not stated in the FAQ.
- **Thermochemistry**: near the `ZPVE` line, which gives the electronic energy, entropy, and enthalpy and free-energy corrections. Control it with `$thermo sigma= temperature=`.
- **Charges and bond orders**: `print=charges+bonds` (Hirshfeld charges for DFT, Mulliken populations and bond orders for SCF).
- **Numerical Hessian pieces**: `num>` lines (section 3, `$d2edr2`).

## 9. Visualization

- MOLDEN is the reference viewer. "The correct XYZ format is the one MOLDEN reads."
- Geometry to XYZ: `pri2xyz` (KNC script), then open the file in MOLDEN.
- Vibrations: run `task=hessian` with `print=molden`, then pull out the `freq>` lines (from the `Linux_command_prompt` page, verbatim):

```
cat priroda.out | grep "freq>" | sed s/"freq"//g > priroda.molf
```

  Note that this sed removes only the word `freq` and leaves a leading `>` on each line. Laikov's own `num>` recipe uses `sed "s/\.*num>//g"`, which removes the whole marker; `sed 's/^freq>//'` is the clean version.
- Orbitals: `print=vectors+molden` (Documentation: "if +vectors+molden is specified, than the scf orbitals are also prepared for visualization using MOLDEN").
- Run graphical programs such as MOLDEN in an interactive PBS session (`qsub -I`), not on the login node.

## 10. Common problems and fixes (gathered from all pages)

| Problem | Fix (source) |
|---|---|
| Optimization not converged in `steps` (default 50) | Restart from the last geometry (`lastgeo`) and resubmit (FAQ). Raise `steps=` (examples use 100). Paste a `$Energy` Hessian. Use `$optimize cartesian=1` only as a last resort (Doc) |
| Imaginary frequencies after "converged" optimization | Paste `$Energy` from the Hessian run (`lasteng`), switch back to `task=optimize`, re-optimize, then re-run the Hessian (FAQ) |
| SCF does not converge | Raise `$scf iterations=` (examples: 100, 300). Switch `procedure=nr` / `bfgs`. For heavy elements, scalar-relativistic, try `d1small=1`. Restart from saved vectors with `save=` plus `$guess read=1`. Reorder orbitals with `na()` / `nb()` (Doc) |
| Open-shell singlet / diradical TS | `$scf restrict=0` plus `$guess mix=1` (broken-spin UHF; Alder-ene example) |
| Slow preliminary optimizations | `$scf conv=1e-5` and `$grid acc=1e-7` (with tolerance <= 1e-4); refine later (Doc) |
| Wrong basis/fitting combination | Do not mix old bases with riMP2. Do not use point-nucleus bases with the finite-nucleus model (`four=1` defaults to `nucleus=finite`). Do not use pre-v4 relativistic bases with v4+. Use the v5 systematic bases (FAQ) |
| `set=` name error | The name must exist in the `basis=` file (Doc) |
| Wrong charge/multiplicity after `xyz2pri` | The script always writes charge 0, mult 1; edit by hand (Xyz2pri) |
| Garbage lines from `xyz2pri` | Lone-pair pseudo-atoms in the XYZ file; delete them (Xyz2pri) |
| File not found | File names are case-sensitive, unlike keywords. Job file names must use Latin letters and start with a letter (FAQ, PBS_Scripts) |
| Very slow I/O, especially RI-MP2/CC in parallel | Never use NFS (`/home`) for scratch. Use a local disk (`/store/$USER/$PBS_JOBID`), give each process its own physical disk via `path=a:b:c`, or use a RAM-disk (`disk=-MB`, `-disk -MB`) (Doc, PBS_Tutorial) |
| Job killed before finishing | Give both `-time` and `-queue`; the default `short` queue is 36 h (PBS_Scripts, PBS_Tutorial) |
| `pbspriroda6` refuses or misbehaves | `-procs 1:ppn=N` is mandatory for v6. Do not submit SMP Priroda to the multi-node "parallel" queues (PBS_Scripts) |
| Conflicting memory settings | Do not put `$system` in the input when using `pbspriroda*`; use `-mem` and `-disk` instead (Doc comment) |
| Poor RI-MP2 parallel scaling | Choose Nproc as a divisor of Nocc, with Nproc <= min(Nat, Nocc) (Doc) |

## 11. Citation list recommended by the FAQ (verbatim bibliographic data)

1. Laikov D.N. Fast evaluation of density functional exchange-correlation terms using the expansion of the electron density in auxiliary basis sets. // Chem. Phys. Lett., 1997, 281, pp.151-156.
2. Laikov D.N. PhD dissertation, Moscow State University, 2000 (Д.Н.Лайков. Развитие экономного подхода к расчету молекул методом функционала плотности, его применение к решению сложных химических задач. Диссертация на соискание ст. к.ф.-м.н., МГУ, 2000).
3. Laikov D.N., Ustynyuk Yu.A., PRIRODA-04: a quantum-chemical program suite. New possible in the study of molecular systems with the application of parallel computing. // Russ. Chem. Bull., Int. Ed., 2005, V. 54, №3, pp.820-826. (Russian original: Известия академии наук, Серия химическая, 2005, №3, 804-810.)
4. Laikov, D.N. A new class of atomic basis functions for accurate electronic structure calculations of molecules // Chem. Phys. Lett. 2005, 416, pp.116-120.
5. Laikov, D. N. "An implementation of the scalar relativistic density functional theory for molecular calculations with Gaussian basis sets"; DFT2000 Conference, 2000, Menton, France.

(The wiki hosted PDFs of items 1–4 and the dissertation, taken from qchem.ru. They were not captured by the archive.)

## 12. Takeaways for the manual

- The FAQ's workflow, cycling between optimize and Hessian with `$Energy` carried forward as the Hessian, is the canonical beginner procedure. It is worth reproducing with generic scripts in place of the KNC-only `lastgeo`, `lastMOL`, `lasteng` and `pri2xyz`.
- The output markers to document: `MOL>`, `eng>`, `freq>` and `num>`, plus the search strings `OPTIMIZATION CONVERGED`, `Normal Mode`, `ZPVE` and `G(max)`.
- The Documentation mirror is Laikov's v5 keyword text. It is the most complete keyword list found on this site. Version 6 differences are not documented here: the Tutorial is a stub giving only `p6 input output`.
- Uncertain or unverified: the arguments of the KNC helper scripts, the exact format of the `Normal Mode` and `ZPVE` blocks (not shown in any captured page), and whether `basis4.bas` and `basis4.in` are the same file under two names.
