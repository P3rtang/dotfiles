#!/usr/bin/python
import sys
import subprocess
from time import sleep

def toggle():
    swayidle_processes = subprocess.run(["ps", "-ef"], capture_output=True).stdout.decode("utf-8").count("swayidle")

    if swayidle_processes > 0:
        subprocess.run(["killall", "swayidle"])
        print("")
    else:
        idle_cmd = ["swayidle", "-w", "timeout", "30", "'swaylock -f -c 000000'", "timeout", "30", "'swaymsg \"output * dpms off\"'", "resume", "'swaymsg \"output * dpms on\"'", "timeout", "60", "'systemctl suspend'", "before-sleep", "'swaymsg exit'"]
        idle = ["sh", "/home/p3rtang/.config/waybar/swayidle.sh"]
        print("")
        subprocess.Popen(idle)
 
def check():
    sleep(0.1)
    swayidle_processes = subprocess.run(["ps", "-ef"], capture_output=True).stdout.decode("utf-8").count("swayidle")

    if swayidle_processes > 0:
        print("")
    else:
        print("")

if __name__ == "__main__":
    assert len(sys.argv) <= 2
    if sys.argv[1] == "-c":
        check()
    elif sys.argv[1] == "-t":
        toggle()
    else:
        print(f"unexpected argument {sys.argv[1]}")
