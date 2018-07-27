#!/bin/bash

# Copyright 2018  Bjørn Remseth.   This program is
# free software licensed under the GNU GENERAL PUBLIC LICENSE
# Version 3, 29 June 2007


# First determine if ffmpeg is installed.
# not much use in continuing if it  isn't.  Give some
# hints about how to install if not present.
if [ -z $(which ffmpeg) ] ; then
    echo "No ffmpeg in your path."
    echo "Please take a look at https://www.ffmpeg.org/index.html#news, "
    echo "Find a version of ffmpeg that can be run on your computer"
    echo "install it and then put it in your path before trying to run"
    echo "this script again."
    exit 1
fi


# Determine the target directory, if none given assume that it's the current
# working directory.   If not, then cd to it and make it the current working
# directory


if [ $# -ne 0 ]; then
    TARGET_DIR="$1"
    if [ -d "$1" ] ; then
       cd $1
    else
	echo "$1 is not a directory, can't cd to it"
	exit 1
    fi
fi

echo "Assuming target directory to be $(PWD)"

if [ ! -d "JPG" ] ; then
    echo "Could not find any JPG (input) directory in the target directory, bailing out"
    exit 1
fi

if [ ! -d "MPG" ] ; then
    echo "Could not find MPG (output) directory in the target directory, making one"
    mkdir MPG
fi


INPUTFORMAT="JPG/DSC_%04d.JPG"

# Determine the start of the sequence to be generated
START=$(find JPG -name '*.JPG' -print| sed 's|^JPG/DSC_||g' | sed  's|\.JPG$||g' | sort -n | head -n 1)

if  [ -z "$START" ] ; then
    echo "Could not find a start frame, assuming all frames are named according to the format $INPUTFORMAT"
fi

# Output pathnames
HIGH_RES_OUTPUT=MPG/out_high_res.mpg
MED_RES_OUTPUT=MPG/out_med_res.mpg

# Deleting old outputs, if they exist

if [ -f "$HIGH_RES_OUTPUT" ] ; then
    echo "Deleting old high res output file $HIGH_RES_OUTPUT"
    rm "$HIGH_RES_OUTPUT"
fi

if [ -f "$MED_RES_OUTPUT" ] ; then
    echo "Deleting old high res output file $MED_RES_OUTPUT"
    rm "$MED_RES_OUTPUT"
fi


echo "starting using input frame  = $START"

# 4K resolution
HIGH_RESOLUTION="3840x2160"

# Much less.
MEDIUM_RESOLUTION="1280x720"

#Frames per second
FPS=16


# First we make a medium res version
ffmpeg -r $FPS -start_number $START -i $INPUTFORMAT -s $MEDIUM_RESOLUTION -vcodec libx264 $MED_RES_OUTPUT

# Then we make a maximum resolution version
ffmpeg -r $FPS -start_number $START -i $INPUTFORMAT  -s $HIGH_RESOLUTION  -vcodec libx264 $HIGH_RES_OUTPUT
