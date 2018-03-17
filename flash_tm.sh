#!/bin/bash

set -x
arduino --upload tm.ino --port /dev/ttyACM0 && screen /dev/ttyACM0 9600
#set -x
