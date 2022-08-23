#!/bin/bash

# notify-send -u "critical" -t 1000 -a "test" -h string:syncronous:volume -h int:value:20 "testaoeu"

SINK=@DEFAULT_AUDIO_SINK@
CURRENT=$(wpctl get-volume $SINK)

VOLMAX=1.5
VOLINC=5%
VOLDEC=-5%
