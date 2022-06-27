#!/bin/bash
/usr/bin/sdrplay_apiService &
sleep 1
/usr/bin/sdrpp -s -r /config &
wait -n
exit $?