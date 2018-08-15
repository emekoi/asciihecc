##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import syrup/graphics
import ../ecs, ../globals
import ../components/[vec2, sprite]

export graphics

type GraphicsSystem* = ref object of System
  framebuffer: Texture

method init*(self: GraphicsSystem) =
  self.framebuffer = newTexture(WIDTH, HEIGHT)

method update*(self: GraphicsSystem; dt: float) =
  self.framebuffer.clear()
  for e in self.world.entities.keys:
    # echo e
    if self.world.hasComponents(e, Vec2, Sprite):
      let
        position = self.world.getComponent(e, Vec2)
        image = self.world.getComponent(e, Sprite)
      self.framebuffer.drawTexture(image.texture, int(position.x), int(position.y), image.transform)
  graphics.drawTexture(self.framebuffer, WIDTH div 2, HEIGHT div 2)
