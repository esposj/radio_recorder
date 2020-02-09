Example Usage
pi@usbproxy:~/rtl_fm_icecast $ ./radio_streamer_wrapper.sh start
pi@usbproxy:~/rtl_fm_icecast $ ./radio_streamer_wrapper.sh status
Streamer Suite seems to be running!
RTL PID: 8497
SOX PID: 8498
EZ Stream PID: 8500
FREQ: 104.5
pi@usbproxy:~/rtl_fm_icecast $ ./radio_streamer_wrapper.sh -f 106.5 tune
pi@usbproxy:~/rtl_fm_icecast $ ./radio_streamer_wrapper.sh status
Streamer Suite seems to be running!
RTL PID: 8629
SOX PID: 8631
EZ Stream PID: 8633
FREQ: 106.5
pi@usbproxy:~/rtl_fm_icecast $ ./radio_streamer_wrapper.sh stop
pi@usbproxy:~/rtl_fm_icecast $ ./radio_streamer_wrapper.sh status
Streamer Suite is not running.
pi@usbproxy:~/rtl_fm_icecast $
