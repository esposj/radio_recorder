#!/bin/bash
if [ $# -eq 0 ]; then
  FREQ=99.5
else
  FREQ=$1
fi 
rtl_fm -f ${FREQ}M -M fm -s 180k -A fast -l 0 -E deemp -p 82 -g 20 | \
	sox -r 180k -t raw -e signed -b 16 -c 1 -V3 -v 2.2 - -r 48k -t mp3 - sinc 0-15k -t 1000 | \
	#sox -r 180k -t raw -e signed -b 16 -c 1 -V1 -v 2.2 - -r 32k -t vorbis - sinc 0-15k -t 1000 | \
	#ezstream -c ezstream_stdin_mp3.xml &
	lame --mp3input - file.mp3
PID=$!


# Input Options
# -r 180k:  sample rate of input source
# -t raw: defines the type of input
# -e signed: encoding type of signed for input 
# -b 16: number of bits in encoded sample
# -c 1: number of audio channels in encoded sample
# -V1: verbose level 1 (only errors shown) 2 and 3 may prove useful!
# -v 2.2 volume as a multiplier
# - (use stdin)

# Output Options
# -r 32k: sample rate for output
# -t vorbis: output format 
# - filename
# sinc 0-15k bandpass filter
