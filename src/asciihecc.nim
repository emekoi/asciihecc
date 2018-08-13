##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##


import syrup, syrup/debug
import asciiheccpkg/ecs

let WORLD = newWorld()

when not defined(release):
  debug.setVisible(true)

proc update(dt: float) =
  WORLD.update(dt)

proc draw() =
  discard

syrup.run(update, draw)