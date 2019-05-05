#!/bin/bash

function create_timestamp {
    read -p "Name of the work?: " WORK
    printf "started\n$(date +%s)\n$WORK\n" > $FILE_TS
    if [[ ! -e ${DIR}/${WORK} ]]
    then
        mkdir "${DIR}/${WORK}"
    fi
    echo "started $(date +%s)" >> "${DIR}/${WORK}/$(date +%Y%m%d)"
}

function worktime_main {
    if [[ -e $FILE_TS ]]
    then
        worktime_report
    else
        create_timestamp
    fi
}

function worktime_pause {
    # cannot be in paused status to pause something
    if [[ -e $FILE_TS ]] && [[ $(cat $FILE_TS | sed -n 1p) != paused ]]
    then
        worktime_report

        FILENAME=$(ls ${DIR}/${WORK} | tail -1)
        FILE="${DIR}/${WORK}/${FILENAME}"
        STATUS="paused"

        echo $STATUS
        echo "$STATUS $(date +%s)" >> $FILE

        printf "$STATUS\n$(date +%s)\n$WORK\n" > $FILE_TS
    else
        echo "nothing to pause"
    fi

}

function worktime_resume {
    # must be in paused status in order to resume something
    if [[ -e $FILE_TS ]] && [[ $(cat $FILE_TS | sed -n 1p) == paused ]]
    then
        worktime_report

        FILENAME=$(ls ${DIR}/${WORK} | tail -1)
        FILE="${DIR}/${WORK}/${FILENAME}"
        STATUS="resumed"

        echo $STATUS
        echo "$STATUS $(date +%s)" >> $FILE

        printf "$STATUS\n$(date +%s)\n$WORK" > $FILE_TS  
    else
        echo "nothing to resume"
    fi

}

function worktime_stop {
    if [[ -e $FILE_TS ]]
    then
        worktime_report

        FILENAME=$(ls ${DIR}/${WORK} | tail -1)
        FILE="${DIR}/${WORK}/${FILENAME}"
        STATUS="stopped"

        echo $STATUS
        echo "$STATUS $(date +%s)" >> $FILE

        read -p "Desc: " DESC
        MSG="\n"
        MSG+="Desc: $DESC \n\n\n"
        printf "$MSG" >> $FILE  # append to the file
        rm $FILE_TS
    else
        echo "nothing to stop"
    fi
}

