#!/usr/bin/python

import Leap
from appscript import app, k
import time

class KeyRouter:
  def __init__(self):
    self.system_events = app('System Events')
    self.arrow_map = {
      'left':   123,
      'right':  124,
      'down':   125,
      'up':     126
    }

  def send_arrow(self, arrow):
    key_code = self.arrow_map[arrow]
    if key_code:
      self.send_key_code(key_code)
    else:
      print 'Arrow type \'%s\' not supported' % arrow

  def send_key_code(self, key_code):
    self.system_events.key_code(key_code)

  def send_text(self, text):
    self.system_events.keystroke(text)
