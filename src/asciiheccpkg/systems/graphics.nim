##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import syrup/graphics
import ecs, globals

type GraphicsSystem = ref object of System
  framebuffer: Texture

method init*(self: GraphicsSystem) =
  self.framebuffer = newTexture(WIDTH, HEIGHT)

method update*(self: GraphicsSystem; dt: float) =
  self.framebuffer.clear()
  self.framebuffer.drawCircle(color(1.0, 1.0, 1.0), 0, 0)
  graphics.drawTexture(self.framebuffer, 0, 0)