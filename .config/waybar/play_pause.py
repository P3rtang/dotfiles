#!/usr/bin/env python3
import subprocess

cmd = ["playerctl", "--all-players", "status"]
state = subprocess.run(cmd, capture_output=True).stdout.decode('utf-8').replace('\n', '')
if state == "Playing":
    print('')
elif state == "Paused":
    print('')
else:
    print('')

