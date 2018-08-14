##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import syrup
import ../ecs, ../globals
import ../components/[controller, vec2]

type InputSystem* = ref object of System

method update*(self: InputSystem; dt: float) =
  for e in self.world.entities.keys:
    if self.world.hasComponents(e, Controller, Vec2):
      let
        keyboard = self.world.getComponent(e, Controller)
        position = self.world.getComponent(e, Vec2)
      
      if keyboard.wasPressed("quit"):
        syrup.exit()
      
      if keyboard.isDown("right"):
        position.x += 1.0
        echo "kkk"

