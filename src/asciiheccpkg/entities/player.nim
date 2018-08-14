##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import ../ecs, ../globals, syrup/font
import ../components/[vec2, sprite, controller]

proc newPlayer*(self: World; pos: Vec2): Entity =
  let
    image = sprite.newSprite("@")
    controls = Controller(keymap: CONTROLLER_KEYMAP)
  self.addEntity([pos, image, controls])