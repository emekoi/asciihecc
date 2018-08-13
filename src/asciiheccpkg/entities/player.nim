##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import ../ecs, syrup/font
import ../components/[vec2, sprite]

proc newPlayer*(self: World; pos: Vec2): Entity =
  let image = self.newSprite("@")
  self.addEntity([pos, image])