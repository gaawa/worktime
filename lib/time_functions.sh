#!/bin/bash
function worktime_report {
    STATUS=$(cat $FILE_TS | sed -n 1p)  # get status
    TS=$(cat $FILE_TS | sed -n 2p)  # get timestamp
    WORK=$(cat $FILE_TS | sed -n 3p) # get the work label

    T_DELTA=$(( $(date +%s) - $TS ))
    T_DELTA_MSG=$(eval "echo $(date -ud "@$T_DELTA" +'$((%s/3600)) hours %M minutes %S seconds')")

    printf "$WORK $STATUS since:\n$T_DELTA_MSG\n"
}

function worktime_total_report {
    FILENAME=$(ls ${DIR}/${WORK} | tail -1)
    FILE="${DIR}/${WORK}/${FILENAME}"
    $(dirname "$BASH_SOURCE")/calc-time.awk $FILE | fold -w 80 -s $DESC
}
