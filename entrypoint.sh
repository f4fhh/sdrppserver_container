#!/bin/bash
set -euo pipefail

trap 'jobs -p | xargs -r kill' SIGINT SIGTERM

/usr/bin/sdrplay_apiService &
sleep 1
/usr/bin/sdrpp -s -r /config &
wait -n
exit $?\n