##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import math
import ../ecs
import ../components/[rigidbody, vec2]
#[
    let d = (p.pos - p.prev) * FRICTION
  p.prev = p.pos
  p.pos += d
]#

type PhysicsSystem* = ref object of System

method update*(self: PhysicsSystem; dt: float) =
  for e in self.world.entities.keys:
    if self.world.hasComponents(e, RigidBody):
      let
        body = self.world.getComponent(e, RigidBody)
        d = (body.current - body.previous) * 1.999
      body.previous = body.current.clone()
      body.current += d
      echo repr d
      
