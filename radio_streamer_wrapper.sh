#!/bin/bash
# wrapper [-f FREQ ] start
# wrapper stop
# wrapper status
# wraper [-f FREQ] tune
# set defaults
SCRIPT="./radio_streamer.sh"
FREQ="104.5"
PIDPATH="/var/run/radio_streamer"
RTLPIDFILE="rtl_fm.pid"
SOXPIDFILE="sox.pid"
EZPIDFILE="ezstream.pid"
FREQFILE="frequency.txt"
DEBUG=0
POSITIONAL=()

# Functions
function execute_stream () {
    FREQ=$1
    (rtl_fm -f ${FREQ}M -M fm -s 180k -A fast -l 0 -E deemp -p 82 -g 20 | \
    	sox -r 180k -t raw -e signed -b 16 -c 1 -V3 -v 2.2 - -r 64k -t mp3 - sinc 0-15k -t 1000 | \
    	#sox -r 180k -t raw -e signed -b 16 -c 1 -V1 -v 2.2 - -r 32k -t vorbis - sinc 0-15k -t 1000 | \
    	ezstream -c ezstream_stdin_mp3.xml )> /dev/null 2>&1 &
    rtl_pid=`ps aux | grep rtl_fm | grep -v grep | awk '{print $2}'`
    sox_pid=`ps aux | grep sox | grep -v grep | awk '{print $2}'`
    ezstream_pid=`ps aux | grep ezstream | grep -v grep | awk '{print $2}'`
   
    echo $rtl_pid > $PIDPATH/$RTLPIDFILE
    echo $sox_pid > $PIDPATH/$SOXPIDFILE
    echo $ezstream_pid > $PIDPATH/$EZPIDFILE
    echo $FREQ > $PIDPATH/$FREQFILE
}

function check_for_pid () {
    if [ "$(ls -A $PIDPATH)" ]; then
        if [ $DEBUG == 1 ]; then
            echo "Streamer Suite seems to be running!"
            echo -n "RTL PID: "
            cat $PIDPATH/$RTLPIDFILE
            echo -n "SOX PID: "
            cat $PIDPATH/$SOXPIDFILE
            echo -n "EZ Stream PID: "
            cat $PIDPATH/$EZPIDFILE
	        echo -n "FREQ: "
	        cat $PIDPATH/$FREQFILE
        fi
        return 1
    else
	    if [ $DEBUG  == 1 ]; then
                echo "Streamer Suite is not running."
	    fi
        return 0
    fi
}
function start_streamer () {
    FREQ=$1
    check_for_pid
    result=$?
    if [ $result ]; then
        execute_stream $FREQ
    fi
}
function stop_streamer () {
    check_for_pid
    result=$?
    if [ $result ]; then
        for FILE in $EZPIDFILE $SOXPIDFILE $RTLPIDFILE; do 
            kill -9 `cat $PIDPATH/$FILE`
            rm $PIDPATH/$FILE
        done
        rm $PIDPATH/$FREQFILE

    fi
}
function display_usage () {
    echo "USAGE: $0 [-f FREQUENCY|--frequency FREQUENCY] start|stop|status|tune|kill"
    exit 1
}
function display_status () {
    # force verbose output on status call
    DEBUG=1
    check_for_pid
    exit 0
}
# kill all rtl and sox processes w/o concern
function kill_stream () {

  kill -9 `ps aux | grep sox | grep -v grep | awk '{print $2}'`
  kill -9 `ps aux | grep rtl_fm | grep -v grep | awk '{print $2}'`   
  kill -9 `ps aux | grep ezstram| grep -v grep | awk '{print $2}'`   
  rm -f $PIDPATH/*
  exit 0
}
#parse arguments
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -f|--frequency)
    FREQ="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--debug)
    DEBUG=1
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}"
COMMAND=$1
if [[ ${#POSITIONAL[@]} == 0  ]]; then
    display_usage
fi

# main worker
case $COMMAND in
    start)
    start_streamer $FREQ
    ;;
    stop)
    stop_streamer
    ;;
    status)
    display_status
    ;;
    tune)
    stop_streamer
    start_streamer $FREQ
    ;;
    kill)
    kill_stream
    ;;
    *)
    display_usage
    ;; 

 esac

