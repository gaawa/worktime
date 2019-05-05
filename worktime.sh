#!/bin/bash
set -e

DIR="$HOME/.worktime"
FILE_TS="$DIR/timestamp"

if [[ ! -e $DIR ]]
then
    mkdir $DIR
fi

source "./lib/running.sh"
source "./lib/time_functions.sh"

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
else
    printf "incorrect input parameter"
fi

