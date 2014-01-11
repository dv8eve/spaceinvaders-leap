#!/usr/bin/python

from pykeyboard import PyKeyboard
import sys

k = PyKeyboard()

keys = {
  'left': 'a',
  'right': 'd',
  'accelerate': 'w',
  'brake': 's',
  'fire': ' ',
  'nitro': 'n'
}

while True:
  line = sys.stdin.readline()
  line = line.strip()
  pair = line.split("-")
  if len(pair) != 2:
    print("unknown event: " + line)
  else:
    print("EVENT: " + line)
    if pair[0] in keys:
      key = keys[pair[0]]
      if pair[1] == "up":
        k.release_key(key)
      elif pair[1] == "down":
        k.press_key(key)
      elif pair[1] == "press":
        k.tap_key(key)
      else:
        print("unknown event: " + line)
    else:
      print("unknown event: " + line)
