# chemport.ru thread 28803: "Природа" (the main PRIRODA user thread)

- URL: https://chemport.ru/forum/viewtopic.php?f=71&t=28803
- Fetched 2026-10-16 with `curl -sL` directly. The site did not block, so the Wayback Machine was not needed. Raw HTML (UTF-8 with BOM) is in
  `/tmp/claude-1000/-home-egor-projects-priroda/1ef56c3b-4910-42be-b3ba-954ec62c9d15/scratchpad/raw_cp28803/p0.html` … `p500.html`.
- **Pagination:** 20 posts per page, `&start=0,20,…,500`. The page header reads "Страница 26 из 26" and "518 сообщений".
  `&start=520` returns page 26 again. **All 26 pages and 518 posts (518 unique post IDs) are covered.**
- **Time span:** post #1 is Вик, 13 Feb 2009; post #518 is amge, 3 Jul 2026.
- **Post numbering:** "#N" is the post's sequence number in the thread (1–518). Page P holds posts 20(P−1)+1 … 20P.
  To open a post, use `viewtopic.php?f=71&t=28803&start=<20·(P−1)>`.
- **Authority:**
  - **Dimitri Laikov never posts in this thread.** Statements of his reach it only second-hand: e-mail answers that users relay
    (e.g. #381 Raman recipe, #382 energy printout, #347 "no D3"), quotes from his site, or quotes from the manual
    (`input.txt`, KNC-wiki PDF). These are tagged "[authoritative?]", "[quotes manual]" or similar in the text.
  - Most posts come from long-time power users: amge (87 posts; NIOCh Novosibirsk, author of the `pri`/`pri2mol`/`xyz2jmod` scripts),
    EvgeniX (61), Гесс (61; forum moderator), sanya1024 (32), Любитель_Манниха (25), OrganikNV (25), Tasha (23), Metalian (23),
    Droog_Andrey (19), VTur (15; often speculative), alxyppv, YuraM, asp. These are tagged "[experienced user]".
    Guesses are tagged "[unverified]".
- **Method:** posts were extracted from the HTML, split into 7 page ranges, and summarised by topic. A first extraction lost
  reply text that followed quotes. It was redone with a fixed parser, and every lost reply was restored and merged in.
  Within each topic below the material is grouped by page range (in chronological order), so a later sub-section can update
  or contradict an earlier one. **Always prefer the newest information**, since program behaviour changed a lot from v6 (2006)
  to v23 (2023).
- **Not recoverable:** attachments and images in the thread need forum login ("У вас нет необходимых прав для просмотра вложений").
  These include several inputs (#112, #118, #216, #229, #234, #328) and some error screenshots (#472).
- **Small gap filled here:** #487 amge (30 Dec 2021), on the polymer-crystal collapse in the geometry section:
  "Тут смотря что понимать под разрушением ячейки… я то думаю, что просто начальная структура с терминированными концами
  кардинально меняла конформацию. Так то Лайковская полуэмпирика многократно опробована, ничего такого совсем плохого не было."
  (It depends on what "cell destruction" means. I think the starting structure with capped ends simply changed its conformation
  drastically. Laikov's semiempirical method has been tested many times and nothing really bad came up.)

---

## 0. Key takeaways for the manual (digest; details and sources in the sections below)

**Getting the program and versions**
- Distribution has always been by the author: ask Laikov by e-mail (`laikov@physto.se` in 2009, later `dimitri_laikov@mail.ru`).
  Sites: `http://www.physto.se/~laikov/p/` (2009), then `http://rad.chem.msu.ru/~laikov/` with Windows builds at `…/~laikov/p_w/`
  (files `p1.exe`, `p1_190306.exe`, `p_190306.exe`, `xm.exe`, `cygwin1.dll`).
- Versions mentioned: 2, 4, 6 (2006.08.20), 8, 9, 10 (2011.04.14), 11, 16, 17, 23 (2023.06.22, the newest as of 2024).
  Parallel runs only really work from v16 on. In v6 the Hessian uses at most 2 cores (#401).
- Energies differ slightly between versions. Do not compare close energies computed with different versions (#514 amge).
- The manual is the `input.txt` file in the distribution (#151, #327). The old online KNC wiki ("Природа_для_самых_маленьких",
  wt.knc.ru) is dead. A PDF mirror survives: https://monitor.hpc.umanitoba.ca/doc/Priroda_Documentation_from_KNCWiki.pdf (#468).

**Running**
- `p in out` (serial, e.g. `p6 1.in 1.out`, `p1.exe in out`). Parallel on Linux: `p -np N in out`. Do not go through the bundled mpiexec.
  Use full paths, including the basis-file path inside the input.
- Windows: Cygwin build, serial `p1.exe`. For a parallel run, copy the Cygwin OpenMPI DLLs next to `p.exe` and create `dev\shm` and
  `dev\mqueue` one level above. Then run `mpirun.exe`/`orterun.exe -np 2 p.exe in out` with `TMPDIR` set (#370, #397, #472).
  On 32-bit Cygwin the build cannot allocate more than about 1 GB.
- Inputs must be plain ASCII/ANSI with **Unix (LF) line endings** and straight quotes. CRLF gives
  `molecule input: ''` / `' ?matrix` or `?rtesian`, or `task=scan` silently runs an optimization instead. Fix with `dos2unix`.
- `$system memory=<MB> disk=<GB> path=<scratch dir> $end`. A **negative `disk=`** means a RAM disk in MB, e.g.
  `memory=9000 disk=-14000` on a 24 GB node (manual quote, #468). `memory` + |disk| must fit in physical RAM, or you get
  `malloc(…) failed`. Scratch lookup order: `path=`, then `$TMPDIR`, then the input-file directory (#465).
  On Windows without `/tmp`, set `path=.`. Values are per process.

**Input and methods**
- Groups seen: `$system`, `$control` (`task=`, `theory=`, `basis=`, `four=1`, `print=`, `save=`), `$dft functional=`,
  `$molecule charge= mult= cartesian|z-matrix`, `$optimize`, `$scf`, `$grid`, `$guess read=1`, `$nmr standard(Z)=`, `$integral`.
- `theory=dft` is pure GGA with RI. **Hybrids (B3LYP, PBE0/PBE1) need `theory=ridft`.** With `theory=dft`, either the HF exchange is
  silently dropped (old versions), or the job aborts with `MPI_Abort` after reading the basis twice (#96, #99, #307–#310).
  NMR (`task=nmr`) works only with `theory=dft`.
- Only `task=optimize+hessian` works as a combined task. Two `task=` lines silently run only the first one.
  amge's `pri` wrapper script handles other combinations.
- Bases: Λ/L series `L1`≈cc-pVDZ, `L2`≈cc-pVTZ, `L22`≈cc-pCVTZ (in `basis.in`); relativistic `L1r`/`L2r` (in `basis4.in`, need
  `four=1`); `3z.bas` (DFT only, Z≤54; with ab initio methods it is 30–40 kcal/mol off vs L2); `sbk.bas` (ECP on every element),
  `20+sbk.bas`. Bases can be imported from BSE, with auxiliary bases generated by ORCA (method at limor1.nioch.nsc.ru/priroda.html).
  The program copes badly with diffuse or non-native bases.
- Not available: symmetry (always C1), continuum solvation, D3 dispersion (the author refused; only a new `dfl6a`-type
  functional appeared around v23 according to amge), periodic systems. Present: MP2/RI-MP2, CCSD(T), TDDFT (`theory=tddft`),
  NMR, IRC, Laikov's QM semiempirical method (amge/Гесс: about as good as GFN2-xTB, much better than PM7).

**Optimization, TS, IRC, scans**
- `$optimize steps= tolerance= saddle=1 cartesian=1 fix=… value=… points=…` (manual excerpt quoted verbatim in #373).
- A TS search needs an exact Hessian first; IRC needs an exact Hessian at the TS. After an IRC, always re-optimize the endpoints.
- Priroda's dihedral angles have the **opposite sign** to the usual convention (#278).
- The crash `process 0 got signal 6` with `too few` in the internal-coordinate table is fixed by `$optimize cartesian=1 $end` (#518).
- `Vicinity of a Stationary Point(?) --- STOP.` in IRC means the energy did not drop on that step: change the step size (#298).

**SCF trouble**
- Cap the iterations (`iterations=10`), save vectors (`save=`), restart with `$guess read=1`, and repeat.
  Alternatively use `$grid accuracy=1e-9` with `$scf convergence=1e-7 procedure=bfgs iterations=250`.
  The `$scf` options `convergence` and `iterations` only take effect together with `procedure=bfgs` (#324).
- A NaN energy or a fake one-step "optimization" usually means the basis is missing for an element (e.g. Bi with `3z`) or the ECP was not read.

**Thermochemistry and output**
- H = E + ddH and G = E + ddG, where E is in hartree and ddH, ddG are in kcal/mol from the "total" row of the `task=hessian`
  thermo table. ZPE is included. Monoatomic species get an extra RT.
- Raman: run `task=hessian` and `task=dipole` separately, feed both results into the input, and rerun `task=hessian` (Laikov, relayed in #381).
- The printed energy components omit nuclear repulsion (Laikov, relayed in #382).
- Charges: `Overlap populations` (Mulliken) and `Atomic partitions of the density` (Hirshfeld).
  The optimized geometry is on the `MOL>` lines after `OPTIMIZATION CONVERGED`.
- Visualization: Chemcraft-exported Cartesians (`Z x y z`) can be pasted into `$molecule … cartesian` (#214); amge's `pri2mol` converts it to Molden. MOs need `print=+vectors+molden` in `$control`.
  NMR shifts can be shown as `.xyzppm`. Density critical points come from `print=+density` (not `task=critical`).
  `xm.exe` is Laikov's output viewer.

**Performance**
- About 3x faster per optimization step than ORCA 4.0 (PBE/cc-pVDZ, C10H17NO, 1 core; #415-#417, 2018).
- Scales well within one node but gains little beyond 6–8 cores for DFT and nothing across nodes.
  Example timings: 101 / 63 / 37 s on 8 / 12 / 24 cores. 10 PBE/L1 optimization steps: 81.5 / 42.5 / 29.8 / 29.3 s on 1–4 cores (v10).
- Priroda is very demanding of disk speed. If processes share one physical drive, performance is "degraded terribly".

---

## 1. Obtaining, installing, versions

### Obtaining, installing, versions — pages 1-4, posts #1-#80, 2009-02..2011-08

- Official site (2009): `http://www.physto.se/~laikov/p/` — #3 buraten, 13 Feb 2009. Also quoted by #20.
- Laikov's e-mail (2009): `laikov@physto.se` — #2 amge, 13 Feb 2009 [experienced user].
  Quote: "Хотя программа и выложена автором в свободном доступе, обычно у него спрашивают разрешения, он и скажет, откуда скачать."
  (Although the author put the program in free access, people usually ask him for permission, and he tells where to download.)
- Oct-Nov 2010: Laikov's site appeared dead and he did not answer e-mails — #27 iVovne9 (22 Oct 2010), #29 RAS (16 Nov 2010).
  RAS: "природой делится сам Лайков (или вкупе с Устынюком)" (Laikov distributes it himself, or together with Ustynyuk).
  #30 EvgeniX replied (16 Nov 2010) but the post was later edited to "." (edited 12 Aug 2017) — probably a contact/download hint, removed. #31 RAS thanks him.
- Versions mentioned: p6 (`p6.exe`, "Природа 6"), version 8, version 9 (Jan 2011). Version 6 was downloadable from the official site (#36 Droog_Andrey, 20 Jan 2011).
  To get newer versions (8/9): "Просить Диму лично." (Ask Dima [Laikov] personally) — #37 sanya1024, 22 Jan 2011 [experienced user].
- Limits on number of atoms / basis functions: "Насколько я знаю, ограничений нет (кроме оперативки и др. hardware, конечно)." (As far as I know there are no limits except RAM and other hardware) — #2 amge [experienced user].
- Windows package: user unpacked everything into one folder `c:/priroda` and ran `p6.exe` — #20 _Andrey_, 27 Feb 2009.

### Obtaining, installing, versions — pages 5-8, posts #81-#160, 2011-08..2012-04

- **Where to get Priroda:** write to the author: `dimitri_laikov(at)mail(точка)ru` (i.e. dimitri_laikov@mail.ru). — #121 eFo, 25 Nov 2011 [experienced user]
- **Versions seen in this page range:**
  - "Priroda 6 (2006.08.20)" — banner line of the Windows build (`copyright &copy; Dimitri Laikov`) — #94 Partizan, 18 Sep 2011.
  - "Priroda 10 (2011.04.14)" — banner line of a Linux build (`copyright &copy; D.N. Laikov`), executable named `p` — #152 asp, 14 Jan 2012.
  - "Priroda 4" mentioned as older version whose optimization convergence criteria were somewhat different from v6 — #137 EvgeniX, 5 Dec 2011 [experienced user, hedged "вроде бы"].
  - amge #119 (24 Nov 2011): a user's failing optimization possibly due to "совсем старая Природа" (a very old Priroda) and a strange basis; "6-я версия Природы c близкими по размеру к Вашему базисами L2, L22m и L22 оптимизирует исходную геометрию за 6-7 шагов" (v6 with L2/L22m/L22 optimizes the starting geometry in 6–7 steps). [experienced user]
- **Distribution contents (as received from Laikov):** Windows folder contained `p6.exe` and `cygwin1.dll` (Windows build is Cygwin-based) — #130 OrganikNV, 29 Nov 2011. asp #150/#152 got both Windows and Linux variants; Linux files included `p` (Priroda 10) and a bundled `mpiexec` in the same directory (`/home/asp/bin/priroda/mpiexec`). Executable names mentioned: `p6.exe`, `p6_64` (64-bit, parallel), `p6_64.bin` (#159), `p` (Priroda 10).
- **Linux distro recommendation for dual-boot with Vista:** "OpenSuSe последний 64-битный" (latest 64-bit openSUSE) — #149 EvgeniX, 12 Jan 2012 [experienced user]. asp installed openSUSE 12.1 (#150).
- **Feature history:** `task=optimize+hessian` existed in Priroda 2, vanished in Priroda 6, reappeared in Priroda 9 — #145 amge, 22 Dec 2011 [experienced user].
- The run syntax "приводится в самом начале документации (input.txt)" — the manual file is `input.txt` and the run command is at its very beginning — #151 EvgeniX [experienced user].

### Obtaining, installing, versions — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#183 Лечащий Врач, 15 Jan 2013** [experienced user]: "Использую природу 11" (I use Priroda 11). Runs it on a dual-socket machine with two 4-core Xeons ("относительно старой", relatively old).
- **#209 perezzloy, 16 May 2013** [unverified, but a useful data point]: "Скиньте кто-нибудь "Природу", а то с офф. сайта удалена, а автор молчит(((" (Someone please send me Priroda. It has been removed from the official site and the author is not answering.) So by May 2013 the program was **no longer downloadable from the official site**. Nobody in this page range replied.
- **#171 amge** (Apr 2012): Linux binary name **`p6_64`** (a 64-bit build of Priroda 6?).
- **#206 Любитель_Манниха** (Apr 2013): ran it on Windows. Basis files mentioned: **`3z.bas`** and **`basis4.bas`** (see Basis sets).
- **#211 alxyppv** (Jul 2013): the Windows build runs **through Cygwin** (see Memory).

### Obtaining, installing, versions — pages 13-16, posts #241-#320, 2013-12..2015-06

- **Contact for getting the program.** #286 liliya2014 (Jan 20, 2014) asked where to download Priroda and for Laikov's email. #287 Гесс (Jan 20, 2014) [experienced user]: a Google search for "Лайков Природа" gives his page as the first hit, and it lists `dimitri_laikov(at)mail.ru` (with @). Nobody offers a download link, so the program is obtained by writing to the author.
- **Author page URL**, quoted in the citation in #302: `http://rad.chem.msu.ru/~laikov/`.
- **Version string seen**, #319 Aryl (Jun 25, 2015): `Priroda 6 (2006.08.20)` / `copyright &copy; Dimitri Laikov`, running under Windows 7 64-bit. Some users were still on Priroda 6 (2006) in 2015.
- **Linux build in use**, #315 Любитель_Манниха (Apr 27, 2015): runs under openSUSE 13.2.
- **Basis files mentioned**, #247 (Гесс quoting Evgeniy on qchem.ru, Feb 21, 2010): `basis.in` (holds L1, L2) and `basis4.in` (holds the relativistic L1r, L2r). See Basis sets below.

### Obtaining, installing, versions — pages 17-20, posts #321-#400, 2015-06..2018-12

- **Old documentation URL is dead (2015)**: `http://wt.knc.ru/wiki/index.php/Priroda_Documentation` had Priroda documentation, but the domain wt.knc.ru was down in July 2015. #326 ftorazyne, 2015-07-27. EvgeniX's answer (#327, 2015-07-28): "Эта документация содержится в файле input.txt" ("This documentation is contained in the file input.txt"), i.e. the input-keyword manual ships with the program distribution as `input.txt`. [experienced user]
- **"Laikov's site"** carries binaries plus Cygwin DLLs (#362 amge; but see #370 below: not all DLLs needed for the parallel build are there). alxyppv asked for the link in #368; madschumacher (#369, 2016-12-29): "Может этот [`http://rad.chem.msu.ru/~laikov/p_w/`]?" ("Maybe this one?"). [experienced user; URL as of 2016]
- **Parallel Windows binary naming** (#370 EvgeniX, 2017-01-30): "На сайте p16_64_parallel.exe называется exe64/p.exe" (on the site, the 64-bit parallel build is `exe64/p.exe`; EvgeniX had renamed it `p16_64_parallel.exe`, in a folder `C:\Priroda 16`).
- **Not every build on Laikov's site is reliable.** Любитель_Манниха (#366, 2016-12-10) quotes a note from Laikov's site: `w64/*.exe - попытка собрать для 64-разрядного Cygwin/Windows, вкралась ошибка с DFT/ECP....` ("w64/*.exe is an attempt to build for 64-bit Cygwin/Windows; a bug with DFT/ECP crept in..."). His advice: "напишите Лайкову, ту ли Природу вы запускаете" (write to Laikov and ask whether you are running the right Priroda build). [experienced user, quoting the author's site → semi-authoritative]
- **Author contact (2018)**: `Dimitri Laikov <dimitri_laikov@mail.ru>`. #377 amge, 2018-02-15.
- **Version names**: "природа 6" / "Природа P6" / executable `p6.exe` (#321, #376, #398). Executable names seen: `p1.exe` (single-core), `p.exe` (MPI/parallel), `p6.exe`.
- **Author-made improvements (2016)**: EvgeniX (#339, 2016-10-30) thanks Laikov "за доработку ПРИРОДы (снятие ограничения на выделение памяти для решения SCF задачи - можно больше итераций/микроитераций использовать и снятие ограничений на размер электронной структуры при расчёте гессиана)". Translation: for improving Priroda by removing the memory-allocation limit for the SCF problem (so more iterations/micro-iterations can be used) and removing the electronic-structure size limit for Hessian calculations. This implies older versions had such limits. [experienced user]

### Obtaining, installing, versions — pages 21-23, posts #401-#460, 2018-12..2020-11

- Priroda 6 is referred to as the version that "should parallelize":
  KuznetsovSM (quoted in #401 by EvgeniX, original post Nov 22 2018, on earlier pages):
  "Как исправить?" / "Вроде Природа 6 должна параллелиться..." ("How to fix? / Priroda 6 is
  supposed to run in parallel...", after his `orterun.exe -np 2 p6.exe` crash).
  **Answer, #401 EvgeniX (Dec 11 2018)** [experienced user]: "Взять версию 17, которая
  поддерживает распараллеливание (начиная с 16) с сайта Лайкова Д.Н." ("Take version 17, which
  supports parallelization (from version 16 on), from D.N. Laikov's site.") And: "Никому ничего
  она не должна. Там всё внутрь вшито, уже не исправить. Например, гессиан в 6-й версии
  параллелится не более, чем на 2-х ядрах, в 17 версии можно и на 4-х и больше..." ("It isn't
  obliged to do anything. Everything is hard-wired inside and can't be fixed now. For example,
  the Hessian in version 6 parallelizes on at most 2 cores; in version 17 you can use 4 or
  more...") So: **use Priroda 16/17 for parallel runs; Priroda 6 is effectively not usable in
  parallel** (Hessian ≤ 2 cores).
- Official registration: #404 EvgeniX (Dec 11 2018), answering mizuchi's "why is Priroda
  needed at all": "Импортозамещение! На прогу и свидетельство о регистрации в Росреестре есть."
  ("Import substitution! The program even has a registration certificate with Rosreestr [the
  Russian state registry].") [experienced user]
- Licence: #443 EvgeniX (Dec 18 2018) asked whether Priroda has a licence agreement.
  #444 Metalian (Dec 18 2018): "Задай ему этот вопрос что ли... Раз она выложена на официальном
  сайте для свободного скачивания, то, видимо, никаких негативных последствий ее использование и
  ссылки на ее использование понести не должны. Но таки-да, соглашения никто из пользователей,
  думаю, не подписывал + сомнительно, что ее разработчик имеет юрлицо или даже ИП." ("Ask him,
  I suppose... Since it is posted on the official site for free download, using it and citing
  its use should have no negative consequences. But indeed, I think no user has signed any
  agreement, and it is doubtful the developer has a legal entity or is even a sole
  proprietor.") [opinion]
  #445 madschumacher (Dec 20 2018): "Пару лет назад не имело. Это Д.Н.Л. ответил в личной
  переписке (что у него руки на тот момент не дошли до этого)." ("A couple of years ago it
  had none. D.N.L. [Laikov] said so in private correspondence: he had not got round to it
  at that point.") [second-hand from Laikov]
- Laikov is busy with his main job and does not always answer e-mail quickly or in detail
  (#406 Metalian, Dec 11 2018) [experienced user]. #402 Гесс suggests writing to Laikov
  directly about basis-set details.

### Obtaining, installing, versions — pages 24-26, posts #461-#518, 2020-11..2026-07

- **Latest version (as of Jul 2024): "Priroda 23 (2023.06.22) (последняя)"**. #509 amge, Jul 15 2024 [experienced user]. He says "Все работает как и раньше" ("everything works as before").
- **Windows download page:** https://rad.chem.msu.ru/~laikov/p_w/ #503 idimicur, Nov 16 2023. It contains the files `p1.exe`, `p1_190306.exe`, `p_190306.exe`, `xm.exe` and `cygwin1.dll`. The poster said it was "решительно непонятно, что с этим делать" ("completely unclear what to do with them").
  - The `190306` suffix looks like a build date (2019-03-06). Presumably `p1*.exe` is the serial (1-process) build and `p_*.exe` the parallel build [inference, unverified].
  - **`xm.exe`**: "Да, это визуализатор .out файлов для Linux" ("Yes, it is a viewer for .out files for Linux"). #507 Tasha, Mar 29 2024 [experienced user]. The question came from #505 spa. Metalian (#506, Mar 28 2024) had answered first: "Если правильно помню, то визуализатор. Но не уверен." ("If I remember correctly, it's a viewer. But I'm not sure.") It is odd that a .exe would be "for Linux". It may be a Windows port of Laikov's `xm` viewer.
- **New in v23:** an example input `2H6C6_n3.dfl6a.1a.in` "появился одновременно с последней версией Природы" ("appeared together with the latest version"). amge thinks it is the dispersion-including DFT functional (see the DFT section). #512 amge, Jul 18 2024.
- **Results change between versions:** Tasha noticed that "программа от версии к версии выдает разные параметры для идентичного инпута" ("the program gives different values for an identical input from version to version"). She saw this on critical points. #513 Tasha, May 2 2026.
  - amge confirms it (#514, May 4 2026) [experienced user]: "свежая Природа стала считать быстрее, но выдавать немного другую энергию. Т.е. опасно сравнивать близкие энергии, посчитанные в разных версиях. В пределах одной версии нормально."
  - Translation: "the fresh Priroda became faster but gives slightly different energies, so it is dangerous to compare close energies computed with different versions. Within one version it is fine."
  - He adds that ORCA behaves the same way between versions 5 and 6.
  - **Manual advice:** keep all compared calculations on one Priroda version.
- **Documentation:** the old online doc "Природа_для_самых_маленьких" ("Priroda for the very young") used to be at http://wt.knc.ru/ and is now unavailable. The poster asked where online docs are, and the extracted posts contain no direct answer. #477 Yellow21chem, Dec 10 2021.
- **Manual mirror (PDF):** the old KNC wiki documentation survives as a PDF at https://monitor.hpc.umanitoba.ca/doc/Priroda_Documentation_from_KNCWiki.pdf, cited by Гесс (#468, Nov 7 2020) as the source of his `disk=` quote. [manual mirror; URL as of 2020]
- **Laikov's manual text on `disk=`** is quoted in #468 (see the Memory section). Ahha (#469) could not find that manual by googling.

## 2. Running (command line, mpirun, environment, Windows/Linux)

### Running (command line, mpirun, environment, Windows/Linux) — pages 1-4, posts #1-#80, 2009-02..2011-08

- Command line: `p6 1.in 1.out` (input file, output file) — #64 EvgeniX, 20 May 2011 [experienced user]. Windows: `p6.exe H2OHOH.df.b1.in H2OHOH.df.b1.out` (#20; H2OHOH.df.b1.in is one of the sample inputs shipped with the program).
- Parallel run: `p6 -np 2 1.in 1.out`, where `-np 2` = number of cores — #66 EvgeniX, 26 May 2011 [experienced user].
- "Под Windows многоядерности нет." (No multi-core under Windows) — #66 EvgeniX. User says that even on 1 core the speed was pleasing (#67 Любитель_Манниха).
- Windows/Cygwin line-ending problem: input files with DOS line endings (CRLF) break the parser (see Known errors). Fix: `dos2unix` on the input, or in FAR Manager: `FAR->1.in-F4->shift+F2->UNIX(LF)->F2` — #64 EvgeniX; confirmed fixed by #65 Любитель_Манниха ("Действительно dos2unix исправил положение").
- Quotes in the basis keyword: the sample input pasted had typographic quotes `basis=»3z.bas»`; EvgeniX: "Только заменить на basis="3z.bas"" (just replace with straight quotes `basis="3z.bas"`) — #64.

### Running (command line, mpirun, environment, Windows/Linux) — pages 5-8, posts #81-#160, 2011-08..2012-04

- **Basic command lines** — #127 EvgeniX, 26 Nov 2011 [experienced user]:
  ```
  p6.exe input.in output.out
  p6_64 -np 2 input.in output.out
  ```
  (Windows serial; 64-bit Linux parallel with `-np N`). #151 repeats: `p6_64 -np 4 file.in file.out`.
- **Windows "cannot open input file":** user put `p6.exe`, `cygwin1.dll`, input files and basis folder in folder PR6 and ran `p6.exe input.in output.out`; got `cannot open input file`. amge #131: first `cd` into the folder, then run:
  ```
  cd "путь к этой папке"
  p6.exe input.in output.out
  ```
  User said she already did that (#132). EvgeniX #133 (29 Nov 2011) [experienced user] replied with a link to his own post #128 (`viewtopic.php?f=71&t=28803&start=120#p566632` [URL http://www.chemport.ru/forum/viewtopic.php?f=71&t=28803&start=120#p566632]) — "пробовали?" (have you tried it?), i.e. use the `priroda.cmd` + FAR Manager script below, which `cd`s into the Priroda folder and sets `TMPDIR` itself. Likely causes from elsewhere in this page range: Word/Unicode/CRLF input files (see Known errors). Unresolved in thread.
- **Linux: must give explicit path to the executable** (current dir not in PATH) — #153 EvgeniX, 15 Jan 2012 [experienced user]:
  ```
  cd /home/asp/bin/priroda
  ./p -np 4 h.in h.out
  ```
  or
  ```
  /home/asp/bin/priroda/p -np 4 /home/asp/bin/priroda/h.in /home/asp/bin/priroda/h.out
  ```
  asp #154: the second form (full absolute paths everywhere) worked, "только ещё пришлось в инпут файле прописать полный путь к файлу с базисом" (also had to put the full path to the basis file in the input).
- **Do not launch via the bundled mpiexec directly:** `mpiexec -np 4 p file.in file.out` → `Error in system call mpiexec: No such file or directory` / `mpiexec could not exec p` (#150); `/home/asp/bin/priroda/mpiexec -n 4 /home/asp/bin/priroda/p ...h.in ...h.out` → `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` with 100% load on all cores and output stopping after the node list (#152). Correct way: the Priroda binary itself takes `-np N` (#153). (The MPI_Abort was presumably caused by the relative basis path — asp #154 had to give the full basis path.)
- **Windows convenience script `priroda.cmd` (from qchem.ru) with FAR Manager 2 integration** — #128 EvgeniX, 26 Nov 2011 [experienced user, "Скрипт от qchem.ru"]. Steps:
  1. Copy all Priroda files to `C:\Program Files\Priroda` (or `%ProgramFiles%\Priroda`).
  2. Install FAR 2.0.
  3. Create `C:\Program Files\Priroda\priroda.cmd`:
  ```
  @echo off
  cls
  title *** QChem.Ru & Квантовая-Химия.РФ ***
  echo.
  echo   ╓─────────╖
  echo   ║ PRIRODA ║
  echo   ╙─────────╜
  if '%1'=='' goto noparam
  if '%1'=='-install' goto Install
  if '%1'=='-priroda' goto Priroda
  goto noparam
  rem --- Installation -------------------
  :Install
  rem ··· Far Manger 2 Config ···
  reg add "HKCU\Software\Far2\Associations\Type0" /v "Mask" /t "REG_SZ" /d "*.in" /f >nul
  reg add "HKCU\Software\Far2\Associations\Type0" /v "Description" /t "REG_SZ" /d "Priroda" /f >nul
  reg add "HKCU\Software\Far2\Associations\Type0" /v "Execute" /t "REG_SZ" /d "\"%ProgramFiles%\Priroda\priroda.cmd\" -priroda \"!\!.!\" \"!\!.out\"" /f >nul
  reg add "HKCU\Software\Far2\Associations\Type0" /v "AltExec" /t "REG_SZ" /d "" /f >nul
  reg add "HKCU\Software\Far2\Associations\Type0" /v "View" /t "REG_SZ" /d "" /f >nul
  reg add "HKCU\Software\Far2\Associations\Type0" /v "AltView" /t "REG_SZ" /d "" /f >nul
  reg add "HKCU\Software\Far2\Associations\Type0" /v "Edit" /t "REG_SZ" /d "" /f >nul
  reg add "HKCU\Software\Far2\Associations\Type0" /v "AltEdit" /t "REG_SZ" /d "" /f >nul
  echo.
  echo installed
  echo.
  ping localhost > nul
  goto end
  rem --- Priroda ------------------------
  :Priroda
  if '%2'=='' goto noparam
  if '%3'=='' goto noparam
  echo.
  echo Input: %2
  echo Output: %3
  echo.
  if exist %3 goto PrirodaExist
  rem cd /d "%ProgramFiles%\Priroda"
  rem "%ProgramFiles%\Priroda\dos2unix.exe" %2 > nul
  rem echo.
  cd /d "%ProgramFiles%\Priroda"
  for /d %%i in ("%TEMP%") do (set TEMP83=%%~si)
  set TMPDIR=%TEMP83%
  "p6.exe" %2 %3
  echo Calculation completed!
  goto end
  :PrirodaExist
  echo File %3 exists. End calculation.
  goto end
  rem ------------------------------------
  :noparam
  echo.
  echo Usage:
  echo.
  echo  "priroda -install" for config Windows and Far Manager
  echo.
  echo  "priroda -priroda file.in file.out" for start PRIRODA
  rem ------------------------------------
  :end
  ```
  4. Run once: `%ProgramFiles%\Priroda\priroda.cmd -install`. Then select an `.in` file in FAR and press Enter to run.
  - Features: "Не нужно указывать директорию для временных файлов, временные файлы будут записываться в системную директорию для временных файлов" (no need to give a temp dir — temp files go to the system temp dir; this works via env var **`TMPDIR`** set to the 8.3 short form of `%TEMP%`); "Не нужно указывать полный путь к файлу с базисными наборами, достаточно указывать basis="3z.bas" или basis="basis.in"" (no full basis path needed, because the script `cd`s into the Priroda folder). It refuses to overwrite an existing output file. Commented-out line shows optional `dos2unix.exe` conversion of the input.
  - **Env var:** `TMPDIR` controls Priroda's temp directory (implied by script). [experienced user]
- OrganikNV #129: failure of the plain command may have been because she did not specify the temp-file path ("не указывала путь к временным файлам") [unverified].

### Running (command line, mpirun, environment, Windows/Linux) — pages 9-12, posts #161-#240, 2012-04..2013-12

#### Linux "input file not found" saga (#161-#174, Apr 2012)
User Любитель_Манниха could not get the Linux binary to read `task.in`.
- **#161 Любитель_Манниха, 22 Apr 2012**: the path in the input was misspelled as "pridoda", but fixing it changed nothing ("в моей копипасте (и командной строке) ошибка, "pridoda" для инпута, но её исправление ничего не меняет"). "А если запускать, не указывая путь, то результат такой" (running without giving a path), verbatim:
  ```
  malloc: using debugging hooks

  [0] MPI Abort by user Aborting program !

  [0] Aborting program!
  ```
  "Причём, если названия файлов содержат большие буквы, добавляется такое ругательство" (and if the file names contain capital letters, this extra complaint is added):
  ```
  0: output file 'tasK.out'?
  ```
  So even the serial run prints MPI-style abort messages (the binary is MPI-linked), and **capital letters in file names provoke an `output file '...'?` complaint** — keep input/output file names lower-case. [unverified user observation]
- **#162 amge, 22 Apr 2012** [experienced user]: first check `ls -l /home/quantum/priroda/task.in`.
- **#163**: from inside `/home/quantum/priroda`, `ls -l task.in` gives `-rw------- 1 username users 5211 Apr 22 02:33 task.in`, but the absolute path gives `ls: cannot access /home/quantum/priroda/task.in: No such file...`. The directory did not really exist under that path (see #166).
- **#164 EvgeniX**: asked for the output of `ls /home`, `ls /home/quantum`, `ls /home/quantum/priroda`. **#165 starless**: also `who am i`.
- **#166**: `ls /home` → `lost+found  username`, so `/home/quantum` does not exist.
- **#167 starless**: "Откуда возьмётся файл, которого нет? пропиши правильный путь к нему" (Where would a non-existent file come from? Give the correct path to it.)
- **#168**: the user moved Priroda to `home/abcd/priroda` with the same effect. As root the run seemed to start, and it worked "not for all file names" (unexplained).
- **#169 starless**: "Надо работать не в /home, а в /home/username" (Work in /home/username, not in /home.)
- **#170**: correction: as root it also only printed `malloc: using debugging hooks` and did not return to the prompt. In `home/username/priroda` it still said "no such file".
- **#171 amge, 23 Apr 2012** [experienced user]: full recipe, verbatim:
  ```
  по рутом
  chown -R username.users /home/username
  под собой
  chmod -R +r /home/username
  проверьте, что во все директории можете входить (все строки следующей команды должны начинаться с drwx)
  ls -r -l /home/username/* | grep ^d
  После этого создайте директорию priroda, если ее нет
  mkdir /home/username/priroda
  поместите туда файлы p6_64 и task.in
  зайдите в нее
  cd /home/username/priroda
  и запускайте
  p6_64 task.in task.out
  ```
  In English: as root, chown your home directory. As yourself, make it readable. Check that every directory line starts with `drwx`. Create `~/priroda`, put the binary `p6_64` and `task.in` there, cd into it, and run **`p6_64 task.in task.out`**. So the command form is: binary, input file, output file.
- **#172 Любитель_Манниха, 23 Apr 2012**: as root: ``chown: cannot access `/home/username/.gvfs': Permission denied``. As himself he typed `chown` instead of `chmod` (``chown: invalid user: `+r'``). "Все строки начинаются с drwxr" (all directory lines start with drwxr). As root Priroda does work, "просто файл .out создаётся почему-то не сразу" (the .out file just does not appear immediately, probably output buffering). As a normal user the .out contains, verbatim:
  ```
  molecule input: ''

  'cartesian

  ' ?
  ```
  "Хотя инпут корректный, в винде и под рутом работает" (although the input is correct and works on Windows and as root), and also:
  ```
  OOPS: semop lock failed 98304
  ```
  See Known errors.
- **#173 amge, 23 Apr 2012** [experienced user]: "Под собой я предлагал сделать не chown (изменить собственника), а chmod +r (разрешить на чтение)" (as yourself I suggested not chown (change owner) but chmod +r (allow reading)). "Правильно я понял, что под юзером природа стала таки видеть инпут-файл? Но не может его прочесть?" (So as a user Priroda now sees the input file but cannot read it?) Try:
  ```
  cd /home/$USER/priroda
  chmod +r *
  ls -la
  ```
  Note the `molecule input: '' 'cartesian ' ?` error shows a stray line break right after `cartesian` — consistent with a CR character (DOS line ending) — hence sanya1024's `dos2unix` advice in #174.
- **#174 sanya1024, 24 Apr 2012** [experienced user]: convert `task.in` from DOS/Windows line endings to Unix with **`dos2unix`**. "Если в файле уже были юниксовые концы строк, хуже ему не станет" (If the file already had Unix line endings it will not hurt.) The thread does not say whether this fixed the problem.

Takeaways for the manual:
1. Run in a directory you own and can write to.
2. Command form: `p6_64 input output`.
3. Use Unix line endings in the input.
4. `OOPS: semop lock failed` points to a SysV semaphore or permission problem, which shows up as a normal user and not as root.
5. Avoid capital letters in input/output file names (`0: output file 'tasK.out'?`, #161).

#### Windows
- #206, #210, #211: Priroda runs on Windows 7 64-bit through Cygwin.

### Running (command line, mpirun, environment, Windows/Linux) — pages 13-16, posts #241-#320, 2013-12..2015-06

- **Windows paths.** #319 Aryl (Jun 25, 2015) gives a basis file by absolute Windows path in `$control`: `basis=D:\NMR\Nature\basis\6-31+G(d)`. The output echoes `Basis set input: 'D:\NMR\Nature\basis\6-31+G(d)'`. The working directory is set with `path=.` in `$system`. The header prints the node: `node  0: 'Sasha_PC'`.
- **Silent hang on Linux.** #315 Любитель_Манниха (Apr 27, 2015): under openSUSE 13.2 the output stopped right after the header block (`scf options...`, `grid: accuracy=...`). `top` showed the process still using memory and CPU, with no zombie processes.
  - #316 Гесс [experienced user]: "Оно в районе старта не создало еще один файл там же где запускалось? Похоже что оно подвисло, такое часто." ("Did it create another file next to where it was started? It looks hung; that happens often.")
  - #317: it was indeed hung. Killing the processes added nothing to the output.
  - #318 Гесс, debugging advice: look for new files named after the input, the output or the launch script in (1) the input folder, (2) the output folder, (3) the Priroda folder and (4) the home folder. If there are none, "все очень грустно и надо перебирать все подряд ища из-за чего оно умирает" ("it's grim, and you have to try everything to find out why it dies").
- Header from that hung run, verbatim (173 atoms, PBE):
```
 | Number of atoms                    173
 | Charge of molecule                   1
 | Spin multiplicity                    1
 | Number of alpha electrons          339
 | Number of beta  electrons          339
 | Number of core  electrons           95
 | Theoretical Method                 DFT
 | Approximation to E(xc)             PBE
 | Dimension of wavefunction basis   1733
 | Dimension of   auxiliary  basis   4233
 | Hamiltonian: non-relativistic
 +---------------------------------------
 scf options: conv=1.0e-06, 1.0e-03; iter=50,16
 cut-off for S,T,V integrals: 1.0e-10 (1.0e-06)
 grid: accuracy=1.0e-08,1.0e-05, cut=1.0e-10,1.0e-07
```

### Running (command line, mpirun, environment, Windows/Linux) — pages 17-20, posts #321-#400, 2015-06..2018-12

#### Windows: no full Cygwin needed
- **#362 amge, 2016-12-09** [experienced user]: "Зачем ставить весь cygwin? На сайте Лайкова есть все нужные dll'ки. Просто положите их туда же, куда и exe'шник Природы. Это даже лучше, т.к. не факт, что ваш cygwin подойдет для exe'шника, не под ним скомпилированного." Translation: there is no need to install all of Cygwin. Laikov's site has all the needed DLLs; put them in the same folder as the Priroda exe. This is even better, because your own Cygwin may not suit an exe that was not compiled under it.
- **#370 EvgeniX, 2017-01-30** [experienced user], replying to that, disagrees for the parallel build: "На сайте не все необходимые DLL.." ("Not all the necessary DLLs are on the site"). See the full recipe in the next subsection. About the result: `p.exe` "Работает и никаких ошибок не выводит. Памяти сколько угодно видит. Для 64-битной одноядерной версии достаточно файла cygwin1.dll и никаких административных прав не нужно." Translation: it works with no errors and sees any amount of memory. For the 64-bit single-core version, the file `cygwin1.dll` alone is enough, and no administrator rights are needed.
- **Command lines recommended by Laikov** (relayed by amge in #365, 2016-12-10) [semi-authoritative]:
  ```
  p1.exe C60.qm.in C60.qm.w.1.out          (на одном ядре / on one core)
  mpirun.exe -np 2 p.exe C60.qm.in C60.qm.w.2.out   (на нескольких ядрах / on several cores)
  ```
  The syntax is `<exe> <input> <output>`. amge himself could not get these to run on an old Windows XP guest under VirtualBox.
- **Cygwin environment pitfall (#360 Ahha, 2016-12-08)**: LVictor hit an error on Win10 when starting from the command line (screenshot not available). Ahha points to the Cygwin mailing-list post `https://cygwin.com/ml/cygwin/2013-12/msg00296.html` and quotes: "the program runs in SH.exe (and mintty.exe) but gives this message when run from a DOS box: `Warning: '/dev/shm' does not exists or is not a directory.`" Advice: "попробуйте запустить из sh.exe или mintty.exe" (try launching from sh.exe or mintty.exe). The explanation quoted from the list: running Cygwin tools outside the Cygwin distro with its own DLL requires setting up "a matching environment" around that DLL. His interpretation: "при запуске из cmd.exe не устанавливаются нужные переменные окружения" (when launched from cmd.exe, the needed environment variables are not set). Otherwise something is misconfigured in Cygwin. [experienced user] The `dev\shm` directory trick in #370 below is the fix that allows launching from cmd.exe.

#### Windows parallel setup without a Cygwin terminal (#370 EvgeniX, 2017-01-30) [experienced user]
"Для запуска параллельной 64-разрядной версии нужно скачать 64-разрядную CygWin, установить базовую поставку, плюс библиотеку OpenMPI, оттуда перекачать следующие модули (больше CygWin будет не нужен)" (to run the parallel 64-bit version, download 64-bit Cygwin, install the base distribution plus the OpenMPI library, and copy the following modules from it; Cygwin itself is then no longer needed):
1. `cygwin1.dll`
2. `cyggcc_s-seh-1.dll`
3. `cygmpi-12.dll`
4. `cygopen-pal-13.dll`
5. `cygopen-rte-12.dll`
6. `orterun.exe`

- "cygwin1.dll нужно брать именно из поставки CygWin, т.к. версии остальных DLL работают только с ней." (`cygwin1.dll` must be taken from the same Cygwin distribution, because the versions of the other DLLs work only with it.)
- **`dev\shm` and `dev\mqueue` trick**: "Чтобы не запускать из-под терминала CygWin нужно на директорию выше, из которой запускается ПРИРОДА создать директорию dev, а внутри поддиректории shm и mqueue. Когда библиотеки CygWin не находят установленное окружение, они считают, что корень окружения / находится на директорию выше, чем то место, откуда происходит запуск." (To avoid launching from the Cygwin terminal, create a directory `dev` one level above the directory Priroda is launched from, with subdirectories `shm` and `mqueue`. When the Cygwin libraries do not find an installed environment, they assume the root `/` is one directory above the launch location.) Example: with Priroda in `C:\Priroda 16`, you need `C:\dev\shm` and `C:\dev\mqueue`.
- "Если программа лежит в системных директориях, вроде C:\Program Files, то запуск нужно вести от администратора." (If the program is in a system directory such as `C:\Program Files`, run as administrator.)
- Launch (cmd.exe):
  ```
  cd /d "C:\Priroda 16"
  set TMPDIR="%TEMP%"
  "orterun.exe" -np 2 ./p16_64_parallel.exe "C:\Work\file.in" "C:\Work\file.out"
  ```
  (`p16_64_parallel.exe` = `exe64/p.exe` from Laikov's site.) Note `TMPDIR` is set to the Windows temp directory.
- "Для 64-битной одноядерной версии достаточно файла cygwin1.dll и никаких административных прав не нужно." (For the 64-bit single-core version, `cygwin1.dll` alone suffices and no admin rights are needed.)

#### Windows parallel setup with Cygwin OpenMPI (#397 Любитель_Манниха, 2018-11-12) [experienced user]
- Install Cygwin (64-bit). In the installer, search for the `openmpi` package and tick it, and do not cancel the default packages.
- Installer link given: `https://cygwin.com/setup-x86_64.exe`. First requirement: "нужна версия Природы, которая это поддерживает" (you need a Priroda build that supports parallel runs).
- He then relays EvgeniX's #370 instructions in full (DLL list, `dev\shm`/`dev\mqueue`, admin rights; see above), with the launch command in the form `orterun.exe -np 2 p.exe "C:\Work\file.in" "C:\Work\file.out"`. His correction for newer OpenMPI: "там нет файлов `cygopen-pal-13.dll` `cygopen-rte-12.dll` а есть ...pal40 и rte-40, берёте их". Translation: those files are absent, there are ...pal40 and rte-40 instead, so take those (i.e. `cygopen-pal-40.dll`, `cygopen-rte-40.dll`).
- **Network pitfall**: "Если у вас комп подключён через WiFi, при этом в списке устройств есть LAN-адаптер - отключите его. Иначе тупой Openmpi будет вываливаться с ошибкой `"tcp_peer_send_blocking: send() to socket 12 failed: Transport endpoint is not connected (128)"`". Translation: if the PC is on WiFi but has a LAN adapter listed, disable that adapter, or OpenMPI crashes with that error.
- Related observation, **#374 EvgeniX, 2017-06-04**: "если вытащить Ethernet кабель, то считает только на 1,3-ядрах. А если обратно вставить, то на всех." Translation: under Windows, unplugging the Ethernet cable makes the parallel run use only cores 1 and 3; plugging it back in restores all cores.
- See Known errors for the `orterun.exe` failure (#398).

### Running (command line, mpirun, environment, Windows/Linux) — pages 21-23, posts #401-#460, 2018-12..2020-11

- #406 Metalian: runs Priroda on a personal computer under Ubuntu, 24x7. Point made: on such
  modest hardware you can't do much with other programs. [experienced user]
- #460 KuznetsovSM runs on a cluster (see Known errors).

### Running (command line, mpirun, environment, Windows/Linux) — pages 24-26, posts #461-#518, 2020-11..2026-07

#### Windows, serial (#504 spa, Mar 18 2024) [user]
> Копируете все файлы например в папку C:\pr\
> Запуск C:\pr\p1.exe C:\pr\имя_исходного_файла C:\pr\имя_выходного_файла

Translation: copy all files to e.g. `C:\pr\`, then run `C:\pr\p1.exe C:\pr\<input_file> C:\pr\<output_file>`. The syntax is `p1.exe input output`, with the input as the first argument and the output as the second.

#### Windows, parallel 64-bit via Cygwin OpenMPI (#472 Tasha, Jun 11 2021)
Tasha re-posts an older answer by Любитель_Манниха (Nov 12 2018), which itself quotes EvgeniX [experienced users].

- "Во-первых, нужна версия Природы, которая это поддерживает." ("First, you need a Priroda version that supports this.")
- Download Cygwin from https://cygwin.com/setup-x86_64.exe. In the installer, search for and tick the package **openmpi**, and keep the default packages.
- A newer OpenMPI no longer has `cygopen-pal-13.dll` and `cygopen-rte-12.dll`. It has `...pal-40` and `...rte-40` versions instead, and you take those.

EvgeniX's original instructions, verbatim:
```
Для запуска параллельной 64-разрядной версии нужно скачать 64-разрядную CygWin, установить базовую поставку, плюс библиотеку OpenMPI, оттуда перекачать следующие модули (больше CygWin будет не нужен):

1) cygwin1.dll
2) cyggcc_s-seh-1.dll
3) cygmpi-12.dll
4) cygopen-pal-13.dll
5) cygopen-rte-12.dll
6) orterun.exe

cygwin1.dll нужно брать именно из поставки CygWin, т.к. версии остальных DLL работают только с ней.

Чтобы не запускать из-под терминала CygWin, нужно на директорию выше, из которой запускается ПРИРОДА создать директорию dev, а внутри поддиректории shm и mqueue. (Когда библиотеки CygWin не находят установленное окружение, они считают, что корень окружения / находится на директорию выше, чем то место, откуда происходит запуск.) Если программа лежит в системных директориях, вроде C:\Program Files, то запуск нужно вести от администратора.

Сам запуск ведётся командой вида:

orterun.exe -np 2 p.exe "C:\Work\file.in" "C:\Work\file.out"
```
English summary:
- Install 64-bit Cygwin with the base packages and OpenMPI.
- Copy out the six files listed above. After that, Cygwin itself is no longer needed.
- `cygwin1.dll` must come from that same Cygwin installation, because the other DLLs only work with matching versions.
- To run outside the Cygwin terminal, create a `dev` directory one level above the directory Priroda runs from, with subdirectories `shm` and `mqueue`. When the Cygwin libraries cannot find an installed environment, they treat the parent of the launch directory as root `/`.
- If Priroda lives in a system directory such as `C:\Program Files`, run it as administrator.
- Launch with: `orterun.exe -np 2 p.exe "C:\Work\file.in" "C:\Work\file.out"`.

**Tasha's report (#472, Jun 11 2021):** "Столкнулась с проблемой. На дворе 2021 год, и инструкция от 2018 годе перестала работать. Операционка Win10-64. Запускаю под cygwin64 терминалом, но выдает следующую ошибку: [screenshot]" ("I ran into a problem. It's 2021 and the 2018 instructions stopped working. OS Win10-64. I run it under the cygwin64 terminal, but it gives the following error: [screenshot]"). The error text was only in a screenshot (`2021-06-11_11-19-14.jpg`) and is not available; no fix appears in the thread. So this recipe may need adapting to newer Cygwin/OpenMPI versions. [user report]

#### Linux/WSL
- leshii (#508, Jul 2024) runs Priroda under **WSL** on Windows.

## 3. Parallel / MPI

### Parallel / MPI — pages 1-4, posts #1-#80, 2009-02..2011-08

- Linux only; `p6 -np N in out` — #66 EvgeniX, 26 May 2011 [experienced user].
- `path=` for multi-core: the sample input showed `path=/tmpa:/tmpb:/tmpc:/tmpd` (colon-separated list of scratch dirs, one per process); user reported it "не работает" (#65). EvgeniX: "для многоядерности достаточно "path=/tmp", несколько дисков пишут, когда есть несколько независимых скоростных дисков." (For multi-core `path=/tmp` is enough; several directories are given when you have several independent fast disks.) — #66.
- Scaling (2011, p6-era): "Большинство задач распараллеливается только на 2 ядра, оптимизация/сканирование/IRC/энергия иногда работает на 4-х." (Most tasks parallelize only on 2 cores; optimization/scan/IRC/energy sometimes work on 4.) — #66 EvgeniX [experienced user; version-specific].

### Parallel / MPI — pages 5-8, posts #81-#160, 2011-08..2012-04

- Windows Priroda is **not parallel**: "Беда только, что виндовская Природа -- не параллельная" — #99 sanya1024, 19 Sep 2011 [experienced user]. Hence asp's wish to install Linux to use several cores (#148).
- Linux parallel run: `p6_64 -np 4 file.in file.out` (#151) / `./p -np 4 h.in h.out` (#153). Output header then shows `parallel on  4 processors` and `node  0: 'linux-ldmm'` … `node  3: ...` (#152).
- Scaling benchmark: see Performance.

### Parallel / MPI — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#180 Metalian, 15 Jan 2013**: asked how many cores optimization, Hessian and IRC can use efficiently. **#182 Metalian** repeated: "На сколько ядер эффективно распараллеливается Природа?" and whether one PCI-E SATA controller with two SSDs suffices for an 8-core CPU running 2 parallel jobs × 4 cores; also "сколько вообще памяти умеет использовать программа?" and how big the temp files are.
- **#193 Metalian** asked whether all-core load in amge's AMD comparison was >95%. No answer.
- **#194 EvgeniX, 16 Jan 2013** [experienced user], on whether Priroda can finish several IRCs overnight: "Вряд-ли, это всё-таки IRC, где по-хорошему шагов много. ... Вообще, зависит также от систем. Для ярко выраженных максимумов и IRC лучше считается." (Unlikely — a proper IRC has many steps. It depends on the system; for sharply pronounced maxima IRC runs better.)
- **#183 Лечащий Врач** [experienced user]: "На 8-ядерной машине параллелится практически оптимально" (on an 8-core machine it parallelizes almost optimally). This is on 2×4-core Xeons with Priroda 11.
- **#181 Лечащий Врач**: "параллелизация объем требуемой памяти почти не увеличивает" (running in parallel barely increases the memory needed).
- **#185 EvgeniX, 15 Jan 2013** [experienced user]: "При распараллеливании объём потребляемой ОЗУ не меняется. При распараллеливании гессиана весь диск жрёт преимущественно 1-й процесс" (Running in parallel does not change RAM use. In a parallel Hessian run, the first process uses nearly all of the disk.)
- **#189 Лечащий Врач**: one powerful machine beats two weak ones. Two machines only stay busy if the jobs are fully independent and routine. Otherwise "вы за сведение scf в каждой из систем будете натурально биться" (you will be fighting to get SCF to converge on each of them).

### Parallel / MPI — pages 13-16, posts #241-#320, 2013-12..2015-06

- **MPI_Abort error with hybrids under `theory=dft`.** #307 Гесс (Sep 30, 2014): "кто нибудь сталкивался с `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` при замене чистого функционала типа PBE на гибридный типа B3LYP или PBE1?" (has anyone seen MPI_Abort when replacing a pure functional like PBE by a hybrid like B3LYP or PBE1?). "Задача замирает после двукратного чтения `Basis set input: './basis.in'`" (the job freezes after reading the basis twice), i.e. the next lines that should appear (`+-----` / `| Number of atoms`) never come. He knew about ridft (link: viewtopic.php?f=71&t=24024#p185535 [URL http://www.chemport.ru/forum/viewtopic.php?f=71&t=24024#p185535]) but wanted `theory=dft` test runs for comparison. #309 Гесс: alxyppv's sample input (ridft) runs fine, "При замене на dft происходит тоже самое что и с моими инпутами" (switching it to dft gives the same failure). So in this (2014) Priroda version **hybrid + `theory=dft` aborts with MPI_Abort right after basis input** — see amge #310 in DFT functionals. See Known errors.
- **16-process runs.** #289 Гесс: with 16 processes, only 16 of the many temp files are non-empty (one per process). See Memory/disk.
- **Disk warning printed by Priroda**, quoted in #293: "For all methods the performance will be degraded terribly if more than one process read and write large files on the same physical drive!" Гесс: "Не найду я природе 16 независимых физических дисков" ("I won't find 16 separate physical disks for Priroda"). He ignored the warning and put all temp files on one fast disk.

### Parallel / MPI — pages 17-20, posts #321-#400, 2015-06..2018-12

- **Scaling limits of Priroda DFT** (#343 EvgeniX, 2016-10-31) [experienced user]: "DFT - больше 8 ядер смысла нет =) Даже (C60)9 на 8 ядрах эффективнее. Это какой-то предел для текущей реализации. Там хоть 32 ядра используй, а выигрыш не больше 10% от 6-8." Translation: beyond 8 cores there is no point for DFT. Even (C60)9 runs more efficiently on 8 cores. Even with 32 cores, the gain over 6-8 is at most 10%.
  - "С RI-MP2 ... оно параллелится лучше, по крайней мере, по памяти точно (в отличие от ПРИРОДной DFT)". Translation: RI-MP2 parallelizes better, at least memory-wise, unlike Priroda's DFT.
- **amge (#344, 2016-11-01)** [experienced user]: "Про DFT в Природе уточню: больше одной ноды смысла нет." (For DFT, using more than one node is pointless.) Benchmark: a 38-step geometry optimization of C6H13O4 on 8-, 12- and 24-core nodes took **101, 63 and 37 s** respectively, so scaling within one node is good. He saw no speedup beyond one node.
- Гесс (#345): C6H13O4 is small, so degraded scaling is not surprising. "Мы тестили на фенилпорфиринах." (We tested on phenylporphyrins.)
- **Upper limit on cores** (Гесс #342, 2016-10-30) [experienced user]: when choosing a code for a highly parallel cluster (40-core nodes, with a strong recommendation against using few nodes per job), he tested Priroda, "но выяснилось что больше чем на 500 (емнип) ядер она вообще параллелиться не хочет да и до этого выиграш от параллелизма был какой-то мутный" (but it turned out that beyond about 500 cores (iirc) it does not parallelize at all, and even below that the gain from parallelism was murky).
- Гесс (#396, 2018-11-11): "Да паллелится оно, параллелится." (Yes, it does parallelize.)
- KuznetsovSM (#394, 2018-11-11), answering whether Priroda supports parallel computing: "Да, у Лайкова даже есть статья, в которой он приводит вычислительные времена для разных задач и веществ при разных количествах ядер." (Yes, Laikov even has a paper giving computation times for various tasks and compounds at different core counts.) The paper is not named. [experienced user]
- RI: Гесс (#333, 2016-09-26) claims "Ri насколько я понимаю там не задействован" (as I understand it, RI is not used there) and says the speedup vs Gaussian is "не в десятки раз" (not tens of times). [unverified; contradicts the known Priroda density-fitting approach and EvgeniX's mention of RI-MP2 in #343]

### Parallel / MPI — pages 21-23, posts #401-#460, 2018-12..2020-11

- **Version matters (#401 EvgeniX, Dec 11 2018)**: parallelization is supported from version 16;
  in version 6 the Hessian runs on at most 2 cores, in version 17 on 4 or more. Fix for the
  `orterun` / `p6.exe` failure reported in #398: switch to version 17 from Laikov's site.
  [experienced user]
- #417 amge (Dec 13 2018): "природа хорошо параллелится (у меня, правда, только в пределах
  одной ноды)" ("Priroda parallelizes well, though for me only within one node").
  [experienced user]
- Same post: he could not get multi-core ORCA running ("There are not enough slots
  available..."), so the benchmark below was single-core.

### Parallel / MPI — pages 24-26, posts #461-#518, 2020-11..2026-07

- "Больше одной ноды использовать не нужно, у природы почему-то плохо с параллелизацией за пределы ноды." ("No need to use more than one node; for some reason Priroda parallelizes poorly beyond one node.") #462 amge, Nov 3 2020 [experienced user].
- KuznetsovSM (#463) runs systems up to about 105 atoms reliably (optimization, dipole, Hessian) and believes his failures with larger systems are not a parallelization problem.

## 4. Memory, disk, temp files

### Memory, disk, temp files — pages 1-4, posts #1-#80, 2009-02..2011-08

- `$system` group keywords seen: `memory=512` (MB), `disk=10` (GB), `path=.` (scratch dir); also the short form `mem=512` in #69. Output echoes them as:
  ```
   System options:
   Memory: 512 (512) MB
   Disk:   10 GB '.'
  ```
- Default (no $system): Memory 128 MB, Disk 1 GB, scratch `/tmp` (seen in #20 output: `Memory: 128 (128) MB`, `Disk:   1 GB '/tmp'`).
- On Windows the default `/tmp` does not exist → hang/failure at `0: opening file /tmp/tmp2960.0`. Fix: add `$system path=. $end` — #21 EvgeniX, 27 Feb 2009 [experienced user].
- Temp file naming: `/tmp/tmp<number>.<suffix>` e.g. `/tmp/tmp2960.0` (#20). (Earlier read here as `<PID>.<rank>`; in v25 two processes wrote `tmp5345.0000` and `tmp5346.0000`, so the suffix is not the rank: 08 Slurm tests s02.)
- `malloc(536870912) failed` = program tried to allocate 512 MB RAM and failed — #58 Droog_Andrey, 26 Feb 2011 (during a scan). User found a solution herself but did not say what (#59) — presumably lower `memory=` to what is physically available [unverified].

### Memory, disk, temp files — pages 5-8, posts #81-#160, 2011-08..2012-04

- `$system` example (Windows, failing): `$system memory=1601 disk=90 path=.\temp\ $end` → header `Memory: 1601 (1601) MB`, `Disk:   90 GB '.\temp\'`, then `malloc(1678770176) failed.` — #94 Partizan, 18 Sep 2011. Units: `memory` in MB, `disk` in GB.
- Partizan #95: max memory that would start was 1114 MB with disk=30; with disk=50 max was 1113; with disk=5 would not start even at 1113. #104: "Программа у меня не поддерживает выделение более 1000 Мб оперативной памяти" (Windows build would not allocate more than ~1000 MB); suspects Windows. [unverified user observation]
- sanya1024 #105 confirms: "Виндовская Природа действительно не поддерживает больше какого-то порога оперативки. Я обычно ставлю 512 и мне всегда хватало" (Windows Priroda doesn't support RAM above some threshold; 512 MB always sufficed, even for large systems). #99: default 512 MB in her Windows setup is enough for all DFT runs; a substituted porphyrin is "штука небольшая по меркам Природы" (small by Priroda standards). [experienced user] (Note: 32-bit Cygwin address space is the likely cause.)
- amge #96 (18 Sep 2011) [experienced user]: Zr2Al3Cl2C44H79 needs only ~140 MB RAM and <1 GB disk for geometry optimization; NMR needs more but not much more.
- Partizan #97: earlier porphyrin-derivative NMR run on Athlon 3000+ needed ~100 MB RAM and 300 MB disk.
- Linux example: `memory=256 disk=2 path=/tmp` (#152).

### Memory, disk, temp files — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#180 Metalian**: asked how demanding Priroda is on disk speed. In Firefly with direct SCF (DFT) disk speed hardly matters. He was weighing one machine with several SSDs (one per two cores, on a separate SATA controller) against two plain HDD machines.
- **#181 Лечащий Врач, 15 Jan 2013** [experienced user; relays the author's view]: "Если задача "выливается" из памяти на диск, то имхо использование Природы перестает быть оправданным … **Автор считает, что к производительности диска очень требовательна.** Зато к памяти не прожорлива, среднего размера органика в 8 гигов влезает легко" (Once a job spills from memory to disk, using Priroda is no longer worth it, in my opinion. **The author thinks the program is very demanding of disk performance.** It is not memory-hungry, though: medium-sized organic molecules fit easily into 8 GB.)
- **#183 Лечащий Врач** [experienced user]: "**В природе можно в явном виде указать "писать все в память", тогда скорость диска утрачивает всякое значение.**" (In Priroda you can explicitly tell it to keep everything in memory, and then disk speed no longer matters.) The keyword is not named in #183, but EvgeniX #196 shows it: a **negative `disk=` value** in `$system` (see below). Jobs that do not fit in 8 GB are "что-то с несколькими тысячами базисных функций" (something with several thousand basis functions). For systems of 30-50 non-hydrogen atoms memory use stays within a few GB. Large solute+solvent systems should be done with ONIOM and not in Priroda: "даже если бы они влезли в память, это расчет на неделю" (even if they fit in memory, it would be a week-long calculation).
- **#185 EvgeniX, 15 Jan 2013** [experienced user]:
  - "В ПРИРОДе реализован **direct SCF (группа $integral)**. Сэкономите память в 3 раза, зато считаться в 10 раз дольше будет." (Priroda has direct SCF, set in the **$integral** group. It saves 3× memory but runs about 10× longer.) The exact keyword inside `$integral` is not given.
  - "Потребление по диску не больше, чем у других программ" (disk use is no larger than in other programs).
  - Parallel runs do not change RAM use. In a parallel Hessian the first process uses most of the disk.
- **#192 amge, 16 Jan 2013** [experienced user] — real-world direct vs conventional SCF: "Недавно коллега считал довольно большую систему в riMP2 Природой. За ночь - 2 шага оптимизации, задачку с трудом удалось снять, компьютер был настолько занят дисковыми операциями, что был скорее мертв, чем жив. Повторили с direct SCF (группа $integral). За ночь 20 шагов. Т.е. всяко бывает, зависит от задачки и конфигурации машины." (A colleague ran a fairly large system with riMP2 in Priroda: 2 optimization steps overnight, the machine was so busy with disk I/O that the job could barely be killed. Repeated with direct SCF ($integral group): 20 steps overnight. So it varies with the job and the machine.) → contradicts the "10× slower" rule of thumb when the job is disk-bound.
- **#194 EvgeniX, 16 Jan 2013** [experienced user]: "Я имел в виду чистое процессорное время. Если работу программы лимитирует диск - т.е. напрямую подошли к возможностям компьютера, то конечно, нужно включать Direct SCF, и результирующая скорость расчёта будет выше и можно будет увеличить размер задачи." (I meant pure CPU time. If the disk is the bottleneck, i.e. you are at the machine's limits, then switch on direct SCF. The overall speed will be higher and you can run larger jobs.) Metalian #193: "придется, видимо, еще для каждой конкретной группы задач сравнивать direct и conventional SCF" (one has to compare direct vs conventional for each class of jobs); #195: direct is surely faster "если при conventional SCF получается CPU usage порядка 20%" (if conventional SCF gives only ~20% CPU usage).
- **EvgeniX (#194/#195 quote)**: built a home machine with a Core i7 3770 and 32 GB RAM. The memory cost "значительно дешевле 10 тыс.руб." (well under 10,000 rubles). Advice: "оперативной памяти действительно нужно ставить по-максимуму. Тем более, что она теперь стоит копейки" (fit as much RAM as possible; it is cheap now) (#194).
- **Scratch in RAM via negative `disk=`** — #196 EvgeniX, 16 Jan 2013 [experienced user], in reply to the RAM-disk question: "Вот пример для текущей задачи ПРИРОДы расчёта гессиана для запуска на 2 ядрах процессорах:"
  ```
  $system memory=1024 disk=-2048 path=/tmp $end
  ```
  "Оперативной памяти может использоваться до 2*1024 МБ, scratch (файлы, которые обычно создаются на жёстком диске) создаются в оперативной памяти ("-" перед числом указывает на то, чтобы использовать для scratch оперативную память и что единицы измерения МБ) и может быть выделено 2*2048 МБ (хотя реально при расчёте гессиана максимальное потребление будет только у первого процесса, т.е. реальный лимит будет 2048 МБ)."
  (Up to 2×1024 MB of RAM may be used; scratch files (normally created on disk) are created in RAM — **a "-" before the number means: use RAM for scratch, and the unit is MB** — and up to 2×2048 MB may be allocated (though in a Hessian run only the first process reaches the maximum, so the real limit is 2048 MB).) So: `memory=` and `disk=` are **per process** (multiplied by the number of processes); positive `disk=` is in GB on `path=`, negative `disk=` is in-RAM scratch in MB. No RAM disk needed.
- **#197 Metalian** (follow-up): in Firefly he rarely needs >500 MB per process, but in Priroda systems are larger and "природный SBK-базис тоже несопоставимо больше того SBKJC, что в Firefly" (Priroda's SBK basis is incomparably larger than Firefly's SBKJC), so scratch needs for conventional SCF are unclear. Suggests disabling system swap so that memory over-allocation doesn't push into swap on a slow disk. [unverified]
- **#189 Лечащий Врач** [experienced user]: keep system, programs and job files on an HDD RAID mirror. Use a small (64-128 GB) SSD with good multi-threaded write benchmarks **only for scratch**. "Системы, требующие для хранения больше 32 Гб, все равно будут считаться на таком железе больше недели" (systems needing more than 32 GB of storage will take over a week on such hardware anyway). "И памяти, памяти нужно побольше, это сильнее влияет на скорость, чем SSD" (and more memory: it matters more for speed than an SSD).
- **#195 Metalian**: asked whether to put half of 32 GB into a RAM disk for scratch; answered by EvgeniX #196 (negative `disk=`, above). **#204 uchebnik fiziki** (17 Jan 2013) asked the same (32-64 GB RAM plus a RAM disk) — no separate answer; #196 applies.
- **#198 Shorku, 16 Jan 2013**: SSD wear. About 10,000 rewrite cycles, spread over the whole disk. Lifetime ≈ 128 × 10000 / n days for a 128 GB SSD with a 1 GB scratch written n times a day. "на высокопроизводительных серверах может сгореть и за год" (on high-load servers it can die within a year). (Context: EvgeniX #194 asked "Не боитесь, что под нагрузкой SSD быстро сгорит?"; Metalian #195 cited MTBF up to 2 million hours.)
- **Too little memory/scratch** — Metalian #197: "а как вообще работает Природа, если выделенной памяти и/или выделенного скретча меньше, чем, скажем так, хотелось бы для расчета?" (How does Priroda behave when it gets less memory or scratch than the job wants?) **#199 EvgeniX, 16 Jan 2013** [experienced user]: "Расчёт вылетит с соответствующей ошибкой и всё." (The job will crash with a corresponding error, that's all.) — i.e. Priroda does not degrade gracefully (no automatic fallback); set `memory=`/`disk=` large enough.
- **#203 Metalian, 17 Jan 2013**: in Firefly, conventional SCF sometimes crashes where direct works. Does that happen in Priroda? No answer in this page range.
- **#210 Любитель_Манниха, 4 Jul 2013**: Windows 7 64-bit, 4 GB total RAM with 1.5 GB used by the system. Priroda wants 1.3 GB, but when the input allows that much it reports it cannot allocate it. 1024 MB allocates fine.
- **#211 alxyppv, 4 Jul 2013** [experienced user]: "Это проблема не природы самой по себе, а **cygwin**, через который она под виндой работает. Это он не может больше выделить. Под линуксом таких проблем нет..." (This is not Priroda's problem but Cygwin's, which Priroda runs through on Windows. Cygwin cannot allocate more. There is no such problem on Linux.)
  - For the manual: on Windows (Cygwin build), allocations above about 1 GB may fail. Use Linux for larger memory. (Cygwin's default heap limit can sometimes be raised, but that is not from the thread.)

### Memory, disk, temp files — pages 13-16, posts #241-#320, 2013-12..2015-06

- **Hessian on a large cluster with cc-pVDZ and cc-pVTZ.** #289 Гесс (Jan 28, 2014):
  - The cc-pVDZ hessian on a "каплкластер" ("drop cluster") fit entirely into the 60 GB of RAM he gave it, with no disk use. He notes it could probably have used much less.
  - The cc-pVTZ recalculation failed with:
    - `0: out of disk space (ci.Rnvvo), 553912160`
    - or `0: out of disk space (VNNNN), 542865328`
  - The array name `ci.Rnvvo` suggests a correlated (CI/CC-type) method, so this was probably a CCSD/MP2-type hessian; the method is not stated in this page range. Гесс wonders whether it really needs more than 500 GB. That reading of the numbers is his; the unit is unknown, and the number may be bytes or 8-byte words per process.
  - The temp folder gets many files, all empty except 16, the ones for his 16 processes.
- #290 EvgeniX (Jan 29, 2014) [experienced user]: "Файлы заполняются по мере требования, каждый временный файл создаётся на планируемые 1 ГБ и на каждое ядро." ("Files are filled as needed; each temporary file is created for a planned 1 GB, one per core.")
- #291 Гесс: the temp folder stayed at 18 GB from the first FORWARD step onward. He was on step 7 of a planned 24 "forward" and 24 "backward" steps, so this is a numerical hessian by finite differences of gradients.
- #294 EvgeniX (Jan 29, 2014) [experienced user]: "Когда гессиан численный, затраты на диск и оперативку равняются тем же затратам на оптимизацию (одиночный расчёт энергии)." (When the hessian is numerical, the disk and RAM requirements equal those of an optimization (a single energy calculation).) This explains the constant 18 GB temp folder through all FORWARD/backward steps (#291).
- #292 Tasha (Jan 29, 2014): "во входном файле в разделе $control надо поставить путь для tmp-файлов. делаете так: disk=1 path=./" ("set the path for tmp files in the input: disk=1 path=./").
  - She says `$control`, but in #319 the keys `disk=` and `path=` sit in `$system`, and the output echoes them as System options. `$system` is the documented place.
- #293 Гесс: he had already set it, to 40 GB rather than 1, the most "fast disk" he could give. The run stayed within 18 GB of temp files and he expected another week of runtime.
- `$system` echo in the output, from #319:
```
 System options:
 Memory: 1024 (1024) MB
 Disk:   5 GB '.'
```
  So `memory=` is in MB, `disk=` is in GB, and `path=` is the scratch directory.

### Memory, disk, temp files — pages 17-20, posts #321-#400, 2015-06..2018-12

- `$system memory=160 disk=2 path=./tmp $end` is used in Gulnara's input (#376, see the full input below). Units are not stated in this page range.
- EvgeniX (#370): the 64-bit `p.exe` under Windows with only `cygwin1.dll` "Памяти сколько угодно видит" (sees any amount of memory).
- SCF memory-allocation limit and Hessian size limit were removed by Laikov circa 2016 (#339).
- Limits on the maximum number of atoms and basis functions (asked by Вик, quoted in #328, 2016-03-15). EvgeniX (#328): "В прикреплённом файле последние данные. Работа ещё в процессе, много чего пока не оформлено в виде каких-либо рекомендаций." (The latest data are in the attached file. The work is still in progress, and much has not yet been formulated as recommendations.) The attachment is not available, so no numbers survive. [experienced user]
- `TMPDIR` environment variable: EvgeniX sets `set TMPDIR="%TEMP%"` before launching the parallel build on Windows (#370).

### Memory, disk, temp files — pages 21-23, posts #401-#460, 2018-12..2020-11

- #460 KuznetsovSM (Nov 3 2020): `$system memory=9000 disk=40 $end`. Temp files are written to
  `/tmp/tmpNNNN.NN` (e.g. `/tmp/tmp9633.11`). The Hessian job died on a temp-file write
  (see Known errors). The thread gives no answer here. The likely cause is that `/tmp`
  ran out of space or the file got too large (lpos ~ 996 MB). [my inference, unverified]

### Memory, disk, temp files — pages 24-26, posts #461-#518, 2020-11..2026-07

**Context:** KuznetsovSM's cluster job failed with an error writing a temp file. His original question and input are in the earlier pages; his input used `disk=40`.

- **Error message:** `0: malloc( цифры ) failed`. KuznetsovSM (#463, Nov 6 2020): "с памятью больше, чем memory=9250 disk=-9250, всегда выскакивает такая ошибка" ("with more memory than memory=9250 disk=-9250 this error always pops up"); the number in parentheses equals the `disk` amount in bytes. I.e. on his node, RAM for `memory` plus the RAM disk could not exceed about 2 × 9250 MB.
  - Ahha (#464) [unverified]: "По какой-то причине не удается зарезервировать указанный объем памяти. malloc - это функция такая" ("For some reason the requested amount of memory cannot be reserved. malloc is a [C] function").
- **"We need 1.5 GB of memory..."**: KuznetsovSM (#463) got this message on an ordinary PC with `disk=40`, and thought 40 GB of disk might be too little. Ahha (#464): "Вероятно с тем, что ей надо 1.5 Гб памяти, а 40 Гб диска на их наличие не влияют." ("Probably because it needs 1.5 GB of memory, and 40 GB of disk doesn't affect whether that's available.") I.e. this message is about RAM (`memory=`), not disk. [unverified]
- KuznetsovSM (#463) also tried a `tmp` folder for temp files and still got the same file-write error.
- **amge (#462, Nov 3 2020) [experienced user]:**
  - "Вы не указали место для размещения временных файлов (path=), а по умолчанию они создаются на /tmp. Это, скорее всего, на мастер-ноде." ("You did not specify a location for temp files (path=); by default they are created in /tmp, most likely on the master node.")
    - Quotas on the master node can make the job fail.
    - Use the cluster's fast scratch array, for example `/mnt/scratch` on his cluster.
  - "Если на ноде достаточно оперативки, то можно временные файлы размещать в ней. При этом и считать будет немного быстрее. Например, memory=9000 disk=-14000 для 24 Гб оперативки" ("If the node has enough RAM, temp files can be kept in RAM, which is also a bit faster. E.g. memory=9000 disk=-14000 for 24 GB RAM.")
- **Default temp location (resolved):** KuznetsovSM wrote (#463, quoted in #465): "если path не указано, то временные файлы создаются в той же директории, где лежит *.in файл" ("if path is not given, temp files are created in the same directory as the *.in file"). amge (#465, Nov 6 2020) [experienced user]: "Действительно, так, но только если $TMPDIR не задана. И судя по имени /tmp/tmp9633.11 из вашего первого поста, она была задана. Но в любом случае, ни /tmp, ни текущая директория - не подходящие места на кластере для больших временных файлов." ("Indeed so, but only if $TMPDIR is not set. Judging by the name /tmp/tmp9633.11 in your first post, it was set. In any case, neither /tmp nor the current directory is a suitable place on a cluster for large temp files.")
  - **Rule:** temp-file directory = `path=` if given; else `$TMPDIR` if set; else the directory of the input file. Temp files are named like `tmpNNNN.NN`.
  - amge added that a job with such an input would also have crashed on his cluster, and offered to run it himself to find out exactly how much memory and disk it needs ("Если хотите, кидайте координаты - попробую запустить себя").
- **Units of `disk=`:**
  - KuznetsovSM believed `disk=40` meant 40 GB ("Скорее всего, 40 ГБ может и не хватить", "most likely 40 GB may not be enough").
  - Ahha (#467) suspected it meant 40 MB, judging from amge's "memory=9000 disk=-14000 для 24 Гб оперативки" (he said he does not use Priroda and may be wrong).
  - Гесс settled it in #468 (Nov 7 2020) by quoting the official manual verbatim [authoritative: manual quote]:
    ```
    disk=%d positive: disk space in gigabytes
     negative: amount of memory in megabytes  to use as disk emulation
    ```
  - So `disk=40` means 40 GB on disk, and `disk=-14000` means 14000 MB of RAM used as a RAM disk.
  - The source Гесс cites is the PDF manual mirror https://monitor.hpc.umanitoba.ca/doc/Priroda_Documentation_from_KNCWiki.pdf.
  - Ahha (#469) on the mixed units: "Нелогично как-то один и тот же параметр в одной и той же программе измерять в разных попугаях" ("illogical to measure the same parameter in different units").
  - amge (#471, Nov 8 2020), citing `memory=9000 disk=-14000`: "Некоторая логика м.б. в том, что то и другое - оперативная память, размер которой нельзя превышать. Сложить Мб+Мб проще, чем Мб+Гб." ("Some logic may be that both are RAM, whose size must not be exceeded. Adding MB+MB is easier than MB+GB.") I.e. with a negative `disk`, `memory` + |`disk`| (both MB) must fit in the node's RAM. [experienced user]
- **Two-value `disk` syntax:** Yellow21chem's input (#481) has `$system mem=32000 disk=-10240,-1 $end`. Here `disk` takes two comma-separated values, `-10240,-1`. The meaning of the second value (-1) was not explained [undocumented].
- **Memory keyword spelling:** amge writes `memory=9000` and Yellow21chem writes `mem=32000`. Both forms appear in practice, both in MB.

## 5. Input groups & keywords

### Input groups & keywords — pages 1-4, posts #1-#80, 2009-02..2011-08

Groups seen: `$system`, `$control`, `$dft`, `$optimize`, `$molecule`, `$grid`, `$nmr`.

- `$control theory=dft task=optimize basis="3z.bas"` (#63/#64). `theory=DFT` also uppercase (#69).
- `task=` values mentioned: `optimize`, `NMR`/`nmr`, `hessian`, `dipole` (#33), `optimize+hessian` (combined), scan (#56,#60, keyword not shown), IRC (#66).
- Combined tasks: two `task=` lines (`task=optimize` + `task=NMR`) do NOT work — only optimization is performed (#69 Любитель_Манниха, 9 Jun 2011). sanya1024: "из "комбинированных" задач Природа понимает только task=optimize+hessian, и то не во всех версиях." (Of combined tasks Priroda understands only task=optimize+hessian, and not in all versions.) — #70 [experienced user].
- `task=optimize+hessian` = optimization followed by a Hessian at the optimized geometry (check for imaginary frequencies); GAMESS analogue `$statpt hssend=.t. $end` — #73 sanya1024, 8 Aug 2011.
- Workaround for other combinations: amge's wrapper script `pri` (http://limor1.nioch.nsc.ru/quant/program/pri/) "обрабатывает инпуты с task=optimize+nmr и т.п." (handles inputs with task=optimize+nmr etc.) — #71 amge, 10 Jun 2011 [experienced user].
- `$optimize steps=100 $end` (#63), `$optimize tol=1e-5 $end` (#69).
- Frozen coordinates: `$optimize  fix=a,b,c,d,e value=f $end`, "где а-тип замораживаемой координаты, b, c, d, e-координаты атомов, f-значение замораживаемой координаты" (a = type of frozen coordinate, b,c,d,e = atom numbers, f = value) — #52 petrovps, 1 Feb 2011 [experienced user; exact type codes not given].
- `$grid accur=1e-8 $end` (integration grid accuracy; used for NMR) — #69.
- `$nmr standard(1)=31.3867 standard(6)=181.9781 $end` — reference shieldings per element (Z=1 H, Z=6 C) so that chemical shifts are printed relative to TMS — #69.
- `$molecule charge=0 mult=1 z-matrix` / `$molecule charge=0 mult=1 cartesian` (Cartesian XYZ input) — #63, #69.
- `mass` parameter (in thermochemistry docs): "Этот параметр для изотопов, вводить его не нужно." (It is for isotopes; no need to enter it.) — #46 EvgeniX.
- Charge/multiplicity for a radical anion: `-1 1` was posted by VTur (#49, 1 Feb 2011) — NOTE: this is wrong in the usual convention (a radical anion of a closed-shell molecule is charge -1, multiplicity 2). Check what `mult` means in Priroda (2S+1 vs. number of unpaired electrons); flag as [unverified/likely wrong].

Complete sample input (one of the shipped samples, as posted in #63 by Любитель_Манниха, 20 May 2011; typographic quotes around 3z.bas must be replaced by straight `"` per #64):
```
$system memory=512 disk=10 path=. $end
$control theory=dft task=optimize basis=»3z.bas» $end
$dft functional=PBE $end
$optimize steps=100 $end
$molecule charge=0 mult=1 z-matrix
1
7 1 1.026
1 2 1.026 1 105.116
8 2 1.464 3 102.846 1 107.322
1 4 0.972 2 101.187 1 -125.643
$end
```
(Z-matrix lines: atomic number, then ref atom/bond, ref atom/angle, ref atom/dihedral; first line is just `1` = H atom. Molecule: H2N-OH.)

NMR input attempt (#69, 9 Jun 2011; only optimization runs because combined tasks unsupported):
```
$system mem=512 disk=10 path=. $end
$control
 task=optimize
 task=NMR
 theory=DFT basis=3z.bas
$end
$grid accur=1e-8 $end
$optimize tol=1e-5 $end
$nmr standard(1)=31.3867 standard(6)=181.9781 $end
 
$molecule charge=0 mult=1 cartesian
.......
```
Note this input writes `basis=3z.bas` without quotes.

### Input groups & keywords — pages 5-8, posts #81-#160, 2011-08..2012-04

- **Input file format requirements:**
  - Must be plain text ANSI, not Unicode: "сохранил текст в кодировке Юникод. Программа читает ANSI" — #104 Partizan.
  - Must have Unix line endings even under Windows: "Природе, даже под виндой, нужны инпут-файлы с юниксовыми концами строк (не "\r\n", а "\n")" — #113 amge, 1 Nov 2011 [experienced user]. Editing `.in` files in MS Word → no chance to run. amge's "Как этого добиться, читайте здесь" link: http://www.qchem.ru/f/kvantovo-khimicheskie-programmy/kvantovo-khimicheskaya-programma-priroda/msg822/#msg822. Recommended editor: TextPad (#114 Yurii). The qchem script has optional `dos2unix.exe` step.
  - Saving from Word as plain text is not enough — #117 amge, 1 Nov 2011 [experienced user]: "из ворда же можно сохранить в виде текстового файла. И все равно, если в нем потом не поменять концы строк, то Природа и такой файл не примет (такая вот фича). Есть редакторы (тот же TextPad), которые умеют сохранять в юниксовыми концами строк, но им об этом нужно специально сказать, по умолчанию будет с досовскими концами строк." (You can save from Word as a text file, but unless you then change the line endings Priroda still won't accept it ("such a feature"). Editors like TextPad can save with Unix line endings, but you must tell them explicitly — by default they save DOS line endings.)
  - (Caveat: other sources say v6 tolerates CRLF; here amge states it is required. Treat as "safe practice".)
- `$optimize tolerance=%f,%f $end` — manual quote, #109 sanya1024, 23 Sep 2011 [quotes manual]:
  ```
   tolerance=%f,%f         tolerance on gradient (first value)
                           and displacement (second value) in au.
                           default is 0.0001,0.01 ,
                           if only the first is given, the second is
                           computed as 100 times as much (recommended default)
  ```
  Abbreviated form `tol=1e-5` used in #146. Also `$optimize steps=300 $end` (#152).
- `$control print=+bonds+charges+molden` (#152) — print options incl. Molden output.
- `$molecule ... set=L1` inside a cartesian block (#152) — selects basis set name from the basis file.
- `$grid accur=1e-9` (#94) and `$grid accuracy=1e-8` (#152).
- `$control task=` values seen: `nmr` (#94), `optimize` (#146, #152), `scan` (#110), `sadpoint`/IRC (#91, see TS section). `theory=` values: `dft`, `ridft`, `CCSD`, `tddft`.
- **No Link1-type multiple jobs in one input / `task=optimize+hessian`**: Amora #144 asked for Gaussian `--Link1--` analogue. amge #145, 22 Dec 2011 [experienced user]: "В Природе-2 можно было сказать task=optimize+hessian, в Природе-6 эта возможность исчезла, в Природе-9 вновь появилась. Но optimize+hessian - этого мало, поэтому я пользуюсь специальным скриптом [URL http://limor1.nioch.nsc.ru/quant/program/pri/] для последовательного запуска задач." (In Priroda 2 you could write `task=optimize+hessian`; in Priroda 6 this disappeared; in Priroda 9 it came back. But optimize+hessian is not enough, so I use a special script (http://limor1.nioch.nsc.ru/quant/program/pri/) for running jobs sequentially.) — i.e. combined tasks `task=optimize+hessian` exist in v2 and v9+ but **not in v6**; general job chaining needs an external script.
- **No dummy atoms:** "BSSE в Природе считать нельзя -- не поддерживаются dummy atoms" — #146 sanya1024 [experienced user].
- No command to list supported methods — #156 EvgeniX.
- Z-matrix input supported (see #146 example); Cartesian also.

### Input groups & keywords — pages 9-12, posts #161-#240, 2012-04..2013-12

- **`$integral` group**: controls direct SCF (#185 EvgeniX; #192 amge). The exact option name is not given in this page range.
- **`$system memory=… disk=… path=…`** (#196 EvgeniX) [experienced user]: values are per process; `disk=-N` (negative) = keep scratch in RAM, N in MB. This is the "write everything to memory" option of #183 (Лечащий Врач).
  ```
  $system memory=1024 disk=-2048 path=/tmp $end
  ```
- **`$control` … `four=1`** — #207 amge, 10 Apr 2013 [experienced user]: "Вам нужен базис с релятивистскими поправками, он называется basis4.in (если только не переименовали). При его использовании не забывать four=1 в группе $control. Базис 3z.bas, по идее, тоже должен работать, но в нем нет релятивистских поправок." (You need the basis with relativistic corrections; it is called `basis4.in` (unless renamed). When using it, don't forget `four=1` in the `$control` group. The `3z.bas` basis should in principle also work, but it has no relativistic corrections.) This fixed running with the basis file `basis4.bas` (#206/#208). Verified by the user #208: "Проблема была в этом, спасибо!" (That was the problem, thanks!). See Relativistic.
  ```
  $control
   ...
   basis=basis4.in
   four=1
  $end
  ```
- **Charge/multiplicity** (#217 asp): input lines `charge=0` and `mult=2` for the OH radical.
- **Coordinates** (#213/#214): Cartesian lines `Z x y z` with atomic number first, e.g. `6 -3.599214066 5.000568089 -2.755778119`, are "нормальные декартовы координаты в формате Природы" (normal Cartesian coordinates in Priroda format) (sanya1024). A Z-matrix form also exists (see Geometry optimization).
- **#172**: an output line `molecule input: ''  'cartesian  ' ?` suggests the `$molecule` group has a `cartesian` setting (the error echoes it with a `?`).
- **#216 amge** [experienced user]: for a TS search "сначала нужно посчитать гессиан и вставить его в инпут" (first compute the Hessian and insert it into the input). The attachment was not visible.

### Input groups & keywords — pages 13-16, posts #241-#320, 2013-12..2015-06

Groups and keywords seen in this page range:
- **`$system`**: `memory=1024` (MB), `disk=5` (GB), `path=.`. Tasha (#292) puts `disk=1 path=./` in `$control`.
- **`$control`**:
  - `task=optimize`
  - `theory=DFT`
  - `four=0` (#319; meaning not explained)
  - `basis=<path to basis file>`
  - `save=filename`, which writes the vectors file (#306 amge)
  - `task=extremal` (#314 amge: exists, "но это не совсем то" for periodic hessian recomputation in IRC; details not given)
  - `theory=ridft` required for hybrids; `theory=dft` + B3LYP/PBE1 → MPI_Abort (#307–#310)
- **`$dft`**: `functional=B3LYP` (#319).
- **`$grid`**: `acc=1e-6` (#319). alxyppv writes `accuracy=1e-9`.
- **`$scf`**:
  - `conv=1e-5` (#319)
  - `convergence=1e-7`, `procedure=bfgs`, `iterations=250` (#320 alxyppv)
  - `iterations=10` (#306 amge)
- **`$guess`**: `read=1` restarts from saved vectors (#306 amge).
- **`$optimize`**:
  - `steps=300 tol=1e-5 cartesian=1` (#319)
  - `fix=...`, `value=...` (or `val(i)=`), `points=...` for scans (#268, #269, #300)
- **`$molecule`**:
  - `charge=1`
  - `mult=0 cartesian`
  - `set=6-31+G(d)`, which names the basis set inside the basis file
  - Cartesian lines: atomic number, x, y, z
- Groups can be written on one line: `$scf conv=1e-5 $end`, `$optimize fix=3,6,1,11,16 value=0,68 points=18 $end`.

**Odd parse in #319 (my observation).** The output in #319 shows `scf options: conv=1.0e-04, 1.0e-01; iter=16,16`, `grid: accuracy=1.0e-05,1.0e-03`, `Tolerance on gradient = 0.00010000` and `Maximum number of steps = 100`. The input asked for `conv=1e-5`, `acc=1e-6`, `tol=1e-5` and `steps=300`. The printed values look like defaults, which suggests the one-line `$grid`/`$scf`/`$optimize` groups (or `acc=`) were not applied in that Priroda 6 run. Nobody in the thread commented on this.

Default values as printed in #319 (Priroda 6, 2006):
- scf `conv=1.0e-04, 1.0e-01`, `iter=16,16`
- integral cut-off `1.0e-10 (1.0e-06)`
- grid `accuracy=1.0e-05,1.0e-03`, `cut=1.0e-07,1.0e-05`
- optimization:
```
 Geometry optimization options:
 Coordinates: cartesian
 Tolerance on gradient       = 0.00010000
 Tolerance on displacement   = 0.01000000
 Trust radius                = 0.20000000 (max), 0.01250000 (min)
 Maximum number of steps     =        100
 Updated hessian used
```

**Scan syntax.** See TS/IRC/scan.

### Input groups & keywords — pages 17-20, posts #321-#400, 2015-06..2018-12

#### `$scf` convergence + iterations quirk (#322-#324, June 2015) [experienced users]
alxyppv's standard fragment (quoted in #322):
```
$scf
convergence=1e-7
procedure=bfgs
iterations=250
$end
```
- amge (#322) noted that in a neighbouring thread (`http://www.chemport.ru/forum/viewtopic.php?f=71&t=112860`) it unexpectedly turned out that using `convergence` and `iterations` together is "вредно для самочувствия" (harmful, i.e. causes problems).
- alxyppv (#323): this is his standard input fragment and the keywords seem to coexist fine.
- amge (#324): "Ваш фрагмент и у меня работает! Но если убрать из него строку procedure=bfgs, то перестает." Translation: your fragment works for me too, but if I remove the `procedure=bfgs` line, it stops working. **Conclusion**: `convergence` + `iterations` together break unless `procedure=bfgs` is also given. The exact failure mode is not stated. [experienced user, empirical]

#### Abbreviated keywords
Gulnara's input (#376) uses short forms: `conv=1e-8`, `proc=NR`, `accur=1e-9`, `func=PBE`. Also `print=-internals` (suppresses printing of internal coordinates) and `&dft ... $end` (the group opened with `&` instead of `$`). The input was otherwise accepted, which implies Priroda accepts abbreviated keyword names. [inferred]

#### `$control`
- `four=1` in `$control` is needed when using the all-electron relativistic basis file `basis4.in` (#336 amge, see Relativistic).
- `task=hessian` and `basis=3z.bas` (#376).
- `theory=ridft` and `theory=dft` (#321, see DFT).

#### `$optimize` (manual excerpt quoted by EvgeniX, #373, 2017-06-01) [authoritative: verbatim from the Priroda manual]
```
$optimize
steps=%d                number of optimization cycles (50 by default)
cartesian=%d            0 - use redundant internal coordinated (defaul)
                        1 - use cartesian coordinated (last resort)
points=%d               optimize N points during an IRC run,
                        or do N constrained geometry optimization
                        during a scan run.
fix=%d,%d,...           a list of internal coordinated to be kept fixed
                        during geomety optimization. The format is like above
value=%f,%f,...         the values of the fixed internal coordinates
                        (in angstroms and degrees). By default these are
                        computed from input geometry. For the scan run type
                        this is a list of all initial values followed
                        by the list of final values. Example:
$optimize
fix   =1,7,9,0,0, 1,8,10,0,0, 3,8,7,9,0, 3,10,9,7,0
val(1)=1.6,       1.7
val(5)=2.0,       2.1
points=5
$end
In this case 5 geometry optimizations will be done
with values 1.6, 1.7, 1.8, 1.9, 2.0 for distance 7-9
values 1.7, 1.8, 1.9, 2.0, 2.1 for distance 8-10
and with angles 8-7-9 and 10-9-7 fixed at their
input values.
```
Notes on this excerpt:
- Each `fix` entry is a 5-tuple: type code (1 = distance, 3 = angle; presumably 2 = ... and 4 = dihedral, not shown here), then 4 atom indices padded with 0.
- `val(N)=` sets entries of the flat value list starting at position N. With 4 fixed coordinates, positions 1-4 are the initial values and positions 5-8 the final values. So `val(1)=1.6,1.7` sets the initial values of coordinates 1 and 2 (distances 7-9 and 8-10), and `val(5)=2.0,2.1` sets their final values. Positions not set (the angles) keep their input-geometry values. With `points=5` this gives a 2-D linear scan, 7-9 from 1.6 to 2.0 and 8-10 from 1.7 to 2.1, as the prose says. Also, `value=` can evidently be abbreviated to `val`.
- "The format is like above" refers to an earlier format description that is not quoted here.
- This was the answer to darkchemist (#372): can several atoms (24) be frozen, as with "frozen" in Gaussian? The answer offers internal-coordinate constraints via `fix`. Freezing Cartesian atoms directly was not discussed.

### Input groups & keywords — pages 21-23, posts #401-#460, 2018-12..2020-11

Complete input from #460 KuznetsovSM (Nov 3 2020). Raman spectrum (спектр КР) of a 142-atom
linear CH-chain hydrocarbon on a cluster. The coordinates were not shown in the post:

```
$system memory=9000 disk=40 $end
$control
	task=hessian
	basis=4z.bas
	print=-internals+molden
$end
$optimize
	tolerance=1e-7
	trust=0.005
	steps=5000
$end
$dft func=OLYP $end
$scf conv=1e-8 proc=bfgs $end
$grid accur=1e-9 $end
```

Keywords shown: `$system memory= disk=`; `$control task=hessian basis=4z.bas`;
`print=-internals+molden` (turns off the internals print and turns on the Molden print,
using +/- syntax); `$optimize tolerance= trust= steps=`; `$dft func=OLYP`;
`$scf conv=1e-8 proc=bfgs` (SCF procedure option "bfgs"); `$grid accur=1e-9`.
[user input, not verified as optimal]

### Input groups & keywords — pages 24-26, posts #461-#518, 2020-11..2026-07

- `$system mem=32000 disk=-10240,-1 $end` (#481): memory in MB, plus `disk` with two values.
- `path=` (#462) sets the temp directory, e.g. `/mnt/scratch` on a cluster.
- `$control task=optimize theory=qm_n3 basis=qm.in $end` (#481) runs a semiempirical qm_n3 optimization.
- `$optimize sym=1 cart=1 tol=1e-5 $end` (#481) [user input].
- `$optimize cartesian=1 $end` (#518 amge, Jul 3 2026) [experienced user] is the fix for the "too few" internal-coordinate crash (see Known errors). Both spellings appear: `cart=1` (#481) and `cartesian=1` (#518).
- `$molecule sym=1 cartesian ... $end` (#481) means Cartesian coordinates follow, with `sym=1`.
- `task=hessian` (#475/#476) gives thermochemistry. Yellow21chem's spelling "task=oprimize" was a typo.
- **`task=optimize+hessian`** (#478 Metalian, Dec 17 2021) [experienced user]: "task=optimize+hessian и не надо два раза запускать" ("task=optimize+hessian, and there's no need to run twice"). Tasks can be chained with `+` in one run: optimize, then Hessian at the optimized geometry.
- `task=critical`: Tasha (#495) wrote "по task=crytical, кажется, он выдает набор критических точек" ("with task=crytical it seems to output a set of critical points"). amge (#497, Aug 8 2022) tried it: "обнаружил, что task=crytical не работает" ("found that task=crytical doesn't work"). Whether a correctly spelled `task=critical` exists was not confirmed. [unverified]
- **`print=+density`** (#498/#499) is what actually produces the critical-point set (QTAIM/Bader analysis of the density).
  - amge asked (#497) "Уточните, пожалуйста, что надо сказать, чтобы получить набор критических точек" ("please clarify what you have to put to get the set of critical points"). Tasha answered "print=+density", and amge (#499, Aug 11 2022) confirmed: "Работает! Спасибо большое!" ("It works! Thanks a lot!") [confirmed by experienced user]
- `print=+charges+density` (#502 amge) adds charges to the critical-point output, so they can be shown as labels in Molden.
- `print=+vectors+molden` in the `$control` group (#509 amge) writes MOs in a form `pri2mol` can convert for Molden. leshii (#510) confirmed that forgetting `+molden` was his problem.
- `theory=riDFT` (#512) is the RI-DFT theory keyword. The output header shows `Theoretical Method RIDFT`.

## 6. Basis sets

### Basis sets — pages 1-4, posts #1-#80, 2009-02..2011-08

- Basis given as file: `basis="3z.bas"` (#63/#64). Also mentioned: L1, 3z, L2 (#15), TZVPP (#38), relativistic bases (#33-#35).
- "стандартные природовские базисы серии L (аналоги cc-pVnZ) очень немаленькие" (standard Priroda L-series bases, analogues of cc-pVnZ, are quite large, which compensates for possible imperfection) — #6 amge, 15 Feb 2009 [experienced user]. "Базисов тоже немного" (not many bases available).
- amge: PBE with L1, 3z, L2 — "в пределах этих базисов результат почти одинаков" (results nearly the same within these bases) — #15.
- VTur's (#7) claim from reading Laikov's dissertation: basis sets had to be re-fitted to the program ("стандартные не идут" — standard ones don't work) because of the density-fitting scheme [unverified interpretation — actually these are the auxiliary fitting bases].
- MP2/L1 gave energetics practically the same as MP2/L2 for Br-carbocations — #17 EvgeniX.

### Basis sets — pages 5-8, posts #81-#160, 2011-08..2012-04

- **Correspondence to Turbomole/Ahlrichs:** TZVPP and def-TZVPP ↔ "L2 и 3z" — #124 EvgeniX, 25 Nov 2011 [experienced user] (likely L2 ↔ TZVPP-like correlation-consistent, 3z ↔ def-TZVPP-like; mapping order not explicitly stated).
- "там самые часто используемые -- 3z и L2, оба triple-zeta quality. Они не содержат диффузных функций сами по себе" (most used are 3z and L2, both triple-zeta, no diffuse functions) — #105 sanya1024 [experienced user].
- Other basis names: `L1` (#152 `set=L1`), `L22m`, `L22` (#119), `3z.bas` file (#94, #128), `basis.in` file (#128, #146, #152).
- **Foreign basis sets:** cannot be pasted in directly; can be converted by hand. Converting Priroda → GAMESS is easy; reverse is harder because "Природе кроме собственно базиса нужен вспомогательный базис, которого в гамессе нет" (Priroda needs an auxiliary basis besides the orbital one, which GAMESS lacks) — #87 amge, 24 Aug 2011 [experienced user].
- Turbomole has both orbital and auxiliary (RI) basis sets, so they can be converted into Priroda format; idea also to convert Turbomole ECP bases — #88 sanya1024 [experienced user, suggestion].
- Nicolass #89 (25 Aug 2011) asked how exactly to do the manual conversion ("а как это все в ручную сделать-то?"); amge answered with the side-by-side L2/H example (#90, below).
- Warning: "В Природе вспомогательные базисы для density-fitting-а не рассчитаны на использование сторонних основных базисов" (Priroda's density-fitting auxiliary bases are not designed for foreign orbital bases; may work, may cause problems) — #105 sanya1024. Also risk of conversion errors.
- **Gaussian 6-311++G vs Priroda bases** — #103 Partizan clarified that he used "311G++" ("чуть ли не самый большой" — almost the largest) in Gaussian, not in Priroda. amge #106, 22 Sep 2011 [experienced user]: "Не понял только, зачем для расчета хим. сдвигов диффузные функции. Поляризационные нужны. Т.е. 311**. Это будет нормальный базис, для углеродов можно и поменьше, для протонов меньше не стоит. В природовских базисах прямого аналога 311** нет, по числу базисных функций/контрактаций это примерно 3z/L2." (Diffuse functions are not needed for chemical shifts; polarization functions are — i.e. 6-311G**. That is a normal basis; for carbons you can go smaller, for protons not. Priroda has no direct analogue of 311**; by number of basis functions/contractions it corresponds roughly to **3z / L2**.)
- **Basis file format example — L2 for hydrogen, GAMESS vs Priroda side by side** — #90 amge, 25 Aug 2011 [experienced user]. Priroda format: header line `1   6` (= element Z=1, 6 contracted functions? — interpretation: atomic number and number of shells: 3 s + 2 p + 1 d = 6), then for each shell a line `L  N` (angular momentum, number of primitives) followed by N lines `exponent coefficient` in full-precision Fortran E format:
  ```
               GAMESS                           |          PRIRODA
  ____________________________________________________________________________________________________

                                                |          1   6
     S       6                                  |  0  6
       1            418.5580082268  0.00070146  |  +.418558008226773188e+003 +.701462145993333792e-003
       2             62.7453487397  0.00790918  |  +.627453487397196708e+002 +.790918189868878021e-002
       3             14.2795839589  0.02842289  |  +.142795839589171436e+002 +.284228887446080352e-001
       4              4.0418169604  0.35256539  |  +.404181696039377211e+001 +.352565392091014808e+000
       5              1.3163895142  0.93455224  |  +.131638951421841844e+001 +.934552240284832500e+000
       6              0.4734618645 -0.37050906  |  +.473461864521954180e+000 -.370509059490446757e+000
     S       7                                  |  0  7
       1            418.5580082268 -0.00015551  |  +.418558008226773188e+003 -.155507523793641254e-003
       2             62.7453487397 -0.00411244  |  +.627453487397196708e+002 -.411244148615100725e-002
       3             14.2795839589 -0.00532980  |  +.142795839589171436e+002 -.532980181190408738e-002
       4              4.0418169604 -0.28108579  |  +.404181696039377211e+001 -.281085789488589654e+000
       5              1.3163895142 -0.54030860  |  +.131638951421841844e+001 -.540308601567060749e+000
       6              0.4734618645  1.23691077  |  +.473461864521954180e+000 +.123691076523447009e+001
       7              0.1827999116  0.18791205  |  +.182799911639394739e+000 +.187912050577034813e+000
     S       8                                  |  0  8
       1            418.5580082268 -0.00012732  |  +.418558008226773188e+003 -.127316143323039976e-003
       2             62.7453487397 -0.00509163  |  +.627453487397196708e+002 -.509162914618938409e-002
       3             14.2795839589 -0.00198272  |  +.142795839589171436e+002 -.198271877698908381e-002
       4              4.0418169604 -0.34284097  |  +.404181696039377211e+001 -.342840968036270988e+000
       5              1.3163895142 -0.38314030  |  +.131638951421841844e+001 -.383140300379688874e+000
       6              0.4734618645  1.81376570  |  +.473461864521954180e+000 +.181376569986496248e+001
       7              0.1827999116 -1.06147098  |  +.182799911639394739e+000 -.106147098065003351e+001
       8              0.0728843619 -0.65859427  |  +.728843619414293301e-001 -.658594274899141652e+000
     P       3                                  |  1  3
       1              4.0418169604  0.08845815  |  +.404181696039377211e+001 +.884581474930872548e-001
       2              1.3163895142  0.64974944  |  +.131638951421841844e+001 +.649749437400244417e+000
       3              0.4734618645  0.36039377  |  +.473461864521954180e+000 +.360393770222693832e+000
     P       4                                  |  1  4
       1              4.0418169604  0.12099256  |  +.404181696039377211e+001 +.120992558669658488e+000
       2              1.3163895142  0.76906885  |  +.131638951421841844e+001 +.769068854383535804e+000
       3              0.4734618645 -0.57957485  |  +.473461864521954180e+000 -.579574851455606463e+000
       4              0.1827999116 -0.64369674  |  +.182799911639394739e+000 -.643696736010480168e+000
     D       2                                  |  2  2
       1              1.3163895142  0.41680389  |  +.131638951421841844e+001 +.416803892764054888e+000
       2              0.4734618645  0.67914281  |  +.473461864521954180e+000 +.679142806273200708e+000
  ```
  Observations: L2 hydrogen = 3s2p1d contracted from a shared set of 8 even-tempered-like exponents (418.56 … 0.0729); contractions are general-style (same exponents reused, nested). (Note: this snippet likely shows only the orbital part; the full basis entry in the Priroda file also has auxiliary-basis data — not shown.)

### Basis sets — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#206 Любитель_Манниха, 10 Apr 2013**: Windows run with basis **`3z.bas`**. Geometry optimization of a mercury porphyrin crashes at the first step with "process 0 recieved signal 11". Os gives the same crash, Ru works. Nobody explained the crash (possibly 3z.bas or the build for heavy 6th-row elements).
- **#206**: with **`basis4.bas`** the OUT file shows (truncated): `Basis set input: 'basis4.bas'   1?...`.
- **#208**: fixed by `four=1` in `$control` (amge's tip #207). The user notes the file name in his earlier post had a typo.
- **#207 amge** [experienced user]: the relativistic basis file is named **`basis4.in`** in the distribution ("если только не переименовали"); `3z.bas` has **no relativistic corrections** but should in principle work for heavy elements too. amge offered to run the input himself.
- **#197 Metalian**: Priroda's SBK basis is much larger than Firefly's SBKJC. [unverified]

### Basis sets — pages 13-16, posts #241-#320, 2013-12..2015-06

- **3z.** #247 Гесс (Dec 28, 2013) quotes Evgeniy on qchem.ru (Feb 21, 2010): "Базисы - любые, кроме 3z (этот сверх-ускоренный базис кроме DFT/PBE больше ни для чего не подходит). Имеет смысл использовать лямбда-базисы L1, L2 (из basis.in), L1r, L2r (релятивистские из basis4.in)." ("Any basis except 3z; this super-accelerated basis is good only for DFT/PBE. It makes sense to use the lambda bases L1, L2 from basis.in, and L1r, L2r, the relativistic ones, from basis4.in.") [experienced user, a quote]
  - **#257 EvgeniX (Dec 31, 2013)** [experienced user], answering "Для своих каплкластеров мне 3z лучше не использовать?": "С DFT ещё можно, а вот с неэмпирикой будет безбожно врать, отклонение 30-40 ккал/моль на энтальпию реакции (по сравнению с L2) небольших молекул не предел." (With DFT it's still OK, but with ab initio (post-HF) methods it will lie outrageously: deviations of 30-40 kcal/mol in reaction enthalpies of small molecules (relative to L2) are not the limit.) → **3z: DFT only; never for MP2/CC.**
  - #258 Гесс: "Вас то я и ждал! (у меня было предположение что цитата ваша)" — he had guessed the qchem.ru quote was EvgeniX's (suggests EvgeniX = Evgeniy from qchem.ru). "30-40 ккал/моль превратят мне бабушку в дедушку и Гоголя в Гегеля..."
- **Why prefer the Λ (L) series over 3z — #249 amge (Dec 29, 2013)** [experienced user]: "Даже если в 3z будет не хуже, базисы серии лямбда имеют чисто утилитарные преимущества." (Even if 3z is no worse, the lambda bases have purely practical advantages.)
  1. "на базисы серии лямбда легко сослаться (есть статья), тогда как единственное место, где 3z более-менее описан - диссертация Лайкова (на русском)" (the L bases are easy to cite (there is a paper); 3z is described more or less only in Laikov's dissertation, in Russian).
  2. "название 3z, видимо, не самое удачное: один из рецензентов воспринял это название как обозначение уровня базиса трипл-дзета и просил дать имя базиса" (the name 3z is unfortunate: a referee took it as just "triple-zeta level" and asked for the basis name).
  3. "у базисов серии L, в отличие от 3z, есть близкие аналоги среди общеизвестных базисов (L1 - cc-pvDz, L2 - cc-pvTz, L22 - cc-pcvTz и т.д)" (L bases have close well-known analogues: **L1 ≈ cc-pVDZ, L2 ≈ cc-pVTZ, L22 ≈ cc-pCVTZ**, etc.).
  4. "L - это полноценная серия, тогда как 3z, фактически один единственный (есть еще 2z, но только для первых элементов)" (L is a full series, while 3z is essentially a single basis; there is also **2z, but only for the first elements**).
- **Basis sensitivity at the DFT level.** #249 amge (Dec 29, 2013) [experienced user] (also quoted by Гесс in #251): "Насчет несовпадения результатов в разных базисах - у меня (на уровне DFT) ни разу не было такого, чтобы 3z, L1, L2, L22 давали существенные отличия (как по геометрии, так и по относительной энергии). В basis.in есть легкий базис b1, вот он дает отличия." ("At the DFT level I never saw 3z, L1, L2 and L22 give substantially different geometries or relative energies. basis.in has a light basis **b1**; that one does give differences.")
- **Qualitative basis dependence (Гесс's case).** #251 Гесс (Dec 29, 2013): Priroda has no symmetry, so "симметричный" means "close to symmetric". Most of his calculations find a symmetric minimum; "L2 расчет находит конкретно искаженный вроде как минимум (гессиана пока нет). def2-SVP находит симметричное переходное состояние." (L2 finds a clearly distorted apparent minimum (no hessian yet); def2-SVP finds a symmetric TS.) He calls his system method/basis/"phase of the moon" dependent. [user observation; also shows def2-SVP was used in Priroda]
- **3z vs L1 at CCSD(T).** #255 Гесс (Dec 30, 2013): CCSD(T)/3z found a symmetric transition state, against his expectation. CCSD(T)/L1 and CCSD/L1 gave minima. This is consistent with 3z being unsuitable for correlated methods.
- **Correlation-consistent bases.** cc-pVDZ and cc-pVTZ were used in Priroda for hessians (#289), so Dunning bases can be used from a file.
- **Custom (non-Priroda) basis file**, #319 Aryl: 6-31+G(d) from file `D:\NMR\Nature\basis\6-31+G(d)`, selected with `set=6-31+G(d)` in `$molecule`.
  - The output reads that same file twice. The first read is the orbital basis (C: `18/31 : {4,3,1}/{11,5,1}`; H: `2/4 : {2}/{4}`). The second is the auxiliary (fitting) basis (C: `37/39 : {6,3,3,1}/{8,3,3,1}`; H: `5/10 : {2,1}/{4,2}`).
  - The file must therefore also provide an auxiliary basis under the same set name.
  - The orbital basis shown, `{4,3,1}` for C, actually has no diffuse sp ("+") functions. This hints the custom file was not built correctly (my observation).
  - #320 alxyppv: "Насколько аккуратно у Вас сработаны 'неродные' базис - сложно сказать. Если не очень хорошо - то тоже могут быть проблемы." ("Hard to say how carefully your non-native basis was prepared; if not well, that can also cause problems.")
- **Citations for L-bases**: see Misc.

### Basis sets — pages 17-20, posts #321-#400, 2015-06..2018-12

- **`3z` covers elements up to Z=54 (Xe) only.** amge (#336, 2016-09-29): "в базисе 3z нет висмута. Используйте либо ECP-базис sbk, либо полноэлектронный релятивистский базис basis4.in (в последнем случае не забудьте сказать four=1 в группе $control." Translation: the 3z basis has no bismuth. Use either the ECP basis `sbk`, or the all-electron relativistic basis `basis4.in`, and in the latter case do not forget `four=1` in `$control`. sinigin confirmed (#337): "3z подходит для элементов до 54-го" (3z is suitable for elements up to the 54th). [experienced user]
- **ECP handling vs GAMESS**: sinigin (#337) asked whether he must specify `C-ECP NONE` etc. per element as in GAMESS `$ECP`. amge (#338, 2016-09-30): "В базисе sbk.bas ECP на всех элементах, и, насколько я знаю, управлять этим нельзя. Но если хотите, чтобы ECP было только на тяжелых элементах, можно взять комбинированные базисы, например, 3z + SBK [`http://limor1.nioch.nsc.ru/file/Priroda/20+sbk.bas`]. Либо использовать полноэлектронные базисы серии L из basis4.in." Translation: in `sbk.bas` the ECP is on all elements and, as far as I know, this cannot be controlled. If you want ECP only on heavy elements, take a combined basis file, e.g. 3z + SBK (`20+sbk.bas` at the URL above), or use the all-electron L-series bases from `basis4.in`. So no per-element `ECP NONE` input exists: ECP assignment is fixed by the basis file. [experienced user]
- **Non-native and diffuse bases cause SCF problems.** amge (#321, 2015-06-26), replying to Aryl's report of "SCF is far from convergence" with a non-Priroda basis: "сходимость SCF в базисах с диффузными функциями во всех программах хуже, а Природа с такими базисами совсем не дружит. Если край надо, то хотя бы берите в качестве начального приближения "хорошую" геометрию, уже оптимизированную в родном базисе." Translation: SCF convergence with diffuse bases is worse in all programs, and Priroda really does not get along with such bases. If you absolutely must, at least start from a "good" geometry already optimized in a native basis. [experienced user]
- VTur's characterization of the method (quoted in #329): basis sets had to be reparametrized and fitted to Priroda ("стандартные не идут", standard ones do not work). [unverified; partly a misunderstanding, as the reply in #330/#331 shows]
- **b2 / b4 basis families**: Metalian (#399, 2018-12-10) asked for a review or description of basis "families" b2 and b4. EvgeniX (#400) pointed to `https://arxiv.org/abs/1808.05454` ("не оно?", isn't that it?). This is presumably Laikov's 2018 arXiv paper on the basis sets. [experienced user]

### Basis sets — pages 21-23, posts #401-#460, 2018-12..2020-11

- **B2-type basis composition.** #402 Гесс (Dec 11 2018, 1:45 am) cites
  https://arxiv.org/ftp/physics/papers/0312/0312130.pdf: "В деталях эти базисы наверняка
  знает только сам Лайков" ("Probably only Laikov himself knows these bases in detail"). He
  says the contraction for e.g. B2 can be found "если не в аутпуте то в файле базисов"
  ("if not in the output, then in the basis file"). The table from that paper for B2:
  ```
  Atoms ----- Orbital basis set ---------- Auxiliary basis set
  C,O,N ---- (17s4p1d)/[3s2p1d] --- (25s11p6d1f)/[4s3p2d1f]
  ---H ---------(8s1p)/[2s1p] ----------------(8s1p)/[2s1p]
  ```
  Interpretation (Гесс): a double-zeta basis. For heavy atoms the function count is close to
  cc-pVDZ, but it is clearly more diffuse on H. The number of s primitives on H is
  surprising: the only similarly diffuse H basis he found on bse.pnl was 6-31++G**-J,
  which was built for one specific task. There is no cc-pVXZ-level documentation for
  these bases. [experienced user]
- **Unanswered question:** #410 Metalian (Dec 11 2018) read the paper but "совершенно не понял,
  в чем разница между b2u, b2un, b4s и b4sn" ("did not understand at all the difference
  between b2u, b2un, b4s and b4sn"). No answer in this page range. (These are basis-file names.)
- **Traditional basis sets:** Гесс #408 (Dec 11 2018; also quoted in #409): "Традиционные базисы к
  ней таки прицепили." ("Traditional basis sets have been attached to it after all.")
- **Why not just use L1/L2?** #414 Metalian (Dec 12 2018), replying to YuraM #412: "Тем, что
  расчеты требуют больше машинного времени, чем в случае с ECP-базисами." ("Because the
  calculations need more computer time than with ECP bases.") [experienced user]
- **Limits of the ORCA route for auxiliary bases:** #414 Metalian, replying to YuraM #413:
  "Сгенерировать при помощи ORCA можно те базисы, что в нее зашиты, насколько я понимаю. А в
  нее вроде как CRENBL ECP, LANL2DZ и еще некоторые ECP-базисы не зашиты." ("As I understand,
  ORCA can only generate [auxiliary sets for] the bases built into it, and CRENBL ECP, LANL2DZ
  and some other ECP bases apparently are not built in.") He had not yet installed ORCA.
  [unverified]
- **Converting BSE bases with ECP to Priroda format:** #411 Metalian (Dec 11 2018) asked for
  ready-made scripts that need no commercial software to turn an ECP basis from
  https://bse.pnl.gov/bse/portal into a Priroda basis.
  #413 YuraM (Dec 12 2018): it can probably be done. You need to understand how
  pseudopotentials are written in Priroda's format and rewrite the bases. Auxiliary
  (fitting) bases in Priroda format "можно их сгенерировать свободной программой ORCA"
  ("can be generated with the free program ORCA"). He says this is done and described at
  http://limor1.nioch.nsc.ru/priroda.html [experienced user]
- **All-electron scalar-relativistic bases:** #412 YuraM (Dec 12 2018): "не совсем понятно, чем
  не нравятся скалярно-релятивистские полноэлектронные базисы в Природе типа L1, L2.
  Возможность полноэлектронных расчетов и учета скалярных релятивистских эффектов я считал
  одним из основных достоинств данного пакета." ("It's not clear what's wrong with Priroda's
  scalar-relativistic all-electron bases like L1, L2. All-electron calculations with scalar
  relativistic effects are, I thought, one of the main strengths of this package.")
  [experienced user]
- **ECP basis file problems (Tasha, 2020).** See Known errors. File names: `20+St-rsc-97.bas`
  (a non-native Stuttgart RSC-97 ECP basis, given to her long ago by Sanya1024) and
  `20+sbk.bas` (an SBK-type ECP basis; the Pt variant is called "sbku"). Using `20+sbk.bas`
  works: "ECP считывается когда надо" ("ECP is read when it should be"). #451 Tasha
  (Feb 22 2020): she found the problem in the basis file. While fixing it she also solved
  how to insert pseudopotentials for actinides. The fix itself is not described.
- Other basis files mentioned: `4z.bas` (#460), `3z` and `3z-sbk` (#457 amge, used for Te NMR).

### Basis sets — pages 24-26, posts #461-#518, 2020-11..2026-07

- **4z basis:**
  - amge first offered (#465) to run KuznetsovSM's 4z.bas job himself ("кидайте координаты - попробую запустить себя", "send the coordinates and I'll try running it myself"), then retracted (#466, Nov 6 2020): "Стоп, с последним предложением я погорячился, т.к. ни у меня, ни на сайте Лайкова нет базиса 4z" ("Wait, I was hasty with that last offer, since neither I nor Laikov's site has the 4z basis"). In #470 he renewed the offer after building the file.
  - Гесс (#468): "Для CH-молекулы 4z-bas опубликован в https://www.mdpi.com/2073-4360/12/9/2153/s1". This is a PDF download of the supplementary information for MDPI *Polymers* 12(9):2153 (2020) and covers only C and H.
  - Гесс's warning: "при копировании минусы убиваются в какие то левые символы" ("when copying, the minus signs turn into junk characters"). Check the minus signs after copying the basis from the PDF.
  - amge (#470, Nov 8 2020): "Сделал себе 4z, проверил - вроде работает." ("Built myself the 4z [basis file], tested, seems to work.") His own copy had correct minus signs.
- **`qm.in`** is the basis/parameter file used with `theory=qm_n3` (#481).
- **Basis file seen in output:** `C:\p64\b2un.in` (#515 spa, Windows). It appears twice in the output: the first `Basis set input` block is the orbital basis and the second is the auxiliary (RI) basis.
- **How to read the basis summary line (#515/#516).** Output from spa (#515, May 8 2026), water with RIDFT/PBE1:
  ```
   Kinetic energy corrections:
   atomic number   8: N = 15
   atomic number   1: N = 15
   Basis set input: 'C:\p64\b2un.in'
      1   8  O :  14 /  43 : { 3, 2, 1}                          / {12, 7, 2}                          log2(a) =  -3.02, +16.55
      2   1  H :   5 /  12 : { 2, 1}                             / { 6, 2}                             log2(a) =  -3.51,  +6.67
      3   1  H :   5 /  12 : { 2, 1}                             / { 6, 2}                             log2(a) =  -3.51,  +6.67
   Finite nucleus model (2):
   atomic number   8:  a = 5.863144e+08, c = 2.039675e+13
   atomic number   1:  a = 2.124824e+09, c = 1.758975e+13
   Basis set input: 'C:\p64\b2un.in'
      1   8  O :  30 /  43 : { 4, 3, 2, 1}                       / { 6, 5, 3, 1}                       log2(a) =  -0.62,  +8.40
      2   1  H :   5 /   9 : { 2, 1}                             / { 3, 2}                             log2(a) =  -1.52,  +2.41
      3   1  H :   5 /   9 : { 2, 1}                             / { 3, 2}                             log2(a) =  -1.52,  +2.41
   +---------------------------------------
   | Number of atoms                      3
   | Charge of molecule                   0
   | Spin multiplicity                    1
   | Number of alpha electrons            5
   | Number of beta  electrons            5
   | Number of core  electrons            1
   | Theoretical Method               RIDFT
   | Approximation to E(xc)            PBE1
   | Dimension of wavefunction basis     24
   | Dimension of   auxiliary  basis     40
   | Hamiltonian: non-relativistic
   +---------------------------------------
  ```
  - spa asked what the curly braces mean and how the dimensions 24 and 40 come out: "Я суммирую и ничего не сходится" ("I add them up and nothing matches").
  - amge (#516, May 12 2026) [experienced user]:
    > O : 14 / 43 : { 3, 2, 1} / {12, 7, 2}
    > До контрактаций {12, 7, 2} это 12s7p2d, 12*1 + 7*3 + 2*5 = 43
    > После { 3, 2, 1} 3s2p1d, 3*1 + 2*3 +1*5 = 14
  - Translation: before contraction `{12,7,2}` = 12s7p2d = 12·1 + 7·3 + 2·5 = 43 primitive functions. After contraction `{3,2,1}` = 3s2p1d = 3·1 + 2·3 + 1·5 = 14 functions. Spherical harmonics are used, so d has 5 components.
  - Line format: `atom# Z symbol : N_contracted / N_primitive : {contracted shells per l} / {primitive shells per l} log2(a) = min, max` exponent range (log2).
  - Check (my arithmetic, consistent with amge's explanation):
    - Orbital basis: O 14 + H 5 + H 5 = 24, which matches `Dimension of wavefunction basis 24`. For H, {2,1} = 2s1p = 2 + 3 = 5.
    - Auxiliary basis: the counts are O 30 + H 5 + H 5 = 40, which matches `Dimension of auxiliary basis 40`. For O, {4,3,2,1} = 4s3p2d1f = 4 + 9 + 10 + 7 = 30.
    - The aux basis is also contracted. Its primitives are {6,5,3,1} = 6 + 15 + 15 + 7 = 43 for O and {3,2} = 3 + 6 = 9 for H.
  - "Kinetic energy corrections: N = 15" and "Finite nucleus model (2)" with parameters a and c are printed but were not explained.
  - "Number of core electrons 1" is printed for water and was also not explained (pairs? frozen core?) [open question].

## 7. DFT functionals & methods

### DFT functionals & methods — pages 1-4, posts #1-#80, 2009-02..2011-08

- `$dft functional=PBE $end` (#63). PBE is the workhorse (#15 amge, #41 sanya1024). Hybrids B3LYP/PBE0 mentioned as possible alternatives (#41).
- "Другой значимый для меня недостаток -- отсутствие многих интересных функционалов." (Another drawback: many interesting functionals missing.) — #6 amge.
- MP2 available: "Эта программа и MP2 умеет считать. Активно использую. Правда по времени вроде как от гауссиана сильно не отличается (специально не сравнивал)." (Also does MP2; actively used; timing not much different from Gaussian, not compared specifically.) — #8 EvgeniX, 26 Feb 2009.
- VTur's description of the method from Laikov's dissertation (#7, 26 Feb 2009) [unverified/partly inaccurate layman description]: something between ab initio and semi-empirical; part of exchange (four-centre) integrals not computed, others estimated by recurrence formulas; Coulomb and three-centre integrals for distant nuclei zeroed or computed via multipole expansion → speed; basis re-parametrization; "не всякий функционал подойдет" (not every functional fits). (In reality Priroda uses density fitting / RI with auxiliary bases.) VTur #10: "способ расчета интегралов от способа учета поправок не зависит" (how integrals are computed doesn't depend on the correlation method) — re MP2.
- Concern raised: long-range conjugation / delocalisation over ~150 atoms (#9 Droog_Andrey); VTur: OK if weak delocalisation and no strong interatomic density accumulation (#10) [unverified].
- Bridging bonds: "В ПРИРОДе (да и вроде в других программах) все DFT-функционалы занижают энергии мостиковых связей (вроде C-Al-C, H-Al-H, Zr-H-Al, Zr-Cl-Al и подобные). MP2/L2 вроде хорошо воспроизводит экспериментальные значения." (All DFT functionals underestimate bridging-bond energies; MP2/L2 reproduces experiment well.) — #17 EvgeniX [experienced user].

### DFT functionals & methods — pages 5-8, posts #81-#160, 2011-08..2012-04

- **Hybrids require `theory=ridft`:** "для гибридных функционалов типа b3lyp обязательно нужно theory=ridft, иначе получится бред, хотя программа и не поругается" (for hybrids like b3lyp you must use theory=ridft, otherwise you get nonsense although the program won't complain) — #96 amge, 18 Sep 2011 [experienced user].
  - Explanation, #99 sanya1024: without RIDFT the program "забудет" (forgets) the admixture of HF exchange → a functional with a strange ratio of KS exchange and correlation; "явно будет не расчет с желаемым гибридным функционалом" (definitely not a calculation with the desired hybrid). [experienced user]
- **NMR only with theory=dft (non-hybrid):** "хим. сдвиги Природа умеет считать только при theory=dft, поэтому используйте functional=pbe" (Priroda computes chemical shifts only with theory=dft, so use PBE) — #96 amge.
- CCSD available: `theory=CCSD` (incl. geometry optimization) — #146 sanya1024 (example below). CCSD(T) asked about in #144 — no explicit CCSD(T) keyword given in answer.
- **Not available:** MRCI, CASPT2 — "Нет таких (ни команд, ни методов). Пользуйтесь ORCA" — #156 EvgeniX, 18 Apr 2012 [experienced user].
- **TDDFT / UV spectra:** `theory=tddft` — #158 amge (see Excited states).
- **Full input — CCSD geometry optimization of H2CO** — #146 sanya1024, 22 Dec 2011 [experienced user]:
  ```
  $control
   task=optimize
   theory=CCSD
   basis=basis.in
  $end
  $optimize tol=1e-5 $end
  $molecule
   z-matrix
     6
     8    1    1.20055382
     1    1    1.10516882    2    122.595004
     1    1    1.10516882    2    122.595004    3    180.000000
  $end
  ```
  "Понятно, что координаты можно задавать и декартовы" (Cartesian coordinates are also possible). Z-matrix lines: atomic number, reference atom, distance, reference atom, angle, reference atom, dihedral.

### DFT functionals & methods — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#219 sanya1024, 8 Dec 2013** [experienced user]: alpha and beta orbitals in output come from the **unrestricted** Kohn-Sham method ("неограниченный метод -- в данном случае -- Кона-Шема, раз речь о Природе"), i.e. different orbitals for different spins.
- **#218 VTur**: in this model all electrons are unpaired and split into alpha and beta, each with its own orbitals and energies.
- **#228 amge, 16 Dec 2013** [experienced user]: "Хвосты могут слипаться благодаря дисперсионным поправкам в функционале … **Но в Природе (если речь о ней) функционалов с такими поправками нет.**" (Tails can stick together because of dispersion corrections in the functional. **But Priroda, if that is what we are talking about, has no functionals with such corrections.**) As of Dec 2013 there was no DFT-D in Priroda.
- **#235 Tasha, 16 Dec 2013**: PBE describes vdW and dispersion forces, but poorly. References:
  - http://onlinelibrary.wiley.com/doi/10.1002/jcc.20078
  - http://scitation.aip.org/content/aip/journal/jcp/107/19/10.1063/1.475105
  - http://scitation.aip.org/content/aip/journal/jcp/117/13/10.1063/1.1501132
- **#240 amge**: "PBE хоть и недооценивает дисперсионное взаимодействие, но все же не игнорирует его напрочь" (PBE underestimates dispersion but does not ignore it completely). So flexible alkyl tails can attract weakly under PBE.
- **#236 Гесс**: to check dispersion effects, run optimizations in ORCA with and without dispersion correction ("в орке … там это реализовано", ORCA has it). Link to an earlier forum dispute: viewtopic.php?f=71&t=101390&start=20#p755290.
- **#237 VTur**: strange, look at NMR. Alkane tails repel sterically ("как существуют мембраны клеток?", how would cell membranes exist otherwise?). **#238 Droog_Andrey**: "им положено слипаться, только не слишком сильно" (they are supposed to stick, just not too strongly).

### DFT functionals & methods — pages 13-16, posts #241-#320, 2013-12..2015-06

- **Hybrids with `theory=dft`.** #310 amge (Oct 1, 2014) [experienced user]: "theory=dft нельзя использовать с гибридными функционалами. На ранних версиях природы такое успешно считалось, но результаты были неправильные (типа длина С-Н 1.2 ангстрем). Это еще хуже, чем зависание." ("theory=dft cannot be used with hybrid functionals. Early versions of Priroda ran it 'successfully' but gave wrong results, like a C-H length of 1.2 Å. That is worse than a hang.") This is the key fact for the hybrid-functional MPI_Abort in #307.
- **Hybrids with `theory=dft` in newer versions abort.** #307/#309 Гесс (Sep 30, 2014): replacing PBE by B3LYP or PBE1 under `theory=dft` gives `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` after the basis is read; alxyppv's ridft sample works, but the same sample with `dft` fails identically. Гесс: "Возможно эта комбинация в природе и врет, но вот совсем несчитаться - это какой то очень грубый метод "нерекомендовать"." (Maybe the combination gives wrong results, but refusing to run at all is a crude way to "not recommend" it.) Combined with #310: older versions ran hybrid+dft silently with wrong results; newer versions abort. **Use `theory=ridft` for hybrids.**
- **ridft.** #308 alxyppv (Sep 30, 2014) [experienced user]: "это было с ridft или без? если у Вас просто гибридные функционалы не работают в Природе, то вот в приложении входной файл который точно работал (но это было очень очень давно...). а если дело именно в ridft - то тут запросто может быть что без ridft код просто не работает..." ("Was it with ridft or without? If hybrids just don't work for you, here is an attached input that definitely worked, long ago. If it's about ridft, the code may simply not work without ridft.")
  - The attachment is not available. Гесс #309 confirms the sample "именно ridft" (is precisely ridft) and that changing it to dft reproduces the failure — i.e. `theory=ridft` (cf. the ridft explanation in notes_05-08, #96/#99).
- **Unnoticed problem in #319 (my observation).** The input uses `theory=DFT` with `functional=B3LYP`. Per #310 this combination is not valid, and it may explain that SCF failure. Nobody in the thread pointed it out.
- **Dispersion in PBE.** #246 sanya1024 (Dec 27, 2013) [experienced user]: in Priroda, the PBE potential curve for He2 with a triple-zeta basis has a minimum ("немножко дисперсии в PBE есть" ("there is a little dispersion in PBE")). It is too weak, and possibly an artefact of error cancellation. It grows with contact area, so it shows up for long alkyl chains. For real dispersion she recommends MP4 ("не MP2!" ("not MP2!")), CCSD(T), Grimme's DFT dispersion correction, force fields fitted to CCSD(T), or EFP.
  - Context, #244-#245 Tasha/kbob: long alkyl tails "stick together" in gas-phase PBE calculations.
- **MP2 and basis size.** #281 VTur (Jan 10, 2014): "С МР2 чем меньше базис, тем значительно хуже, чем с DFT. МР2 любит большие базисы" ("With MP2 a smaller basis hurts far more than with DFT; MP2 likes big bases").
- **MP2 failure example.** #283 sanya1024 (Jan 17, 2014): MP2 predicts planar naphthalene as a saddle point, with an imaginary "book-folding" mode, in 6-31G*. MP4 in the same basis fixes it.
- **MP2 benzene non-planarity.** #274 Yu/2 (Jan 9, 2014) cites http://pubs.acs.org/doi/abs/10.1021/ja0630285 (benzene/arenes predicted nonplanar by popular methods) and adds: "там проблема в том, что базисы очень плохие" ("the problem there is that the bases are very poor"). #275 Гесс: "6-311++G(d,p) - плохой базис??? Он возможно артефактит на конкретной задаче. А возможно MP2." ("6-311++G(d,p) a bad basis??? Maybe it gives artefacts on this particular problem. Or maybe it's MP2.")
  - #277 Yu/2 [experienced user]: "Да, это "плохой" базис. А MP2 -- очень удачное приближение. Это "хороший" метод." (Yes, it is a "bad" basis. And MP2 is a very successful approximation, a "good" method.)
  - #279 Гесс: in his case MP2 "врет как бешеное (по сравнению с CCSD(T), в геометриях, частотах, энергиях), в то время как основанные на B3LYPe методы воспроизводят каплкластер очень и очень" (MP2 is wildly wrong vs CCSD(T) in geometries, frequencies and energies, while B3LYP-based methods reproduce his drop cluster very well).
  - #280 Yu/2: "MP2 пригоден не для всех электронных задач. И CC, кстати, тоже, что не делает эти методы плохими. Их сила в систематичности. А DFT в существенной степени эмпирическая в большинстве реализаций" (MP2 isn't suitable for all electronic problems, nor is CC, which doesn't make them bad; their strength is systematic improvability, whereas DFT is largely empirical in most implementations).
- **Benzene flexibility scan.** #270 amge (Jan 8, 2014) [experienced user], after VTur's advice to scan in a large basis ("В малом его гнет хорошо"): "Самый плоский потенциал получился как раз в наиболее навороченном базисе. Но зависимость от базиса настолько минимальна, что можно говорить об ее отсутствии." (The flattest potential came out in the most elaborate basis, but the basis dependence is so small it is practically absent.) Image benzene_scan.png not available.
- **Lanthanide spin states.** #282 Tasha (Jan 12, 2014): Eu complexes computed in Priroda come out with a high-spin minimum (multiplicity about 7), while experiment (NMR) suggests low spin. #284 sanya1024: 4f electrons are too shielded for low-spin states; the alternative is LMCT, Eu(III) to Eu(II), also high-spin. Tasha moved this to a separate thread (#285).

### DFT functionals & methods — pages 17-20, posts #321-#400, 2015-06..2018-12

- **B3LYP requires `theory=ridft`**: amge (#321): "Для B3LYP обязательно нужно theory=ridft. Но это гораздо дольше, чем с чистым GGA-функционалом типа BLYP или PBE. Рекомендую сначала оптимизировать геометрию с theory=dft и functional=PBE." Translation: B3LYP requires `theory=ridft`, which is much slower than pure GGA functionals such as BLYP or PBE. First optimize the geometry with `theory=dft` and `functional=PBE`. [experienced user]
- **Methods available**: Гесс (#331): "DFT, MP2, CCSD(T), полуэмпирике..." (DFT, MP2, CCSD(T), semiempirics...). This corrects Суровый's (#330) claim, based on the thesis abstract, that the program is only about DFT. [experienced user] Суровый (#332, 2016-09-26) followed up: "CCSD(T) тоже с ускорением расчётов или там оригинальный метод?" (Is CCSD(T) also accelerated, or is it the original method?) No answer in this page range.
- RI-MP2 is present and parallelizes better than DFT (#343 EvgeniX).
- **No dispersion (VdW/D3) correction**. *php* (#346) relayed a US colleague's question ("PBA", sic, PBE). Любитель_Манниха (#347): "Аффтар природы не собирается вводить эту поправку (выяснено из переписки)." Translation: the author does not plan to add this correction (learned from correspondence). [second-hand from Laikov → semi-authoritative]
  - amge's workaround (#348): Priroda users usually use PBE, which "провирается на дисперсионных поправках не очень сильно" (errs only mildly on dispersion, unlike B3LYP). D3 can be added a posteriori for the final geometry with Grimme's program (dftd3). The corrections are "обычно меньше килокалории" (usually under 1 kcal/mol), and he has never seen D3 change a result qualitatively. [experienced user, opinion]
  - Counterpoints: Гесс (#349, 2016-11-23) asked for a reference for the PBE claim, and objected: "Но это DFT, а не DFT-D геометрия, из чего может вылазить разница" (but that is a DFT, not a DFT-D geometry, which can produce a difference), and reminded amge of his own argon-dimer curves. His data: for the neutral fullerene dimer near the real minimum, the dispersion correction (D3BJ-corrected minus uncorrected) is "более 13 ккал/моль на B3LYP/cc-pVTZ" (over 13 kcal/mol at B3LYP/cc-pVTZ; cc-pVDZ is fine for tests, basis size is not critical here) and at least 7 kcal/mol for several other functionals tested. Moreover, for most functionals without dispersion "кривая вообще не имеет минимума - отталкивание плавно нарастает по мере сближения частиц" (the curve has no minimum at all; repulsion grows smoothly as the fragments approach). Exceptions are functionals with van der Waals built into the parametrization, or old "crooked" functionals that give the right behaviour by accident. [experienced user]
  - amge's reply (#350, 2016-11-23): he could not find the reference for the PBE claim. On DFT vs DFT-D geometries: "скорее всего, разница будет вылазить только на очень особых объектах" (most likely the difference shows up only for very special objects). On the argon dimer: "качественного отличия у PBE и PBE-D3 не было (и там, и там минимум, но с D3 более глубокий и тесный)" (there was no qualitative difference between PBE and PBE-D3: both have a minimum, but with D3 it is deeper and tighter). But he agreed: "тому, кто занимается DFT-расчетами всяких VDW-комплексов, без дисперсионной коррекции нельзя и Природа сгодится разве что как пре-оптимизатор" (anyone doing DFT on VDW complexes cannot do without a dispersion correction, and Priroda is good at most as a pre-optimizer). [experienced user]
  - YuraM (#353, 2016-11-24) supplied the reference: PBE gives geometries closer to dispersion-corrected functionals than B3LYP does, and "PBE рекоммендуется когда DFT-D функционалов нет" (PBE is recommended when DFT-D functionals are unavailable). Paper: "The accuracy of DFT-optimized geometries of functional transition metal compounds: a validation study of catalysts for olefin metathesis and other reactions in the homogeneous phase." [experienced user] On the size of the correction, YuraM (#353): for association/dissociation of ~100-150-atom molecules, the corrections are "чудовищны, и бывают 20-30 ккал/моль" (monstrous, sometimes 20-30 kcal/mol). Without them many systems would dissociate in solution, e.g. Grubbs catalysts (Org. Lett. 2007, 9(10), 1967-1970; J. Phys. Chem. A 2009, 113(43), 11833). [experienced user]
- Energy components output (#375 EvgeniX, 2017-12-30; repeated in #382 with no answer):
  ```
  E  =    -232.0211375591
  T  =     230.89636282  V  =    -944.03076786  J  =     312.67315771
  Ex =     -33.07586264  Ec =      -1.37265420
  ```
  Question: why T+V+J+Ex+Ec ≠ E. Their sum is ≈ −434.91. **Answer** (EvgeniX #382, 2018-03-11, relaying Laikov): "Автор ответил, что нужна ещё энергия отталкивания ядер." (The author replied that the nuclear repulsion energy must also be added.) So E = T + V + J + Ex + Ec + E_nn, and E_nn is not printed in that line (here E_nn ≈ +202.89 Eh). [second-hand from Laikov → semi-authoritative]

### DFT functionals & methods — pages 21-23, posts #401-#460, 2018-12..2020-11

- PBE/cc-pVDZ was used for the ORCA comparison (#415 amge, recovered from quote in #416).
- OLYP: `$dft func=OLYP $end` (#460).
- **DFT-D3 is not built in:** #417 amge (Dec 13 2018): "Что досадно, это отсутствие в природе
  растворителя и DFT-D3." ("What's annoying is that Priroda has no solvent model and no
  DFT-D3.") #419 amge: he has a script that runs the external D3 utility (Grimme's dftd3,
  implied) and writes the dispersion correction into the 2nd line of the xyz files. That is
  only a single-point correction, and in a few cases the geometry depends strongly on D3.
- Workaround ideas: EvgeniX #420 (recovered from quote in #424): "Посчитать градиенты, сделать
  внешний оптимизатор? )))" ("Compute the gradients and build an external optimizer?").
  YuraM #421 (Dec 13 2018): "я же такой скрипт со студентами написал для оптимизации в
  Декартовых координатах" ("I wrote such a script with students for optimization in Cartesian
  coordinates"), meaning an external optimizer that combines Priroda gradients with D3. The
  script is not posted. [experienced user]
  #424 amge (Dec 13 2018): "А скорость его работы по сравнению с нормальным расчетом не
  замеряли? Я тоже думал и чем-то таком, но боюсь, с подобными костылями исчезнет главное (для
  меня) преимущество Природы - скорость." ("Did you measure its speed against a normal run? I
  thought of something like that too, but I fear that with such crutches Priroda's main
  advantage (for me), its speed, will disappear.") [experienced user, opinion]
- **Laikov's semiempirical "QM" method:** #408 Гесс (Dec 11 2018): "там есть лайковская
  полуэмпирика QM, в некоторых вопросах показывающая очень хорошие результаты (на уровне
  GFN2-xTB и DFTB, то есть намного лучше чем PM7 и все его предшественники)" ("it has Laikov's
  semiempirical QM, which in some questions shows very good results, on the level of GFN2-xTB
  and DFTB, i.e. much better than PM7 and all its predecessors"). [experienced user]
- **RI inconsistency:** #408 Гесс: Priroda should "избавиться от этого дурдома с применением ri
  «здесь только с RI, здесь только без RI»" ("get rid of this madhouse with RI usage: 'here only
  with RI, here only without RI'"), i.e. some methods are available only with RI and others
  only without it. [experienced user, criticism]

### DFT functionals & methods — pages 24-26, posts #461-#518, 2020-11..2026-07

- **OLYP and dispersion (#470 amge, Nov 8 2020)** [experienced user]:
  - He tested **OLYP/4z on C17H36**, whose most stable conformation is not linear but П-shaped (hairpin) because of dispersion.
  - Finding: "у OLYP, как и у B3LYP без D3, хуже с дисперсией, чем у PBE - ножки буквы П еще более не параллельны" ("OLYP, like B3LYP without D3, handles dispersion worse than PBE; the legs of the П are even less parallel").
- **Supported functionals:** Metalian (#494, Feb 3 2022) asked "Есть ли актуальные данные по поддерживаемым Природой функционалам?" ("Is there current info on functionals supported by Priroda?"). There was no answer in this page range.
- **Dispersion-corrected DFT in v23 (#511 YuraM, #512 amge, Jul 2024):**
  - YuraM thinks v23 may have a DFT functional that accounts for dispersion, and asks whether RI works for it.
  - amge: the new example input `2H6C6_n3.dfl6a.1a.in` "Похоже, это оно. Можно проверить. Но судя по theory=riDFT, RI работает." ("Looks like this is it. Could be checked. Judging by theory=riDFT, RI works.")
  - The name suggests a benzene dimer (2 × C6H6), "n3" and a "dfl6a" functional [inference].
- **PBE1 (PBE0):** spa's output shows `Approximation to E(xc) PBE1` with RIDFT (#515).
- **qm_n3 (Laikov's semiempirical/"QM" method):**
  - Paper: https://aip.scitation.org/doi/10.1063/1.3646498 (Laikov, J. Chem. Phys. 135, 134120 (2011)).
  - Yellow21chem (#479, Dec 21 2021): it "с помощью которого можно достаточно быстро оптимизировать системы из несколько сот атомов" ("can fairly quickly optimize systems of several hundred atoms").
  - Гесс (#480, Dec 23 2021) [experienced user]: "насколько я помню qm природы - там есть шанс свести 2500 атомов. Качество энергий которые мы им получали для малых систем было выше чем у большинства классической полуэмпирики и примерно на уровне обоих традиционных тайтбайндингов: dftb+ и gfn-xtb2"
  - Translation: "with Priroda's qm there is a chance to converge 2500 atoms. Energy quality we got for small systems was higher than most classical semiempirics and roughly on par with DFTB+ and GFN2-xTB."
  - amge (#487, recovered from quote in #490; #487 itself is not in the restored text): "Так то Лайковская полуэмпирика многократно опробована, ничего такого совсем плохого не было." ("Laikov's semiempirics has been tested many times; nothing really bad.")

## 8. SCF convergence problems & fixes

### SCF convergence problems & fixes — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#185 EvgeniX** [experienced user]: large metal clusters (Pt12Al6(OH)4) will probably have wavefunction convergence problems.
- **#194 EvgeniX, 16 Jan 2013** [experienced user]: "Вряд ли проблемы с SCF будут, в ПРИРОДе SCF сходится значительно лучше, чем во многих других квантово-химических пакетах. Вот оптимизация структуры хуже, чем например, в Gaussian'е." (SCF problems are unlikely; in Priroda SCF converges much better than in many other QC packages. Geometry optimization, however, is worse than e.g. in Gaussian.) Same post: "В основном проблемы со сходимость будут для металлов в низких степенях окисления. В тех случаях, когда начинает проявлятся некоторый многоконфигурационный характер. Или при использовании очень гигантских базисов.. Если рассчитывать металлы в высших степенях окисления, то проблем, как правило никогда не бывает." (Convergence problems mostly come with metals in low oxidation states, where some multiconfigurational character appears, or with very large basis sets. Metals in high oxidation states usually give no problems.)
- **#187 Metalian** (Firefly user): SCF in Firefly "обычно сходится" with `DAMP=.t., SHIFT=.t., SOSCF=.t.`, sometimes toggling one of them (Firefly options, for comparison). #195: his Pt is in oxidation state 0 or slightly higher — the "low oxidation state" risk group per EvgeniX.
- **#187 Metalian**: for Pt4Al2, the triplet lies below the singlet and quintet. Multiplicity probably does not change along the reaction. He mentions a paper on Pt/Pd clusters with nonet ground states at about 10 atoms.

### SCF convergence problems & fixes — pages 13-16, posts #241-#320, 2013-12..2015-06

- **Case 1: diverging SCF.** #305 YuraM (May 27, 2014) posted this SCF log (energy about -2800 a.u.; it diverges at "h = -25.15!"):
```
 Grid:   114960 points
   0  -2798.6760461674   0.0000000000   0.21371967    289.3
   1                                    0.12422695     32.1
   2                                    0.09700103     64.7
   3                 hmin = -0.298      0.06527505     96.8
   1  -2800.9585017555  -2.2824555881   0.09377744    576.3
   1                                    0.05466149     34.6
   2                                    0.02929557     67.0
   3                                    0.01513771     99.5
   4                 hmin = -0.112      0.01657128    132.0
   2  -2802.1770910374  -1.2185892818   0.05471068    899.9
   1                                    0.03161015     32.1
   2                                    0.20694357     64.8
 h = -25.15!
```
  Changing functionals did not help.
- **Fix 1: restart from saved vectors.** #306 amge (May 27, 2014) [experienced user]: "Иногда помогает следующее" ("Sometimes the following helps"):
  1. Set a moderate number of SCF cycles, e.g. `iterations=10` in `$scf`.
  2. Turn on writing of the vectors file: `save=filename` in `$control`.
  3. If after those cycles the SCF gradient is still too large and Priroda exits with "SCF is far from convergence", restart from the last vectors with `read=1` in `$guess`.
  4. "кол-во циклов SCF стоит поставить таким, чтобы hmin не зашкаливало" ("pick the number of SCF cycles so that hmin does not go off the scale").
  5. Repeat as needed. amge has automation scripts for this ("у меня есть средства автоматизации" ("I have automation tools")).

  Sketch assembled from his description (not posted verbatim):
```
$control ... save=vectors.dat $end
$scf iterations=10 $end
$guess read=1 $end      (on restart)
```
- **Case 2: SCF fails on Windows (Priroda 6).** #319 Aryl (Jun 25, 2015). Error `SCF is far from convergence`; changing `conv` did not help; the basis is non-native. Full input, verbatim:
```
$system
 memory=1024
 disk=5
 path=.
$end
$control
 task=optimize theory=DFT four=0
 basis=D:\NMR\Nature\basis\6-31+G(d)
$end 
$dft
 functional=B3LYP
$end
 $grid 
acc=1e-6 $end
$scf conv=1e-5 $end
$optimize steps=300 tol=1e-5 cartesian=1 $end
$molecule
 charge=1
 mult=0 cartesian
 set=6-31+G(d) 
6	0	0	0
6	1.3932	0	0
6	2.1003	1.2099	0
6	1.3932	2.4163	0.0048
6	-0.002	2.412	0.0101
6	-0.7004	1.2063	0.0068
6	3.6077	1.1573	-0.0101
7	4.2079	2.2033	0.7894
6	5.4235	2.6097	0.4739
7	6.2822	2.024	-0.5019
6	5.6782	1.0482	-1.3997
6	4.1361	1.1147	-1.4662
6	6.2642	1.079	-2.8171
6	5.771	2.2575	-3.6261
6	4.2581	2.2814	-3.6831
6	3.6604	2.297	-2.2894
7	6.0605	3.712	1.1782
7	5.5682	4.1451	2.2574
7	5.2744	4.6564	3.2218
1	-0.5473	-0.9538	-0.0006
1	1.9389	-0.9554	0.0032
1	1.9336	3.3748	0.0078
1	-0.5504	3.3654	0.0195
1	-1.7998	1.2053	0.0116
1	3.9073	0.1683	0.4671
1	6.9032	2.6637	-0.9542
1	5.9477	0.0417	-0.9482
1	3.7701	0.167	-1.9452
1	5.9579	0.1257	-3.3239
1	7.3846	1.0892	-2.7714
1	6.1856	2.1934	-4.6662
1	6.1467	3.2142	-3.1765
1	3.89	       1.3821	-4.2434
1	3.9168	3.1902	-4.2439
1	3.9349	3.2566	-1.7763
1	2.5403	2.2679	-2.3587
$end
```
  Key output excerpt, verbatim (summary block and SCF log, abbreviated in the middle):
```
 +---------------------------------------
 | Number of atoms                     36
 | Charge of molecule                   1
 | Spin multiplicity                    0
 | Number of alpha electrons           67
 | Number of beta  electrons           68
 | Number of core  electrons           19
 | Theoretical Method                 DFT
 | Approximation to E(xc)           B3LYP
 | Dimension of wavefunction basis    376
 | Dimension of   auxiliary  basis    788
 | Hamiltonian: non-relativistic
 +---------------------------------------

 scf options: conv=1.0e-04, 1.0e-01; iter=16,16
 cut-off for S,T,V integrals: 1.0e-10 (1.0e-06)

 grid: accuracy=1.0e-05,1.0e-03, cut=1.0e-07,1.0e-05
 ...
 it.       energy       energy change    gradient     time
 Grid:    33092 points
   0   -762.9007029165   0.0000000000   0.70828983      3.2
   1                                  233.69288672      1.1

 lowest eigenvalue = -1814.64!!!
   2                                  233.69035554      2.3
   1   -756.2309660231   6.6697368934   0.71047781      7.1
 ...  (energy rises every macro-iteration)
 Grid:   118136 points
  14      1.5262747452 232.8088585804   4.18771550     64.8

 lowest eigenvalue =   -21.61!!!
   1                                  278.52276772      1.1

 lowest eigenvalue = -788121.66!!!
   2                                  113.92142232      2.3

 lowest eigenvalue = -838214.51!!!
   3                                  114.89121266      3.5
  15    333.0810076749 331.5547329297   5.03959633     70.8
 no convergence!
 ...
  16 F,   31 F1

  E  =     333.08100767
  T  =     763.17039360  V  =   -2515.83963670  J  =     760.20271099
  Ex =     -80.90288596  Ec =      -4.04956452

  dipole = 399.022533 au (1014.221908 D)
 ...
 virtual:
  68   -26.932136   69   -26.822778   ...      (virtual orbital energies negative — nonsense)
 ...
 SCF is far from convergence
```
- **Fix 2: grid, SCF settings and BFGS.** #320 alxyppv (Jun 25, 2015) [experienced user], verbatim:
```
$grid            
 accuracy=1e-9   
$end 
```
  "1e-8 сойдет для грубых расчетов, совсем точных лучше 1e-10" ("1e-8 is fine for rough work; for really accurate work 1e-10 is better").
```
$scf             
convergence=1e-7 
procedure=bfgs
iterations=250
$end            
```
  - "у вас стояло очень маленькое число итераций (16). очень мало какая задача успеет сойтись за столько шагов. А у Вас диффузные функции. с ними всегда сходимость так себе..." ("You had a very small number of iterations, 16; very few jobs converge in that many steps. And you have diffuse functions, which always converge poorly.")
  - "для сложных случаев (да почти для всех) лучше работает procedure=bfgs" ("for difficult cases, which is nearly all of them, procedure=bfgs works better").
  - Use `convergence=1e-8` for better convergence, "но тогда и grid надо частым делать - типа 1e-9 или 1e-10" ("but then the grid must be finer too, 1e-9 or 1e-10").
  - Non-native bases may be badly prepared (see Basis sets).
- **My observations on #319, not raised in the thread.** These are all likely contributors to the failure:
  - `mult=0` with an odd electron count (H17C14N5, charge +1, 135 electrons) gives "Spin multiplicity 0" with alpha 67 / beta 68. It should be `mult=2`.
  - `theory=DFT` with hybrid B3LYP, which #310 says is invalid.
  - The custom basis file gives an orbital basis without diffuse functions for C.
  - The `$scf`/`$grid`/`$optimize` settings were apparently not applied (defaults printed).
  - The huge negative "lowest eigenvalue" lines appeared from the first iteration.

### SCF convergence problems & fixes — pages 17-20, posts #321-#400, 2015-06..2018-12

- Error `SCF is far from convergence` (Priroda 6, Windows 7 64-bit, non-native basis). Varying `conv` does not help (#321 Aryl). Fixes from amge (#321):
  1. bad starting geometry: "У вас очень плохая начальная геометрия. Настолько, что даже непонятно, что это такое." (Your initial geometry is very bad, so bad that it is not even clear what it is supposed to be.) He attached a corrected `A.xyz`. "Плохая сходимость SCF может быть и из-за этого" (poor SCF convergence can also be because of this).
  2. use `theory=ridft` for B3LYP, and pre-optimize with `theory=dft`, `functional=PBE`
  3. avoid diffuse and non-native bases, or start from a geometry optimized in a native basis
- See the `$scf` `convergence` + `iterations` quirk (needs `procedure=bfgs`) under Input groups.
- `NaN` energy at the first SCF step makes an "optimization" stop after one step. See Geometry optimization (#335/#336).

## 9. Geometry optimization

### Geometry optimization — pages 1-4, posts #1-#80, 2009-02..2011-08

- `$optimize steps=100 $end`, `$optimize tol=1e-5 $end`, frozen coords via `fix=... value=...` (see Input section).
- Anion of quinone-imine with SO2Alk group: `optimize+hessian` with TZVPP detaches the SO2Alk group, energy decreasing (#38-#40 OrganikNV). sanya1024 (#41): likely physics, not a bug — no local minimum for that configuration with PBE; a hybrid (B3LYP/PBE0) might give a shallow local minimum.
- Gas-phase anions change structure during optimization; Droog_Andrey: "Анионы в газовой фазе карпизны." (Anions in the gas phase are capricious.) — #53-#55.
- Br-containing carbocations: DFT failed to optimize some known structures but optimized non-existent ones (same with Gaussian/B3LYP); MP2/L1 handled it well — #17 EvgeniX.
- Performance: ~70 carbons, ~1700 basis functions — geometry optimization takes a few hours on a single-processor computer; Hessian longer but fits overnight — #6 amge, Feb 2009.

### Geometry optimization — pages 5-8, posts #81-#160, 2011-08..2012-04

- Convergence tolerance: `$optimize tolerance=grad,displ $end` (au), default `0.0001,0.01`; if only first given, second = 100× (recommended) — #109 [quotes manual]. Example `$optimize tol=1e-5 $end` (#146).
- `$optimize steps=300 $end` to raise max number of steps (#152).
- Failed optimization (#118 OrganikNV, files not viewable): amge #119 suspected very old Priroda version and strange basis; v6 with L2/L22m/L22 converged in 6–7 steps.
- **Ferrocene optimizes to eclipsed conformation** even when started from staggered (#136 eFo, 5 Dec 2011). Explanations: EvgeniX #137 — maybe the reference staggered structure was optimized in v4 with slightly different convergence criteria [unverified] (eFo #138: no, the start was simply a `.mol` file "с идеальной геометрией" found on the internet); amge #139, 6 Dec 2011 [experienced user]: "Потому что минимум энергии - это именно заслонённая конформация, а "заторможенная" - переходное состояние." (Because the energy minimum is precisely the eclipsed conformation, and the "staggered" one is a transition state.) eFo #140/#142: this contradicts what was taught in crystal chemistry (where the point group was even determined as staggered) — i.e. solid-state/textbook structures need not match the gas-phase minimum. Droog_Andrey #141 [experienced user]: for Fe the 18-electron sandwich makes the more symmetric (eclipsed) rotamer slightly more stable; chromocene and nickelocene are staggered; #143: methyl substituents could sterically push the eclipsed form out of the global minimum. (Physically: ferrocene's eclipsed D5h is indeed the gas-phase minimum — so Priroda's result is correct.)
- Freezing coordinates (#84 sanya1024, 19 Aug 2011) [experienced user]: use only when you know why. Uses: (1) relaxed scan along a coordinate; (2) subsystem A+B (protein fragment + ligand, surface + adsorbate) — freeze the fragment taken from experiment/MD and optimize only the ligand/adsorbate. "с такой заморозкой, когда нужно заморозить большое количество декартовых координат, а остальную оптимизацию вести во внутренних, в Природе довольно плохо. Но это можно в Орке делать." (Freezing many Cartesian coordinates while optimizing the rest in internals is done rather poorly in Priroda; ORCA can do it.)
- Bonds drawn in the input/visualizer are irrelevant to QC programs; only atoms and coordinates are read; visualizers draw bonds by a hard-coded distance threshold (e.g. 1.545 vs 1.550 Å may flip a drawn bond) — #83 sanya1024.

### Geometry optimization — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#176 wait, 11 Aug 2012** [experienced user]: where to find the optimized geometry: (1) the program has finished; (2) near the end of the output there is "**OPTIMIZATION CONVERGED in ?? steps!**". Right below it are the optimized geometry and energy, on lines starting with **`MOL>`**:
  ```
  MOL> ...
  MOL> ...
  ```
- **#213 sweetheart, 26 Aug 2013**: built a structure in Chemcraft and got Cartesians (nitrobenzene, 14 atoms):
  ```
  6 -3.599214066 5.000568089 -2.755778119
  6 -4.168131609 3.919707763 -2.081629468
  6 -4.164665127 3.926580579 -0.686768292
  1 -4.604427642 3.091201735 -0.142093612
  6 -3.599773111 5.000862603 0.009153937
  6 -3.030524120 6.081537116 -2.081626005
  1 -3.600047611 5.000993715 1.099499499
  1 -2.599259289 6.899950002 -2.654370101
  6 -3.034467459 6.074924358 -0.686758890
  1 -2.594373382 6.910127430 -0.142076544
  1 -4.598670552 3.100917531 -2.654378862
  7 -3.598680807 5.000298391 -4.241700511
  8 -4.110363850 4.029536677 -4.812718364
  8 -3.086398294 5.970747264 -4.812706443
  ```
  The Priroda documentation ("файл инфа о Природе") shows a Z-matrix example (verbatim):
  ```
  1
  7 1 1.026
  1 2 1.026 1 105.116
  8 2 1.464 3 102.846 1 107.322
  1 4 0.972 2 101.187 1 -125.643
  ```
  The format per line is `Z  refatom bond  refatom angle  refatom dihedral`. She asked how to get the Z-matrix form because "с такими как в первом программа не считает" (the program won't run with the first form).
- **#214 sanya1024** [experienced user]: "нормальные декартовы координаты в формате Природы. Покажите инпут файл. Второй вариант -- это z-матрица. Мороки с ними много, а смысла их использовать -- не очень." (These are normal Cartesian coordinates in Priroda format. Show the input file. The second form is a Z-matrix: a lot of hassle and not much point.)
- **#216 amge** [experienced user]: "Действительно, нормально считает" (it really does run fine) with those Cartesians. The poor starting guess does not matter. The right starting guess is nitrobenzene with the nitro group perpendicular to the ring. The input file was attached but is not visible.
- **#194 EvgeniX, 16 Jan 2013** [experienced user]: "оптимизация структуры хуже, чем например, в Gaussian'е" (Priroda's structure optimizer is worse than e.g. Gaussian's), while its SCF converges better than in many packages.
- **#227 Tasha, 15 Dec 2013**: several long alkyl chains in one molecule "склеиваются" (stick together) after optimization. Is it the program, DFT, or user error? See DFT functionals and TS/scan.

### Geometry optimization — pages 13-16, posts #241-#320, 2013-12..2015-06

- **Symmetric starts.** #254 amge (Dec 30, 2013) [experienced user]: "С симметричными структурами нужно осторожно. Обычная ситуация: симметричное начальное приближение после успешной оптимизации остается симметричным, а после расчета гессиана выясняется, что это седло. И это несмотря на С1. Т.е. если оптимизация не нарушила симметрию, то обязательно считать гессиан. С1 - не гарантия спуска в минимум." ("Be careful with symmetric structures. A symmetric starting guess often stays symmetric through a successful optimization, and the hessian then shows it is a saddle point, even in C1. So if the optimization did not break the symmetry, always compute the hessian. C1 does not guarantee descent to a minimum.")
  - Context, #252-#253: Гесс explained his "symmetry" using benzene. sanya1024 had suggested reporting a bug to Laikov if it happened on benzene.
- **Cartesian optimization.** `cartesian=1` in `$optimize` gives "Coordinates: cartesian" in the output (#319).

### Geometry optimization — pages 17-20, posts #321-#400, 2015-06..2018-12

- **Optimization "converging" in one iteration** (#334 sinigin, 2016-09-28): Гесс (#335) diagnosed "Оно сошлось за одну итерацию потому что несмогло посчитать энергию на первом шаге scf (not a number)" (it converged in one iteration because it could not compute the energy on the first SCF step: not a number). He also suggested checking blank lines before and after the coordinates as a possible input problem [unverified guess]. **Real cause** (amge #336): the molecule contained Bi, which the `3z` basis lacks. Fix: use `sbk` (ECP) or `basis4.in` with `four=1`. [experienced user]
- **Constraints / frozen coordinates**: `$optimize fix=... value=...` (manual excerpt above, #373). Defaults: `steps` = 50, redundant internal coordinates (`cartesian=0`). `cartesian=1` is the "last resort".
- amge (#352): for non-rigid systems such as explicit solvation shells, "алгоритмы типа DLC будут работать плохо, если вообще будут, оптимизировать придется в xyz-координатах" (DLC-type algorithms work badly, if at all, so you have to optimize in xyz coordinates). The minima are also broad and shallow.

### Geometry optimization — pages 21-23, posts #401-#460, 2018-12..2020-11

- #405 amge (Dec 11 2018): Priroda needs few resources and is not demanding about the quality
  of the starting geometry for optimization. [experienced user]
- #460 shows `$optimize tolerance=1e-7 trust=0.005 steps=5000 $end`.

### Geometry optimization — pages 24-26, posts #461-#518, 2020-11..2026-07

#### Large polymer crystal cell with qm_n3 (#481 Yellow21chem, Dec 24 2021)
Yellow21chem ran about 2500 atoms. After 100 optimization steps the "structure starts to 'collapse' and deviate from the initial structure." Header used, verbatim:
```
$system mem=32000 disk=-10240,-1 $end
$control
 task=optimize
 theory=qm_n3
 basis=qm.in
$end
$optimize
 sym=1
 cart=1
 tol=1e-5
 $end
$molecule
 sym=1
 cartesian
$end
```
This is only a header: the coordinates were omitted in the post.

Responses:
- Metalian (#482): a crystal should be treated periodically, and "Природа, к сожалению, в периодику не умеет" ("Priroda unfortunately cannot do periodic systems").
- Гесс (#483) thinks the collapse indicates an unsuitable Hamiltonian, i.e. the element parameterization does not describe the system.
- amge (#484, Dec 30 2021) [experienced user] puts it down to edge effects:
  > "Или о краевых эффектах. По моему опыту, чтобы без периодики более-менее сохранилась геометрия ячейки, нужно оптимизировать 3х3х3 ячейки, затем отбрасывать все, кроме центральной. И у меня в ячейке были целые молекулы, а тут осложняется тем, что в ней только часть полимера. Для квантовой химии концы нужно чем-то забивать. Краевые эффекты будут гигантскими."

  Translation: "Or edge effects. In my experience, to roughly preserve the cell geometry without periodicity you need to optimize a 3×3×3 supercell and then discard everything except the central cell. I had whole molecules in the cell; here it is harder since the cell contains only part of the polymer. For QC, the chain ends must be capped with something. Edge effects will be huge."
  He added: "Я оптимизировал ММ, о квантовой химии для таких размеров и мысли не было." ("I optimized with MM; quantum chemistry at such sizes wasn't even a thought.")
- Yellow21chem (#489, Jan 3 2022) agreed: all the "collapse" effects are edge effects: "укладка полимерных цепей друг относительно друга нарушается по краям кристаллической ячейки и распространяется к её середине" ("the packing of the polymer chains relative to each other is disrupted at the edges of the cell and propagates to its middle").
- Гесс (#485) agrees that termination is needed. But if the geometry is significantly broken even with reasonable termination, the Hamiltonian is the problem.
- amge (#487, recovered from quote in #490): "Если бы молекула рвалась на радикалы, например, то да, можно грешить на гамильтониан. Но я то думаю, что просто начальная структура с терминированными концами кардинально меняла конформацию." ("If the molecule broke into radicals, then blame the Hamiltonian; but I think the starting structure with terminated ends simply changed conformation drastically.")
- Yellow21chem (#490, Jan 3 2022): "Молекула не рвалась на радикалы. Система разрушалась из-за отсутствия в моделировании периодических граничных условий." ("The molecule did not break into radicals. The system collapsed because there were no periodic boundary conditions in the simulation.") Гесс (#491) asked "А как она терминирована?" ("How was it terminated?").
- Yellow21chem (#492, Jan 25 2022): "Полимерный кристалл никак не был терминирован. Он был взят «как есть» после построения" ("The polymer crystal was not terminated at all; it was taken 'as is' after building"). So the capping step amge recommended had been skipped. He then switched to PBC in CP2K and asked which level of theory to use there (answered in #493, see Comparisons).

**Takeaway for the manual:** Priroda has no PBC. For crystal cells, use a 3×3×3 cluster, cap the dangling ends, and keep the central cell.

#### Crash with "too few" in internal coordinates (#517/#518, Jul 2026)
- **Symptom:** the optimization ends with `process 0 got signal 6`, and on the last step the output shows the `INTERNAL COORDINATES` table ending with `too few`. Asked by spa (#517).
- **Fix** from amge (#518) [experienced user]: optimize in Cartesian coordinates.
  ```
  $optimize cartesian=1 $end
  ```

## 10. TS / IRC / scan

### TS / IRC / scan — pages 1-4, posts #1-#80, 2009-02..2011-08

- No symmetry → main drawback especially for TS searches (would be very useful) — #6 amge.
- TS searches requiring many Hessians are the expensive case (#6).
- Scan: `malloc(536870912) failed` during scan (#56, see Errors). Scan with 10 points requested computed only 7; with 20 → 11 (#60 OrganikNV, 1 Mar 2011). No input posted; sanya1024 asked for input (#62); EvgeniX mocked the vague question (#61). Unresolved.
- IRC exists as a task (#66).

### TS / IRC / scan — pages 5-8, posts #81-#160, 2011-08..2012-04

- **Building a TS guess** (#83 sanya1024, 19 Aug 2011) [experienced user]: place the nucleophile near the potential attack site, oriented with the correct end toward it — saves a lot of time if guessed right. No need to draw bonds.
- **TS workflow** proposed by Elbereth #91 (29 Aug 2011): 1) draw, optimize geometry; 2) compute Hessian, check first frequency imaginary; 3) run `sadpoint`; 4) IRC. EvgeniX #92 [experienced user] adds: **"3.5) рассчитать точный гессиан, убедиться в том, что первая частота мнимая. Без 3.5 процедура 4 не заработает."** (compute an exact Hessian at the found saddle point and confirm one imaginary frequency; without it IRC will not work).
- sanya1024 #93: pitfalls — more than one imaginary frequency, or the single imaginary frequency may correspond to e.g. methyl rotation.
- sanya1024 #101 (20 Sep 2011): ideal IRC output is a series of points (like relaxed-scan constrained optimizations) with energies going downhill from the TS. "в Природе тоже перед расчетом IRC нужно найти ПС и скормить программе гессиан" (in Priroda too, before IRC you must find the TS and feed the program the Hessian).
- Nicolass #100: IRC gave only 2 points/2 energies with `back=0`; with `back=1` no curve at all. (Keyword `back=` in the IRC group — values 0/1, presumably direction of IRC.) amge #102, 20 Sep 2011 [experienced user]: "Больше похоже на артефакт, по крайней мере, такое поведение IRC типично для недооптимизированной геометрии. И, судя по тому, что переходное состояние Вы, похоже, не искали, это точно артефакт." (Looks more like an artifact; such IRC behaviour is typical of an under-optimized geometry. And since you apparently never searched for the TS, it is definitely an artifact.) → **2 points / no curve from IRC = the starting point was not a properly optimized TS.**
- **What IRC is and how to run it in Priroda** — amge #102, 20 Sep 2011 [experienced user]: "IRC обеспечивает плавный спуск с переходного состояния (ПС). В отличие от релаксированного скана, при котором фиксируется какой-либо геометрический параметр (длина связи, угол), в IRC фиксируется шаг, представляющий собой "различие" предыдущей геометрии от следующей (в единицах rmsd). Поэтому спуск по IRC всегда плавный, без рывков геометрии и всегда приводит к соседней стационарной точке (как правило, к минимуму, изредка к другому ПС). Чтобы сделать IRC, нужно найти ПС (в Природе task=optimize и saddle=1 в группе $optimize) и посчитать его гессиан."
  (IRC gives a smooth descent from the TS. Unlike a relaxed scan, where a geometric parameter (bond length, angle) is fixed, IRC fixes the step — the "difference" between successive geometries in rmsd units. So IRC descent is always smooth, without geometry jumps, and always leads to the neighbouring stationary point (usually a minimum, occasionally another TS). To do IRC you must find the TS — **in Priroda `task=optimize` with `saddle=1` in the `$optimize` group** (the Priroda analogue of GAMESS `sadpoint`) — and compute its Hessian.)
  ```
  $control task=optimize ... $end
  $optimize saddle=1 $end
  ```
  When to bother (IRC is fairly long): "когда не очевидно, к каким минимумам приведет спуск из ПС (часто это и так ясно, но IRC обеспечивает однозначную связь ПС с соответствующими минимумами) и если нужна красивая визуализация реакции (спуск по IRC, в отличие от скана, всегда плавный)" (when it is not obvious which minima the TS connects — IRC gives an unambiguous TS↔minima link — and when a nice visualization of the reaction is needed).
- **task=scan silently ran an optimization instead** (#110 OrganikNV, 1 Nov 2011); worked on another computer. Diagnosis by amge #113: input edited in Word → needs Unix line endings/plain text (see Known errors). [experienced user]

### TS / IRC / scan — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#216 amge** [experienced user]: TS search, verbatim: "**сначала нужно посчитать гессиан и вставить его в инпут**" (first compute the Hessian and insert it into the input). So the TS optimization reads a precomputed Hessian that you paste into the input file.
- **#229 Tasha, 16 Dec 2013**: in a scan over the pyridine-pyridine torsion of an octyl-substituted bipyridyl, the two octyl tails from opposite ends clearly stick together. This lowers the rotation barrier by about 1 kcal/mol. Images: Oct2_py_scan-Final122.jpg, Py.jpg.
- **#230 amge, 16 Dec 2013** [experienced user]: "Это очень интересно. Может, и вправду дисперсионное взаимодействие? Но не исключено, что просто артефакт сканирования. На максимумах кривой истинные переходные состояния? В них действительно слипшиеся хвосты? Не пробовали ли сканирование по нескольким углам сразу, чтобы октильные "рога" синхронно проворачивались на манер шестеренки, не слипаясь. Не понизится ли при этом барьер?" (Very interesting. Maybe it really is dispersion? But it could just be a scan artifact. Are the curve maxima true transition states? Do the tails really stick together in them? Have you tried scanning several angles at once, so the octyl "horns" turn together like gears without sticking? Wouldn't the barrier drop then?) Advice: verify scan maxima with a real TS optimization, and consider a multi-coordinate scan.
- **#234 Tasha, 16 Dec 2013**: "Это не должен быть артефакт сканирования, т.к. это возникает и поиске локальных минимумов и при сканировании." (It shouldn't be a scan artifact, since it appears both in local-minimum searches and in the scan.) The global minimum (Oct2_h-Final45.jpg) has stuck tails; "Истинное переходное состояние несколько не располагает к такому слипанию из-за геометрических факторов, нет достаточного сближения половин молекулы" (the true TS does not favor such sticking for geometric reasons — the halves of the molecule are not close enough) (Oct2_py_tr_0-Final28.jpg). Implication: the scan maxima ≠ true TS here, so the ~1 kcal/mol barrier lowering seen in the scan should be checked against the true TS energy. [unverified]
- **#232 amge**: "Стерика странная. Обычно "инертные" фрагменты стремятся не слипаться, а наоборот, избегать близких контактов" (The sterics look odd. "Inert" fragments usually avoid close contacts instead of sticking.) **#231/#233 uchebnik fiziki**: sticking is normal, since the interaction is favorable.
- **#180 Metalian**: asked about parallel IRC efficiency. **#194 EvgeniX** [experienced user]: several IRCs overnight are unlikely — "это всё-таки IRC, где по-хорошему шагов много ... Для ярко выраженных максимумов и IRC лучше считается" (a proper IRC has many steps; IRC runs better for sharply pronounced maxima).

### TS / IRC / scan — pages 13-16, posts #241-#320, 2013-12..2015-06

- **What moves in a dihedral scan.** #259 Гесс (Jan 3, 2014) asks whether only atom 4 moves or atoms 1 and 4 together. His worry is that atom 4 ends up far from its bonded neighbour, e.g. a benzene 1-2-3-4 dihedral scanned from 0 to 90°.
  - **#261 amge (Jan 3, 2014)** [experienced user]: "Одновременно 1ый и 4ый, симметрично. При этом все остальные на первом шаге оптимизации остаются на своих прежних местах." (Atoms 1 and 4 move simultaneously, symmetrically. All other atoms stay in place at the first optimization step.)
  - #263 VTur: "При сканировании вся геометрия едет." ("In a scan the whole geometry relaxes.") Strong coupling between rotors can move neighbouring groups too.
  - The automatic scan is more convenient than a series of separate constrained optimizations. With small increments it reuses the previous wavefunction as the guess, so SCF converges faster (#263).
  - #260 Гесс: separate constrained optimizations let him pre-shape each starting geometry with a cheaper method.
  - **#262 amge (Jan 3, 2014)** [experienced user] on automatic scan vs. a series of independent constrained optimizations: "Смысл сканирования - избежать резких изменений геометрии: начальным приближением каждой следующей точки является оптимизированная геометрия предыдущей. Сканирование можно воспроизвести вручную, если всякий раз дожидаться оптимизации очередной геометрии, чтобы подать ее (и, наверное, вектора тоже) на вход следующей точки. Если не дожидаться, а одновременно запустить серию расчетов одной и той же начальной структуры с фиксированным на разных значениях параметром, то могут быть (но не факт, что будут) различные неприятности. Например, при большом изменении параметра получится "дикая" структура, и SCF не сойдется, или сойдется, но оптимизация уведет куда-то не туда." (The point of a scan is to avoid abrupt geometry changes: each point starts from the optimized geometry of the previous one. You can reproduce a scan by hand if you wait for each optimization and feed its geometry (and probably the vectors too) into the next point. If instead you launch a series from the same starting structure with the parameter fixed at different values, there may (not necessarily) be trouble: for a large parameter change you get a "wild" structure and SCF fails to converge, or converges but the optimization wanders off somewhere wrong.)
- **Equal-valued coordinates in one scan.** #268 Гесс (Jan 7, 2014) wants to scan both O-H bonds of water at the same time with equal lengths. His try, from the manual:
```
$optimize
                         fix   =1,1,2,0,0, 1,1,3,0,0
                         val(1)=0.7,       0.7
                         val(6)=1.2,       1.2
                         points=6
$end
```
- **amge's form.** #269 amge (Jan 8, 2014) [experienced user]: "Я привык задавать так:" ("This is how I usually write it:")
```
fix =1,1,2,0,0, 1,1,3,0,0
value=0.7,0.7, 1.2,1.2
points=6
```
  How the format reads from these examples:
  - Each constraint has 5 integers: a type code followed by 4 atom indices, zero-padded. Type 1 is a bond (atoms 1-2, 1-3), type 3 is a dihedral; type 2 is presumably an angle.
  - `value=` lists the start values of all constraints, then their end values: 0.7,0.7 to 1.2,1.2 Å.
  - `points=` is the number of scan points.
  - `val(i)=` (with i the starting position in the fix array, here 1 and 6) appears to be an alternative indexed form.
  - #271 Гесс (Jan 8, 2014): his first attempt (with the manual's `val(i)=` form) "дала какую-то нездоровую крякозябру причем со старта, неимеющую ничего общего с xyz координатами кроме числа и типа атомов" (gave an unhealthy mess right from the start, having nothing in common with the xyz coordinates except number and type of atoms); he planned to test amge's form.
- **Dihedral sign convention.** #276 Гесс (Jan 9, 2014): when he tried equating 3 dihedrals in amge's manner, "опять на старт выходит ежик не имеющий ничего общего с инпутовской геометрией" (again the start is a "hedgehog" with nothing in common with the input geometry). #278 amge (Jan 9, 2014) [experienced user]: "Имейте в виду, что в Природе диэдральные углы имеют противоположный знак по сравнению с принятым по конвенции и вычисляемым другими программами. Такая вот фича. "Ежик" мог (и должен был) получиться из-за нее." ("Keep in mind that in Priroda dihedral angles have the opposite sign to the usual convention and to what other programs compute. That's a feature. The 'hedgehog' could, and should, have come from it.") This is important for the manual.
  - **Confirmed**, #279 Гесс: "Полечил, перепроверил, перезапустил ... Первая геометрия правильная." (Fixed it [flipped the signs], rechecked, restarted ... the first geometry is correct.) → When giving `value=` for dihedral constraints, **flip the sign** relative to the dihedral measured in other programs/visualizers.
- **Ring rotation in 1,2,3,4,5-pentamethylferrocene.** #299 Tasha (Feb 14, 2014) asked how to scan it. #300 amge (Feb 14, 2014) [experienced user]:
```
$optimize fix=3,6,1,11,16 value=0,68 points=18 $end
```
  - "где 6,1,11,16 - номера атомов Me-C---C-H (C---C - любые два ближайшие атомы углерода из разных колец)" ("where 6,1,11,16 are the atoms Me-C---C-H; C---C are any two nearest carbons on different rings").
  - The scan runs from 0 to 68° in 18 points (4° steps over the 72° period).
  - "Но такое сканирование не даст симметричный профиль. Лучше найти TS вращения и спуститься с него по IRC." ("But such a scan won't give a symmetric profile. Better to find the rotation TS and descend from it by IRC.")
  - #301 Гесс [unverified]: there was supposedly an option to "cross" Priroda with Gaussian and use dummy atoms through Gaussian; he had not tried it.
- **IRC stops after the first point.** #295 Гесс (Feb 9, 2014): after a TS search, the hessian showed one imaginary frequency. IRC then did 7 optimization steps for the first point and printed:
```
 Vicinity of a Stationary Point(?) --- STOP.

IRC> point   1: distance =   0.15692098 E =
```
  "Далее идет REACTION PATH: состоящий из одной, нулевой точки." (Then follows a REACTION PATH consisting of a single, zeroth point.) Earlier, with a cheaper method, the IRC from the TS went fine in both directions, but the PES was very flat — barrier ≈ 0.35 kcal/mol in the direction of interest.
  - #296 Droog_Andrey: on a very flat surface a point found with one method may be somewhere else entirely in another method.
  - #298 amge (Feb 10, 2014) [experienced user]: "Vicinity of a Stationary Point на первом шаге IRC означает, что энергия на этом шаге не понизилась." ("On the first IRC step it means the energy did not decrease at that step.")
    - If the top of the profile is very flat, increase the step to jump past the flat part onto the slope.
    - The same symptom appears when the barrier is very narrow, e.g. a proton transfer. A step suitable for heavy atoms throws the proton too far and the energy rises, so decrease the step.
- **IRC ends short of the minima.** #313 Metalian (Feb 13, 2015): IRC ends near the minima but not in them, so they have to be re-optimized and a clean IRC curve cannot be plotted. They had enough `points`, `tolerance` could be tightened (1e-6), and they asked about recomputing the hessian every n steps but found no such key in `input.txt`.
  - `input.txt` is the manual/keyword file distributed with Priroda.
  - **#314 amge (Feb 14, 2015)** [experienced user]: "Как правило, IRC приводит к точке, близкой к минимуму. Но да, всегда нужно дооптимизировать. Теоретически (а изредка и практически) IRC может заканчиваться не минимумом, а другим переходным состоянием. Тогда - гессиан и новая IRC. Иногда IRC останавливается не на минимуме и не на ПС, а на пологой полочке, на которой градиент достаточно мал. Тогда чтобы получить плавную кривую, можно просто надергать точек из оптимизации, чтобы геометрия и энергия менялись плавно (критерий - визуальное восприятие, т.е. на глазок). Или можно более строго: гессиан, новая IRC. При этом бывает, что IRC сдвигается на шаг и опять останавливается. Еще раз то же самое. Бывает, раза три-четыре приходится повторять, прежде чем IRC уйдет с полочки."
    (As a rule IRC leads to a point close to the minimum, but you always have to finish with an optimization. In theory (and occasionally in practice) IRC can end at another TS instead of a minimum — then: hessian and a new IRC. Sometimes IRC stops neither at a minimum nor at a TS but on a gentle "shelf" where the gradient is small enough. To get a smooth curve you can then just pick points from the follow-up optimization so that geometry and energy change smoothly (judged by eye). Or, more rigorously: hessian, new IRC. IRC may advance one step and stop again — repeat; sometimes 3–4 repeats are needed before IRC leaves the shelf.)
  - "Опции "пересчитывать гессиан каждые n шагов" в Природе, насколько я знаю, нет. Есть task=extremal [URL http://www.qchem.ru/f/kvantovo-khimicheskie-programmy/kvantovo-khimicheskaya-programma-priroda/], но это не совсем то." (As far as I know Priroda has **no option to recompute the hessian every n steps**. There is **`task=extremal`** (see qchem.ru Priroda forum), but that is not quite the same thing.) `task=extremal` is otherwise undocumented here — presumably gradient-extremal path following [unverified].
  - Workflow summary: TS → hessian → IRC → re-optimize endpoints; if IRC stalls on a shelf or at a TS: new hessian at the stall point → new IRC, repeat.
  - Also unanswered: has anyone computed conical intersections in Priroda?

### TS / IRC / scan — pages 17-20, posts #321-#400, 2015-06..2018-12

- `points=%d` gives the number of IRC points, or the number of constrained optimizations in a scan run. Initial and final `value`s define a linear scan (manual excerpt, #373). The run types themselves (e.g. `task=irc`, `task=scan`) are not named in this page range.
- amge (#352): TS searches with explicit solvent molecules are "мучение" (torture) for non-rigid systems.

### TS / IRC / scan — pages 21-23, posts #401-#460, 2018-12..2020-11

- #408 Гесс (Dec 11 2018): "Там таки есть irc которого кажется до сих пор нет в орке" ("It does
  have IRC, which ORCA still seems to lack [as of 2018]"). [experienced user]

## 11. Frequencies & thermochemistry

### Frequencies & thermochemistry — pages 1-4, posts #1-#80, 2009-02..2011-08

- Thermochemistry: compute Hessian, then "S=S, H=E+ddH, G=E+ddG. С учётом того, что E - в хартри, ddH и ddG - в ккал/моль." (E in hartree, ddH and ddG in kcal/mol) — #44 EvgeniX, 26 Jan 2011 [experienced user]; ref http://www.qchem.ru/practice/priroda/conf/ .
- Where to read them — the thermo table from the Hessian output (#80 EvgeniX, 18 Aug 2011), verbatim:
  ```
   T =  298.000 K      ln(Q)       S          U          H          G
                                cal/mol*K  kcal/mol   kcal/mol   kcal/mol
   ----------------------------------------------------------------------
   translational      17.7957    40.3319     0.8883     1.4805   -10.5384
   rotational         12.9277    28.6710     0.8883     0.8883    -7.6557
   vibrational         3.2744    15.7332    64.1572    64.1572    59.4687
   total              33.9978    84.7361    65.9338    66.5259    41.2746
   ----------------------------------------------------------------------
  ```
  "S=[S,total]; ddH=[H,total]; ddG=[G,total]". So H and G corrections include ZPE (vibrational U at 298 K).
- Rumoured thermochemistry "error": "На слухи про ошибку не обращайте внимание, там единственно не понятно как считает для одноатомных молекул (присутствует лишний вклад RT)." (Ignore rumours; the only unclear thing is monoatomic species, where there's an extra RT contribution.) — #80 EvgeniX.
- `mass` keyword: for isotopes only (#46).
- `optimize+hessian` checks minimum vs imaginary frequencies (#73).

### Frequencies & thermochemistry — pages 5-8, posts #81-#160, 2011-08..2012-04

- Thermochemistry from Priroda Hessian output (EvgeniX formula quoted by eFo #134, 1 Dec 2011) [experienced user]:
  ```
  Считаете гессиан, потом
  S=S,
  H=E+ddH,
  G=E+ddG.
  С учётом того, что E - в хартри, ddH и ddG - в ккал/моль.
  ```
  (After a Hessian run: S = S; H = E + ddH; G = E + ddG; E in hartree, ddH and ddG in kcal/mol — convert units before adding.) EvgeniX #135: "Всё-таки E и не трогать E0!" (Use E, and don't touch E0!) — i.e. use the electronic energy E, not the printed E0 (ZPE-corrected energy), since ddH/ddG already include ZPE.

### Frequencies & thermochemistry — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#224 asp, 8 Dec 2013**: thermochemistry block after a Hessian calculation, verbatim:
  ```
   E =  -883.196624    E0 =  -882.965225
   ZPVE = 0.231400 a.u. =  145.2055 kcal/mol
   ----------------------------------------------------------------------
   T =  298.150 K      ln(Q)       S          U          H          G
                                cal/mol*K  kcal/mol   kcal/mol   kcal/mol
   ----------------------------------------------------------------------
   translational      18.2651    41.2648     0.8887     1.4812   -10.8219
   rotational         13.9350    30.6726     0.8887     0.8887    -8.2563
   vibrational        11.7828    49.5866   153.0086   153.0086   138.2243
   total              43.9829   121.5241   154.7860   155.3785   119.1461
   ----------------------------------------------------------------------
  ```
- **#225 sanya1024** [experienced user]: "**E + ZPVE = E0.** Т.е., здесь E0 -- это энергия, поправленная на ZPE." (Here E0 is the energy corrected for ZPE.) Check: -883.196624 + 0.231400 = -882.965224. Note that **E is the electronic energy and E0 = E + ZPVE**, which is the opposite of what sanya1024 first guessed in #221. The U/H/G columns are thermal contributions in kcal/mol at T = 298.150 K.
- **#221 sanya1024**: for conformer populations it hardly matters, because ZPE (half the sum of the frequencies) is nearly the same for conformers. Use a Boltzmann factor exp(-ΔE/RT) with the relative conformational energy.
- **#220 asp**: elsewhere on the forum someone said "E и не трогайте E0" (use E, don't touch E0) for thermodynamic properties. A doctoral thesis used E0 for conformer populations.
- **#223 sanya1024, 8 Dec 2013** [experienced user], on E vs E0 for conformer populations: "если все-таки речь идет о энергии на нулевом колебательном уровне и энергии в минимуме, то правильнее все-таки отсчитывать от нулевого уровня. Но вся поправка скомпенсируется, разница будет в несколько см-1, что меньше погрешности расчета." (If we mean the energy at the zero vibrational level vs the energy at the minimum, it is more correct to count from the zero level (i.e. E0). But the correction largely cancels; the difference will be a few cm⁻¹, less than the calculation error.) asp #222 had noted "E меньше по величине чем E0" (E is lower than E0, consistent with E0 = E + ZPVE).
- **#222/#223**: competing reactions with different barriers. Relative rates can be estimated from the barrier ratio, as with conformer populations. sanya1024: OK "если ничего не напутаете в выкладках" (if you don't mess up the derivation), but keep in mind how reliable the barrier is, which depends on the method and on whether and how the environment is included. **#226 asp**: should one use E0 for the two-reaction case? No answer in this page range.

### Frequencies & thermochemistry — pages 13-16, posts #241-#320, 2013-12..2015-06

- **Numerical hessian steps.** The hessian for correlated methods with large bases is done by finite differences, printed as FORWARD/backward steps. #291: 24 "forward" and 24 "backward" steps planned, a week-plus of runtime.
- **Number of FORWARD/backward steps.** #311 Гесс (Nov 30, 2014) asked what the number of forward/backward steps depends on ("Хотелось бы прикинуть сколько мне еще ждать"). #312 Shorku (Nov 30, 2014): "Не знаю, как в природе, но обычно это число атомов*3*2 (три пространственные координаты на сдвиг в плюс и в минус)" (I don't know about Priroda, but usually it is N_atoms × 3 × 2 — three Cartesian coordinates, each displaced plus and minus). [unverified for Priroda] (If so, the 24+24 steps of #291 would correspond to an 8-atom system — not checked.)
- **Resources of a numerical hessian** — #294 EvgeniX [experienced user]: disk and RAM equal those of a single energy/gradient calculation (see Memory/disk).
- **Hessian check.** Always compute the hessian when an optimization preserved symmetry (#254 amge). Hessian results: CCSD(T)/3z gave a TS, while CCSD(T)/L1 and CCSD/L1 gave minima (#255).

### Frequencies & thermochemistry — pages 17-20, posts #321-#400, 2015-06..2018-12

- Raman intensities (#376 Gulnara, 2018-02-14). With the input below, the columns `Raman A` and `Raman D` in the output are all zeros. She tried various combinations of the `hessian` and `dipole` tasks.
  ```
  $system memory=160 disk=2 path=./tmp $end
  $control
  task=hessian
  basis=3z.bas
  print=-internals
  $end
  &dft func=PBE $end
  $scf conv=1e-8 proc=NR $end
  $grid accur=1e-9 $end
  $molecule
  cartesian
  17  -0.45685720  -0.40290523   0.31694323
  17   2.46808600  -0.38642225   0.31698823
  17   0.99216408   1.99493098  -0.52362520
  17   0.99661094   1.19439185   2.28969288
  6   0.99999619   0.60000467   0.60000092
  $end
  ```
  - YuraM's answer (#378, 2018-02-15): "I asked the same question a while ago, first you need to calculate polarizability". He links an earlier chemport thread: `viewtopic.php?f=71&t=116231&p=891834` (truncated URL). [experienced user] Exact keywords for polarizability are not given in this page range.
  - amge (#377) suggests asking Laikov directly. EvgeniX (#379) said he would be interested to see Raman work done with Priroda. Gulnara (#380, 2018-02-19): "Мы написали Д.Н. Лайкову, и он нам подробно ответил." (We wrote to D.N. Laikov and he answered in detail.)
  - **Laikov's recipe for Raman intensities** (relayed verbatim by Gulnara, #381, 2018-02-19) [second-hand from Laikov → semi-authoritative]:
    ```
    Нужно запустить отдельно (1) task=hessian,
    отдельно (2) task=dipole,
    и собрать в исходные данные
    вторые производные энергии (1)
    и производные поляризуемости (2)
    и ещё раз запустить task=hessian.
    ```
    Translation: run (1) `task=hessian` and (2) `task=dipole` separately; put into the input data the energy second derivatives from (1) and the polarizability derivatives from (2); then run `task=hessian` once more. The exact input groups used to feed these data back in are not given in this page range.
- Hessian size limit was removed by Laikov circa 2016 (#339).

### Frequencies & thermochemistry — pages 21-23, posts #401-#460, 2018-12..2020-11

- `task=hessian` runs "ANALYTIC SECOND DERIVATIVES OF SCF ENERGY" (output header quoted in #460).
  Raman spectrum of a 142-atom molecule was attempted with OLYP/4z.bas and failed on a
  temp-file write. See Known errors.

### Frequencies & thermochemistry — pages 24-26, posts #461-#518, 2020-11..2026-07

- **Energy units:** "В атомных единицах, они же хартри. 1 хартри = 627.51 ккал/моль" ("In atomic units, i.e. hartree. 1 hartree = 627.51 kcal/mol"). #474 amge, Dec 5 2021.
- **Gibbs free energy:** Yellow21chem (#475) asks whether to run `task=optimize` first and then `task=hessian` after convergence, and whether Priroda then prints the Gibbs free energy of the system. amge (#476, Dec 9 2021) [experienced user]: "Не совсем так. В таблице с термодинамическими величинами, в числе которых и G, будут поправки к электронно-ядерной энергии (уже с учетом ZPE)." ("Not quite. The table of thermodynamic quantities, including G, gives corrections to the electron-nuclear energy (already including ZPE).") So Priroda does not print the total G; you add the correction yourself. His example output block:
  ```
   E =  -196.328936    E0 =  -196.191669

   ZPVE = 0.137267 a.u. =   86.1366 kcal/mol

   ----------------------------------------------------------------------
   T =  298.000 K      ln(Q)       S          U          H          G
                                cal/mol*K  kcal/mol   kcal/mol   kcal/mol
   ----------------------------------------------------------------------
   translational      16.9514    38.6542     0.8883     1.4805   -10.0385
   rotational         11.1465    25.1313     0.8883     0.8883    -6.6008
   vibrational         0.6842     4.7490    87.1466    87.1466    85.7314
   total              28.7821    68.5345    88.9232    89.5154    69.0921
   ----------------------------------------------------------------------
  ```
  - amge: "энергия Гиббса системы будет -196.328936*627.51+69.0921" ("the system's Gibbs energy is -196.328936*627.51 + 69.0921" [kcal/mol]).
  - So **G = E(electronic, hartree) × 627.51 + G_total(kcal/mol)**.
  - Use E, not E0. E0 = E + ZPVE, and the vibrational G/U/H already include the ZPVE, so adding to E0 would double-count it.
  - Default T = 298.000 K, and the table splits into translational, rotational and vibrational contributions.
  - Metalian (#478, Dec 17 2021) [experienced user], quoting "сначала задать task=oprimize, а после достижения сходимости рассчитать task=hessian": "task=optimize+hessian и не надо два раза запускать." ("task=optimize+hessian, and there's no need to run twice.")
    ```
    $control
     task=optimize+hessian
    $end
    ```
    (minimal `$control` fragment; other keywords as usual)

## 12. Excited states (TDDFT)

### Excited states (TDDFT) — pages 5-8, posts #81-#160, 2011-08..2012-04

- UV absorption spectrum: `theory=tddft` — #158 amge, 19 Apr 2012 [experienced user] (no further details).

## 13. NMR

### NMR — pages 1-4, posts #1-#80, 2009-02..2011-08

- `task=nmr`, `$nmr standard(1)=31.3867 standard(6)=181.9781 $end`, `$grid accur=1e-8 $end` (#69).
- Accuracy (PBE): metallocene Cp-ring 13C shifts computed 3-7 ppm too high (avg ~5 ppm); 1H ~0.1 ppm — #17 EvgeniX. amge (#18): aromatic carbons consistently 5-7 ppm too high, others less but also overestimated (vs TMS); "я просто от сигмы ТМС вычел 5 м.д., и стало гораздо лучше" (I just subtracted 5 ppm from TMS sigma — much better) [experienced user, empirical].
- amge (#15): hydrocarbons/carbocations NMR "excellent to good"; N-oxides "satisfactory"; fluorinated carbocations NMR "poor"; N-heterocycles NMR — colleagues satisfied.
- NMR spectrum visualization (#68 amge, 27 May 2011): own scripts —
  - `pri2mol` (http://limor1.nioch.nsc.ru/quant/program/pri2mol/) makes from the Priroda output a text file with extension `.xyzppm`: coordinates + chemical shifts (5th column). Viewable in Molden; "Label - atom+charge" labels atoms with shifts.
  - `xyz2jmod` (http://limor1.nioch.nsc.ru/quant/program/xyz2jmod/) draws the spectrum from the xyzppm file.
  - Work out-of-the-box on Linux; on Windows need Perl, an X server (e.g. Xming), gnuplot.
  - Alternative commercial: ChemOffice (#67).

### NMR — pages 5-8, posts #81-#160, 2011-08..2012-04

- `task=nmr` requires `theory=dft` (non-hybrid); use `functional=pbe` — #96 amge.
- Partizan's (problematic) NMR input, #94 (fragment, coordinates elided by poster):
  ```
  $system memory=1601 disk=90 path=.\temp\ $end
  $control
  task=nmr
  basis=3z.bas
  theory=dft
  $end
  $dft functional=b3lyp $end
  $grid accur=1e-9 $end
  $molecule
  charge=0
  mult=1
  cartesian и т.д.
  ```
  Problems: memory too high for Windows build (malloc failure), b3lyp with theory=dft (wrong), Unicode encoding.
- Partizan: H39C36N5O5 porphyrin derivative with Gaussian didn't finish in 10 days (#97); Droog_Andrey #98: probably a huge basis — Partizan #103 confirms "311G++". amge #106 [experienced user]: diffuse functions are pointless for chemical shifts, polarization functions are needed (6-311G**); in Priroda use roughly **3z or L2** (see Basis sets).

### NMR — pages 9-12, posts #161-#240, 2012-04..2013-12

- #237 VTur only says "Надо смотреть на ЯМР" (look at NMR) as an experimental check for chain sticking. Nothing about NMR in Priroda.

### NMR — pages 21-23, posts #401-#460, 2018-12..2020-11

- **Pt NMR with ECP bases fails (Tasha, May 2020).** #454: chemical shifts of [PtCl6]2- with two
  nearly identical ECP bases. Tasha (after Гесс #453 asked her to share how she solved her
  earlier problem): "Решение, как и прошлый раз пришло с заменой базиса" ("The solution, like
  last time, came from replacing the basis"). Only basis 2 (sbk) gives results. Single-atom tests of Pt and Cl
  work in both bases, but the combined complex fails with basis 1 (St-rsc-97). Output, input
  and basis links:
  - complex: https://yadi.sk/d/mNFJZjhS-1Ljnw (basis 1), https://yadi.sk/d/cIL77tdZHQ2XQQ (basis 2)
  - Pt atom: https://yadi.sk/d/TkMvJc45dK3_OQ , https://yadi.sk/d/HZuMreQjf1k4oA
  - Cl atom: https://yadi.sk/d/o37LcP2vE44CiQ , https://yadi.sk/d/b2hB5shdEdfLNg
  - Basis 1: https://yadi.sk/i/e4Y_HpcZSQIw5Q ; Basis 2: https://yadi.sk/d/pn6D1429l3ps0g
  #455 Гесс: Cl is identical in both bases. Pt has very different bases and ECPs: "sbku на 4
  функции больше, а его энергия для атома заметно ниже" ("sbku has 4 more functions and a
  noticeably lower atomic energy"). For PtCl6 the St-rsc-97 basis "не справляется с первой
  электронной итерацией и выдает NAN (Not A Number)" ("fails at the first electronic
  iteration and gives NAN"). [experienced user] There is no explanation of the root cause.
- #458 Tasha: in the symmetric [PtCl6]2- all Cl atoms got different(!) chemical shifts. This
  is a suspicious result and was not explained.
- **Heavy-nucleus NMR reliability.** #457 amge (May 22 2020): "бросайте вы это темное дело -
  считать ямр тяжелых ядер Природой" ("give up this murky business of computing heavy-nucleus
  NMR with Priroda"). His Pt attempts long ago showed no correlation with experiment. More
  recently, Te compounds with `3z` and `3z-sbk` gave "фигня полная" ("total garbage"). The
  heavy-atom effect on neighbouring nuclei is also not reproduced at all. DIRAC is much
  better, apart from compute time. [experienced user]

## 14. Solvation

### Solvation — pages 1-4, posts #1-#80, 2009-02..2011-08

- "В Природе ни в какой версии нет такой возможности" (no continuum solvation in any version) — #75 sanya1024, 17 Aug 2011 [experienced user, as of 2011].
- Only explicit (discrete) solvent — #76 EvgeniX. sanya1024 (#79): place explicit solvent molecules (e.g. ~100), or just at coordination sites (rarely >10 molecules) and optimize; insufficient for non-specific solvation.

### Solvation — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#183 Лечащий Врач** [experienced user]: explicit solute+solvent systems that exceed the memory limits should not be done "в лоб" (by brute force). Use ONIOM, for example, "И не в Природе" (and not in Priroda).

### Solvation — pages 13-16, posts #241-#320, 2013-12..2015-06

- Only general discussion (#244, #246): in a good non-polar solvent, hydrophobic tails are solvated and do not stick together; in polar solvents, aggregation or micelles can form. Tasha (#245): in acetonitrile, the binding constants are an order of magnitude larger for the long-tail ligand. No Priroda solvation keywords appear in this page range.

### Solvation — pages 17-20, posts #321-#400, 2015-06..2018-12

- **No solvent model in Priroda** (as of 2016). amge (#348): "Вот чего мне реально не хватает в Природе - это учета растворителя." (What I really miss in Priroda is solvent treatment.) For ion pairs he has to use GAMESS, which is many times slower even in a very weak basis. [experienced user]
- Debate on explicit vs continuum solvation (#351-#357). Любитель_Манниха calls continuum models "мракобесием" (obscurantism) and prefers explicit first-shell molecules. amge (#352) gives a detailed rebuttal: where do you get the shell, there are countless conformers, TS searches are hard, and optimization fails (DLC, shallow minima). YuraM (#354) proposes gas-phase optimization + TS, then a Hess-cycle solvation free energy at fixed geometries. EvgeniX (#355, 2016-11-24): "Вообще-то так и делают, потому что это самый разумный вариант." (That is actually what people do, because it is the most sensible option.) amge (#356) and EvgeniX (#357): this fails for ion pairs (they collapse to covalent compounds in vacuum) and for zwitterions.

### Solvation — pages 21-23, posts #401-#460, 2018-12..2020-11

- There is no continuum solvent model in Priroda (#417 amge).
- #421 YuraM: do the solvent as a single point in ORCA. #425 YuraM: if a continuum SP is not
  enough, use explicit solvent (at least 1-2 molecules). Optimizing in a continuum model
  seems "треш" ("trash") to him, and he doubts its plausibility and numerical stability.
  #426 amge (recovered from quote in #427): with explicit solvent "отдельный расчет становится
  тяжелее, но это мелочь, главное - приходится проверять все множество мест координации
  растворителя" ("each calculation gets heavier, but that's minor; the main thing is you
  have to check all the possible solvent coordination sites"). [opinion]
- **Why gas-phase optimization + solvent SP can fail** (#424 amge, Dec 13 2018), replying to
  YuraM's "Растворитель можно сделать SP в той же ORCA": "Иногда можно. Но попробуй какую-нибудь
  аминокислоту в цвиттер-ионной форме. Высока вероятность, что в процессе оптимизации в вакууме
  протон у тебя радостно перескочит, и что толку будет считать SP." ("Sometimes you can. But try
  an amino acid in zwitterionic form: during vacuum optimization the proton will very likely
  happily hop over, and then what's the point of the SP.") [experienced user]
- **Ion pairs need a dielectric** (#426 amge, Dec 13 2018), against "if a continuum SP is not
  enough, use explicit solvent": "Вовсе не всегда. Во многих случаях и континуальная модель
  может сильно помочь. Например, система ион-противоион. В вакууме, скорее всего, будет
  ковалентная связь между ними." ("Not always. In many cases a continuum model helps a lot,
  e.g. an ion/counter-ion system: in vacuum there will most likely be a covalent bond between
  them.") The Coulomb attraction at ordinary chemical distances is ~50 kcal/mol and overrides
  everything; in a dielectric medium it drops (in water to under 1 kcal/mol). He agrees with
  adding 1-2 explicit solvent molecules optimized in a continuum, "Но в том то и дело, что
  здесь мы говорим о Природе, в которой нет континуальной модели. А без диэлектрической среды
  добавление 1-2 молекул растворителя не спасает от закона Кулона" ("But the point is that we
  are talking about Priroda, which has no continuum model, and without a dielectric medium
  adding 1-2 solvent molecules does not save you from Coulomb's law", though it softens it).
  [experienced user]
- **Solvent placement automated by Laikov?** #427 Гесс (Dec 13 2018), on amge's point about
  having to check all coordination sites: "Ну вот это я так понимаю Лайков недавно
  алгоритмизировал." ("As I understand it, Laikov has recently turned that into an algorithm.")
  #408 Гесс likewise: "касательно сольватационных моделей природа идет своим собственным путем"
  ("regarding solvation models, Priroda goes its own way"). No keywords given. [unverified]

## 15. Relativistic / heavy elements

### Relativistic / heavy elements — pages 1-4, posts #1-#80, 2009-02..2011-08

- Dipole moment printed as `dipole =   0.000000 au (  0.000000 D)` for all molecules (#32 Droog_Andrey, 12 Jan 2011). amge (#33): with non-relativistic bases the dipole is computed; with relativistic ones it is not, "Даже с task=dipole". sanya1024 (#35): version 6 really gives zeros with relativistic basis; version 8 gives a number → "лекарство -- апгрейд до 8 или 9 версии" (cure: upgrade to v8 or v9).

### Relativistic / heavy elements — pages 9-12, posts #161-#240, 2012-04..2013-12

- **`four=1` in `$control`** is needed with the relativistic basis `basis4.in`/`basis4.bas` — #207 amge, 10 Apr 2013 [experienced user], confirmed by the user #208. "Вам нужен базис с релятивистскими поправками, он называется basis4.in ... При его использовании не забывать four=1 в группе $control." This presumably switches on Priroda's four-component (scalar-relativistic) Hamiltonian, matching the "4" basis family. Without it the job stopped at `Basis set input: 'basis4.bas'   1?`.
- #206: Hg and Os porphyrins crash with signal 11 using `3z.bas`, while Ru works. amge #207 confirms `3z.bas` has "нет релятивистских поправок" (no relativistic corrections) but "по идее, тоже должен работать" (should in principle work); for Hg/Os the recommended route is `basis4.in` + `four=1`. Cause of the signal 11 itself not established.

### Relativistic / heavy elements — pages 13-16, posts #241-#320, 2013-12..2015-06

- The relativistic lambda bases L1r and L2r are in `basis4.in` (#247 quote).

### Relativistic / heavy elements — pages 17-20, posts #321-#400, 2015-06..2018-12

- `basis4.in` is the all-electron relativistic basis file (L-series bases). It requires `four=1` in `$control` (#336, #338 amge). [experienced user]

### Relativistic / heavy elements — pages 21-23, posts #401-#460, 2018-12..2020-11

- Scalar-relativistic all-electron bases L1, L2 are seen as a key strength (#412 YuraM).
- #422 YuraM (Dec 13 2018): any basis and ECP can be used in ORCA (basis format like GAMESS-US).
  He would like to see ECP vs DKH comparisons specifically in Priroda. For open-shell
  metal systems spin-orbit effects can be very large and can even change the relative
  energies of states with different multiplicity. He asks whether Priroda can treat
  spin-orbit coupling. **Unanswered** in this page range. #423: ADF can do this black-box.
- #457 amge: heavy-atom NMR needs a proper relativistic (DIRAC) treatment, see NMR.

## 16. Output parsing & visualization

### Output parsing & visualization — pages 1-4, posts #1-#80, 2009-02..2011-08

- Molden + Priroda orbitals: see qchem.ru thread http://www.qchem.ru/f/kvantovo-khimicheskie-programmy/vizualizatsiya-prirod%27nykh-orbitaley/ ("visualization of Priroda orbitals") — #24 amge, 29 Mar 2010.
- Opening files in Molden: button `READ` on the left in the `Miscellaneous` group — #26 Lantano.
- Charges: `Overlap populations:` (Mulliken) and `Atomic partitions of the density:` (Hirshfeld) — #79 sanya1024. Spin densities for radicals asked (#28 petrovps, which table?) — not directly answered in pages 1-4 (presumably the spin columns in these same tables [unverified]).
- pri2mol / xyz2jmod / pri scripts by amge at limor1.nioch.nsc.ru (see NMR section).

### Output parsing & visualization — pages 5-8, posts #81-#160, 2011-08..2012-04

- `print=+bonds+charges+molden` in `$control` (#152).
- QCC visualizer for Priroda: eFo #122 asked what parameters "Curvature" and "Overlap" mean — unanswered.
- Visualizers draw bonds by distance thresholds only (#83).

### Output parsing & visualization — pages 9-12, posts #161-#240, 2012-04..2013-12

- **Optimized geometry**: after `OPTIMIZATION CONVERGED in ?? steps!`, lines starting with `MOL>` (#176 wait).
- **Orbital energies** (#177 asp, 5 Nov 2012), verbatim:
  ```
   One-Electron Energies (alpha)
   occupied:
     2   -24.363483    3    -1.243922    4    -1.016089    5    -0.565072
     6    -0.469250    7    -0.469250    8    -0.347299    9    -0.347299
   virtual:
    10    -0.216700   11     0.383494   12     0.407634   13     0.440590
    14     0.440590   15     0.555513   16     0.555928   17     0.555928
  ```
  **#178 sanya1024** [experienced user]: these are frontier orbital energies (in hartree). "occupied" lists the top 8 occupied orbitals and "virtual" the 8 lowest virtuals, each preceded by its orbital number. Here the HOMO is #9/#8 (degenerate), the LUMO is #10. So **the HOMO is the last "occupied" entry and the LUMO is the first "virtual" entry**. Only a window around the gap is printed, which is why the list starts at #2.
- **Open shell** (#217 asp, OH radical, `charge=0`, `mult=2`), verbatim:
  ```
   One-Electron Energies (alpha)
   occupied:
     1   -18.798107    2    -0.912118    3    -0.402635    4    -0.339656
     5    -0.262965
   virtual:
     6     0.065161    7     0.645940    8     0.792183    9     0.818306
    10     1.033836   11     1.153356   12     1.202627   13     1.648191
   One-Electron Energies (beta)
   occupied:
     1   -18.775005    2    -0.855401    3    -0.379235    4    -0.239290
   virtual:
     5    -0.207968    6     0.077357    7     0.652559    8     0.819880
     9     0.830750   10     1.055276   11     1.219243   12     1.244771
  ```
  For open-shell (UKS) runs, alpha and beta spin orbitals are printed separately (#218, #219).
- **Chemcraft** (#213): used to build the starting structure. Its Cartesian export (`Z x y z`) is directly usable in Priroda (#214, #216).
- Thermochemistry table: see Frequencies.
- #172: the `.out` file may appear only after a delay (buffered output).

### Output parsing & visualization — pages 21-23, posts #401-#460, 2018-12..2020-11

- `print=-internals+molden` in `$control` (#460).
- amge's D3 script writes the energy correction to line 2 of xyz files (#419).

### Output parsing & visualization — pages 24-26, posts #461-#518, 2020-11..2026-07

#### Critical points of the density (QTAIM/Bader) (#495-#502, Aug 2022)
Tasha (#495) asks how to visualize Bader analysis. She thought "task=crytical" gives the critical points, but amge (#497) found it does not work; `print=+density` does (#499). Abbreviated format of her output (an Am complex, Z=95):
```
Critical Points of the Density
 nx=144, ny=117, nz=119
.......
 Np=120
 Np=127
 Np=103
 r= -1.224245, -4.125734,  2.586955 f=0.482746 h=-1.25587,-1.18324, 2.32204
 r= -1.150373, -3.043379,  2.594823 f=0.379692 h=-0.91717,-0.84871, 2.07723
 ...
 Atomic Coordinates:
  95  -0.86642152  -1.12254941   0.90202230
   8  -1.91768730   0.71052134   2.12986636
 ...
   0  -1.22424477  -4.12573429   2.58695451
   0  -1.15037286  -3.04337940   2.59482290
 ...
```
- `r=` is the position of each critical point, in Å judging by the atomic coordinates. `nx, ny, nz` are the grid dimensions.
- `f=` is very likely the density value at the point [inference].
- `h=` is three numbers, which look like the Hessian eigenvalues: (-,-,+) for bond CPs, (-,+,+) for ring CPs, (+,+,+) for cage CPs. Tasha (#500) wrote "h - декартовы координаты точки, см. в конце общий список xyz точек после xyz атомов" ("h – Cartesian coordinates of the point, see the xyz list at the end after the atoms"). That reading seems wrong. The `r=` values match the dummy-atom (Z=0) coordinates in the trailing list, so `r` holds the positions and `h` holds curvatures [inference, unverified]. amge (#501, Aug 12 2022) [experienced user] also rejects Tasha's reading: "Не похоже. Декартовы координаты точки - это r (проверил). А h - это что-то инвариантное к xyz-координатам, похоже на некий вектор, связанный с точкой." ("Doesn't look like it. The Cartesian coordinates of the point are r (I checked). And h is something invariant to the xyz coordinates, looks like some vector associated with the point.") Rotational invariance is consistent with h being the three eigenvalues of the density Hessian. amge (#499) had asked "что такое h, кто-нибудь знает?" ("does anyone know what h is?"); no definitive answer.
- `Np=120 / 127 / 103` are probably counts per CP type or per search pass [unexplained].
- After the atoms, `Atomic Coordinates:` lists the critical points again as atoms with **Z = 0** (ghost/dummy atoms).
- Tasha's reply quoted in #499 says she used `print=+density`; amge confirmed it works (#499).
- Гесс (#496) suggests showing the f value as well as the positions. He points to an earlier thread post, https://chemport.ru/forum/viewtopic.php ... e#p1023582 (URL truncated in the source), where "Из пятиколоночного xyz molden-ом Amge творил чудеса" ("Amge worked wonders with Molden from a five-column xyz").
- Tasha (#500) did it with **QCC Front-End by Besedin** ("QCC Front-End Беседина"), answering amge's question (#499) which program made her picture. An installer link was posted elsewhere on the forum.
- **amge's recipe (#502, Aug 15 2022)** [experienced user]:
  > "Сделал визуализацию критических точек из Природы через molden. Сначала нужно над аутпутом Природы прогнать pri2mol , сгенерируется xyz-файл, и его открывать molden'ом, там Label - atom+charge. Если в природовском инпуте сказано print=+charges+density, то выглядит так: [screenshot]"

  Translation: "Run `pri2mol` on the Priroda output. It generates an xyz file. Open that in Molden and set Label to atom+charge. If the input has `print=+charges+density`, the result looks like [screenshot]."

#### Molecular orbitals with pri2mol and Molden (#508-#510, Jul 2024)
- leshii says `pri2mol` stopped converting the output for Molden, as if newer versions no longer start the orbital section with `mos>`. leshii works under WSL.
- amge (#509): with Priroda 23 (2023.06.22) "Все работает как и раньше. В инпуте print=+vectors+molden в группе $control не забываете?" ("Everything works as before. Don't you forget print=+vectors+molden in $control?")
- leshii (#510): "Да, забыл дописывать +molden" ("Yes, I forgot to add +molden").
- **Rule:** `print=+vectors+molden` in `$control` is required for `pri2mol`/Molden MO output.

#### xm.exe
- A viewer for Priroda .out files, described as "for Linux" (#507 Tasha).

## 17. Known errors (exact messages + fixes)

### Known errors (exact messages + fixes) — pages 1-4, posts #1-#80, 2009-02..2011-08

- `0: opening file /tmp/tmp2960.0` (then stops; Windows, no /tmp) → add `$system path=. $end` — #20/#21 EvgeniX.
- `molecule input: ''` followed by `' ?matrix` (for z-matrix) or `?rtesian` (for cartesian) → DOS (CRLF) line endings; run `dos2unix` (or FAR editor Shift+F2 → UNIX(LF)) — #63/#64/#65. Full output shown:
  ```
   System options:
   Memory: 512 (512) MB
   Disk:   10 GB '.'
   molecule input: ''
  ' ?matrix
  ```
  Also replace typographic quotes `»3z.bas»` by `"3z.bas"` (#64).
- `malloc(536870912) failed` → could not allocate 512 MB of RAM; reduce memory / free RAM — #58 Droog_Andrey.
- `dipole =   0.000000 au (  0.000000 D)` with relativistic basis in v6 → upgrade to v8/9 (#35).
- Multiple `task=` lines silently ignored except first (#69/#70).

### Known errors (exact messages + fixes) — pages 5-8, posts #81-#160, 2011-08..2012-04

| Message / symptom | Cause / fix | Source |
|---|---|---|
| `malloc(1678770176) failed.` (after `Memory: 1601 (1601) MB`) | Windows (32-bit) build can't allocate >~1000–1100 MB; use ≤1000, typically 512 MB is plenty | #94, #95, #104 Partizan; #105 sanya1024 |
| Input "doesn't run" / `task=scan` runs as optimization / nothing works | Input saved in Unicode or edited in Word / CRLF line endings. Save as ANSI plain text with Unix `\n` endings (Word "save as text" still leaves DOS endings; TextPad must be told explicitly to save Unix endings); use TextPad or dos2unix | #104 Partizan; #113, #117 amge; #114 Yurii |
| IRC gives only 2 points (`back=0`) or no curve (`back=1`) | Starting geometry was not an optimized TS — find TS first (`task=optimize`, `$optimize saddle=1`), compute Hessian, then IRC | #100 Nicolass; #102 amge |
| `cannot open input file` (Windows) | cd into the folder first; check file name/encoding. Unresolved | #130, #131 |
| `Cannot open input file '/home/quantum/pridoda/task.in'.` (Linux, with `malloc:...` in quoted output) | File not found at that path — note the typo "pridoda" vs "priroda" in the user's command `./p6_64.bin /home/quantum/pridoda/task.in /home/quantum/priroda/task.out` | #159 Любитель_Манниха, 22 Apr 2012; #160 alxyppv |
| `If 'p6_64' is not a typo you can use command-not-found ...` | Linux: current dir not in PATH; use `./p ...` or full path | #152, #153 |
| `Error in system call mpiexec: No such file or directory` / `mpiexec could not exec p` | Don't launch via mpiexec; run `./p -np 4 in out` | #150, #153 |
| `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0`, output stops after node list, 100% CPU | Use full paths, including full path to basis file in input | #152, #154 asp |
| Hybrid functional with `theory=dft` — no error, but wrong results (HF exchange ignored) | Use `theory=ridft` | #96, #99 |

### Known errors (exact messages + fixes) — pages 9-12, posts #161-#240, 2012-04..2013-12

| Message (verbatim, possibly truncated) | Context | Fix / explanation |
|---|---|---|
| `malloc: using debugging hooks` / `[0] MPI Abort by user Aborting program !` / `[0] Aborting program!` | #161, Linux, input or output path problem | Use correct paths, work in your own `/home/username/priroda`, run `p6_64 task.in task.out` (#167, #169, #171) |
| `0: output file 'tasK.out'?` | #161, file names with capital letters | Use lower-case file names [unverified] |
| Job aborts with an error when given memory/scratch is insufficient (wording not given) | #197/#199 | "Расчёт вылетит с соответствующей ошибкой и всё" — increase `memory=`/`disk=` in `$system` (EvgeniX #199) |
| `malloc: using debugging hooks` (then hangs, no prompt) | #170, running as root | Probably just running. The .out file appears later (#172) |
| `ls: cannot access /home/quantum/priroda/task.in: No such file...` | #163 | The directory did not exist. Fix the path (#166, #167) |
| `molecule input: ''` / `'cartesian` / `' ?` ... `OOPS: semop lock failed 98304` | #172, normal user on Linux (same input works on Windows and as root) | Suggestions: fix permissions with `chmod +r *` (not `chown`) (#173), or `dos2unix task.in` to remove CRLF line endings (#174). Not confirmed resolved. Likely cause: Windows line endings in `$molecule`, and SysV semaphore permissions for "semop lock failed" |
| `process 0 recieved signal 11` (sic) | #206, Windows, Hg/Os porphyrin, basis 3z.bas, first optimization step | Unresolved. Ru works |
| `Basis set input: 'basis4.bas'   1?...` | #206, with basis4.bas | Add `four=1` to `$control` (amge #207; confirmed #208) |
| Cannot allocate about 1.3 GB (wording not given) | #210, Windows 7 x64, 4 GB RAM | Cygwin limitation. 1024 MB works. Use Linux (#211) |
| `chown: cannot access '/home/username/.gvfs': Permission denied` | #172 | Harmless (GVFS mount). Not Priroda-related |

### Known errors (exact messages + fixes) — pages 13-16, posts #241-#320, 2013-12..2015-06

| Message (verbatim) | Context | Fix / explanation |
|---|---|---|
| `h = -25.15!` (and `hmin = -0.298` lines) | SCF diverging, #305 | amge #306: limit `iterations=10`, `save=` in `$control`, restart with `$guess read=1`; repeat |
| `SCF is far from convergence` | #306, #319 | amge #306 (restart from vectors); alxyppv #320: `$grid accuracy=1e-9`, `$scf convergence=1e-7 procedure=bfgs iterations=250`; check custom basis; check mult and `theory=` (my observations) |
| `lowest eigenvalue = -1814.64!!!` … `no convergence!` | #319, SCF blows up from iteration 1 | see above; likely bad input (mult=0 for odd electrons, theory=DFT+B3LYP, custom basis) |
| `0: out of disk space (ci.Rnvvo), 553912160` / `0: out of disk space (VNNNN), 542865328` | cc-pVTZ hessian, correlated method, 16 procs, #289 | give more `disk=` in `$system`; temp files are 1 GB per core, filled as needed (#290) |
| "For all methods the performance will be degraded terribly if more than one process read and write large files on the same physical drive!" | warning, #293 | use separate physical drives per process if possible |
| `application called MPI_Abort(MPI_COMM_WORLD, 1) - process 0` | job freezes after reading `Basis set input: './basis.in'` twice (no `| Number of atoms` block); B3LYP or PBE1 with `theory=dft`, #307/#309 | amge #310: `theory=dft` cannot be used with hybrid functionals; use `theory=ridft` (alxyppv #308 sample with ridft runs, same sample with dft fails, #309) |
| ` Vicinity of a Stationary Point(?) --- STOP.` / `IRC> point   1: distance = ...` | first IRC point, #295 | amge #298: energy didn't drop; increase the step for flat tops, decrease it for narrow (proton) barriers |
| Silent hang after header (openSUSE 13.2) | #315 | none; Гесс says hangs are frequent; look for stray output files (#318) |
| Wrong geometry ("ежик", "крякозябра") at scan start | equal-dihedral scan, #271, #276 | Priroda's dihedral sign is opposite to convention (#278 amge); flipping the signs fixed it (#279 Гесс) |
| IRC stops on a flat "shelf" or at another TS, not at a minimum | #313 | amge #314: re-optimize; or hessian at stall point + new IRC, repeat 3–4× if needed; no "recompute hessian every n steps" option |

### Known errors (exact messages + fixes) — pages 17-20, posts #321-#400, 2015-06..2018-12

| Message / symptom | Context | Fix | Source |
|---|---|---|---|
| `SCF is far from convergence` | P6, Win7 x64, non-native/diffuse basis, B3LYP | `theory=ridft` for B3LYP; pre-optimize with PBE/`theory=dft`; native basis; good starting geometry | #321 amge |
| Optimization ends after 1 step; SCF energy "not a number" | Bi-containing salt with `3z` basis | `3z` covers only Z≤54. Use `sbk` ECP basis or `basis4.in` + `four=1` | #335 Гесс, #336 amge |
| `$scf` with `convergence=` + `iterations=` misbehaves | — | Also add `procedure=bfgs` | #322-#324 |
| `"tcp_peer_send_blocking: send() to socket 12 failed: Transport endpoint is not connected (128)"` | Cygwin OpenMPI on Windows; WiFi PC that also has a LAN adapter | Disable the LAN adapter | #397 Любитель_Манниха |
| Only cores 1 and 3 used | Windows parallel run, Ethernet cable unplugged | Plug the cable back in (network interface must be up) | #374 EvgeniX |
| Cygwin warning `Warning: '/dev/shm' does not exists or is not a directory.` when run from cmd.exe but not from SH.exe/mintty | Win10 + Cygwin | Environment variables not set in cmd.exe: launch from sh.exe/mintty; or skip Cygwin, put the DLLs next to the exe and create `dev\shm` and `dev\mqueue` one level above the launch directory | #360 Ahha, #362 amge, #370 EvgeniX |
| `E` ≠ T+V+J+Ex+Ec in the energy printout | any | Not an error: nuclear repulsion is not included in that line | #375, #382 EvgeniX (Laikov's answer) |
| Raman A / Raman D columns all zero | `task=hessian` | Run `task=hessian` and `task=dipole` separately, feed second derivatives + polarizability derivatives into the input, rerun `task=hessian` (Laikov) | #376, #378, #381 |
| DFT/ECP bug in `w64/*.exe` builds | Laikov's 64-bit Cygwin build | Ask Laikov for the right build | #366 |

**Unresolved (#398 KuznetsovSM, 2018-11-22)**: `orterun.exe -np 2 p6.exe test.in test.out` on Windows/Cygwin OpenMPI 3.1.3 gives:
```
Sorry!  You were supposed to get help about:
agent-not-found
from the file:
help-plm-rsh.txt
But I couldn't find that topic in the file.  Sorry!
--------------------------------------------------------------------------
[KSM-big:46468] [[INVALID],INVALID] FORCE-TERMINATE AT Not found:-13 - error /cygdrive/d/cyg_pub/devel/openmpi/v3.1/openmpi-3.1.3-1.x86_64/src/openmpi-3.1.3/orte/mca/plm/rsh/plm_rsh_component.c(327)
[KSM-big:46468] *** Process received signal ***
[KSM-big:46468] Signal: Segmentation fault (11)
[KSM-big:46468] Signal code: Address not mapped (23)
[KSM-big:46468] Failing at address: 0x0
Unable to print stack trace!
[KSM-big:46468] *** End of error message ***
Segmentation fault (стек памяти сброшен на диск)
```
He also noted there is no `mpirun.exe` in his Cygwin folder, so `mpirun -np 2` is "not found". No answer appears within this page range; it comes in #401 (later pages, EvgeniX, 2018-12-11): use version 17 from Laikov's site, because parallelization is supported only from version 16 ("Никому ничего она не должна. Там всё внутрь вшито", version 6 is hard-wired, e.g. its Hessian runs on at most 2 cores). (The `plm_rsh` "agent-not-found" error typically means OpenMPI cannot find an ssh/rsh launch agent. This is general OpenMPI knowledge, not from the thread: a possible fix is installing Cygwin `openssh` or setting the MCA parameter `plm_rsh_agent`.) [my note, unverified for Priroda]

### Known errors (exact messages + fixes) — pages 21-23, posts #401-#460, 2018-12..2020-11

1. **Temp-file write failure during analytic Hessian (#460 KuznetsovSM, Nov 3 2020).**
   After several iterations of "ANALYTIC SECOND DERIVATIVES OF SCF ENERGY" the run stops with:
   ```
   0: write file /tmp/tmp9633.11 (leAX): fd=21 buf=0x2aaaae307e80 siz=9525120,3885400 lpos=996398760
   ```
   System: 142-atom CH chain, cluster, input as above (`memory=9000 disk=40`, 4z.bas, OLYP).
   No reply in this page range. Likely causes are /tmp being full or a quota/file-size limit, so
   check free space in the temp directory and the `disk=` setting. [unverified inference]
2. **ECP not read / zero basis functions (#447-#451 Tasha, Feb 2020).** The same input and the
   same program version stopped reproducing old (2011) NMR-with-ECP results. There was no
   error message and nothing was computed. The basis seemed not to be read.
   Old output: https://yadi.sk/d/3YQzVHtf6PSClQ ; new: https://yadi.sk/d/Bs_0nLlsvIdgEQ ;
   basis: https://yadi.sk/i/e4Y_HpcZSQIw5Q
   Diagnosis, #448 Гесс: the program read the bases twice (as before) with a different result.
   This time Lu (лютеций) had zeros on the first read, and there was no sign of the ECP being
   read, which earlier happened before the basis read. He asked whether `20+St-rsc-97.bas` is
   character-for-character identical to `20+sbk.bas`.
   Fix: with `20+sbk.bas` everything works. Tasha found that the problem was in the basis
   file (she had overlooked it herself) (#449, #451). The exact defect is not stated.
   Tip: when ECP bases misbehave, check in the output that the ECP is read before the basis
   and that the basis functions are non-zero. [experienced user]
3. **NAN at the first SCF iteration** with St-rsc-97 ECP basis for [PtCl6]2- (#455 Гесс).
   The workaround is to switch to the sbk(u) basis (#454).
4. ORCA (not Priroda) MPI error mentioned by amge: "There are not enough slots available..." (#417).

### Known errors (exact messages + fixes) — pages 24-26, posts #461-#518, 2020-11..2026-07

| Message | Context | Fix / explanation |
|---|---|---|
| `0: malloc( цифры ) failed` (`цифры` = a number in bytes, apparently the `disk` amount) | KuznetsovSM, cluster, large system (>105 atoms); appears whenever he goes above `memory=9250 disk=-9250` (#463) | Allocation failed: `memory` + |negative `disk`| (MB) exceeds the RAM actually available (#464, #471). Set `path=` to a scratch directory with enough space (by default temp files may go to `/tmp` on a quota-limited node, #462). Or use a RAM disk with a negative `disk` value in MB, e.g. `memory=9000 disk=-14000` for a 24 GB node, and make sure the node really has that RAM. Positive `disk` is in GB. (#462 amge, #464 Ahha, #468 Гесс manual quote) |
| `process 0 got signal 6`, with `INTERNAL COORDINATES` table ending in `too few` | Geometry optimization (#517 spa) | `$optimize cartesian=1 $end` (#518 amge) |
| `pri2mol` produces no MOs / no `mos>` section | Priroda 23 (#508) | Add `print=+vectors+molden` to `$control` (#509, #510) |
| `We need 1.5 GB of memory...` | ordinary PC, `disk=40` (#463) | Refers to RAM: raise `memory=`; disk space does not help (#464 Ahha) [unverified] |
| `task=crytical` does nothing | Bader critical points (#495, #497) | Use `print=+density` (#499) |
| Error under cygwin64 terminal (text only in screenshot) | 2018 Cygwin/OpenMPI recipe on Win10-64 in 2021 (#472 Tasha) | No fix posted |

## 18. Comparisons with other programs

### Comparisons with other programs — pages 1-4, posts #1-#80, 2009-02..2011-08

- PBE/3z PES results lie between B3LYP/6-311++G** and MP2/6-311++G** on light models — #15 amge.
- Zirconocene ethylene polymerization PES looks like classical literature works — #15 amge.
- Fluorinated cation- and anion-radicals PES: colleagues didn't like results — #15.
- MP2 timing similar to Gaussian (#8 EvgeniX, not benchmarked).
- GAMESS `$statpt hssend=.t. $end` ≈ Priroda `task=optimize+hessian` (#73).
- Droog_Andrey (#11-#16): planned Gaussian vs Priroda comparison on large borohydride clusters (no experimental data; contacted Chris Reed) — results not posted in pages 1-4.

### Comparisons with other programs — pages 5-8, posts #81-#160, 2011-08..2012-04

- Priroda vs GAMESS basis formats (#87, #90). GAMESS needs `sadpoint` before IRC; Priroda similarly needs TS + Hessian (#100, #101); Priroda's analogue of GAMESS `sadpoint` is `task=optimize` + `$optimize saddle=1 $end` (#102 amge).
- Gaussian `6-311++G` vs Priroda: no direct analogue of 6-311G**; ≈ 3z/L2 by size (#106 amge).
- Speed comparisons of Priroda with other free programs on qchem.ru forum (http://www.qchem.ru/f/kvantovo-khimicheskie-priblizheniya/raznye-metody-raznye-znacheniya/msg325/#msg325 "и следующие посты") and in: **Беляков П.А., Анаников В.П. Изв. АН. Сер. хим., 2011, №5, стр. 765-771** (Belyakov & Ananikov, Russ. Chem. Bull. 2011, no. 5, 765–771) — "пара слов о Природа vs. Гауссиан" — #87 amge.
- ORCA recommended for: freezing many Cartesian coordinates with internal-coordinate optimization of the rest (#84); MRCI/CASPT2 (#156).
- Turbomole bases (orbital + RI auxiliary + ECP) are convertible sources for Priroda (#88).
- Gaussian on porphyrin derivative did not finish in 10 days (#97).

### Comparisons with other programs — pages 9-12, posts #161-#240, 2012-04..2013-12

- **Firefly** (#180, #203 Metalian): with direct SCF (DFT), disk speed hardly matters. Conventional SCF sometimes crashes where direct works. Whether Priroda behaves the same is unanswered. Firefly SCF aids `DAMP=.t., SHIFT=.t., SOSCF=.t.` (#187). Firefly's SBKJC basis is much smaller than Priroda's SBK (#197).
- **Gaussian** (#194 EvgeniX): Priroda's SCF converges better than many packages, but its geometry optimizer is worse than Gaussian's.
- **ORCA** (#236 Гесс): has dispersion corrections. Priroda had none as of Dec 2013 (#228 amge).
- **ONIOM** (in other programs) for large solute+solvent systems (#183).
- **Firefly author Granovsky** reportedly criticized AMD Bulldozer (#189 Лечащий Врач).

### Comparisons with other programs — pages 13-16, posts #241-#320, 2013-12..2015-06

- Dihedral sign in Priroda is opposite to other programs (#278 amge; confirmed #279).
- Λ-basis analogues: L1 ≈ cc-pVDZ, L2 ≈ cc-pVTZ, L22 ≈ cc-pCVTZ (#249 amge).
- 3z vs L2 for ab initio methods: 30–40 kcal/mol reaction-enthalpy errors with 3z (#257 EvgeniX).
- #250 VTur [unverified, general claims]:
  - No DFT functional contains true dispersion.
  - In Gaussian, GAMESS and FF (Firefly) Gaussian orbitals have the wrong asymptotics, so a "density bridge" between monomers is hard to get.
  - Recommends ADF (correct asymptotics), very large bases, or extra-large bases only on the terminal atoms.
- #301 Гесс [unverified]: a possible Priroda + Gaussian coupling for dummy atoms.

### Comparisons with other programs — pages 17-20, posts #321-#400, 2015-06..2018-12

- vs GAMESS: amge (#348) says GAMESS is "во много раз дольше" (many times slower), used only when solvation is needed. sinigin previously used GAMESS with manual `$ECP` (#337).
- vs Gaussian: Гесс (#333) believes the speedup over Gaussian exists but is "не в десятки раз" (not tens of times). He mentions RI-CC2 in Turbomole, RI-CCSD (he thinks) in ORCA, and says LPNO looks more promising. [opinion/unverified]
- VTur's description of Laikov's thesis (quoted in #329) [unverified, partly wrong]: something between ab initio and semiempirical. Some exchange integrals are not computed (four-center), others are estimated by recurrence formulas, and Coulomb/three-center integrals for distant nuclei are zeroed or computed by multipole expansion, hence the speed. Bases were refitted. Суровый (#330) concluded from the thesis abstract that it is a DFT program, and Гесс (#331) corrected that it also has MP2, CCSD(T) and semiempirics.
- **How large are systems computed elsewhere** (Гесс #340, 2016-10-30, answering EvgeniX) [experienced user, general QC context]: a fullerene tetramer without symmetry has been published. S12L/S30L benchmark sets contain systems of ~300 atoms, handled with double hybrids, which is roughly the upper edge for routine (non-benchmark) DFT able to describe van der Waals. DLPNO: near-linear scaling, Liakos showed DLPNO-CCSD only ~2.5x more expensive than B3LYP; Гесс himself could not reproduce that, but 100+ non-hydrogen atoms with TightPNO at cc-pVTZ is feasible. MP3 (and MP2.5, MP2.C, MP2X) stay below ~100 atoms even with RI; MP2 goes further; SOS-MP2 with 4th-power scaling in Turbomole. Canonical CCSD: a fullerene with a modest basis. Semiempirics: EMPIRE optimizes thousands of atoms and does single points on tens of thousands on one node; with parallelism, half a million atoms at AM1/PM3/MNDO. EvgeniX (#341) replied that one should support domestic software; Гесс's answer is under Parallel/MPI (500-core limit).
- Large-scale DFT elsewhere (Гесс #371, #383): BigDFT, "Пятнадцать тысяч атомов! (на суперкластерах)" (fifteen thousand atoms, on supercomputers), from the paper "Efficient computation of sparse matrix functions for large scale electronic structure calculations: The CheSS library" and "Accurate and efficient linear scaling DFT calculations with universal applicability"; BigDFT (Daubechies wavelets, linear scaling, CheSS library; GPU-capable). CRYSTAL17 with sHF-3c / PBEh-3c / HSE-3c / B97-3c on a poly(dA)-poly(dT) helix: 2904 atoms and 10000 orbitals took 2000 CPU-h on one 28-CPU node. A CRYSTAL PBE run with 13896 atoms (JCTC, `https://pubs.acs.org/doi/abs/10.1021/acs.jctc.7b00687`) took 1 SCF iteration per hour on 4096 CPUs and 15 min on 32768 CPUs (~40% scaling). Off-topic for Priroda.

### Comparisons with other programs — pages 21-23, posts #401-#460, 2018-12..2020-11

- #403 mizuchi asked why Priroda is needed at all. #405 amge: about 15 years ago it was far
  faster than anything else available to him (he used GAMESS then). It is also light on
  resources and tolerant of poor starting geometries.
- #406 Metalian: if you have compute resources, use Firefly, ORCA or NWChem. If you also have
  money, use Gaussian, GAMESS-UK, VASP, ADF. Priroda is what you use on a personal PC.
- #407 Гесс: ORCA with RI is now not far behind Priroda (he did not benchmark it).
- #408 Гесс (Dec 11 2018), answering mizuchi's "why is Priroda needed": strengths are Laikov's
  semiempirical QM (GFN2-xTB/DFTB level) and IRC (missing in ORCA), "ну и так, по мелочам" ("and
  minor things"). Weaknesses: "Природе на мой взгляд нехватает нормального мануала" ("in my
  view Priroda lacks a proper manual") and the RI-only/non-RI-only split. [experienced user]
- #416 mizuchi asked which molecule and hardware gave the 3x speedup ("Трехкратная разница --
  это сильно", "a threefold difference is a lot"); answered in #417 (C10H17NO, single core).
- **Benchmark #415 amge (Dec 12 2018), recovered from quote in #416:** "Счас специально проверил
  оптимизацию геометрии в PBE/cc-pVDZ. Шаг оптимизации у природы раза в три быстрее."
  ("Just checked a PBE/cc-pVDZ geometry optimization: Priroda's optimization step is about
  3x faster.") #417: molecule C10H17NO, single core. About 10 years ago the difference was 5x,
  so ORCA has caught up somewhat.
- #428 amge (Dec 14 2018): a published (Russian) article comparing Priroda, ORCA (2.8) and Gaussian
  (without RI) shows Priroda is several times faster, and the gap grows with system size.
  The attachment is not visible and there is no citation in the text. #430 Гесс: that was
  ORCA 2.8 vs current 4.0. He quotes the authors: "варьируя различные параметры оптимизации
  (уменьшив сетку интегрирования и критерии сходимости), можно добиться практически одинакового
  времени расчетов для программных пакетов Priroda и Orca" ("by varying parameters, i.e.
  coarser integration grid and looser convergence criteria, one can get practically the same
  timings for Priroda and ORCA"). He warns that accuracy must be checked because the grids
  and cutoffs differ.
- **Grids (#431 amge, Dec 14 2018):** Priroda first uses `Grid: 44184 points` and switches to
  `292728 points` near the end of each SCF. ORCA's default grid starts at `Total number of grid
  points 29744` and switches to 115877 near the end of the optimization. So Priroda's speed
  is not due to a sparser grid. #437 amge, ORCA settings: `Radial Grid Type RadialGrid ...
  Gauss-Chebyshev`, `Angular Grid (max. acc.) AngularGrid ... Lebedev-110`.
- #432 amge (recovered from quote in #435): "Было бы странно, если бы программа Лайкова была не на
  сетках Лебедева-Лайкова, а на чьих-то чужих :)" ("It would be odd if Laikov's program
  used anyone else's grids than the Lebedev-Laikov ones"). #435 Гесс: the difference is in the
  radial shells. Full #435 text: he had not expected Priroda's grid to be sparse, since "у Орки
  уже аномально редкая сетка по сравнению с большинством других программ" ("ORCA already has an
  anomalously sparse grid compared with most other programs"), see
  https://orcaforum.kofo.mpg.de/viewtopic.php?f=8&t=4272#p17673 and following, "причем разница
  в radial shells" ("and the difference is in the radial shells"). Laikov co-authored the
  Lebedev-Laikov grid code:
  http://www.ccl.net/cca/software/SOURCES/FORTRAN/Lebedev-Laikov-Grids/Lebedev-Laikov.F
- #457 amge: DIRAC is much better than Priroda for heavy-nucleus NMR.

### Comparisons with other programs — pages 24-26, posts #461-#518, 2020-11..2026-07

Гесс (#483, Dec 29 2021) [experienced user] lists alternatives for periodic systems:
- **Periodic semiempirics:** VAMP and Empire.
- **Periodic tight binding:** should now be in recent gfn-xtb releases. Otherwise DFTB+ and dftbaby, whose parameter sets cover a limited set of elements.
- **Periodic DFT:** Gaussian has it, but "категорически не рекомендую" ("strongly do not recommend"). His proper options are CP2K, VASP, WIEN2k, Quantum ESPRESSO and CRYSTAL.

amge (#486, Dec 30 2021) [experienced user] on periodic gfn-xtb: "О! Это интересно. Надо будет посмотреть." ("Oh, that's interesting, I'll have to look.") On MOPAC: "Еще полуэмпирическая периодика есть в мопаке (РМ7), это бесплатно. Я даже пробовал. Не рекомендую. У них на сайте куча якобы успешных примеров, но стоило уменьшить градиент до нормальных значений, и ячейка превращалась в бред. Но это было давно. Не исключено, что поправили." ("MOPAC (PM7) also has periodic semiempirics, free. I even tried it. Not recommended. Their site has lots of supposedly successful examples, but as soon as I lowered the gradient to normal values the cell turned into nonsense. That was long ago, though; it may have been fixed.")

Yellow21chem (#488, Jan 3 2022) chose CP2K and Quantum ESPRESSO for periodic work and asked what tight binding offers over DFT in CP2K. Гесс (#491): "Ценой. Там цена сравнимая с классической полуэмпирикой, то есть намного лучше и скейлинг и префактор по сравнению с классическим DFT." ("Cost. The cost is comparable to classical semiempirics, i.e. both the scaling and the prefactor are much better than conventional DFT.")

Гесс (#493, Jan 26 2022):
- "Основа CP2K это DFT" ("CP2K is DFT-based"). DFT is fine for final, not just preliminary, modelling, since systems that size do not fit into anything more accurate.
- With PBC you should talk about surfaces or bulk; "кластеры, наночастицы, кристаллы" ("clusters, nanoparticles, crystals") are different things.

Other points:
- Priroda's qm_n3 is roughly on par with DFTB+ and GFN2-xTB and better than most classical semiempirics (#480 Гесс).
- ORCA also gives slightly different energies between versions 5 and 6, just as Priroda does between its versions (#514 amge).

## 19. Performance & benchmarks

### Performance & benchmarks — pages 1-4, posts #1-#80, 2009-02..2011-08

- ~70 C atoms / ~1700 basis functions: optimization a few hours on single CPU; Hessian overnight (#6 amge, Feb 2009).
- Single-core speed on Windows "порадовала" (pleasing) (#67).
- Parallel scaling: mostly 2 cores, some tasks up to 4 (#66).

### Performance & benchmarks — pages 5-8, posts #81-#160, 2011-08..2012-04

- asp #154 (15 Jan 2012): same optimization (input below, 10 atoms, PBE/L1, 10 opt steps):
  - Priroda 06, Windows Vista 32-bit, 1 core — 103.00 s
  - Priroda 10, openSUSE 12.1 64-bit, 1 core — 81.49 s
  - 2 cores — 42.50 s
  - 3 cores — 29.80 s
  - 4 cores — 29.26 s
  (Earlier he said the job took ~2 min on one core in Windows v6.)
- Benchmark input — #152 asp (molecule is C2H7N-like: 1 N, 2 C, 7 H — dimethylamine):
  ```
  $system
   memory=256
   disk=2
   path=/tmp
  $end
  $control
   task=optimize
   theory=DFT
   basis=basis.in
   print=+bonds+charges+molden
  $end
  $dft functional=PBE $end
  $grid accuracy=1e-8 $end
  $optimize
   steps=300
  $end
  $molecule
   cartesian
   set=L1
  7    -1.12733723  -1.04312817   1.24201890
  6    -0.96726132   0.20444693   1.98033270
  6    -0.66426953  -0.93315611  -0.13650462
  1    -2.11668408  -1.30877490   1.24330117
  1    -1.39353114   0.09718960   2.99074156
  1     0.10865975   0.42435713   2.09716952
  1    -1.43496052   1.09499491   1.49906291
  1    -0.87134660  -1.87128091  -0.67604681
  1     0.42975719  -0.78233257  -0.14376392
  1    -1.11542004  -0.09343271  -0.71520128
  $end
  ```
  (On Linux the `basis=` had to be changed to a full path, #154.)
- Resource scale: Zr2Al3Cl2C44H79 optimization ~140 MB RAM, <1 GB disk (#96).

### Performance & benchmarks — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#183**: 2×4-core Xeon, Priroda 11, near-optimal scaling on 8 cores. 30-50 heavy atoms need only a few GB. Jobs that exceed 8 GB have several thousand basis functions.
- **#185**: direct SCF uses about 3× less memory and runs about 10× slower (EvgeniX). Counterexample **#192 amge**: disk-bound riMP2 optimization went from 2 to 20 steps overnight after switching to direct SCF (see Memory).
- **#192 amge, 16 Jan 2013** [experienced user]: "Ну, не так однозначно, если принимать во внимание соотношение цена/производительность. Несколько лет назад мы купили Intel i5, а коллеги за те же деньги 6-ядерный AMD. На AMD Природа считала в 2 с лишним раза быстрее... Рассказывали про сравнение 4-яденого интела с более дешевым 8-ядерным AMD. Тоже в пользу AMD." (Not so clear-cut if you consider price/performance. Some years ago we bought an Intel i5 and colleagues bought a 6-core AMD for the same money. Priroda ran more than 2× faster on the AMD. A 4-core Intel vs a cheaper 8-core AMD comparison also favored AMD.) This is price/performance.
- **#185 EvgeniX**: "AMD ни в коем случае брать нельзя! Это ж дикий тормоз!" (Never buy AMD, it is terribly slow!) EvgeniX later clarified (#194): "Всё же, если сравнивать топовые или около-топовые модели, то думаю, что Intel лидирует" (comparing top or near-top models, Intel leads) and "Я имел в виду чистое процессорное время" (I meant pure CPU time). **#188 EvgeniX**: even Granovsky (Firefly author) criticized Bulldozers; "ещё вопрос, под что оптимизированы программы, которые вы используете" (it also depends on what the programs you use are optimized for). **#190 Metalian**: Phenom II X6 no longer on sale (only X4). **#195 Metalian**: best AMD available is FX-8150; would compare with Core i7-3770 / i5-3570.
- **#186, #191, #200 Droog_Andrey**: called this holy-war bait. His roughly 3-year-old AMD is not being outrun by modern Intels. Compare actual candidate machines directly in practice.
- **#189 Лечащий Врач**: AMD FX (Bulldozer) 8-core has only 4 FPUs for 8 integer cores. Quantum chemistry is floating-point, so it is barely better than hyper-threading. Phenom X6 is better.
- **#184 Metalian**: plans 32 GB RAM with an 8-core AMD. Target systems: Pt4Al2 with ethanol, ethylene or acetaldehyde, later Pt12Al6(OH)4 with up to C6 molecules.
- **#203 Metalian**: budget machines are 8-core Phenoms, 32 GB RAM and an SSD.

### Performance & benchmarks — pages 13-16, posts #241-#320, 2013-12..2015-06

- **Correlated hessian on a "каплкластер"** (#289-#293):
  - cc-pVDZ fit in 60 GB of RAM with no disk.
  - cc-pVTZ on 16 processes ran out of disk; then it ran with `disk=40` (GB) on a single fast drive, 18 GB of temp in use.
  - 48 displacement steps (24 forward + 24 backward), expected to take more than a week.
- **173-atom PBE job** (#315): basis dimension 1733, auxiliary 4233. It hung on Linux.
- **#319 timings** (36 atoms, basis 376 / aux 788, Windows PC with 1 GB RAM): about 4 s per SCF macro-iteration. Coulomb integrals took 45 s and the whole SCF 71 s for 16 iterations.

### Performance & benchmarks — pages 17-20, posts #321-#400, 2015-06..2018-12

- C6H13O4, 38 optimization steps: **101 s (8 cores), 63 s (12 cores), 37 s (24 cores)** on single cluster nodes. No gain from more than one node (#344 amge, 2016-11-01).
- DFT gains little beyond 6-8 cores: ≤10% gain at 32 cores, observed for systems up to (C60)9 (#343 EvgeniX).
- Large systems: EvgeniX's group published fullerene calculations up to **C420** with Priroda (#339, ScienceDirect link truncated: `http://www.sciencedirect.com/science/ar ... 7716306865`). Another fullerene work in Priroda is mentioned: `http://perst.issp.ras.ru/Control/Inform/perst/2018/18_7_8/index.htm` (kbob, quoted in #390). Pankratyev's paper is referenced in EvgeniX's topic (#391).

### Performance & benchmarks — pages 21-23, posts #401-#460, 2018-12..2020-11

- See Comparisons: about 3x faster per optimization step than ORCA 4.0 (PBE/cc-pVDZ, C10H17NO,
  1 core, 2018). It was about 5x a decade earlier.
- Priroda grid sizes: 44184 points, then 292728 points (#431).

### Performance & benchmarks — pages 24-26, posts #461-#518, 2020-11..2026-07

- Systems up to about 105 atoms run reliably on a cluster: optimization, dipole and Hessian (#463 KuznetsovSM).
- Keeping temp files in RAM (negative `disk`) is "немного быстрее" ("a bit faster") (#462 amge).
- For a 24 GB node: `memory=9000 disk=-14000` (#462).
- qm_n3 might converge about 2500 atoms (#480). Yellow21chem used `mem=32000 disk=-10240,-1` for about 2500 atoms (#481).
- The newer Priroda (around 2025) is faster but gives slightly different energies (#514).

## 20. Miscellaneous / community facts

### Miscellaneous / community facts — pages 1-4, posts #1-#80, 2009-02..2011-08

- No symmetry: "Все в С1." (everything in C1) — #6 amge; main drawback per amge, especially for TS search. (#5 Droog_Andrey found nothing on symmetry in docs.)
- qchem.ru Priroda resources: http://www.qchem.ru/practice/priroda/conf/ (#22, #44); qchem.ru was moving hosting in Feb 2009 (#19), back up 1 Mar 2009 (#22). "много инфы по ПРИРОДе есть на кукеме.ру" (lots of info on qchem.ru) — #66.
- amge's scripts site: limor1.nioch.nsc.ru/quant/program/ (pri, pri2mol, xyz2jmod) — amge is at NIOCh (Novosibirsk) [inference from URL].
- Laikov's dissertation discussed (#7).

### Miscellaneous / community facts — pages 5-8, posts #81-#160, 2011-08..2012-04

- EvgeniX #111 proposed forum rules: always attach input and output files for specific questions.
- Attachments in the thread require registration to view.
- **Attaching inputs to the forum** — #116 EvgeniX, 1 Nov 2011 [experienced user]: the forum rejects `.in` files; "Добавьте к расширению ".in" ещё ".txt", чтобы было "file.in.txt", форум примет. И ещё добавьте нерабочий "file.out.txt"" (append `.txt` → `file.in.txt`, and also attach the failing output as `file.out.txt`).
- **Sequential-job script by amge:** http://limor1.nioch.nsc.ru/quant/program/pri/ (#145).
- Open/unanswered questions in this page range: meaning of QCC "Curvature"/"Overlap" (#122); Windows "cannot open input file" (#130–#133); CCSD(T)+BSSE input (only CCSD example given; BSSE impossible due to no dummy atoms). (IRC `back=0/1` question #100 is answered by amge #102 — unoptimized TS.)

### Miscellaneous / community facts — pages 9-12, posts #161-#240, 2012-04..2013-12

- **#181, #183, #189**: Лечащий Врач often posts from an iPhone. He is a regular with Priroda 11 experience.
- Active knowledgeable regulars in this period: amge, sanya1024, EvgeniX, alxyppv, Лечащий Врач, starless, Droog_Andrey.
- **#205 janai** (Apr 2013) asked for private help running Priroda.
- **#214/#215**: sanya1024 asked moderators to move a Priroda question from another topic (t=100328, titled "Гелиеподобные ионы") into this thread. #216's header shows that title.
- Unanswered questions:
  - Does conventional SCF crash where direct works (#203)?
  - What exactly causes the Hg/Os signal 11 crash with 3z.bas (#206)? (amge #207 recommends basis4.in + `four=1`.)
  - (Resolved: too little memory/scratch → job aborts with an error, #199; RAM-disk scratch → use negative `disk=`, #196.)
  - Should E0 be used for competing-reaction barriers (#226)?
  - Was the semop error resolved (#172-#174)?

### Miscellaneous / community facts — pages 13-16, posts #241-#320, 2013-12..2015-06

- **How to cite Priroda.** #302 Гесс (Feb 26, 2014):
  > Laikov, D. N.; Ustynyuk, Yu. A. PRIRODA-04: a quantum-chemical program suite. New possibilities in the study of molecular systems with the application of parallel computing. Russian Chemical Bulletin, 2005, 54(3), 820-826. For the current version, see http://rad.chem.msu.ru/~laikov/

  #303 alxyppv [experienced user] adds:
  - For DFT: Laikov, D. N. Fast evaluation of density functional exchange-correlation terms using the expansion of the electron density in auxiliary basis sets. Chem. Phys. Lett. 281, 151-156 (1997).
  - If L-bases are used: Laikov, D. N. A new class of atomic basis functions for accurate electronic structure calculations of molecules. Chem. Phys. Lett. 416, 116-120 (2005).
- **Author email:** `dimitri_laikov(at)mail.ru` (#287).
- **Literature links:**
  - http://pubs.acs.org/doi/abs/10.1021/jz201327t (#265, on whether benzene is non-rigid)
  - http://pubs.acs.org/doi/abs/10.1021/ja0630285 (#274, methods predicting nonplanar benzene)
  - VTur (#266/#273): benzene "bends" in small bases, and MP2 results on this vary with the basis. amge's own scan (#270) found practically no basis dependence.
  - #272 Лечащий Врач (Jan 8, 2014) [experienced user]: non-planarity of aromatics comes from experiment: in crystals perfectly planar benzene rings with all torsions at 0 are "совершенно не правило" (not at all the rule); for substituted benzenes the sum of torsion deviations lies within ±3° with no sharp maximum (his quick CSD check). Credits Shishkin's work proving aromatic and double bonds really bend (now in Phys Chem Lett); he himself saw a double bond twisted by 5° in a hydrofumarate anion.
- **Basis citation argument** (#249 amge): the L bases have a citable paper (CPL 416, 116 (2005), see #303), while 3z is described only in Laikov's (Russian) dissertation — a practical reason to use L bases in publications.
- **Thermal energy argument.** #241/#243 VTur: compare interaction energies with kT; if a barrier is below kT, the interaction can be neglected.

### Miscellaneous / community facts — pages 17-20, posts #321-#400, 2015-06..2018-12

- Priroda is used by non-specialists, e.g. *php* (#346), a synthetic chemist using it to explore reaction mechanisms with PBE.
- **Priroda's QM model (semiempirical/"QM" parametrization) is not recommended** (Любитель_Манниха #367, 2016-12-10) [experienced user]. Replying to LVictor, who was running the example files (`C60.qm.in`, cf. #365) and asked whether they were enough: "А базисы где? (инпут в студию)" (Where are the basis files? Show us the input.) "Хотите считать QM - не советую." (If you want to compute with QM, I do not recommend it.) "Даже автор туманно пишет, что «Слабости этой модели уже становятся понемногу понятны, надеюсь в будущем осилить улучшенную и расширенную параметризацию»" (Even the author writes vaguely that "the weaknesses of this model are gradually becoming clear; I hope to manage an improved and extended parametrization in the future"). "Порфирины оно из плоскости в клубок сворачивает" (it folds porphyrins from planar into a ball). [experienced user, quoting the author's own caveat]
- Гесс (#390, 2018-11-02), on kbob's link to another fullerene study done in Priroda (`http://perst.issp.ras.ru/Control/Inform/perst/2018/18_7_8/index.htm`): fullerenes are EvgeniX's bread and butter (link to EvgeniX's topic `https://www.chemport.ru/forum/viewtopic.php?f=71&t=124248&p=970950#p970888`).
- Open, unanswered within this page range: CCSD(T) acceleration (#332); `orterun` failure (#398); how to parallelize on 4-core Windows (#392; answered by #397, but see #398). Answered after the restoration: atom/basis limits (#328, attachment only), energy-component sum (#382, nuclear repulsion).

### Miscellaneous / community facts — pages 21-23, posts #401-#460, 2018-12..2020-11

- #433 Metalian: claims Gaussian's licence forbids publishing comparisons with other programs.
  This is an off-topic joke/rant. #434 Гесс: Gaussian's own page says these "Banned by
  Gaussian" stories are nonsense and they do not do that: http://gaussian.com/silly/
- #429/#438-#442: YuraM asked for his account to be deleted; EvgeniX (#438) made the same
  request. Гесс refused. Not technical.
- #453 Гесс (May 22 2020), asking Tasha to share her fix: "В инете не так много мест где люди
  обсуждают как работает Природа и что с ней делать чтоб она работала. В отсутствие мануала опыт
  каждого бесценен." ("There are few places online where people discuss how Priroda works and
  what to do to make it work. In the absence of a manual, everyone's experience is
  invaluable.")
- #452 Tasha (May 22 2020): "Грамотная формулировка проблемы есть половина ее решения"
  ("A well-formulated problem is half solved").

### Miscellaneous / community facts — pages 24-26, posts #461-#518, 2020-11..2026-07

- The `pri2mol` script converts Priroda output to Molden or xyz format. It was used for both MOs and critical points (#502, #508-#509).
- QCC Front-End (by Besedin) is a GUI/front-end that can display Priroda results, including critical points (#500).
- Laikov's Windows binaries are at https://rad.chem.msu.ru/~laikov/p_w/ (#503).
- The old community doc site wt.knc.ru ("Природа для самых маленьких") is gone (#477).

#### Open/unanswered questions in this page range
- Where to find online documentation (#477). Not answered directly, but a PDF mirror of the KNC wiki manual was cited earlier in #468 (https://monitor.hpc.umanitoba.ca/doc/Priroda_Documentation_from_KNCWiki.pdf).
- An up-to-date list of supported functionals (#494). Not answered.
- Meaning of the second value in `disk=-10240,-1`. Not discussed.
- Meaning of `Np=`, `f=`, `h=` in the critical-point output. Only partly discussed: amge (#501) established `r` = Cartesian position and `h` = something rotation-invariant (not coordinates), so Tasha's interpretation of `h` is wrong.
- Whether a correctly spelled `task=critical` exists (#497: `task=crytical` does not work).
- The Cygwin error in #472 (screenshot only).
- Meaning of "Number of core electrons 1", "Kinetic energy corrections N=15" and "Finite nucleus model (2)" in the output header. Not explained.
- ~~Whether the default temp directory is `/tmp` or the input-file directory (#462 vs #465).~~ Resolved by amge #465: `path=` > `$TMPDIR` > input-file directory.

## 21. Open (unanswered) questions

### Open (unanswered) questions — pages 1-4, posts #1-#80, 2009-02..2011-08

- Spin densities for radicals — which table (#28).
- Scan computing fewer points than requested (#60).
- What OrganikNV's fix for malloc failure was (#59).
- Exact `fix=` coordinate type codes (#52).

### Open (unanswered) questions — pages 21-23, posts #401-#460, 2018-12..2020-11

- Difference between basis files b2u, b2un, b4s, b4sn (#410).
- Spin-orbit coupling support in Priroda (#422).
- Cause of the `write file /tmp/...` Hessian failure (#460).
- Why St-rsc-97 Pt basis gives NAN in PtCl6, and why the Cl shifts differ in symmetric
  [PtCl6]2- (#455-#458).
