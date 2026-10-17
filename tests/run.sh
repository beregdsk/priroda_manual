#!/bin/bash
# Run the verification inputs serially and keep every output.
#   PRIRODA=/path/to/p BASIS=/path/to/basis.in ./run.sh             # all tests
#   PRIRODA=/path/to/p BASIS=/path/to/basis.in ./run.sh t22 t24     # tests whose name starts with t22 or t24
# Optional:
#   BASIS4=/path/to/basis4.in    enables t35 (four=1)
#   QMBASIS=/path/to/qm.in       enables t39 and the *_qm_n3 tests (theory=qm_n3)
#   MPIEXEC=/path/to/mpiexec     enables t21b (bundled mpiexec); mpirun on PATH enables t21c
#   NP=N with MPIEXEC=…          run the tests on N processes, e.g. NP=8 MPIEXEC=/path/to/mpiexec
#   TIMEOUT=seconds              time limit per run (default 3600; 0 = no limit), e.g. TIMEOUT=0 LONG=1 ./run.sh t72
# Outputs go to runs/<date>/: <name>.out, plus <name>.err when the program wrote to stderr.
# Exit statuses are collected in runs/<date>/status.txt.
set -u
: "${PRIRODA:?set PRIRODA to the Priroda executable}"
: "${BASIS:?set BASIS to the absolute path of basis.in}"
here=$(cd "$(dirname "$0")" && pwd)
out="$here/runs/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$out"
THEORIES="hf rihf cis mp2 mp3 mp4dq mp4sdq mp4sdtq ccs ccd ccsd ccsd4t"

selected() { local id=$1; shift; [ $# -eq 0 ] && return 0; for s in "$@"; do [[ $id == "$s"* ]] && return 0; done; return 1; }

# prep <input name> <theory> <run name>: fill placeholders and write runs/<date>/<run name>.in
prep() {
  sed -e "s|@BASIS@|$BASIS|" -e "s|@BASIS4@|${BASIS4:-}|" -e "s|@QMBASIS@|${QMBASIS:-}|" \
      -e "s|@THEORY@|${2:-}|" "$here/inputs/$1.in" > "$out/$3.in"
}
# last_energy <output>: the last $Energy group from eng-prefixed lines, prefix stripped
last_energy() { sed -n 's/^eng>//p' "$1" | awk '/\$Energy/{buf=""} {buf=buf $0 "\n"} END{printf "%s", buf}'; }
# run <name> [command prefix...]: run <name>.in in $out, keep stderr, record the exit status
run() {
  local name=$1; shift
  # NP=N with MPIEXEC set: run tests that are otherwise serial on N processes
  if [ $# -eq 0 ] && [ "${NP:-1}" -gt 1 ]; then
    : "${MPIEXEC:?NP needs MPIEXEC (the mpiexec from the official site)}"
    set -- "$MPIEXEC" -np "$NP"
  fi
  (cd "$out" && timeout "${TIMEOUT:-3600}" "$@" "$PRIRODA" "$name.in" "$name.out" 2> "$name.err"; echo "$name exit=$?" >> status.txt)
  [ -s "$out/$name.err" ] || rm -f "$out/$name.err"
}
skip() { echo "$1 skipped: $2" >> "$out/status.txt"; }

for f in "$here"/inputs/t*.in; do
  name=$(basename "$f" .in)
  selected "$name" "$@" || continue
  if [[ $name == *_qm_n3 ]] && [ -z "${QMBASIS:-}" ]; then skip "$name" "QMBASIS not set"; continue; fi
  case $name in
    t03_*)  # relative basis name: run next to a temporary copy of basis.in, then delete the copy
      mkdir -p "$out/t03" && cp "$BASIS" "$out/t03/basis.in" && cp "$f" "$out/t03/$name.in"
      (cd "$out/t03" && timeout 600 "$PRIRODA" "$name.in" "$name.out" 2> "$name.err"; echo "$name exit=$?" >> "$out/status.txt")
      rm -f "$out/t03/basis.in"; [ -s "$out/t03/$name.err" ] || rm -f "$out/t03/$name.err" ;;
    t17_*)
      for th in $THEORIES; do prep "$name" "$th" "t17_$th"; run "t17_$th"; done ;;
    t27b_*)  # needs the vectors saved by t27a
      if [ ! -e "$out/t27.vec" ]; then skip "$name" "needs t27a in the same run (no t27.vec)"; continue; fi
      prep "$name" "" "$name"; run "$name" ;;
    t59_*)  # relative basis name in a parallel run: needs MPIEXEC
      if [ -z "${MPIEXEC:-}" ]; then skip "$name" "MPIEXEC not set"; continue; fi
      mkdir -p "$out/t59" && cp "$BASIS" "$out/t59/basis.in" && cp "$f" "$out/t59/$name.in"
      (cd "$out/t59" && timeout 600 "$MPIEXEC" -np 2 "$PRIRODA" "$name.in" "$name.out" > "$name.stdout" 2>&1; echo "$name exit=$?" >> "$out/status.txt")
      rm -f "$out/t59/basis.in" ;;
    t63_*)  # parallel run of a numerical Hessian: needs MPIEXEC
      if [ -z "${MPIEXEC:-}" ]; then skip "$name" "MPIEXEC not set"; continue; fi
      prep "$name" "" "$name"; run "$name" "$MPIEXEC" -np 2 ;;
    t64_*)  # scratch location: a) TMPDIR unset, run from a subdirectory; b) TMPDIR set to a directory of its own
      mkdir -p "$out/t64a" "$out/t64b/tmpdir" && prep "$name" "" "$name"
      cp "$out/$name.in" "$out/t64a/"; cp "$out/$name.in" "$out/t64b/"
      (cd "$out/t64a" && env -u TMPDIR timeout 600 "$PRIRODA" "$name.in" "$name.out" 2> "$name.err"; echo "t64a exit=$?" >> "$out/status.txt")
      (cd "$out/t64b" && TMPDIR="$out/t64b/tmpdir" timeout 600 "$PRIRODA" "$name.in" "$name.out" 2> "$name.err"; echo "t64b exit=$?" >> "$out/status.txt") ;;
    t71_*|t71b_*)  # SCF restart loop: up to 8 cycles of 10 iterations, each reading the vectors saved by the previous one
      prep "$name" "" "${name}_cycle1"
      for c in 1 2 3 4 5 6 7 8; do
        if [ $c -gt 1 ]; then
          sed '/^\$molecule/i $guess read=1 $end' "$out/$name.in" > "$out/${name}_cycle$c.in"
        else cp "$out/${name}_cycle1.in" "$out/$name.in"; fi
        run "${name}_cycle$c"
        if grep -q "converged!" "$out/${name}_cycle$c.out"; then echo "$name converged in cycle $c" >> "$out/status.txt"; break; fi
      done
      rm -f "$out/cu.vec" ;;
    t72_*)  # long: optimization + Hessian of a 22-atom complex; only with LONG=1
      if [ -z "${LONG:-}" ]; then skip "$name" "long run, set LONG=1"; continue; fi
      prep "$name" "" "$name"; run "$name" ;;
    t74b_*|t74c_*)  # need the triplet vectors saved by t74a; each run starts from a fresh copy of them
      [ -e "$out/o2t_triplet.vec" ] || { [ -e "$out/o2t.vec" ] && cp "$out/o2t.vec" "$out/o2t_triplet.vec"; }
      if [ ! -e "$out/o2t_triplet.vec" ]; then skip "$name" "needs t74a in the same run (no o2t.vec)"; continue; fi
      cp "$out/o2t_triplet.vec" "$out/o2t.vec"
      prep "$name" "" "$name"; run "$name" ;;
    t35_*|t49_*) if [ -z "${BASIS4:-}" ]; then skip "$name" "BASIS4 not set"; continue; fi; prep "$name" "" "$name"; run "$name" ;;
    t39_*) if [ -z "${QMBASIS:-}" ]; then skip "$name" "QMBASIS not set"; continue; fi; prep "$name" "" "$name"; run "$name" ;;
    *)
      # Inputs with @ENERGY_FROM_tNN@ lines get the last $Energy group of test tNN's output (same run) in its place.
      need=$(grep -o '@ENERGY_FROM_t[0-9a-z]*@' "$f" | sort -u | sed 's/@ENERGY_FROM_\(.*\)@/\1/')
      neednum=$(grep -o '@NUM_FROM_t[0-9a-z]*@' "$f" | sed 's/@NUM_FROM_\(.*\)@/\1/')
      if [ -z "$need$neednum" ]; then prep "$name" "" "$name"; run "$name"; continue; fi
      prep "$name" "" "$name"; ok=1
      for src in $need; do
        srcout=$(ls "$out"/${src}_*.out 2>/dev/null | head -1)
        if [ -z "$srcout" ] || [ ! -s "$srcout" ]; then skip "$name" "needs $src in the same run"; ok=0; break; fi
        last_energy "$srcout" > "$out/energy.tmp"
        sed -i -e "/@ENERGY_FROM_$src@/r $out/energy.tmp" -e "/@ENERGY_FROM_$src@/d" "$out/$name.in"
        rm -f "$out/energy.tmp"
      done
      # @NUM_FROM_tNN@ lines get all num-prefixed lines of test tNN's output, prefix stripped.
      for src in $neednum; do
        [ $ok = 1 ] || break
        srcout=$(ls "$out"/${src}_*.out 2>/dev/null | head -1)
        if [ -z "$srcout" ] || [ ! -s "$srcout" ]; then skip "$name" "needs $src in the same run"; ok=0; break; fi
        sed -n 's/^num>//p' "$srcout" > "$out/num.tmp"
        sed -i -e "/@NUM_FROM_$src@/r $out/num.tmp" -e "/@NUM_FROM_$src@/d" "$out/$name.in"
        rm -f "$out/num.tmp"
      done
      [ $ok = 1 ] && run "$name" ;;
  esac
done

if selected t19 "$@"; then  # output file name with capital letters
  prep t01_energy "" t19_capital
  (cd "$out" && "$PRIRODA" t19_capital.in T19_Capital.out 2> t19_capital.err; echo "t19 exit=$?" >> status.txt)
fi
if selected t20 "$@"; then  # no output file given: does the output go to standard output?
  prep t01_energy "" t20_stdout
  (cd "$out" && "$PRIRODA" t20_stdout.in > t20_stdout.stdout 2>&1; echo "t20 exit=$?" >> status.txt)
fi
if selected t21 "$@"; then  # parallel launch forms, 2 processes
  prep t01_energy "" t21a_np
  (cd "$out" && "$PRIRODA" -np 2 t21a_np.in t21a_np.out > t21a_np.stdout 2>&1; echo "t21a exit=$?" >> status.txt)
  mpx="${MPIEXEC:-$(dirname "$PRIRODA")/mpiexec}"
  if [ -x "$mpx" ]; then
    prep t01_energy "" t21b_mpiexec
    (cd "$out" && "$mpx" -np 2 "$PRIRODA" t21b_mpiexec.in t21b_mpiexec.out > t21b_mpiexec.stdout 2>&1; echo "t21b exit=$?" >> status.txt)
  else skip t21b "no bundled mpiexec (set MPIEXEC)"; fi
  if command -v mpirun > /dev/null; then
    prep t01_energy "" t21c_mpirun
    (cd "$out" && mpirun -np 2 "$PRIRODA" t21c_mpirun.in t21c_mpirun.out > t21c_mpirun.stdout 2>&1; echo "t21c exit=$?" >> status.txt)
  else skip t21c "no mpirun on PATH"; fi
fi

rm -f "$out"/t27.vec "$out"/o2t.vec "$out"/o2t_triplet.vec
echo "Outputs in $out"; cat "$out/status.txt"
