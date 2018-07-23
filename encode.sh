#!/bin/bash



START=$(find JPG -name '*.JPG' -print| sed 's|^JPG/DSC_||g' | sed  's|\.JPG$||g' | sort -n | head -n 1)


END=$(find JPG -name '*.JPG' -print| sed 's|^JPG/DSC_||g' | sed  's|\.JPG$||g' | sort -n | tail -n 1)

echo "start = $START, end = $END"

# 4K resolution
HIGH_RESOLUTION="3840x2160"


# Much less.
MEDIUM_RESOLUTION="1280x720"

#Frames per second
FPS=16


# First we make a medium res version
ffmpeg -r $FPS -start_number $START -i "JPG/DSC_%04d.JPG" -s $MEDIUM_RESOLUTION -vcodec libx264 MPG/out_med_res.mpg

# Then we make a maximum resolution version
ffmpeg -r $FPS -start_number $START -i "JPG/DSC_%04d.JPG"  -s $HIGH_RESOLUTION  -vcodec libx264 MPG/out_high_res.mpg
