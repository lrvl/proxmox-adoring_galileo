!/bin/bash

MAILTO="" # Silence, no mail
SHELL=/bin/bash
SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
PATH=/usr/bin:/bin

cd $SCRIPTPATH
cd ../scores

find . -maxdepth 1 -mmin +1 -type f -delete

sleep $[ ( $RANDOM % 10 )  + 1 ]s

LOADAVG1M=$(cat /proc/loadavg | awk '{print $1}')
MEM_P=$(/usr/bin/free | grep Mem | awk '{$1=sprintf("%.0f",$3/$2 * 100.0)} {print $1}')
SCORE_FLOAT=$(echo "${LOADAVG1M} + ${MEM_P}" | scale=0 bc -l)
SCORE_INT=$(printf "%.0f" $SCORE_FLOAT)

hostname -s > $SCORE_INT
