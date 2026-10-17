#!/bin/bash
# Install a single-node Slurm on this PC (Ubuntu or Debian): the PC is both the controller and the only compute node.
#   sudo ./setup_slurm.sh            # install, configure, start
#   sudo ./setup_slurm.sh remove     # stop and uninstall again
# Afterwards `sinfo` should show one node in state "idle".
set -eu
[ "$(id -u)" = 0 ] || { echo "run with sudo"; exit 1; }

if [ "${1:-}" = remove ]; then
  systemctl disable --now slurmd slurmctld munge 2>/dev/null || true
  apt-get remove -y slurm-wlm slurmctld slurmd munge
  echo "Removed. /etc/slurm/slurm.conf and /var/lib/slurm are left in place; delete them if you like."
  exit 0
fi

apt-get update
apt-get install -y slurm-wlm munge
[ -s /etc/munge/munge.key ] || { /usr/sbin/mungekey --create 2>/dev/null || create-munge-key -f; }
chown munge:munge /etc/munge/munge.key && chmod 400 /etc/munge/munge.key
systemctl enable --now munge

host=$(hostname -s)
# slurmd -C prints this machine's NodeName line (CPUs, sockets, cores, threads, memory). Leave 1 GB of memory free.
node=$(slurmd -C | head -1 | awk '{for (i = 1; i <= NF; i++) if ($i ~ /^RealMemory=/) { split($i, a, "="); $i = "RealMemory=" (a[2] > 2048 ? a[2] - 1024 : a[2]) } print}')
mkdir -p /etc/slurm /var/lib/slurm/slurmd /var/lib/slurm/slurmctld /var/log/slurm
chown -R slurm:slurm /var/lib/slurm /var/log/slurm
[ -e /etc/slurm/slurm.conf ] && cp /etc/slurm/slurm.conf "/etc/slurm/slurm.conf.bak.$(date +%s)"
cat > /etc/slurm/slurm.conf <<EOF
# Single-node test cluster written by setup_slurm.sh
ClusterName=localpc
SlurmctldHost=$host
SlurmUser=slurm
AuthType=auth/munge
ProctrackType=proctrack/linuxproc
TaskPlugin=task/none
ReturnToService=2
SchedulerType=sched/backfill
SelectType=select/cons_tres
SelectTypeParameters=CR_Core
AccountingStorageType=accounting_storage/none
JobAcctGatherType=jobacct_gather/none
KillWait=30
MinJobAge=600
StateSaveLocation=/var/lib/slurm/slurmctld
SlurmdSpoolDir=/var/lib/slurm/slurmd
SlurmctldPidFile=/run/slurmctld.pid
SlurmdPidFile=/run/slurmd.pid
SlurmctldLogFile=/var/log/slurm/slurmctld.log
SlurmdLogFile=/var/log/slurm/slurmd.log
$node State=UNKNOWN
PartitionName=local Nodes=ALL Default=YES MaxTime=INFINITE State=UP
EOF
systemctl enable --now slurmctld slurmd
sleep 3
scontrol update nodename="$host" state=resume 2>/dev/null || true
sinfo
echo "If the node is not 'idle', see /var/log/slurm/slurmd.log and slurmctld.log."
