##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import ecs, syrup/graphics
import vec2

type Sprite* = ref object of Component
  position*: Vec2
  texture*: Texture

type Transform* = ref object of Component
  transform*: Transform