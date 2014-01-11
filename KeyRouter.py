#!/usr/bin/python

import Leap
from appscript import app, k
import time

class KeyRouter:
  def __init__(self):
    self.system_events = app('System Events')
    self.key_map = {
      'left':   123,
      'right':  124,
      'down':   125,
      'up':     126,
      'space':  ' '
    }

  def send_key(self, arrow):
    key = self.key_map[arrow]
    if key:
      if isinstance(key, (int)):
        self.send_key_code(key)
      else:
        self.send_text(key)
    else:
      print 'Arrow type \'%s\' not supported' % arrow

  def send_key_code(self, key_code):
    self.system_events.key_code(key_code)

  def send_text(self, text):
    self.system_events.keystroke(text)
