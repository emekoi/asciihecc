##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import syrup, syrup/debug
import asciiheccpkg/[globals, ecs]
import asciiheccpkg/components/[vec2]
import asciiheccpkg/systems/[graphics, input, physics]
import asciiheccpkg/entities/[player]

syrup.setTitle(TITLE)
syrup.setWidth(WIDTH)
syrup.setHeight(HEIGHT)

let WORLD = newWorld()
WORLD.addSystem(PhysicsSystem)
WORLD.addSystem(GraphicsSystem)
WORLD.addSystem(InputSystem)

discard WORLD.newPlayer(Vec2(x: 256, y: 256))

when not defined(release):
  debug.setVisible(true)

proc update(dt: float) =
  WORLD.update(dt)

proc draw() =
  discard

proc main() =
  syrup.run(update, draw)

main()
