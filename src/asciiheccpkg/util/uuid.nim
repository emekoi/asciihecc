##  Copyright (c) 2015 Willy Heineman
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import math, random, times
import sequtils, strutils

type UUID* = distinct string 

proc `==`*(lhs, rhs: UUID): bool {.borrow.}

const pattern = "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx"

proc getTime(): int  =
  toInt(epochTime() * 100000)

proc genUUID*(): UUID =
  var d = getTime()
  proc fn(c : char): string =
    var r = toInt(toFloat(d) + rand(1.0) * 16) %% 16
    d = toInt(floor(toFloat(d) / 16))
    toHex(if c == 'x': r else: r and 0x3 or 0x8, 1)
  UUID(toLower(join(pattern.mapIt(string, if it == 'x' or it == 'y': fn(it) else: $it))))

randomize()
