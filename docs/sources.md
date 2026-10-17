(sources)=
# Sources

This manual is not an official Priroda document. It was not written or reviewed by the developer of Priroda,
Dimitri Laikov. It is compiled from the sources below, which are listed roughly in the order of how much weight the
manual gives them when they disagree. Each keyword entry in the {doc}`input reference <reference/index>` names the
sources it rests on.

## Test runs

Version 25 test runs
: Small test inputs (water, ammonia, OH) run on Priroda 25 (2025.02.28) in October 2026 for this manual. Where they
  confirm or contradict an older source, the manual follows the run and says so. The inputs and outputs are kept with
  the manual's source files.

## Program files and text from the developer

Official file index
: <https://rad.chem.msu.ru/~laikov/p_w/>, read in October 2026 (page dated June 2025). A bare listing of executables,
  example inputs and outputs, basis-set and parameter files, and the helper scripts `ge`, `gm` and `grx`. It has no
  prose documentation. Example outputs from this site are the strongest evidence for defaults and output formats.
  Windows builds are in the `exe64/` subdirectory.

Input Summary (`input.txt`)
: An English keyword list shipped with the program, apparently written by the developer, with user annotations
  appended. It is the closest thing to an official keyword reference. A few of its Russian annotations are
  corrupted and cannot be read.

Version 5 keyword reference (KNC wiki mirror)
: The developer's "Input Summary" for version 5, mirrored on the wiki of the Kazan Scientific Centre computing centre
  together with a beginner FAQ. The wiki is offline; pages were recovered from the Internet Archive
  (captures 2008–2012). A PDF copy of the documentation page is at
  <https://monitor.hpc.umanitoba.ca/doc/Priroda_Documentation_from_KNCWiki.pdf>.

`Dft.rtf`
: A short Russian keyword list with practical advice, from an older version. Some of its defaults differ from later
  versions.

`Dft_ansi.txt`
: A Russian description of the input of Priroda's predecessor. Its group names are obsolete; it is used here only
  for history.

## User-written material

Forum statements attributed to the developer reach these sources only second-hand, through users who relayed his
e-mails. The manual marks such statements as relayed.

chemport.ru forum, thread 28803 ("Priroda")
: <https://chemport.ru/forum/viewtopic.php?f=71&t=28803>. The main Russian-language user thread, 518 posts from
  2009 to 2026. The largest single source for practical advice and known problems.

chemport.ru forum, thread 112860 ("Difficult cases with Priroda")
: <https://chemport.ru/forum/viewtopic.php?f=71&t=112860>. Six posts (2015–2016) on SCF divergence, RI-MP2 memory and
  parallel hangs, with complete inputs and outputs.

qchem.ru forum, thread "Quantum-chemical program Priroda"
: The forum of the Ufa Quantum Chemistry Society, 2007–2012. The site has been offline since about 2019; posts up to
  August 2012 were recovered from the Internet Archive.

LIMOR page, Novosibirsk Institute of Organic Chemistry
: <http://limor1.nioch.nsc.ru/priroda.html>. Example inputs, tables of basis-set names, and Perl helper scripts
  (`pri`, `priin`, `pri2mol` and others) written by users. Much of what the manual says about the output format is
  inferred from how these scripts parse it.

## Published papers

The papers listed under {ref}`how-to-cite` describe the methods behind Priroda. They are cited where the manual
explains a method, not as documentation of the input.
