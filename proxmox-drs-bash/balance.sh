#!/bin/bash
#
# Name: balance.sh
#  Bash based Distributed Resource Scheduler (DRS) for Proxmox
#
# Function:
#  Load balancing VMs due to imbalanced cluster
#  DRS uses the cluster-level balance metric to make load-balancing decisions
#  Nodes with (Lowest LoadAVG + Lowest Memory Usage) receive more VMs
#
# Author(s):
#   Leroy van Logchem
#

export MAILTO="" # Silence, no mail
SHELL=/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"
PATH=/usr/sbin:/usr/bin:/bin

#
# Exit early if migration lock is still present
#
[ -f "$SCRIPTPATH/lock" ] && exit

#
# Locate the scores of all nodes
#
cd "$SCRIPTPATH" || exit
cd ../scores || exit

#
# Pick the node with the lowest cpu and memory load
#
SELECT_TARGET=$(ls -v1 | grep -E '^[0-9]+$' | sort -n | head -1)
TARGET=$(cat "$SELECT_TARGET")

#
# Do nothing if current host has been selected
#
if [ "$TARGET" = "$(hostname -s)" ]; then
        exit
fi

#
# Balance network load by adding randomness
# 
sleep $(( RANDOM % 30 )) +1s

VMNR=$(qm list | grep -c running)

#
# Exit if only one VM is active (avoid no load)
#
if [ "$VMNR" -lt 2 ]; then
        exit
fi

#
# Migrate one VM
#
MOVEVM=$(qm list | grep running | head -1 | awk '{print $1}')
/bin/rm "$SELECT_TARGET"
flock "$SCRIPTPATH"/lock qm migrate "$MOVEVM" "$TARGET" --online
