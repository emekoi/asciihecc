##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import tables

const
  TITLE* = "asciihecc"
  WIDTH* = 512
  HEIGHT* = 512

let
  CONTROLLER_KEYMAP* = {
    "quit": @["escape"],
    "left": @["w", "left"],
    "right": @["d", "right"],
    "up": @["w", "up"],
    "down": @["s", "down"]
  }.newTable()
