#!/bin/bash

DEFAULT_PORT=0
port="$1"
if [[ -z "port" ]] ; then
    port=${DEFAULT_PORT}
fi

set -x
arduino --upload tm.ino --port /dev/ttyACM${port} && screen /dev/ttyACM${port} 9600
#set -x
