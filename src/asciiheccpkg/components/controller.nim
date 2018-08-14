##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import ../ecs, syrup/keyboard, tables

type Controller* = ref object of Component
  keymap*: TableRef[string, seq[string]]

proc newController*(): Controller =
  new result
  result.keymap = newTable[string, seq[string]]()

proc register*(self: Controller; id: string, keys: openarray[string]) =
  self.keymap[id] = @keys

proc register*(self: Controller; keys: openarray[tuple[id: string, keys: seq[string]]]) =
  for k in keys:
    self.register(k.id, k.keys)

proc isDown*(self: Controller; id: string): bool =
  if not self.keymap.hasKey(id):
    raise newException(Exception, "bad Controller id")
  result = false
  for k in self.keymap[id]:
    if keyboard.keyDown(k):
      return true

proc wasPressed*(self: Controller; id: string): bool =
  if not self.keymap.hasKey(id):
    raise newException(Exception, "bad Controller id")
  result = false
  for k in self.keymap[id]:
    if keyboard.keyPressed(k):
      return true
      
proc wasReleased*(self: Controller; id: string): bool =
  if not self.keymap.hasKey(id):
    raise newException(Exception, "bad Controller id")
  result = false
  for k in self.keymap[id]:
    if keyboard.keyReleased(k):
      return true
