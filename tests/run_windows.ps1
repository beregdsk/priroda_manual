# Windows tests for Priroda (exe64/ builds from the official site). Run from PowerShell in the tests folder:
#
#   $env:PRIRODA = "C:\Priroda\p1.exe"       # cygwin1.dll must be in the same folder
#   $env:BASIS   = "C:\Priroda\basis.in"
#   powershell -ExecutionPolicy Bypass -File .\run_windows.ps1            # all tests
#   powershell -ExecutionPolicy Bypass -File .\run_windows.ps1 w02 w05    # tests whose name starts with w02 or w05
#
# Optional:
#   $env:PRIRODA_MPI = "C:\Priroda\p_190306.exe"   parallel build: run serially (w13b) and, with MPIRUN, on 2 processes
#   $env:MPIRUN      = "C:\Priroda\orterun.exe"     MPI launcher (orterun.exe or mpirun.exe) for w13a
#   $env:TIMEOUT     = seconds per run (default 1800)
#
# Outputs go to runs\win-<date>\. status.txt collects exit codes; env.txt describes the machine and the program folder.
# Inputs are written with Unix (LF) line endings whatever git did to them on checkout; only w06 is written with CRLF.

$ErrorActionPreference = "Stop"
if (-not $env:PRIRODA) { throw "set `$env:PRIRODA to the Priroda executable (p1.exe)" }
if (-not $env:BASIS)   { throw "set `$env:BASIS to the full path of basis.in" }
$priroda = (Resolve-Path $env:PRIRODA).Path
$basis   = (Resolve-Path $env:BASIS).Path
$here    = $PSScriptRoot
$out     = [IO.Path]::Combine($here, "runs", "win-" + (Get-Date -Format "yyyyMMdd-HHmmss"))
New-Item -ItemType Directory -Path $out | Out-Null
$status  = Join-Path $out "status.txt"
$timeout = 1800; if ($env:TIMEOUT) { $timeout = [int]$env:TIMEOUT }
$onWindows = ($env:OS -eq "Windows_NT")
function J { [IO.Path]::Combine([string[]]$args) }
$utf8 = New-Object System.Text.UTF8Encoding($false)
$select = $args

function Selected([string]$id) {
  if ($select.Count -eq 0) { return $true }
  foreach ($s in $select) { if ($id.StartsWith($s)) { return $true } }
  return $false
}
function Note([string]$line) { Add-Content -Path $status -Value $line }

# Prep <input> <destination> [basis value] [crlf]: fill @BASIS@ and write with LF (or CRLF) line endings
function Prep([string]$in, [string]$dest, [string]$b = $basis, [switch]$Crlf) {
  $t = [IO.File]::ReadAllText((J $here "inputs" $in)) -replace "`r`n", "`n"
  $t = $t.Replace("@BASIS@", $b)
  if ($Crlf) { $t = $t.Replace("`n", "`r`n") }
  [IO.File]::WriteAllText($dest, $t, $utf8)
}

# Run <name> <exe> <argument list> [working dir] [environment changes: name = value, or $null to remove]
# stdout and stderr go to <name>.stdout and <name>.err in the working directory when not empty.
function Run([string]$name, [string]$exe, [string[]]$arguments, [string]$cwd = $out, [hashtable]$envChanges = @{}) {
  $psi = New-Object System.Diagnostics.ProcessStartInfo
  $psi.FileName = $exe
  $psi.Arguments = ($arguments | ForEach-Object { '"' + $_ + '"' }) -join " "
  $psi.WorkingDirectory = $cwd
  $psi.UseShellExecute = $false
  $psi.RedirectStandardOutput = $true
  $psi.RedirectStandardError = $true
  foreach ($k in $envChanges.Keys) {
    if ($null -eq $envChanges[$k]) { $psi.EnvironmentVariables.Remove($k) } else { $psi.EnvironmentVariables[$k] = $envChanges[$k] }
  }
  $started = Get-Date
  try { $p = [Diagnostics.Process]::Start($psi) } catch { Note "$name could not start: $($_.Exception.Message)"; return }
  $so = $p.StandardOutput.ReadToEndAsync(); $se = $p.StandardError.ReadToEndAsync()
  if (-not $p.WaitForExit($timeout * 1000)) { $p.Kill(); Note "$name killed after $timeout s" }
  $p.WaitForExit()
  if ($so.Result) { [IO.File]::WriteAllText((Join-Path $cwd "$name.stdout"), $so.Result, $utf8) }
  if ($se.Result) { [IO.File]::WriteAllText((Join-Path $cwd "$name.err"), $se.Result, $utf8) }
  Note ("$name exit=$($p.ExitCode) time={0:N0}s" -f ((Get-Date) - $started).TotalSeconds)
}

# RunBat <name> <lines>: run a cmd.exe batch file (for the "set TMPDIR=..." recipes, which need cmd quoting rules)
function RunBat([string]$name, [string[]]$lines) {
  if (-not $onWindows) { Note "$name skipped: needs cmd.exe"; return }
  $bat = Join-Path $out "$name.bat"
  [IO.File]::WriteAllText($bat, ((@("@echo off", 'cd /d "%~dp0"') + $lines) -join "`r`n") + "`r`n", [Text.Encoding]::ASCII)
  Run $name "cmd.exe" @("/c", $bat)
}

# Machine and program-folder description
$exeDir = Split-Path $priroda
$root = Split-Path $exeDir
$info = @(
  "date: $(Get-Date -Format s)",
  "os: $([Environment]::OSVersion.VersionString)",
  "PRIRODA: $priroda",
  "BASIS: $basis",
  "PRIRODA_MPI: $env:PRIRODA_MPI",
  "MPIRUN: $env:MPIRUN",
  "TMPDIR: $env:TMPDIR",
  "TEMP: $env:TEMP",
  "cygpath on PATH (a Cygwin installation): $([bool](Get-Command cygpath -ErrorAction SilentlyContinue))",
  "folder above the program ($root): tmp exists=$(Test-Path (Join-Path $root 'tmp')), dev\shm exists=$(Test-Path (J $root 'dev' 'shm'))",
  "",
  "files in $exeDir (exe and dll):"
)
$info += Get-ChildItem $exeDir -File | Where-Object { $_.Extension -in ".exe", ".dll" } |
  ForEach-Object { "  {0}  {1:yyyy-MM-dd}  {2} bytes" -f $_.Name, $_.LastWriteTime, $_.Length }
[IO.File]::WriteAllLines((Join-Path $out "env.txt"), [string[]]$info)

# w01: baseline energy (scratch in the current directory); compare with Linux v25 t01, E = -76.3653913723
if (Selected "w01") { Prep "w01_energy.in" (J $out "w01_energy.in"); Run "w01_energy" $priroda @("w01_energy.in", "w01_energy.out") }

# w02: scratch location with disk=1 and no path=
if (Selected "w02") {
  Prep "w02_scratch_default.in" (J $out "w02a_no_tmpdir.in")
  Run "w02a_no_tmpdir" $priroda @("w02a_no_tmpdir.in", "w02a_no_tmpdir.out") $out @{ TMPDIR = $null }
  Prep "w02_scratch_default.in" (J $out "w02b_tmpdir_cmd.in")
  RunBat "w02b_tmpdir_cmd" @('set TMPDIR=%TEMP%', "`"$priroda`" w02b_tmpdir_cmd.in w02b_tmpdir_cmd.out")
  Prep "w02_scratch_default.in" (J $out "w02c_tmpdir_cmd_quoted.in")
  RunBat "w02c_tmpdir_cmd_quoted" @('set TMPDIR="%TEMP%"', "`"$priroda`" w02c_tmpdir_cmd_quoted.in w02c_tmpdir_cmd_quoted.out")
  New-Item -ItemType Directory -Path (J $out "w02d_tmp") | Out-Null
  Prep "w02_scratch_default.in" (J $out "w02d_tmpdir_windows_path.in")
  Run "w02d_tmpdir_windows_path" $priroda @("w02d_tmpdir_windows_path.in", "w02d_tmpdir_windows_path.out") $out @{ TMPDIR = (J $out "w02d_tmp") }
}
# w03: RAM disk (disk=-256), no path=, TMPDIR unset: does it avoid scratch files altogether?
if (Selected "w03") { Prep "w03_ramdisk.in" (J $out "w03_ramdisk.in"); Run "w03_ramdisk" $priroda @("w03_ramdisk.in", "w03_ramdisk.out") $out @{ TMPDIR = $null } }
# w04: no $system group at all, TMPDIR unset (what a beginner's first input looks like)
if (Selected "w04") { Prep "w04_no_system.in" (J $out "w04_no_system.in"); Run "w04_no_system" $priroda @("w04_no_system.in", "w04_no_system.out") $out @{ TMPDIR = $null } }

# w05: basis path forms: backslashes, forward slashes, relative name next to the input
if (Selected "w05") {
  Prep "w01_energy.in" (J $out "w05a_basis_backslash.in") ($basis -replace "/", "\")
  Run "w05a_basis_backslash" $priroda @("w05a_basis_backslash.in", "w05a_basis_backslash.out")
  Prep "w01_energy.in" (J $out "w05b_basis_slash.in") ($basis -replace "\\", "/")
  Run "w05b_basis_slash" $priroda @("w05b_basis_slash.in", "w05b_basis_slash.out")
  $d = (J $out "w05c"); New-Item -ItemType Directory -Path $d | Out-Null; Copy-Item $basis (J $d "basis.in")
  Prep "w01_energy.in" (J $d "w05c_basis_relative.in") "basis.in"
  Run "w05c_basis_relative" $priroda @("w05c_basis_relative.in", "w05c_basis_relative.out") $d
  Remove-Item (J $d "basis.in")
}
# w06: the w01 input with Windows (CRLF) line endings: does the Windows build cope with them?
if (Selected "w06") { Prep "w01_energy.in" (J $out "w06_crlf.in") -Crlf; Run "w06_crlf" $priroda @("w06_crlf.in", "w06_crlf.out") }
# w07: 3000 MB of memory: no "malloc(...) failed" in the 64-bit build?
if (Selected "w07") { Prep "w07_memory_3gb.in" (J $out "w07_memory_3gb.in"); Run "w07_memory_3gb" $priroda @("w07_memory_3gb.in", "w07_memory_3gb.out") }
# w08: no output file given: does the output go to the console (w08_stdout.stdout)?
if (Selected "w08") { Prep "w01_energy.in" (J $out "w08_stdout.in"); Run "w08_stdout" $priroda @("w08_stdout.in") }
# w09: started from another folder, with full Windows paths for input and output
if (Selected "w09") {
  $d = (J $out "w09_cwd"); New-Item -ItemType Directory -Path $d | Out-Null
  Prep "w01_energy.in" (J $out "w09_fullpath.in")
  Run "w09_fullpath" $priroda @((J $out "w09_fullpath.in"), (J $out "w09_fullpath.out")) $d
}
# w10: a folder name with a space: a) run inside it; b) run from outside with quoted relative paths
if (Selected "w10") {
  $d = (J $out "dir with space"); New-Item -ItemType Directory -Path $d | Out-Null
  Prep "w01_energy.in" (J $d "w10a_space_inside.in")
  Run "w10a_space_inside" $priroda @("w10a_space_inside.in", "w10a_space_inside.out") $d
  Prep "w01_energy.in" (J $d "w10b_space_quoted.in")
  Run "w10b_space_quoted" $priroda @((J "dir with space" "w10b_space_quoted.in"), (J "dir with space" "w10b_space_quoted.out"))
}
# w11, w12: optimization and analytic Hessian (heavier scratch use); compare with the Linux v25 water results
if (Selected "w11") { Prep "w11_optimize.in" (J $out "w11_optimize.in"); Run "w11_optimize" $priroda @("w11_optimize.in", "w11_optimize.out") }
if (Selected "w12") { Prep "w12_hessian.in" (J $out "w12_hessian.in"); Run "w12_hessian" $priroda @("w12_hessian.in", "w12_hessian.out") }

# w13: the parallel build. a) on 2 processes through MPIRUN; b) started directly, without a launcher
if (Selected "w13") {
  if (-not $env:PRIRODA_MPI) { Note "w13 skipped: PRIRODA_MPI not set" }
  else {
    $pm = (Resolve-Path $env:PRIRODA_MPI).Path
    if ($env:MPIRUN) {
      Prep "w01_energy.in" (J $out "w13a_parallel.in")
      Run "w13a_parallel" (Resolve-Path $env:MPIRUN).Path @("-np", "2", $pm, "w13a_parallel.in", "w13a_parallel.out") $out @{ TMPDIR = $out }
    } else { Note "w13a skipped: MPIRUN not set" }
    Prep "w01_energy.in" (J $out "w13b_mpi_build_serial.in")
    Run "w13b_mpi_build_serial" $pm @("w13b_mpi_build_serial.in", "w13b_mpi_build_serial.out")
  }
}

# Scratch files left behind (Priroda names them tmp<number>.<rank>)
$left = Get-ChildItem $out -Recurse -File -Filter "tmp*" | ForEach-Object { $_.FullName.Substring($out.Length + 1) }
if ($left) { Note "scratch files left: $($left -join ', ')" } else { Note "no scratch files left in the run folder" }
Note "folder above the program after the runs: tmp exists=$(Test-Path (Join-Path $root 'tmp'))"
Write-Host "Outputs in $out"; Get-Content $status
