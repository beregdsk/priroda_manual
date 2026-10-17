#!/bin/bash
# Run the verification inputs serially and keep every output.
#   PRIRODA=/path/to/p BASIS=/path/to/basis.in ./run.sh            # all tests
#   PRIRODA=/path/to/p BASIS=/path/to/basis.in ./run.sh t01 t08    # selected tests
# Outputs go to runs/<date>/. Tests that need special handling (t03, t19-t21) are run here as described in README.md.
set -u
: "${PRIRODA:?set PRIRODA to the Priroda executable}"
: "${BASIS:?set BASIS to the absolute path of basis.in}"
here=$(cd "$(dirname "$0")" && pwd)
out="$here/runs/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$out"
THEORIES="hf rihf cis mp2 mp3 mp4dq mp4sdq mp4sdtq ccs ccd ccsd ccsd4t"

prep() { sed -e "s|@BASIS@|$BASIS|" -e "s|@THEORY@|${2:-}|" "$here/inputs/$1.in" > "$out/$3.in"; }
run() {  # run <name>: run $out/<name>.in in $out, record the exit status
  (cd "$out" && timeout 1800 "$PRIRODA" "$1.in" "$1.out"; echo "$1 exit=$?" >> status.txt)
}

selected() { local id=$1; shift; [ $# -eq 0 ] && return 0; for s in "$@"; do [[ $id == "$s"* ]] && return 0; done; return 1; }

for f in "$here"/inputs/t*.in; do
  name=$(basename "$f" .in)
  selected "$name" "$@" || continue
  case $name in
    t03_*)  # relative basis name: copy basis.in next to the input, run from that directory
      mkdir -p "$out/t03" && cp "$BASIS" "$out/t03/basis.in" && cp "$f" "$out/t03/$name.in"
      (cd "$out/t03" && timeout 600 "$PRIRODA" "$name.in" "$name.out"; echo "$name exit=$?" >> "$out/status.txt") ;;
    t17_*)
      for th in $THEORIES; do prep "$name" "$th" "t17_$th"; run "t17_$th"; done ;;
    *)  prep "$name" "" "$name"; run "$name" ;;
  esac
done

if selected t19 "$@"; then  # output file name with a capital letter
  prep t01_energy "" t19_capital; (cd "$out" && "$PRIRODA" t19_capital.in T19_Capital.out; echo "t19 exit=$?" >> status.txt)
fi
if selected t20 "$@"; then  # no output file given: does the output go to standard output?
  prep t01_energy "" t20_stdout; (cd "$out" && "$PRIRODA" t20_stdout.in > t20_stdout.stdout 2>&1; echo "t20 exit=$?" >> status.txt)
fi
if selected t21 "$@"; then  # parallel launch forms, 2 processes
  prep t01_energy "" t21a_np; (cd "$out" && "$PRIRODA" -np 2 t21a_np.in t21a_np.out; echo "t21a exit=$?" >> status.txt)
  mpx="$(dirname "$PRIRODA")/mpiexec"
  if [ -x "$mpx" ]; then
    prep t01_energy "" t21b_mpiexec; (cd "$out" && "$mpx" -np 2 "$PRIRODA" t21b_mpiexec.in t21b_mpiexec.out; echo "t21b exit=$?" >> status.txt)
  fi
fi

echo "Outputs in $out"; cat "$out/status.txt"
