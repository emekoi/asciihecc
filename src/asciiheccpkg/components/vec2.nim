##  Copyright (c) 2018 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import math
import ecs

type Vec2* = ref object of Component
  x*, y*: float

proc `+`*(self, rhs: Vec2): Vec2 =
  result.x = self.x + rhs.x
  result.y = self.y + rhs.y

proc `+=`*(self: var Vec2, rhs: Vec2)=
  self.x = self.x + rhs.x
  self.y = self.y + rhs.y

proc `+`*(self: Vec2, rhs: float): Vec2 =
  result.x = self.x + rhs
  result.y = self.y + rhs

proc `+=`*(self: var Vec2, rhs: float)=
  self.x = self.x + rhs
  self.y = self.y + rhs

proc `-`*(self, rhs: Vec2): Vec2 =
  result.x = self.x - rhs.x
  result.y = self.y - rhs.y

proc `-=`*(self: var Vec2, rhs: Vec2)=
  self.x = self.x - rhs.x
  self.y = self.y - rhs.y

proc `-`*(self: Vec2, rhs: float): Vec2 =
  result.x = self.x - rhs
  result.y = self.y - rhs

proc `-=`*(self: var Vec2, rhs: float)=
  self.x = self.x - rhs
  self.y = self.y - rhs

proc `*`*(self, rhs: Vec2): Vec2 =
  result.x = self.x * rhs.x
  result.y = self.y * rhs.y

proc `*=`*(self: var Vec2, rhs: Vec2)=
  self.x = self.x * rhs.x
  self.y = self.y * rhs.y

proc `*`*(self: Vec2, rhs: float): Vec2 =
  result.x = self.x * rhs
  result.y = self.y * rhs

proc `*=`*(self: var Vec2, rhs: float)=
  self.x = self.x * rhs
  self.y = self.y * rhs

proc `/`*(self, rhs: Vec2): Vec2 =
  result.x = self.x / rhs.x
  result.y = self.y / rhs.y

proc `/=`*(self: var Vec2, rhs: Vec2)=
  self.x = self.x / rhs.x
  self.y = self.y / rhs.y

proc `/`*(self: Vec2, rhs: float): Vec2 =
  result.x = self.x / rhs
  result.y = self.y / rhs

proc `/=`*(self: var Vec2, rhs: float)=
  self.x = self.x / rhs
  self.y = self.y / rhs

proc `==`*(self, rhs: Vec2, tol=1.0e-6): bool=
  abs(self.x - rhs.x) <= tol and
    abs(self.y - rhs.y) <= tol

proc `=~`*(self, rhs: Vec2): bool=
  self == rhs

proc `^`*(self, rhs: Vec2): float =
  self.x * rhs.x + self.y * rhs.y

proc `%`*(self: Vec2): Vec2 =
  result.x = -self.y
  result.y = self.x

proc `%=`*(self: var Vec2) =
  self.x = -self.y
  self.y = self.x

proc sqrt*(self: Vec2): Vec2 =
  result.x = self.x.sqrt()
  result.y = self.y.sqrt()

proc rot*(self: Vec2, r: float): Vec2 =
  let (cosr, sinr) = (r.cos(), r.sin())
  result.x = ((self.x * cosr) - (self.y * sinr))
  result.y = ((self.y * cosr) + (self.x * sinr))

proc rot*(self, org: Vec2, r: float): Vec2 =
  let (cosr, sinr) = (r.cos(), r.sin())
  result.x = (((self.x - org.x) * cosr) - ((self.y - org.x) * sinr))
  result.y = (((self.y - org.y) * cosr) + ((self.x - org.y) * sinr))
  result + org

proc rot*(self: Vec2, cosr, sinr: float): Vec2 =
  result.x = ((self.x * cosr) - (self.y * sinr))
  result.y = ((self.y * cosr) + (self.x * sinr))

proc rot*(self, org: Vec2, cosr, sinr: float): Vec2 =
  result.x = (((self.x - org.x) * cosr) - ((self.y - org.x) * sinr))
  result.y = (((self.y - org.y) * cosr) + ((self.x - org.y) * sinr))
  result + org

proc mag*(self: Vec2, squared: bool=false): float =
  result = (self.x ^ 2) + (self.y ^ 2)
  if not squared: return result.sqrt()

proc norm*(self: Vec2, squared: bool=false): Vec2 =
  if squared:
    let m = self.mag(true)
    if m > 0: return (self * self) / m
    else: return self
  else:
    let m = self.mag(false)
    if m > 0: return self / m
    else: return self