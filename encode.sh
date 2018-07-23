#!/bin/bash

# Determine the home directory, if none given assume that it's the current
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

echo "Assuming working directory to be $(PWD)"

if [ ! -d "JPG" ] ; then
    echo "Could not find any JPG (input) directory in the working directory, bailing out"
    exit 1
fi

if [ ! -d "MPG" ] ; then
    echo "Could not find MPG (output) directory in the working directory, making one"
    mkdir MPG
fi


INPUTFORMAT="JPG/DSC_%04d.JPG"

# Determine the start of the sequence to be generated
START=$(find JPG -name '*.JPG' -print| sed 's|^JPG/DSC_||g' | sed  's|\.JPG$||g' | sort -n | head -n 1)

if  [ -z "$START" ] ; then
    echo "Could not find a start frame, assuming all frames are named according to the format $INPUTFORMAT"
fi

echo "starting using input frame  = $START"

# 4K resolution
HIGH_RESOLUTION="3840x2160"

# Much less.
MEDIUM_RESOLUTION="1280x720"

#Frames per second
FPS=16


# First we make a medium res version
ffmpeg -r $FPS -start_number $START -i $INPUTFORMAT -s $MEDIUM_RESOLUTION -vcodec libx264 MPG/out_med_res.mpg

# Then we make a maximum resolution version
ffmpeg -r $FPS -start_number $START -i $INPUTFORMAT  -s $HIGH_RESOLUTION  -vcodec libx264 MPG/out_high_res.mpg
