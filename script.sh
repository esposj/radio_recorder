#!/bin/bash
FREQ=104.5
rtl_fm -f ${FREQ}M -M fm -s 180k -A fast -l 0 -E deemp -p 82 -g 20 | \
	sox -r 180k -t raw -e signed -b 16 -c 1 -V1 -v 2.2 - -r 32k -t vorbis - sinc 0-15k -t 1000 | \
	ezstream -c ezstream_stdin_vorbis.xml
