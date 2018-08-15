##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import math
import syrup, syrup/[mouse]
import ../ecs, ../globals
import ../components/[controller, vec2, rigidbody, sprite]

type InputSystem* = ref object of System

method update*(self: InputSystem; dt: float) =
  for e in self.world.entities.keys:
    if self.world.hasComponents(e, Controller, Vec2, Sprite):
      let
        keyboard = self.world.getComponent(e, Controller)
        body = self.world.getComponent(e, RigidBody)
        sprite = self.world.getComponent(e, Sprite)
        (x, y) = mouse.mousePosition()
      
      if keyboard.wasPressed("quit"):
        syrup.exit()
      
      body.rotation = arctan2(float(y) - body.current.y, float(x) - body.current.x)
      sprite.transform.r = body.rotation

      # if keyboard.isDown("right"):
      #   body.current.x += 1.0
      #   echo "kkk"

