#!/bin/bash
# TODO: force update local time
#       convert timestamp to time in report
set -e

DIR="$HOME/.worktime"
FILE_TS="$DIR/timestamp"

if [[ ! -e $DIR ]]
then
    mkdir $DIR
fi

source "./lib/running.sh"
source "./lib/time_functions.sh"
source "./lib/fzf-select-dir.sh"

if [[ $# -eq 0 ]]
then
    worktime_main
elif [[ $1 == pause ]]
then
    worktime_pause
elif [[ $1 == resume ]]
then
    worktime_resume
elif [[ $1 == stop ]]
then
    worktime_stop
elif [[ $1 == report ]]
then
    if [[ ! -z $2 ]]
    then
        WORK=$2
        FILENAME=$(ls ${DIR}/${WORK} | tail -1)
        FILE=$DIR/$WORK/$FILENAME

        worktime_total_report $FILE
    else
        WORK=$(fzf-select-dir $DIR)
        FILENAME=$(fzf-select-dir $DIR/$WORK)
        FILE=$DIR/$WORK/$FILENAME
        worktime_total_report $FILE
    fi

else
    printf "incorrect input parameter"
fi

