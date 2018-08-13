##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import math
import ecs
import vec2

type Rect* = ref object of Component
  position*: Vec2
  width*, height*: float

# proc x*(self: Rect): float =
#   self.position.x

# proc `x=`*(self: var Rect, rhs: float): float =
#   self.position.x = rhs

# proc y*(self: Rect): float =
#   self.position.y

# proc `y=`*(self: var Rect, rhs: float): float =
#   self.position.y = rhs

proc left*(self: var Rect; value: float): float =
  self.position.x = value
  self.position.x

proc left*(self: Rect; value: float): float =
  self.position.x

proc right*(self: var Rect; value: float): float =
  # move the rect's left side so the right side is at value
  self.position.x = value - self.width
  self.position.x + self.width

proc right*(self: Rect; value: float): float =
  self.position.x + self.width

proc top*(self: var Rect; value: float): float =
  self.position.y = value
  self.position.y

proc top*(self: Rect; value: float): float =
  self.position.y

proc bottom*(self: var Rect; value: float): float =
  # move the rect's top side so the bottom side is at value
  self.position.y = value - self.height
  self.position.y + self.height

proc bottom*(self: Rect; value: float): float =
  self.position.y + self.height

proc middleX*(self: var Rect, value: float): float =
  # move the rect along the x axis so it's center is the point (value, self.y)
  self.position.x = value - self.width / 2
  self.position.x + self.width / 2

proc middleX*(self: Rect): float =
  self.position.x + self.width / 2

proc middleY*(self: var Rect, value: float): float =
  # move the box along the y axis so it's center is the point (self.x, value)
  self.position.y = value - self.height / 2
  self.position.y + self.height / 2

proc middleY*(self: Rect): float =
  self.position.y + self.height / 2
