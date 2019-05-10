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
    FILE=$1
    $(dirname "$BASH_SOURCE")/calc-time.awk $FILE | fold -w 80 -s > /tmp/worktime-report
    readarray -t T_STAMPS <<< $(awk '/started at:|ended at:/{print $0}' /tmp/worktime-report)
    ARR_LEN=${#T_STAMPS[@]}
    echo $ARR_LEN
    for (( i=0; i<${ARR_LEN}; i++ ))
    do
        T_STAMP=(${T_STAMPS[i]})
        T_DATE[2]="${T_STAMP[@]:0:2} $(date -d "@${T_STAMP[2]}" +"%Y-%m-%d %H:%M:%S")"
        eval 'sed -i '"'"'s/'${T_STAMP[@]}'/'${T_DATE[@]}'/'"'"' /tmp/worktime-report' # ebin
    done
    cat /tmp/worktime-report
}
