#!/bin/bash

pkill -x polybar

while pgrep -x polybar >/dev/null; do sleep 1; done

polybar -r example &

echo "Polybar Launched..."
