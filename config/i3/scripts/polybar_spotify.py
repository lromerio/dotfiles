#!/usr/bin/env python

import subprocess

try:
    out = subprocess.run(['spt', 'playback', '-s'], stdout=subprocess.PIPE,
            stderr=subprocess.PIPE, check=True)
except Exception:
    # sbt not running
    print('')
    exit()

# Pad playing song
pad = 75
length = 75
text = out.stdout.decode('utf-8')
state = text[:1]
music = text[1:-1].ljust(pad, ' ')[:length]

# FIXME Terminal character are not same as polybar
pause = '⏸'
play = '▶'

if play in text:
    print('' + music)
elif pause in text:
    print(' ' + music)
else:
    print('Script is broken?')


