#!/bin/bash

# n = 1 --> bottom left
# n = 2 --> bottom center
# n = 3 --> bottom right
# n = 4 --> Up left
# n = 6 --> Up center
# n = 7 --> Up right
# n = 9 --> center left
# n = 10 --> center center
# n = 11 --> center right

# $1 -- INFILE
# $2 -- OUTFILE
# $3 -- CAPTIONS
# $4 -- ALIGNMENT

ffmpeg -i "$1" -lavfi "subtitles=$3:force_style='Alignment=$4,Fontsize=20,OutlineColour=&H100000000,BorderStyle=3,Outline=1,Shadow=0'" "$2"
