#!/bin/bash

function fzf-select-dir {
    dir=$1
    for elements in $dir/*
    do
        choices+="$(basename $elements)\n"
    done

    # printf "$choices"
    printf $choices | fzf
}
