##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import ../ecs, syrup/[graphics, font]
import vec2

let ALPHABET = font.newFontDefault(32)

type Sprite* = ref object of Component
  texture*: Texture

proc newSprite*(self: World; txt: string): Sprite =
  Sprite(
    texture: ALPHABET.render(txt)
  )

type Transform* = ref object of Component
  transform*: Transform