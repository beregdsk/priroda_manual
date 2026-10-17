# qchem.ru forum thread "Квантовохимическая программа ПРИРОДА": extracted technical notes

## Source and coverage

- Thread: "Форум уфимского квантовохимического общества" (Ufa Quantum Chemistry Society, UQCS) > Программное и аппаратное обеспечение > Квантовохимические программы > "Квантовохимическая программа ПРИРОДА". Started by **Evgeniy**, 18 Nov 2007. Live URL `http://www.qchem.ru/f/kvantovo-khimicheskie-programmy/kvantovo-khimicheskaya-programma-priroda/`. The site returns 404 since about 2019.
- Archived copies used (Wayback Machine, `id_` raw captures):
  - `?action=printpage` capture **20120307082639**. This is the whole thread on one page: posts #0 to #205, 18 Nov 2007 to 04 Mar 2012.
  - Paginated pages (15 posts per page, offsets `/15`, `/30`, ... `/195`). The last archived page is `/195` (capture 20130604044201), which holds posts #195 to #209. Posts #206 to #209 (Mar to Aug 2012) come only from that page.
  - Page 1 captures 20120624114908 and 20140410032431 were compared. The first post is identical in both and in the printpage.
- **Gap:** by April 2014 the thread had **15 pages** ("Страниц: [1] 2 3 ... 15", read 90 058 times). Page 15 (`/210`, posts #210 onward, after Aug 2012) was **never archived**. The CDX API and `/web/2014/` lookups for `/210/` and `index.php?topic=…` forms all return nothing. Everything up to post #209 is covered.
- Raw files (untrusted, not executed) are in `/tmp/claude-1000/-home-egor-projects-priroda/1ef56c3b-4910-42be-b3ba-954ec62c9d15/scratchpad/raw_qchemru/`: `printpage_20120307.html`, `p000…p195_*.html`, `cdx.json`. Text dumps: `pp2.txt` (compact) and `pp_keep.txt` (indentation kept).
- Related qchem.ru threads seen in CDX that may be worth harvesting separately:
  - `kvantovo-khimicheskie-priblizheniya/lyambda-bazisy-(priroda-06)/` (Lambda basis sets in Priroda 06)
  - `.../priroda-pochemu-to-ne-khodit-na-koupled-klaster/` ("Priroda won't run coupled cluster")
  - `kvantovo-khimicheskie-programmy/vizualizatsiya-prirod'nykh-orbitaley/` (orbital visualisation)
  - `vizualizatsiya-i-animatsiya-reaktsiy/vizualizatory-kvantovo-khimicheskikh-raschetov/msg957`
  - Practicum pages `http://www.qchem.ru/practice/priroda/conf/` (NH2-OH conformational analysis with full input examples; cited several times as *the* TS-search tutorial) and `/practice/priroda/orbitals/`.

### Who is who (for judging how far to trust each tip)

- **D. N. Laikov never posts in the thread.** Everything attributed to him is second-hand: quotes from his e-mails relayed by *sanya* or *Evgeniy*. Those quotes are the most authoritative material here and are marked **[Laikov, relayed]**.
- **Evgeniy**: forum admin (UQCS, "Старожил", 315 posts), the most active poster (60 posts here). He has had builds compiled by Laikov (v7 objects, v8 for a Myrinet cluster). He co-authored the PBE/3z GIAO NMR statistics paper (JCC 2011, 32, 1993). He is very likely E. Yu. Pankratyev; this is inferred, his surname was moderated out. He is a reliable experienced user, not the developer.
- **amg**: 44 posts. He runs the LIMOR NIOCH SB RAS (Novosibirsk) Priroda page and wrote the helper scripts at `limor1.nioch.nsc.ru/quant/program/` (`pri`, `priin`, `pri2mol`, `addXX`, `xyz2jmod`, `priIR`, `molgeom`, `xyz2inp`). He is a very experienced user and careful with claims.
- **sanya**: female, 22 posts. She corresponds with Laikov directly ("общалась с Димой Лайковым на эту тему много раз"), uses v8 and v9 cluster builds, and is strong on TDDFT and excited states. Her statements are often based on Laikov's statements.
- Others (Marsel, denis, Dimylko, GemmaNC, Chai, Llewule, thegriglat, oxchem, STARWAR82, etc.) are mostly askers. thegriglat and oxchem contribute some tips.

---

## 1. Program facts, versions, distribution

From the first post by Evgeniy (18 Nov 2007, later edited; content as of 2012):

- Author: Дмитрий Лайков (dimitri_laikov(at)mail.ru). Free licence. OS: Linux and Windows ("используется cygwin.dll"). Main methods: DFT, MP, CC.
- "Последняя известная версия: 06 (32- и 64-битные версии с использованием MPI от 2006.08.20); также существуют версии 07, 08, 09." No public download page ("свободное распространение отсутствует").
- Description: "Одна из самых быстрых и малотребовательных квантовохимических программ для DFT-расчётов."
- Version banners seen in outputs:
  - `Priroda 6 (2006.08.20)` / `copyright (c) Dimitri Laikov`
  - `Priroda 8 (2008.09.05)` / `copyright (c) D.N. Laikov`
- Binary names seen: `p6.exe` (Windows, cygwin), `p6_32` and `p6_64` (Linux), `p6` (cluster).
- Version history (Evgeniy, 14 Oct 2008 and 22 May 2009):
  - v8 was built by Laikov on request for an AMD64/Linux/mpich(Myrinet) cluster ("он быстро откликнулся и всё сделал").
  - v7 was sent as **unlinked object files** "которые можно линковать с разными mpich, и в идеале под разные ОС, вроде FreeBSD". Evgeniy linked v7 against InfiniBand/MVAPICH himself.
  - No new documentation came with v7, v8 or v9. Output looks like v6 apart from the two header lines. Evgeniy suspects the changes were mostly parallelisation improvements. Parallel capability "была заложена уже в 6-й версии".
- v9 (amg, 29 May 2009; again no documentation): a "добрый человек" sent it. New or re-enabled `task=` words are listed in §4.
- **[Laikov, relayed by sanya, 02 Jun 2011]** v9 bug fix, from his letter: "На прошлой неделе я нашёл и исправил ошибку, существовавшую уже лет 10, которая _в_редких_случаях_ приводила к неверным градиентам в методах MP2, MP4, CCSD, CCSD(T), CIS(2), EOM-CCSD." So **gradients from those methods in versions before mid-2011 can be wrong in rare cases.**
- sanya (30 Jun 2010) said Laikov was "подумывал включить LC-функционалы" (long-range-corrected functionals) in v9. This is unconfirmed.
- Contact and availability:
  - Write to the author. E-mails given: `laikov (at) physto (dot) se` (Evgeniy, Oct 2008) and `dimitri_laikov(at)mail.ru` (sanya 2010, Evgeniy 2011).
  - Laikov's personal site `http://www.physto.se/~laikov/` was empty by June 2010. Laikov had been in Moscow for several years by then (sanya).
- Legal status (Evgeniy, 17 Oct 2011, quoting slides):
  ```
  Правовой статус PRIRODA
  PRIRODA зарегистрирована в Роспатенте, автор – Д.Н.Лайков
  PRIRODA распространяется через компанию ООО Димонта: vs@dimonta.com
  ```
  amg found that the director of ООО «ДИМОНТА» is В. Б. Сулимов (NIVC MSU). The slides are at `limor1.nioch.nsc.ru/file/tmp/Sulimov_2009_10_30_corr.pdf`.
- References listed in post #0:
  - Laikov, CPL 281, 151 (1997): RI/auxiliary-basis expansion of the density for XC.
  - Laikov and Ustynyuk, Russ. Chem. Bull. 54, 820 (2005): PRIRODA-04.
  - PBE, PRL 77, 3865 (1996).
  - Laikov PhD thesis, MSU 2000: reference for the **3z** basis.
  - Laikov, CPL 416, 116 (2005): **Lambda (L) basis sets**.
  - "D.N. Laikov, PRIRODA, Electronic Structure Code, Version 6, 2006": citation for v6 ("отдельной статьи не было").
  - Pankratyev, Tulyabaev, Khalilov, JCC 32, 1993 (2011), DOI 10.1002/jcc.21786: GIAO PBE/3z NMR statistics and empirical corrections.
  - Беляков and Анаников, Изв. АН Сер. хим. 2011, №5, 765: Priroda GIAO-PBE/3z vs Gaussian B3LYP/6-311G(2d,p) shifts.
- Other documentation sites named: `http://wt.knc.ru/wiki/index.php/Priroda_Documentation` (СЦКП КазНЦ РАН) and `http://limor1.nioch.nsc.ru/priroda.html` (ЛИМОР НИОХ).

## 2. Installation and running

### Windows (cygwin build)
- **The scratch path must be set on Windows** (post #0, Evgeniy):
  - "а) Для указания текущей директории нужно установить `path=.` в группе `$system`."
  - "б) … либо задать её в виде `path=/cygdrive/c/temp` (… c:\temp), либо установить переменную окружения `TMPDIR` командой `set TMPDIR="c:\temp"`".
  - Symptom when it is missing (GemmaNC, 19 Apr 2009): the output stops at
    ```
    System options:
    Memory: 128 (128) MB
    Disk:   1 GB '/tmp'

    0: opening file /tmp/tmp2792.0
    ```
    Fix (Evgeniy): `$system path=. $end`.
- Command line: `C:\Priroda\p6.exe HOHOH_s.rimp2.b1.in HOHOH_s.rimp2.b1.in.out`, that is `p6.exe input output`.
- **The input file must have Unix line endings (LF, not CRLF)** (amg, 20 Apr 2010; forum msg822):
  - Convert with Notepad++. In Notepad such files look like one long line.
  - Evgeniy: "В Windows мы используем скрипт для запуска ПРИРОДы, в котором автоматически вызываем dos2unix.exe". In Far Manager press Shift-F2 when opening the .in file to pick the encoding.
  - amg's `priin` generator was patched to write `open (IN, ">:unix", $in)`.
  - Symptom (Dimylko, Nov 2011): the output ends with `molecule input: ''` followed by `'z-matrix' ?`. The same z-matrix worked in PC GAMESS. amg pointed to the line-ending issue, and Dimylko then reported "разобрался, все заработало".
- amg (Nov 2011): "не нужно кириллицы, пробелов и т.п. в названии компа, директорий и файлов". Dimylko's host was `'Сергей-ПК'`.
- Default resources when `$system` has no memory or disk keywords (from outputs): `Memory: 128 (128) MB`, `Disk:   1 GB '/tmp'`.

### Linux / SMP
- Two kinds of distribution (Evgeniy, 16 Sep 2010):
  - "дистрибутив кластерный - запускается командой `mpirun -n ./p6`"
  - "обычный дистрибутив `./p6 -n`" (built-in shared-memory MPICH)
- Invocations seen:
  ```
  screen
  ./p6_64 -np 7 ../in/job.in | tee ../job.out &
  screen -d
  ```
  ```
  screen
  ./p6_64 ../in/job.in ../job.out  -np 7 &
  screen -d
  ```
  (Chai, Sep 2010.) The output can go to stdout or to a second file argument. `-np N` can come after the file names.
- The header of a parallel run looks like this (v8 on 4 nodes × 2 cores):
  ```
  Priroda 8 (2008.09.05)
  copyright (c) D.N. Laikov

  date: Mon Oct 13 04:41:09 2008

  parallel on  8 processors
  node  0: 'cluster.uimech.org'
  node  1: 'node-2'
  ...
  node  7: 'node-5'

  Memory: 256m (256m) + 768m
  ```
- **Basis file quoting.** `basis="3z.bas"` with *double* quotes is correct. With two single quotes (`basis=''3z.bas''`) the run dies with `error opening file ''3z.bas''` (denis, Sep 2010; fix by Evgeniy: "две одинарные кавычки '', а должна быть одна двойная "."). sanya suggested giving the full path without quotes. amg's example uses an unquoted absolute path: `basis=/usr/local/lib/priroda/basis/L1`.
- UPX-compressed binary (thegriglat, 08 Mar 2012): `p6.exe` 6 872 kB became `p6_upx.exe` 1 984 kB. CPU time was unchanged, REAL time was lower, and no errors were seen. This is a single anecdote.

## 3. Parallel / MPI

- Single machine: shared-memory MPICH (Evgeniy, Apr 2008). "На единичном компьютере параллелится на ура (проверено на 4 ядрах)" (SeriousSem).
- **Per-process limits.** `disk=` in `$system` applies **per process**. "если указать disk=10 и запустить ПРИРОДУ на 4-х ядрах, то может быть занято до 40 ГБ" (Evgeniy, 28 Aug 2008). `memory=` is also per process. moriand: "если всего 4Гб памяти, и 4 ядра и желание выделить например только 2Гб, пишем memory=512 (512х4=2Гб). Так оно и работает".
- v6 core-count caveats (Evgeniy; experience-based, partly disputed):
  - Hessian (frequency) runs on 4 cores can **hang** at the step `"Solving for responses ..."`. Use at most 2 cores. Repeated in Sep 2010: "Если гессиан (DFT), то он максимум 2 процессорных ядра позволяет использовать, если оптимизация (DFT), то оно бывает зависает и на четырёх. Малые задачи MP2 на большом числе ядер вылетают."
  - Counterpoint from sanya (Jun 2011): "у меня DFT совершенно нормально работало на 24-32 ядрах на кластере, в т.ч. гессиан… А CCSD действительно больше чем на 1 ноде (8 ядер) зависало. Но, возможно, дело не в процессорах, а в использовании диска."
  - Evgeniy clarified that his remarks were about v6. With v7 on Myrinet2k, "при распараллеливании DFT задач оперативная память потреблялась по большей части первым узлом… а скорость решения задачи даже уменьшалась по сравнению с одним узлом". Rule of thumb: "Малые задачи на большом числе процессоров зависают."
- v7 built with MVAPICH: **MP2 on a 102-atom / 416-electron complex hangs with signal 8 (arithmetic error) when using more than about 24 cores**. It runs fine on fewer cores (Evgeniy, May 2009).
- **Results can depend on the number of cores** (amg, Nov 2008). The same TS optimisation followed different paths with `p6_64` on different `-np`, and with `-np 4` it did not converge. amg's caveat: this was an unstable TS search from a poor guess; normally results differ only in insignificant digits. His input and plot were at `limor1.nioch.nsc.ru/file/Priroda/pritext.in` and `.pdf`.
- Throughput tip (amg, May 2009, 4-core box): on jobs not limited by disk, "4 одновременных расчета на 1 ядре каждый проходят на 30% быстрее, чем последовательные расчеты на 4-х ядрах каждый". He settled on 2 jobs × 2 cores (about 10% slowdown).
- **v8 cluster benchmarks** (Evgeniy, 13–15 Oct 2008, mpich/Myrinet, 4 nodes × 2 cores):
  - RI-MP2/L1 energy, Zr,Al,Cl,C14,H22:

    | Setup | Wall time | Note |
    |---|---|---|
    | (1) 2 cores, 1 node, temp files on disk | 72 min | |
    | (2) 8 cores, direct SCF, disk temp files | 86 min | |
    | (3) 8 cores, temp files in node RAM | **12.4 min**, 6× faster | |
    | (4) 8 cores, direct SCF + RAM temp files | 82.5 min | |

    Conclusion: spreading over nodes spreads memory evenly. The big win comes when the scratch data fit in RAM. Direct SCF halves disk use but costs speed.
  - DFT PBE/3z **optimisation**, Zr2Al3Cl2C44H79: no speed-up (even slower). RAM barely distributed. **All disk usage stays on node 0.**
  - DFT PBE/3z **hessian**, ZrCl2C10H10: 2-fold speed-up for a 4-fold increase in cores (298 s → 144 s).
- Output footer statistics, useful for profiling:
  ```
  Memory used =   321 486 KB
  Disk  used =  1 359 076 KB,       5 615 611 KB written,     61 805 158 KB read
  Message passing statistics:
  node     sent KB   # msg    time          received      time
  0     6502965   20443    14.8     6331083   23370   183.3
  CPU  time = 2170.81 sec = 36.18 min = 0.60 hr =   50.01%
  REAL time = 4340.58 sec = 72.34 min = 1.21 hr
  ratio     =   99.93%
  ```
- Undocumented `$integral` group (post #0, Evgeniy): `rout=1` / `routine=1` "считает немного медленнее, но лучше параллелизуется на большом числе процессоров". See §5.
- GPUs: someone asked about NVIDIA Teslas. Nothing in the thread suggests Priroda uses GPUs.

## 4. Memory / disk

- See §3 for per-process `memory=` and `disk=`. Units: `memory` in MB (e.g. `memory=512`, `memory=2048`), `disk` in GB (e.g. `disk=10`, `disk=50`). `mem=256` also appears (amg's input, accepted).
- Evgeniy's working H2 example has **`disk=-512`**:
  ```
  $system memory=256 disk=-512 path=/tmp $end
  ```
  The thread does not explain negative `disk`. Probably it means MB, by analogy with the "Memory: 256m" notation, but this is **unverified**.
- **Error `0: out of disk space (VNNNN), <N>KB`.** The job needs more scratch than `disk=` allows.
  - Marsel's MP2 run reported `0: out of disk space (VNNNN), 184441541KB`, about 175 GB.
  - denis's MP2/3z optimisation reported `0: out of disk space (VNNNN), 18067356KB`, about 18 GB.
  - Fixes:
    - raise `disk` above the reported need (Evgeniy);
    - better, use `theory=rimp2` instead of conventional MP2 (sanya; Evgeniy: "MP2 метод заместо riMP2 (первый не работает и памяти всегда ему мало)");
    - check that `cartesian` vs `z-matrix` matches the coordinates actually given ("Памяти может не хватить, если … указывать не те координаты").
  - Evgeniy: "Результаты расчёта, требующего более 20-45 ГБ на диске, не стоят своих затрат."
- Related read error seen with MP2: `0: read file ./tmp/tmp6720.0 (VNNNN): fd=3 buf=0x1ad98b08 siz=8 lpos=0` (Marsel, Feb 2010; same fix).
- Putting the scratch `path` on a RAM disk or tmpfs gave about 6× speed-up for RI-MP2 on a cluster where the data fit (§3).
- `POLARIZABILITY` task in v9 asked for "13055369600 bytes of memory (for H2CO)" (amg). Not practical.

## 5. Input groups and keywords

### Groups and keywords seen in working inputs (verbatim spelling)

| Group | Keywords seen |
|---|---|
| `$system` | `memory=`, `mem=`, `disk=`, `path=` (`.`, `/tmp`, `/cygdrive/c/temp`, quoted path OK: `path="/home/llewule/science/priroda/scratch"`) |
| `$control` | `theory=` (dft, riDFT, riMP2, mp2, tddft, HF…), `task=`, `basis=` (`"3z.bas"`, `"basis.in"`, `"basis4.in"`, `basis.in` unquoted, absolute path), `four=1` (used with `basis4.in`, the relativistic L sets), `print=+molden+vectors`, `print=+charges+bonds`, `save=` (vector saving; see §7) |
| `$molecule` | `charge=`, `mult=` (Llewule wrote `multip=1`; it parsed far enough to compute frequencies), `cartesian` / `z-matrix`, `set=L1` / `set=L33` / `set=3z` (basis set name inside the basis file; **if omitted, the default set defined in the basis file is used**, amg Nov 2011). Several `$molecule` blocks in one input are used for `transit` / `saddle` / `path` (see §8). |
| `$dft` | `functional=PBE` (also `func=PBE` seen) |
| `$scf` | `restrict=0/1`, `iterations=`, `procedure=NR`, `convergence=1e-7` |
| `$guess` | `mix=1`, `read=1` |
| `$grid` | `accur=1e-8` / `accuracy=1e-8` |
| `$optimize` | `steps=`, `step=` (see bug), `tol=1e-5`, `saddle=1`, `back=1` (with IRC) |
| `$thermo` | `sigma=` (rotational symmetry number) |
| `$nmr` | `points=` (ghost points for NICS), `standard(Z)=` reference shielding per element |
| `$energy` | previous-result block (hessian, energy, dipole derivatives); pasted from `eng>` / `num>` lines of an earlier output |

- Manual excerpt quoted by Evgeniy (v6 documentation):
  ```
  $scf
   restrict=%d             0 - spin-unrestricted
                           1 - spin-restricted (available only for few methods)
                           By default restrict=1
                           if the system has an even number of electrons,
                           and restrict=0 otherwise.
  ```
- **Atomic numbers must be integers.** `25.0  0.0208 …` gives `molecule input: ''` / `illegal charge/multiplicity`. Fix: write `25`, `8`, … (Evgeniy, Aug 2011). Faulty input (ion1981):
  ```
  $system path=/tmp $end
  $control
  task=optimize
  theory=DFT
  basis=basis.in $end
  $dft func=PBE $end

  $molecule 
  charge=0 
  mult=6 
  cartesian
  set=L1
  25.0        0.0208        -0.3430         0.1569
  8.0        -0.1955        -2.2307         0.9912
  8.0         0.3122         1.6342        -0.3308
  6.0         0.6418        -3.1609         0.7060
  6.0        -0.5920         2.5160        -0.5565
  8.0         1.6601        -3.0661        -0.0179
  8.0        -1.8330         2.3649        -0.5303
  8.0         0.3425        -4.3552         1.2890
  8.0        -0.0815         3.7412        -0.8546
  1.0         1.0476        -4.9665         0.9928
  1.0        -0.8578         4.3138        -1.0210
  8.0        -2.0202        -0.1032        -0.1298
  8.0         2.0615        -0.4269         0.6444
  1.0        -2.5646        -0.3407         0.6452
  1.0         2.5546         0.1745        -0.0688
  1.0        -2.1030         0.9411        -0.2779
  1.0         2.2634        -1.3801         0.4247
  8.0         0.5880        -1.1755        -1.7865
  8.0        -0.2902         0.0173         2.5140
  1.0        -0.2811        -0.9637         2.6016
  1.0         1.0674        -1.9862        -1.4763
  1.0         1.3038        -0.5636        -2.1794
  1.0         0.6174         0.2856         2.7611
  8.0         2.3612         0.5812        -2.6232
  8.0         3.0079         1.1755        -1.0823
  1.0         2.2228         1.7677        -0.9537
  1.0         3.2390         0.2573        -2.9131
  $end
  ```
  Working version (Evgeniy):
  ```
  $system path=/tmp $end
  $control theory=DFT basis=basis.in task=optimize $end
  $dft functional=PBE $end

  $molecule charge=0 mult=6 cartesian
  set=L1
  25       0.020800000     -0.343000000      0.156900000
  8       -0.195500000     -2.230700000      0.991200000
  8        0.312200000      1.634200000     -0.330800000
  6        0.641800000     -3.160900000      0.706000000
  6       -0.592000000      2.516000000     -0.556500000
  8        1.660100000     -3.066100000     -0.017900000
  8       -1.833000000      2.364900000     -0.530300000
  8        0.342500000     -4.355200000      1.289000000
  8       -0.081500000      3.741200000     -0.854600000
  1        1.047600000     -4.966500000      0.992800000
  1       -0.857800000      4.313800000     -1.021000000
  8       -2.020200000     -0.103200000     -0.129800000
  8        2.061500000     -0.426900000      0.644400000
  1       -2.564600000     -0.340700000      0.645200000
  1        2.554600000      0.174500000     -0.068800000
  1       -2.103000000      0.941100000     -0.277900000
  1        2.263400000     -1.380100000      0.424700000
  8        0.588000000     -1.175500000     -1.786500000
  8       -0.290200000      0.017300000      2.514000000
  1       -0.281100000     -0.963700000      2.601600000
  1        1.067400000     -1.986200000     -1.476300000
  1        1.303800000     -0.563600000     -2.179400000
  1        0.617400000      0.285600000      2.761100000
  8        2.361200000      0.581200000     -2.623200000
  8        3.007900000      1.175500000     -1.082300000
  1        2.222800000      1.767700000     -0.953700000
  1        3.239000000      0.257300000     -2.913100000
  $end
  ```
- A trailing line such as `Energy =   -784.12379607` after `$end` "никак не влияет" (amg). It came from MOL files his output parser builds from `MOL>`-tagged lines.

### Undocumented features (post #0 and later)

- **`$integral`** (Evgeniy, post #0): example `$integral direct=1 rout=2 $end`.
  - "`direct=1` выбирает пересчёт кулоновских интегралов в методах theory=riMP2 и theory=riDFT;"
  - "`routine=0` или `1` выбирает разные алгоритм расчёта двухэлектронных интегралов в методах с учётом корреляции, routine=0 по умолчанию, =1 считает немного медленнее, но лучше параллелизуется на большом числе процессоров."
  - The example uses `rout=2`, but only 0 and 1 are explained. The abbreviation `rout` is apparently accepted.
- **`$guess mix=1`**: "неравнозначность электронов на верхней занятой молекулярной орбитали" (post #0). SeriousSem: "полезен при расчете систем с синглетной открытой оболочкой (например, синглетных бирадикалов)". It is used together with `$scf restrict=0`. See the caveat in §7.
- **`task=extremal`**: "экстремальная оптимизация (после каждого шага оптимизации считается гессиан)" according to Evgeniy's guess. v9 labels it "Calculation of Gradient Extremal Path", which is slow. Shedow asked what it produces and how to visualise it; nobody answered clearly.
- **Scan input shorthand** (post #0; Evgeniy explaining the v6 documentation example):
  ```
  fix=(fix1), (fix2), (fix3)
  val(1)=x1, y1
  val(4)=xN, yN
  points=20
  ```
  "Это равнозначно value=x1,y1,z1, xN,yN,zN. Т.е. val(1) - заполнение множества параметров value, начиная с 1-го, а val(4) - заполнение, начиная с четвёртого." With 3 fixed coordinates, `val(1)` presumably lists the 3 start values and `val(4)` the 3 end values. The `x1, y1` with no `z1` looks like a forum typo.
- **Geometric parameter types for `fix`/scan** (amg, Oct 2008, tested in Priroda 2): besides 1 (distance), 2 (angle) and 3 (dihedral) there is "4,i,j,k,l (угол между прямой l-k и нормалью к плоскости k-j-i) и 5 (не знаю, что такое)". Type 4 is implemented in amg's `molgeom` script.
- **Hidden keyword list** from `strings p6_32` (Tarquinn, 05 Aug 2008). Full list of upper-case tokens:
  ```
  ENERGY GRADIENT OPTIMIZE HESSIAN ANHARMONIC SCAN DYNAMIC SADDLE IRC4 EXTREMAL PATHX TRANSIT STERIC
  DIPOLE POLARIZABILITY COMPARE RITEST RIOPT MULTIPLY SCRIPT LEDFT RIDFT ESCF IMNN OSDFT DFCIS TDDFT
  DUAL FINITE ANALYTIC PRINT MMDATA PATHR VGGA VWN5 BLYP SLYP0 OLYP MPBE BPBE PBE1 HFLSD HFPBE B2PBE
  B3PBE HFLYP B1LYP B2LYP B3LYP BFGS DIIS MCSCF CASSCF NCPSCF GRID CASPT2 CASMP2 MRCISD RIHFDF PT4DQ
  PT4SDQ PT4SDTQ CCD4S CCD4ST CCSD4T LEHF MOLDEN RIMP2 ENERGIES BONDS CHARGES ISODENSITY MATRIX
  MINIMAL VECTORS LOCALIZE RIHF CISDT CISPT2 RILHF RIMP3 OCID CC0D MP2S RIMP4D RIMP4DQ RIMP4SDQ
  RIMP4SDTQ RICID RICISD RICCD RICCSD CISDI CCSDI OMP2 RIMP2DF RILMP2 LCCD RIMP4 RICCSDSD YCISM TCISM
  XCIS YCIS TCIS TCSCF OLMP2 MMP2 MMP2J RLOCAL DECOMP MP4T CIS2 CIS2DT CISDT1 CISDTQ CI12345 CCSDT CISS
  CISSD CIDS CISDSD CCSDSDI CISDTI CISDTQI BMP2 BMP2C CIDAB CCDAB CCDAA CCD1 BASIS ATOMIC TMPDIR
  ```
  Tokens **not mentioned in the v6 documentation**, found by grepping the manual:
  ```
  ANHARMONIC DYNAMIC IRC4 EXTREMAL PATHX TRANSIT STERIC POLARIZABILITY COMPARE RITEST RIOPT MULTIPLY
  SCRIPT LEDFT ESCF IMNN OSDFT DFCIS DUAL ANALYTIC MMDATA PATHR VGGA VWN5 SLYP0 BPBE HFLSD HFPBE B2PBE
  B3PBE HFLYP B1LYP B2LYP DIIS MCSCF CASSCF NCPSCF CASPT2 CASMP2 MRCISD RIHFDF PT4DQ PT4SDQ PT4SDTQ
  CCD4S CCD4ST LEHF ENERGIES ISODENSITY LOCALIZE RIHF CISDT CISPT2 RILHF RIMP3 OCID CC0D MP2S RIMP4D
  RIMP4DQ RIMP4SDQ RIMP4SDTQ RICID RICISD RICCD RICCSD CISDI CCSDI OMP2 RIMP2DF RILMP2 LCCD RIMP4
  RICCSDSD YCISM TCISM XCIS YCIS TCIS TCSCF OLMP2 MMP2 MMP2J RLOCAL DECOMP MP4T CIS2 CIS2DT CISDT1
  CISDTQ CI12345 CCSDT CISS CISSD CIDS CISDSD CCSDSDI CISDTI CISDTQI BMP2 BMP2C CIDAB CCDAB CCDAA CCD1
  ```
  Tarquinn highlighted TCSCF, MCSCF, CASSCF, CASPT2, CASMP2, MRCISD and CISDTQ. Evgeniy: "надо проверять, что из этого работает". None of the multireference words was reported working in the thread.
- **v9 `task=` words** (amg, 29 May 2009, found via strings and tried):
  - `OPTIMIZE+HESSIAN`: "Новое - хорошо забытое старое!" It existed in Priroda 2 and was gone in v6/v8.
  - `CONICAL`: "Conical intersection (0,1)". sanya had not tested it.
  - `ANHARMONIC`: "Anharmonic Corrections to Vibrational Energies", slow. See §10.
  - `EXTREMAL`: "Calculation of Gradient Extremal Path", slow.
  - These need 2 molecules, start and end: `SADDLE` "Approximate Saddle Point Search", `PATH` "Minimum Energy Path Optimization", `TRANSIT` "Synchronous Transit in Internal Coordinates".
  - `MMDYNAMIC` reports `need 'mmdata'`. `POLARIZABILITY` needs about 13 GB for H2CO. "многие для чисто тестовых целей". "Многие из слов и в Природе-6 есть" (amg). sanya confirmed `transit` works in v8 (Jul 2010).
- **Ab initio `theory=` in v6, energy only** (Evgeniy, 07 Jan 2011; experimental):
  - "Работают: HF, riHF, MP2, riMP2, MP4SDTQ (MP4), MP4SDQ, CCS, CCSD, CCD, CCSD4T (CCSD(T))."
  - "Не работают: MP4, riMP4, riMP4SDTQ, riMP4SDQ, riCCSD, riCCSD4T (либо вылетают, либо выводят энергию на уровне HF/riHF)."
  - Earlier (May 2009 and Feb 2010) Evgeniy had said HF asks for huge memory and gives odd values, and that conventional MP2 "не работает". The Jan 2011 list supersedes this, though conventional MP2 remains very disk-hungry.
  - sanya: EOM-CCSD is implemented. CIS is slow and disk-hungry.
- Wish list that implies **missing features** (sanya and amg, Jun 2010):
  - freezing many atoms in Cartesian coordinates (impossible in internal coordinates);
  - gradients and hessians with frozen atoms;
  - constraining equality of two bond lengths or angles (MOPAC-style symmetry);
  - SCF convergence controls ("ни в одном доступном описании даже не упоминаются");
  - root following in excited-state optimisation ("ну нет ее в Природе");
  - RI-CC.

## 6. Basis sets

- **Basis files:**
  - `3z.bas`: the 3z set plus its auxiliary set.
  - `basis.in`: non-relativistic Lambda sets `L1`, `L11`, `L2`, `L22`, `L3`, `L33`.
  - `basis4.in`: relativistic Lambda sets, called "L1r, L2r", "rL22", "L33r" in posts, selected with `set=L1`, `set=L33` together with `four=1`.
  - Choose the file with `$control basis=` and the set with `$molecule set=`.
- **3z** (amg, 25–27 Oct 2011; Evgeniy):
  - "полноэлектронный нерелятивисткий базис для элементов вплоть до 54 (Xe)… так называемый атомный базис".
  - Described in Laikov's 2000 thesis.
  - Contraction table (element range, contraction pattern, uncontracted/contracted function count):
    ```
       1-2               311/1                        8/6
      3-4             51111/31                      21/11
      5-10           611111/411/11                  39/25
     11-12        611111111/61111                   44/24
     13-18       6111111111/611111/11               58/38
     19-20     611111111111/511111111               56/39
     21-30     611111111111/511111111/5111          96/59
     31-36    6111111111111/5111111111/51111       105/68
     37-38   71111111111111/61111111111/5111       108/67
     39-48   71111111111111/61111111111/5111111    123/82
     49-54  711111111111111/611111111111/51111111  132/91
    ```
  - For comparison, 6-311G**: `1-2 311/1 8/6; 3-10 6311/311/1 31/18; 11-18 63111/52111/1 47/25`. Notation: 6311/311/1 = (11s,5p,1d) → [4s,3p,1d]. Count with 5d and 7f (spherical).
  - "3z - отнюдь немаленький базис даже по современным меркам". The auxiliary basis in 3z.bas is wider still and "на результат… практически не влияет".
  - Output example for 3z (columns: contracted/uncontracted counts, then {shells} for the orbital and auxiliary sets):
    ```
     Basis set input: '3z.bas'
        1   6  C :  25/39  : {6,3,2}/{11,6,2}
        6   1  H :   6/8   : {3,1}/{5,1}
    ```
    Relativistic example: `1  78 Pt : 170/580 : {12,11,9,6,3,1}/{37,36,26,19,13,5}` followed by a second block `1  78 Pt : 681/1363 : {22,21,20,18,15,10,6,2,1}/{37,34,31,27,24,22,18,8,4}` (Marsel, L33r). Evgeniy's diagnostic: check this table for zeros, which mean the element is missing from the set.
- **3z is only for DFT/PBE.** "Базисы - любые, кроме 3z (этот сверх-ускоренный базис кроме DFT/PBE больше ни для чего не подходит). Имеет смысл использовать лямба-базисы L1, L2 (из basis.in), L1r, L2r (релятивистские из basis4.in). Работает только RI-MP2 метод." (Evgeniy, Feb 2010, answering MP2 questions.)
- **Choosing a basis:**
  - amg (Feb 2010): "для DFT геометрия при переходе от L1 к L22 меняется очень мало… А относительная энергия (и хим.сдвиги) иногда заметно. Поэтому я обычно оптимизирую в L1 и затем точечный расчет в L22."
  - L22 vs L2 for NMR: carbons next to electronegative atoms (O) are better in L22 than L2, and L2 is better than L1. Without nearby O the basis hardly matters (amg).
  - Evgeniy described L22 as "вроде аналог cc-PCVTZ". This is his impression, not authoritative.
  - **[Laikov, paraphrased by sanya]**: "все проверяется экспериментами… увеличиваешь базис до тех пор, пока заметна разница или пока затраты на расчет не перекроют улучшение качества расчета… брать надо максимально большой базис, к-рый позволяет Ваш компьютер."
  - Evgeniy (Dec 2009): "PBE/3z вообще не воспроизводит структуры, полученные RI-MP2/L2" for a Br-containing mechanism. "Что-то 3z с галогенами не дружит."
  - Weakly bound complexes (Evgeniy, Oct 2011): with a good basis such as L2 the issue is the method more than BSSE. Priroda has no DFT-D. A feasible protocol for 40–50 light atoms is "RI-MP2/L1 // PBE/L2". He thinks 3z BSSE is probably smaller than 6-31G(d) BSSE, but one cannot transfer an RHF/6-31G(d) counterpoise estimate to PBE/3z.
- **ECP bases** (sanya, Oct 2009):
  - User-built ECP+3z files are at `ftp://194.85.223.158/ECP_basis_priroda/`. They include "сделанный самим Димой SBK+3z" and a Stuttgart ECP+3z made the same way: 3z up to element 20, ECP beyond.
  - The auxiliary basis was left as in 3z.
  - sanya: SBK is large-core and not great. amg: for a di-iodo heteroaromatic, ECP made C–I carbon shifts *worse* than plain 3z (3z error was about 30 ppm downfield).
- **Using Priroda L-basis sets in GAMESS** (Nicolass, Aug 2011). Example of hand-inserting Priroda basis functions into a GAMESS `$DATA` group:
  ```
   $CONTRL SCFTYP=RHF EXETYP=check RUNTYP=OPTIMIZE  DFTTYP=b3lyp 
   MAXIT=150 ICHARG=0 MULT=1 UNITS=ANGS COORD=CART $END
   $SYSTEM TIMLIM=1000000 MEMORY=81541 $END
   $SCF DAMP=.TRUE. DIIS=.TRUE. EXTRAP=.TRUE. SOSCF=.FALSE. 
   SHIFT=.FALSE. RSTRCT=.FALSE. NCONV=6 $END
   $STATPT OPTTOL=0.000001 NSTEP=350 $END
   $GUESS GUESS=HUCKEL $END
   $DATA
  H2O
  C1
  OXYGEN      8.0     -1.239765600         0.000000000        -0.454834577
  S    5
  1    5.690075e+3   2.263697e-3
  2    8.542355e+2   1.735207e-2
  3    1.937074e+2   8.643222e-2
  4    5.330476e+1   3.097491e-1
  5    1.581525e+1   6.879624e-1
  S    1
  1    4.740002e+0   1.0
  S    1
  1    1.290672e+0   1.0
  S    1
  1    3.066148e-1   1.0
  P    3
  1    1.581525e+1   6.819612e-2
  2    4.740002e+0   2.796368e-1
  3    1.290672e+0   7.781793e-1
  P    1
  1    3.066148e-1   1.0
  D    1
  1    1.290672e+0   1.0

  HYDROGEN    1.0     -1.239765600         0.759337000         0.141208423
  S    3
  1    1.663135e+1   3.400722e-2
  2    2.520640e+0   2.312626e-1
  3    5.636194e-1   8.172781e-1
  S    1
  1    1.344906e-1   1.0

  HYDROGEN    1.0     -1.239765600        -0.759337000         0.141208423
  S    3
  1    1.663135e+1   3.400722e-2
  2    2.520640e+0   2.312626e-1
  3    5.636194e-1   8.172781e-1
  S    1
  1    1.344906e-1   1.0
   $END
  ```
  The user later solved his problem; the fix was not posted. amg's `xyz2inp` (`limor1.nioch.nsc.ru/quant/program/xyz2inp/`) can insert Priroda L-series bases from `basis.in` into GAMESS inputs after you edit the `basis.in` path in the script.
- To build contraction tables for other bases, amg suggests EMSL Basis Set Exchange in deMon2k format.

## 7. SCF convergence and wavefunction issues

- **Restart trick** (amg, Jun 2010): "Иногда помогает задать умеренное `iterations` в группе `$scf` (например, 10) и включить `save=` в группе `$control`. Когда SCF не сойдется, перезапустить с `read=1` в группе `$guess`. Последний раз таким образом удалось запинать Gd@C60 с mult=7."
  - sanya: saved vectors from a **converged** run can also be read as a start for a harder case. A non-converged run is not required. amg agreed and withdrew his claim that Priroda reads vectors only after a failed SCF.
  - The exact value syntax of `save=` is not given in the thread.
- An example `$scf` block that ran (Llewule, Dec 2011):
  ```
  $scf
  restrict=1
  iterations=128
  procedure=NR
  convergence=1e-7
  $end
  ```
- **Broken-symmetry singlet (open-shell singlet)**: use `$scf restrict=0` + `$guess mix=1`.
  - Caveat (Evgeniy, Feb 2011): for trans-nitroso oxide with **non-RI DFT** (PBE/L1, BLYP/L1) restricted and unrestricted+mix energies were identical to all digits, and the alpha and beta orbital energies were identical. With **RI-DFT** they differed, which he considered correct:
    ```
    PBE/L1:     Restrict=0, Mix=1, E=-2.054'441'926'316e+02
                Restrict=1, Mix=0, E=-2.054'441'926'316e+02
    RI-PBE/L1:  Restrict=0, Mix=1, E=-2.054'441'967'093e+02
                Restrict=1, Mix=0, E=-2.054'441'933'851e+02
    RI-BLYP/L1: Restrict=0, Mix=1, E=-2.056'294'846'798e+02
                Restrict=0, Mix=0, E=-2.056'294'818'844e+02
                Restrict=1, Mix=0, E=-2.056'294'818'844e+02
    ```
  - qadir: pure GGA functionals often do not break symmetry; try a hybrid, or first HF, which "точно должен давать broken symmetry WF".
- Missing SCF controls: sanya, Jun 2010, as quoted in §5.

## 8. Geometry optimisation

- **Tighter settings** for flat PES (amg, Oct 2008; his usual settings):
  ```
  $grid accur=1e-8 $end
  $optimize steps=300 tol=1e-5 $end
  ```
  Evgeniy found little benefit even at `accur=1e-12`. For large complexes he re-optimises a couple of times.
- **v6 optimiser quality** (Evgeniy, Oct 2008): "странноватую процедуру оптимизации (оптимизированная структура часто бывает находится где-то около настоящего минимума)". Later view from amg (Nov 2011): "Практика показывает, что Природа оптимизирует аккуратно, и мнимых частот почти никогда не остается. Исключение - когда берется симметричное начальное приближение, и в процессе оптимизации симметрия сохраняется. В этом случае проверку гессианом нужно делать обязательно."
- **Removing an imaginary frequency** (ClAlMe2 case, amg; archive at `limor1.nioch.nsc.ru/file/ClAlMe2.zip`):
  1. Optimise.
  2. Compute the hessian.
  3. Re-optimise **with that hessian appended to the input** (the `$energy` block). This gives a minimum, or a TS with `saddle=1`.
  - Methyl rotation there was 5 cm⁻¹ and the surface was flat within 5 *cal*/mol. Stationary points on such surfaces "вполне может оказаться… просто артефакты". Scan instead.
  - Evgeniy found the root of his own failures: he had **rounded z-matrix values to 3 decimals**, and in this case the extra digits mattered for the vibrational problem.
- **Verification workflow** (Dimylko and amg, Nov 2011):
  1. Optimise.
  2. Run `task=hessian`.
  3. If there are negative frequencies, append the `$energy` block from the hessian output and re-optimise. One cycle is usually enough.
  - Extract the block (lines prefixed `eng>`) with:
    ```
    perl -ne "s/^eng>// && print" hessian.out > hessian.eng
    ```
    then append `hessian.eng` to the end of the .in file. Do not retype it.
- **Combined tasks:**
  - `task=optimize+hessian` worked in Priroda 2, was gone in v6/v8, and is back in v9.
  - SeriousSem reported v9 computing frequencies at the start geometry, then retracted: "Проблема в ChemCraft, который частоты колебаний накладывает на стартовую геометрию."
  - amg's Perl driver `pri` (`limor1.nioch.nsc.ru/quant/program/pri/`) chains runs with a basis per step: `task=optimize+hessian`, `task=optimize+nmr`, `task=optimize+hessian+nmr`, `task=optimize+hessian+nmr(L22)`, `task=hessian+saddle`, `task=hessian+saddle+hessian`, `task=hessian(b1)+saddle+hessian+irc`. Evgeniy's wish was `task=scan+hessian+saddle(optimize)+hessian+irc(0,1)`.
- **Dihedral sign convention:** "Во всех версиях Природы диэдральные углы имеют противоположный знак по сравнению с общепринятым (по крайней мере, с тем что в molden, mopac, gamess)". This matters when you take scan start values from other programs (amg, Oct 2008; experience-based but specific).
- **Bug (v6): `steps` vs `step`.** If both `steps` and `step` are given in `$optimize`, the maximum number of steps is taken from `step` (Evgeniy, post #1).
- **Cosmetic bug:** "time: Geomtery Optimization" (typo) after each step. It is handy as a grep anchor.
- Optimisation log header example:
  ```
  Geometry Optimization Step 0:
  99 cartesian, 1185 internal coordinates
  93 independent variables
  ```
- A working DFT optimisation input (Dimylko, after fixing line endings):
  ```
  $system memory=512 disk=10 path=. $end
  $control theory=dft task=optimize basis="3z.bas" $end
  $dft functional=PBE $end
  $optimize steps=100 $end
  $molecule mult=1 z-matrix
  6
  6     1    1.384
  6     2    1.385   1    120.097
  6     1    2.775   2    59.93     3      0.071
  6     4    1.386   2    89.723    3   -179.786
  6     1    1.386   2    119.95    3     -0.081
  1     1    1.108   2    119.855   3    179.76
  1     2    1.11    3    119.817   4    179.858
  1     3    1.11    4    120.14    5   -179.851
  6     4    1.477   5    119.085   6    179.67
  1     5    1.11    6    119.936   1    179.588
  1     6    1.111   1    120.021   2   -179.974
  8     10   1.210   4    118.771   5     -0.655
  6     10   1.477   4    122.178   5    179.429
  1     14   1.112   10    120.723   13  -152.376
  6     14   1.341   15    119.989   10  -179.76
  1     16   1.111   14   119.57    15  -179.932
  6     16   1.432   17    119.917   14  -179.787
  6     18   1.212   16  179.697   17   -36.735
  6     19   1.431   18  179.819   16   -80.652
  6     20   1.386   19  120.258   18  -167.275
  6     21   1.386   20  120.098   19   179.92
  6     22   1.385   21  119.932   20     0.331
  6     23   1.386   22  120.038   21    -0.195
  6     24   1.385   23  119.935   22    -0.184
  1     21   1.109   20  119.807   22   179.918
  1     22   1.111   21  120.235   20  -179.823
  1     23   1.11    22  119.783   21   179.756
  1     24   1.111   23  120.14    22   179.82
  1     25   1.111   24  119.915   23  -179.689
  $end
  ```
  thegriglat suggested adding `set=3z`. amg said it is not needed because the default set comes from the basis file.
- denis's MP2/3z optimisation input. It failed with out of disk space and should use `theory=rimp2` with a proper basis, not 3z:
  ```
  $system memory=512 disk=10 path=/tmp $end
  $control theory=mp2 task=optimize basis="3z.bas" $end
  $optimize steps=150 $end
  $molecule charge=0 mult=1
  cartesian
  5       -0.854394940      2.154305570      0.700669310
  9       -0.150393170      1.901403210     -0.424343150
  6       -2.374929290      2.558886450      0.737415950
  6       -0.281392220      2.075986450      2.160967870
  6       -1.368721290      2.793166430      3.006791690
  6       -2.696599230      2.493315520      2.252037940
  1       -0.245246970      1.000297070      2.423474070
  1        0.738226380      2.459022650      2.312450090
  1       -1.416366420      2.380766090      4.027906540
  1       -3.512399080      3.164613390      2.554212770
  1       -2.477251050      3.588079550      0.347488610
  1       -3.033733040      1.938883390      0.112091640
  6       -1.063500900      4.297947690      3.122549810
  1       -0.033385390      4.413155230      3.502360690
  1       -1.061673110      4.758540300      2.117486120
  6       -2.010329440      5.083481870      4.036890120
  1       -3.043071080      5.015240760      3.659389900
  1       -2.017434780      4.613462770      5.034855690
  6       -1.618020550      6.558365480      4.168109740
  1       -2.306564230      7.101221780      4.830876260
  1       -0.603444640      6.663218480      4.580685300
  1       -1.630931210      7.060587880      3.189122380
  1       -3.019657170      1.471066550      2.503570350
  9        1.442988310     -0.978948110      0.115765530
  6        0.299781090     -1.072388380     -2.167395550
  6        1.667008780     -0.951779640     -2.855494730
  5        0.315673640     -1.040122100     -0.604164910
  9       -0.823544870     -1.099767800      0.108665060
  1       -0.213599760     -2.002145460     -2.471905210
  1       -0.379278810     -0.267808640     -2.498875690
  1        2.159886140     -0.005927010     -2.593152710
  1        1.568997610     -0.986179960     -3.949024410
  1        2.340492740     -1.765538610     -2.553796030
  $end
  ```
  Its log ended with `0: out of disk space (VNNNN), 18067356KB`, followed by `time: Two-Electron Integrals : -3.4 …` (negative time), `OOPS: semop lock failed` / `163842` / `process 0 received signal 6`. So **the semop error can be a secondary symptom of an abort**, here a disk-space failure.

## 9. Transition states, IRC, scans, reaction paths

- **Recommended TS protocol** (amg, 15 Apr 2010; consistent with the qchem.ru NH2-OH practicum):
  "Путем сканирования чаще всего получается лишь подходящее начальное приближение переходного состояния… Далее нужно рассчитать гессиан выбранного приближения. В этом гессиане первой должна идти мнимая частота, соответствующая реакции. Если мнимых частот нет вообще или первая из них не такая, значит, нужно искать другое начальное приближение. Если гессиан правильный, то добавить его в инпут-файл и сказать `task=optimize` и в группе `$optimize` `saddle=1`. Это и будет оптимизация переходного состояния. Под конец на всякий случай снова посчитать гессиан получившейся структуры (к тому же, этот гессиан пригодится, если захочется спуститься с ПС по IRC)."
  - In amg's notation the typical sequence is `task=optimize+hessian+nmr` → `task=scan` → `task=hessian+saddle+hessian` → `task=irc`.
- Marsel's claim that "the highest scan point is the TS" was corrected by amg. Scans overshoot and then jump. Example: phenyl rotation in 9-phenylanthracene, where the highest point is not a TS and often has no imaginary frequency (image at `limor1.nioch.nsc.ru/file/tmp/9PhAn-rot.png`).
  - sanya's tip for twisting conjugated bonds: use 2 coordinates. For AB>C=D<EF take twisting = half-sum and wagging = half-difference of the torsions A-C=D-E and B-C=D-F. The TS guess is near twisting = 90°, which is not the same as a 90° single torsion.
  - For 4,4'-B,N-biphenyl twisting, the TS optimisation did not converge. sanya: the TS may be strongly two-configurational, so use CASSCF in another program.
- **IRC input** (denis, Sep 2010). It failed only because of the `''3z.bas''` quoting; with `"3z.bas"` it is a valid template. Note the `$energy` block (hessian from the previous run) appended after `$molecule`, and `back=1` in `$optimize`:
  ```
  $system memory=512 disk=10 path=. $end
  $control theory=dft task=irc basis=''3z.bas'' $end
  $dft functional=PBE $end
  $optimize steps=100 back=1 $end
  $molecule charge=0 mult=1 z-matrix
  13
  6    1    2.05139667
  6    1    2.17743163    2     93.961642
  6    2    2.07224985    1     64.500596    3    -11.509202
  6    3    1.51414008    4    123.235585    1    105.632466
  1    1    1.59831614    2    112.743527    3    110.736467
  1    1    1.59636700    2    108.801871    3   -105.197977
  1    2    1.09659235    1    113.774210    6   -174.622750
  1    2    1.09265565    1    128.559459    6     40.180123
  1    2    1.11824764    1     91.976783    6    -68.758760
  1    4    1.08920519    3    117.130479    5   -159.310085
  1    4    1.08820395    3    118.783753   11    144.655123
  1    3    1.09341306    4    117.747788   12    152.732936
  1    5    1.10302118    3    110.715413    4     99.663505
  1    5    1.09841684    3    112.589399    4   -139.948709
  1    5    1.09942820    3    111.095661    4    -19.503335
  $end
  $energy
   E=-4.010975313571e+02
   D=-8.94909678e-02  8.27285613e-01  1.26095814e-01
   A=-1.05646393e+02
  ...
  $end
  ```
  The meaning of `back=1` is not explained in the thread. Presumably it relates to the IRC direction (backward branch). amg's `pri` runs "спуск по IRC в обе стороны". Treat as unverified.
- **`task=transit`, double-ended** (amg, 01 Jul 2010). Ammonia inversion example: two `$molecule` blocks with reactant and product, and **atom numbering must correspond** (oxchem):
  ```
  $system mem=256 path=/disk2/tmp disk=1 $end
  $control
   task=transit
   basis=/usr/local/lib/priroda/basis/L1
  $end
  $molecule
   cartesian
   7    0.00000000   0.00000000   0.00000000
   1    1.02745321   0.00000000   0.00000000
   1   -0.25084982   0.99634785   0.00000000
   1   -0.25061944  -0.32182112  -0.94302394
  $end
  $molecule
   cartesian
   7    0.00000000   0.00000000   0.00000000
   1    1.02745321   0.00000000   0.00000000
   1   -0.25084982   0.99634785   0.00000000
   1   -0.25061944  -0.32182112   0.94302394
  $end
  ```
  - `task=saddle` ("Approximate Saddle Point Search") with the same two-molecule input gave the same result about twice as fast (amg). oxchem saw 4 vs 5 cycles in favour of saddle. oxchem guessed transit = LST and saddle = QST2-like; this is speculation. Evgeniy: there is no "QST" string in the binary.
  - sanya used saddle (mode-following) successfully with a hessian supplied in the input and the mode to climb specified. Her description: "берем гессиан (лучше всего, чтобы четко выделялась нужная мода), скармливаем в инпут и задаем, вдоль какой моды будем подниматься". The keyword for choosing the mode is not given.
  - `transit` works in v8 (sanya). It is useful to generate a starting guess for saddle when the reactive mode is unclear (macrocycle conformers).
  - `task=path` ("Minimum Energy Path Optimization") also takes two molecules (v9). No usage reports.
- Evgeniy: "Общий подход к поиску ПС - это сканирование в многомерном пространстве =)". QST2/QST3 do not help in hard cases.

## 10. Frequencies, thermochemistry, IR/Raman, anharmonicity

- **Re-using a hessian for new temperatures** (Evgeniy, Feb 2009): if a computed hessian is supplied as input to a new hessian run, you can set new temperatures for the thermochemical corrections, and the hessian is not recomputed. The keyword for temperatures is not given in the thread.
- **Symmetry number:** `$thermo sigma=` works. Evgeniy checked it against his manual correction, which "заключается всего-лишь в вычитании от энтропии R*ln S, где S - число симметрии".
- **Bug: monoatomic enthalpy is off by RT** in v6. "В значении энтальпийного вклада для одноатомной молекулы ошибка (нужно вычесть RT)" (post #1).
- **Monoatomic thermochemistry** prints `-inf`/`inf` rotational terms (Llewule, Aug 2012, version not stated):
  ```
   ----------------------------------------------------------------------
   T =  298.150 K      ln(Q)       S          U          H          G
                              cal/mol*K  kcal/mol   kcal/mol   kcal/mol
   ----------------------------------------------------------------------
   translational      18.2366    41.2080     0.8887     1.4812   -10.8050
   rotational            -inf       -inf     0.5925     0.5925        inf
   vibrational         0.0000     0.0000     0.0000     0.0000     0.0000
   total                 -inf       -inf     1.4812     2.0737        inf
   ----------------------------------------------------------------------
  ```
  - Unanswered in the archive. For an atom, use only the translational term: S = 41.208 cal/mol·K at 298 K. The rotational U/H = 0.5925 (RT) is also spurious for an atom.
  - This table also shows the thermochemistry output layout for parsers.
- **Raman intensities**: there is no direct option.
  - thegriglat (Nov 2011): "сначала посчитать task=hessian, затем task=dipole, а затем, объединив блок $energy (eng>... и num>... соответственно) из предыдующих 2-х расчетов и снова посчитать hessian (пара сек.). В out-е будут интенсивности КР и степень деполяризуемости."
  - amg confirmed it works and simplified it: "task=dipole, и затем task=hessian с приложенным блоком num>".
  - So `task=dipole` writes **`num>`**-prefixed lines, presumably numerical dipole/polarisability derivatives.
- **IR spectra plotting:** amg's `priIR` (Perl + gnuplot). MOLDEN can read IR from the Hessian output (Marsel).
- **Anharmonic corrections** (`task=anharmonic`).
  - **[Laikov, relayed by Evgeniy, May 2009; forum msg586]**: "Вдоль каждого вектора нормальных колебаний гармонического приближения проводится расчёт энергий на сетка 10-20 точек, полученные одномерные поверхности сглаживаются сплайнами и решаются одномерные уравнения Шрёдингера вариационным методом в базисе функций гармонического осциллятора. Так что получается очень упрощенный и ограниченный учёт ангармонизма - в одномерном виде для каждой моды, без учёта связи разных мод. … для типичных валентных колебаний полчаются вполне разумные поправки, но для остальных, в частности, деформационных, торсионных - "поправки" даже ухудшают согласие с экспериментом… Так что я не вижу пользы от этой разработки, поэтому я даже не стал доводить выдачу до легко читаемого вида."
  - Failing example (Llewule, Dec 2011). The run died with `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` after the first displacement, at the line "Scalar Relativistic Density Functional Calculation:". No fix was posted. Possibly the issue is the `four=1` relativistic combination; this is unverified.
    ```
    $system
    path="/home/llewule/science/priroda/scratch"
    disk=1
    memory=256
    $end

    $control
    task=anharmonic
    basis="basis4.in"
    print=+charges+bonds
    theory=dft
    four=1
    $end

    $molecule
    charge=0
    multip=1
    cartesian
    set=L1
    8    -0.11327170   1.57357452   0.12195358
    1     0.67754889   1.01283274   0.04296020
    1     0.00371581   2.21082873  -0.60352478
    $end

    $dft
    functional=PBE
    $end

    $scf
    restrict=1
    iterations=128
    procedure=NR
    convergence=1e-7
    $end

    $grid
    accuracy=1e-8
    $end
    ```
    Output before the crash shows `surf>` blocks (normal-mode data), `mode  1: harmonic frequency = 1629.30  cm^-1`, and `mode  1: cartesian displacement = -0.261400175`.
  - thegriglat: intensities are not computed in the anharmonic mode.
- Hessian runs on 4 or more cores may hang in v6 (§3).

## 11. Excited states (TDDFT, CIS, EOM-CCSD)

- **Input** (sanya, Feb 2010): `theory=tddft` plus `state=m,n`, where "m -- то состояние, для к-рого будет считаться градиент и заселенности, а n -- сколько всего состояний считать. При этом (как и в CIS) основное состояние считается нулевым."
  - With `task=gradient` or `optimize` you also get atomic charges in the ground and excited state. Excited-state geometry optimisation is supported.
  - Restricted reference: excitations of the same multiplicity. With `restricted=0` (her wording) a singlet gives both singlet and triplet excitations.
- **All oscillator strengths zero** (Marsel, Mar 2010): caused by `restrict=0` mixing singlets and triplets. Fix: `restrict=1` and compute one multiplicity at a time (sanya; Marsel confirmed).
- **CRITICAL silent bug: hybrid functionals.**
  - sanya (Oct 2009, repeated Feb 2010; she discussed it "с Димой Лайковым на эту тему много раз, но исправлять эту ошибку он не собирается"): "Гибридные функционалы (PBE0, B3LYP, etc.) работают только в варианте `theory=RIDFT`. Соответственно, theory=TDDFT недоступно. Если же выбрать какой-либо гибридный функционал и задать theory=TDDFT, то сообщения об ошибке не будет! Программа будет считать, как ни в чем не бывало, но вес ХФ обмена будет нулевым".
  - amg confirmed "То же самое происходит, если для гибридных функционалов выбрать theory=DFT."
  - **So hybrids need `theory=riDFT`. With `theory=dft` or `tddft` they silently become pure-GGA-like.** This applies to v6–v8. sanya guessed v9 might add an error message; unverified.
- Accuracy and pitfalls (sanya):
  - TDDFT excitation energies are far better than CIS and comparable to CAS/QDPT and EOM-CC2/CCSD, with typical errors of 0.1–0.3 eV. Hybrid and pure functionals often err in opposite directions.
  - Pure GGAs (the only option in Priroda TDDFT) give spurious low-lying charge-transfer states (about 0.1–1.5 eV, near-zero f), notably for π-cation + anion with lone pairs in the gas phase. These states disturb excited-state optimisation through root flipping, and Priroda has no root following.
  - Transition-metal complexes are hard for non-hybrid DFT.
- **Fluorescence:**
  1. Absorption at the S0 minimum.
  2. Optimise S1 (TDDFT gradient).
  3. Spectrum at the S1 geometry: emission = S0←S1 at the S1 minimum, Kasha's rule.
  - The program computes S0↔Sn energies and f regardless of which state is "initial"; the geometry decides absorption vs emission (sanya, citing arXiv physics/0202029).
  - If S1 has no minimum (S1/S0 crossing), use CASSCF in GAMESS or Firefly.
- **Phosphorescence:** needs spin–orbit coupling, which Priroda does **not** have. sanya used GAMESS-US for this.
- **Excited-state MOs:** Priroda prints only ground-state MOs in TDDFT and CIS. For T1 orbitals, run a separate unrestricted ground-state calculation with mult=3 (DFT, MP2 or even CCSD). For S1 orbitals use GAMESS, Firefly or Gaussian.
- CIS in Priroda is "медленно и очень прожорлива до диска" (sanya). EOM-CCSD is implemented.
- `task=conical` exists in v9 (§5).
- thegriglat's PBE/L2 TDDFT for S,O,F,C,H organics disagreed with experiment, and L22/L3/L33 did not help. His questions went unanswered in the archive.
- **No built-in UV spectrum plotting.** Pull the energies and f values from the output and broaden them yourself (Excel or a script). amg offered to extend his NMR/IR plotters.

## 12. NMR (GIAO), NICS

- Chemical shifts work only with **non-relativistic DFT** (Evgeniy, Aug 2008). MP2 and similar do not output shifts.
- **Relativistic NMR hangs** (`four=1` / basis4.in), for all bases and methods.
  - **[Laikov, relayed by sanya, Oct 2009]**: "теория Дирака… работает с четырёхкомпонентными волновыми функциями… И поэтому по-разному считаются всякие интегралы, и особенно непросто устроены интегралы, связанные с магнитными свойствами. Так что для того, чтобы дописать код, который бы считал константы экранирования ЯМР, нужно было бы основательно посидеть и повыводить формулы, на что у меня времени не нашлось."
  - So relativistic NMR is **not implemented**. The workaround is a relativistic geometry plus a non-relativistic 3z/L-basis or ECP+3z NMR single point. Results for C bonded to I were poor (amg).
- **NICS** (GemmaNC and amg, 2009):
  - Use `$nmr points=... $end`. The output looks like `Point    1 : isotropic=    7.1593  principal=    3.5974    3.5974   14.2829`.
  - NICS = minus the isotropic shielding, here −7.16. NICS(1) at 1 Å above the ring is considered better than NICS(0).
  - Use a bigger basis for shifts, L22 rather than the L1 used for geometry.
  - amg's `addXX` adds ghost atoms at the ring centre and above it and reorients the ring into xy for the zz component. His `priin` turns the dummy atoms into a `$nmr` group.
- **Reference shieldings for `standard(Z)=`**: absolute shielding of the reference compound at the same level, in ppm. Values from Evgeniy (Feb–Apr 2012), who co-authored the NMR benchmarks:
  ```
  1H          13C            ПРИРОДА  (TMS)
  PBE/3z      -31.3917   -182.0037   standard(1)=31.3917 standard(6)=182.0037
  PBE/L1      -31.5184   -184.2836   standard(1)=31.5184 standard(6)=184.2836
  PBE/L11      -31.5556   -181.5032   standard(1)=31.5556 standard(6)=181.5032
  PBE/L2      -31.1796   -182.8910   standard(1)=31.1796 standard(6)=182.8910
  PBE/L22      -31.1903   -181.3325   standard(1)=31.1903 standard(6)=181.3325
  PBE/L3      -31.1593   -182.1304   standard(1)=31.1593 standard(6)=182.1304
  PBE/L33      -31.1672   -179.8099   standard(1)=31.1672 standard(6)=179.8099
  ```
  The table header does not name the 1H/13C reference; presumably TMS.

  15N vs nitromethane (CH3NO2; strong basis dependence, methyl rotor scanned 0–60°):
  ```
  14,15N         ПРИРОДА
  PBE/3z      134.6652   standard(7)=-134.6652
  PBE/L1      136.0508   standard(7)=-136.0508
  PBE/L11      138.3058   standard(7)=-138.3058
  PBE/L2      119.6380   standard(7)=-119.6380
  PBE/L22      132.4000   standard(7)=-132.4000
  PBE/L3      136.6290   standard(7)=-136.6290
  PBE/L33      139.4144   standard(7)=-139.4144

  Галустян 09:
  GIAO-B3LYP/6-311+G(d,p)    -152.4628
  CSGT-B3LYP/6-311+G(d,p)      -152.2519
  GIAO-SCF/6-311+G(d,p)      -256.7758 !!!
  GIAO-MP2/6-311+G(d,p)      -39.9477 !!!
  ```
  15N vs NH3 (gas-phase molecule):
  ```
  N         ПРИРОДА
  GIAO-PBE/3z      -265.3505   standard(7)=265.3505
  GIAO-PBE/L1      -264.0833   standard(7)=264.0833
  GIAO-PBE/L11      -264.4963   standard(7)=264.4963
  GIAO-PBE/L2      -272.2296   standard(7)=272.2296
  GIAO-PBE/L22      -264.6161   standard(7)=264.6161
  GIAO-PBE/L3      -267.8042   standard(7)=267.8042
  GIAO-PBE/L33      -262.5414   standard(7)=262.5414

  Gaussian:
  GIAO-B3LYP/6-311+G(d,p)   259.3570
  CSGT-B3LYP/6-311+G(d,p)   246.2896
  GIAO-MP2/6-311+G(d,p)   276.1659
  ```
  The sign convention of `standard(Z)` is as shown: positive for NH3 and TMS, negative for nitromethane.
  - amg's caveat: gas-phase NH3 is not the liquid-NH3 standard. Use liquid-NH3 shielding 244.6 ppm (264.5 + gas→liquid correction), per JACS 2006, 128, 15200 and Jameson et al. The difference is about 20 ppm.
  - The nitromethane scan curves show jumps near maxima (sanya asked why; unanswered).
- Empirical corrections and statistics for PBE/3z and PBE/Ln are in Pankratyev et al., JCC 2011, 32, 1993, and in the V All-Russian NMR conference abstracts (Kazan 2011, pp. 122–124).
- NMR spectrum plotting: amg's `xyz2jmod` (Perl + gnuplot).
  - `pri2mol` produces `*.xyzppm`. Column 6 is optional peak labels; atom numbers are used otherwise.
  - Windows notes: set `$gnuplot = 'gnuplot';` or the full path instead of `` `which gnuplot` ``. The default terminal is x11; on Windows use `xyz2jmod -terminal=png`. Use `plot 'ppm.out' with line` for a line spectrum.
- Combined `optimize+nmr` with a different NMR basis is available through amg's `pri` (§8).

## 13. Solvation

- **Nothing in the thread shows a solvation model in Priroda.** All discussion assumes gas phase. sanya explicitly attributes CT artefacts in ion pairs to gas-phase treatment.
- Evgeniy (Oct 2011) notes that the NIVC MSU / ООО Димонта group developed a separate solvation QC program, which is commercial and not part of Priroda as discussed.

## 14. Output parsing and visualisation

- **Line-prefix tags in the output** (grep-able):
  - `eng>`: the `$energy` block (E, dipole D, and gradient/hessian data). Paste it after `$end` of `$molecule` in the next input. Example:
    ```
    eng>$Energy
    eng> E=-1.166439642086e+00
    eng> D=-1.64494660e-11 -2.55458947e-12 -4.39549501e-12
    eng>$end
    ```
  - `num>`: numerical-derivative block from `task=dipole` (used for Raman, §10).
  - `mos>`: MO vectors in Molden format when `print=+vectors+molden`.
  - `MOL>`: optimised-geometry lines (amg's parser builds MOL files from them).
  - `surf>`: anharmonic surface data.
  - Input echo lines are prefixed with `<` (e.g. `<$molecule`, `< set=L33`).
  - Summary lines: `| Theoretical Method               RIMP2`, `E2 =`, `E  =`.
- **Orbital visualisation** (post #0): put `print=+vectors+molden` in `$control`, cut the `mos>` section, strip the `mos>` prefix, save as `file.mos`, and open it in **Molden** ("В связи с размером базисов Molden может подтормаживать"). One-liners:
  ```
  grep '^mos>' file.out | sed 's/^mos>//' > file.mos
  perl -ne  's/^mos>// && print' file.out > file.mos
  ```
  On Windows use the Perl version from `cmd` (Evgeniy, Feb 2010: "Пока только Molden" for MOs). The files are large.
- **Orbital energies** are printed as:
  ```
   One-Electron Energies (alpha)
   occupied:
      5    -0.916719    6    -0.648843    7    -0.533182    8    -0.492418
   ...
   virtual:
     13    -0.164674   14     0.046533   15     0.067315   16     0.156056
  ```
  followed by a `(beta)` block for unrestricted runs.
- **Visualisers** listed in post #0: QCC Front-End (QFE), ChemCraft, Priroda Simple Viewer, ViewMol3D, PMViewMol, plus Molden.
  - ChemCraft shows optimisation steps but overlays frequencies on the *starting* geometry (§8).
  - MOLDEN can show scan energy profiles and IR from hessian outputs (Marsel).
- **Wavefunction for AIM:** Rinat (Oct 2008) heard that a program by "некий Волков" extracts a `.wfn` file from Priroda output. Unanswered.
- **Hessian conversion from Gaussian or GAMESS to Priroda format** was asked (oxchem, Apr 2010) and not answered.
- amg's script collection (Perl, mostly OS-independent) at `http://limor1.nioch.nsc.ru/quant/program/`:
  - `pri`: chained jobs
  - `priin`: input generator from xyz, handles dummy atoms for NMR
  - `pri2mol`: output to xyz/mol/xyzppm
  - `addXX`: NICS ghost atoms
  - `xyz2jmod`: NMR spectra
  - `priIR`: IR spectra
  - `molgeom`: geometry parameters, including type 4
  - `xyz2inp`: GAMESS inputs with Priroda bases
  - Plotting uses gnuplot and can export DX format.

## 15. Known bugs and error messages (quick reference)

| Symptom / message | Context | Cause / fix | Source |
|---|---|---|---|
| Output stops at `0: opening file /tmp/tmp2792.0` | Windows p6.exe | Set `$system path=. $end` (or `path=/cygdrive/c/temp`, or `TMPDIR`) | Evgeniy, #0 |
| `molecule input: ''` then `'z-matrix' ?` | Windows | CRLF line endings: convert to LF (dos2unix, Notepad++). Avoid Cyrillic and spaces in host, dir and file names | amg, Dimylko (resolved) |
| `molecule input: ''` / `illegal charge/multiplicity` | any | Atomic numbers written as reals (`25.0`): use integers | Evgeniy |
| `error opening file ''3z.bas''` | IRC run | Use `basis="3z.bas"` (double quotes), not `''…''` | Evgeniy |
| `0: out of disk space (VNNNN), NNNNKB` | MP2 | Raise `disk=` (per process!), or better use `theory=riMP2`; check `cartesian`/`z-matrix` | Evgeniy, sanya |
| `0: read file ./tmp/tmpNNNN.0 (VNNNN): fd=3 buf=… siz=8 lpos=0` | MP2 | Same as above | Marsel/Evgeniy |
| `OOPS: semop lock failed` + `process N received signal 2/6` | v6 SMP `-np 7`, DFT optimise; or after another fatal error | Semaphore failure. `ipcrm` cleanup (Granovsky's advice) did not help. Use fewer cores (≤4 for optimisation, ≤2 for hessian in v6). Also appears as a secondary message after out-of-disk | Chai, Evgeniy, denis |
| Hang at `Solving for responses ...` | v6 hessian on 4 cores | Use ≤2 cores | Evgeniy #1 |
| Hang / signal 8 with >~24 cores | v7 MVAPICH, MP2 on 102 atoms | Use fewer cores | Evgeniy |
| `process 0 received signal 1` during SCF (`hmin = -0.302`) | DFT, rL33 (Pt complex) | Unresolved. Check that the basis table has no zeros (element present in set). Evgeniy's H2/L33 riMP2 test worked | Marsel/Evgeniy |
| riMP2/rL22 energy writes no output file | Pt complex | Unresolved ("Просто что-то вы запускаете не так") | Marsel |
| `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` | `task=anharmonic` with `four=1`, basis4.in | Unresolved | Llewule |
| `MMDYNAMIC  need 'mmdata'` | v9 | Needs an MM data file (not documented) | amg |
| HF with relativistic Hamiltonian (lambda sets from basis4.in) hangs | v6 | Not supported | Evgeniy |
| NMR with relativistic Hamiltonian hangs | all | Not implemented (Laikov) | Evgeniy, sanya |
| Hybrid functional silently uses 0% HF exchange | `theory=dft` or `tddft` | Use `theory=riDFT` for hybrids. No hybrid TDDFT | sanya, amg |
| TDDFT oscillator strengths all 0 | `restrict=0` | Use restricted; one multiplicity per run | sanya |
| UKS `mix=1` gives same E as RKS | non-RI DFT | Use RI-DFT, or hybrid/HF to break symmetry | Evgeniy, qadir |
| `$optimize` with both `steps` and `step`: max steps taken from `step` | v6 | Give only `steps` | Evgeniy #1 |
| `time: Geomtery Optimization` typo | v6 | Cosmetic | Evgeniy #1 |
| Monoatomic enthalpy off by RT; rotational S = `-inf` | thermo | Correct by hand (use translational only) | Evgeniy #1, Llewule |
| Dihedral angles have opposite sign vs Molden/MOPAC/GAMESS | all versions | Flip the sign when transferring | amg |
| Optimisation path depends on `-np` | unstable TS search | Usually negligible | amg |
| Rarely wrong gradients for MP2, MP4, CCSD, CCSD(T), CIS(2), EOM-CCSD | before ~May 2011 | Fixed by Laikov (v9 builds after mid-2011) | sanya [Laikov] |
| `task=optimize+hessian` (v9) frequencies "at start geometry" | ChemCraft display | Not a Priroda bug | SeriousSem |
| Signal 8 / hangs for small jobs on many cores | v6/v7 | "Малые задачи на большом числе процессоров зависают" | Evgeniy |

## 16. Comparisons with other programs

- **Gaussian**: when criteria are tightened, symmetry appears in DFT structures of organoaluminium compounds and imaginary frequencies vanish, whereas Priroda can leave one (Evgeniy, Oct 2008; resolved by amg's hessian-restart procedure). Gaussian is used for QST2, hybrid TDDFT and reference NMR values (tables in §12).
- **GAMESS-US / Firefly / PC GAMESS**: recommended for hybrid and LC-functional TDDFT, CASSCF and MCQDPT (MCQDPT in Firefly prints excited-state orbitals readable by ChemCraft), conical intersections, and spin–orbit coupling (GAMESS-US preferred). Priroda was adopted when GAMESS 6-31G(d) jobs became too big: "быстро, вроде бы воспроизводимость результатов есть… перешли на Природу" (STARWAR82).
- **IGLO program**: compared for iodine-compound NMR (IGLO-II with ECPs). It was no better than Priroda 3z.
- **Dirac**: newer versions reportedly have relativistic NMR (amg, Nov 2010), which Priroda lacks.
- **3z vs 6-311G\*\***: §6. PBE/3z vs B3LYP/6-311G(2d,p) NMR is compared in the Беляков–Анаников 2011 paper.
- **Missing features**: DFT-D and QCISD(T) are not in Priroda (Evgeniy). Raman needs the trick in §10.

## 17. Performance notes

- Priroda is "одна из самых быстрых и малотребовательных" for DFT, thanks to RI density fitting (Laikov 1997). "эта программа считает DFT-задачи очень быстро" (amg). The bottleneck is often job management, which motivated `pri`.
- RI-MP2 is the practical correlated method. Conventional MP2 is disk-bound. Jobs over 20–45 GB of scratch are "не стоят своих затрат" (Evgeniy).
- Scratch in RAM gave 6× for RI-MP2 on a cluster. Direct SCF (`$integral direct=1`) halves disk use but is slower (§3).
- Several 1-core jobs give better throughput than one multi-core job for disk-light work. amg uses 2×2 on 4 cores.
- Numerical hessians are "ужасно долгий" (oxchem), which is why transit and saddle are attractive.
- CIS: slow and disk-hungry. POLARIZABILITY: about 13 GB for H2CO. ANHARMONIC and EXTREMAL: slow.
- UPX-compressed binary: same CPU time, lower REAL time (one report).

## 18. Open questions in the archived part of the thread (unanswered or unclear)

- Exact use of `task=extremal`, `conical`, `path` and `dynamic`. The `state=` keyword for choosing the saddle mode is not given.
- Exact semantics of the `save=` value, `back=1`, `disk=-512` (negative) and `rout=2`.
- How to specify the temperature list for thermochemistry re-runs.
- Exact Coulomb/XC without RI (Ninel, Apr 2012, citing the CPL 1997 statement that the program can do it). Unanswered in the archive. The `$integral direct=1` and `theory=dft` vs `riDFT` distinction may be related, but this is not confirmed.
- Hessian conversion from other codes. A `.wfn` export for AIM.
- Page 15 of the thread (posts after Aug 2012) is not archived.
