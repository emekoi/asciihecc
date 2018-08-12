##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import sugar

type Key* = tuple
  idx: uint32
  version: uint32

proc `==`*(lhs, rhs: Key): bool =
  lhs.idx == rhs.idx and lhs.version == rhs.version

type Slot[T] = tuple
  version: uint32
  nextFree: uint32
  value: T

proc occupied(self: Slot): bool {.inline.} =
  self.version mod 2 > 0'u32

type SlotMap*[T] = object
  slots: seq[Slot[T]]
  freeHead: uint
  len*: uint32

proc newSlotMap*[T](size: Natural = 0): SlotMap[T] =
  SlotMap[T](
    slots: newSeqOfCap[Slot[T]](size),
    freeHead: 0,
    len: 0
  )

proc capacity*(self: SlotMap): int =
  self.slots.len

proc reserve*(self: var SlotMap; additional: Natural) =
  let needed = (self.len + additional) - self.capacity
  self.slots.setLen(needed)

proc hasKey*(self: SlotMap; key: Key): bool =
  try:
    let slot = self.slots[int(key.idx)]
    return slot.version == key.version
  except:
    return false

proc insert*[T](self: var SlotMap[T]; value: T): Key =
  self.insertWithKey((key) => value)

proc insertWithKey*[T](self: var SlotMap[T]; f: (Key) -> T): Key =
  let newLen = self.len + 1
  if newLen == high(uint32):
    raise newException(OverflowError, "SlotMap overflow")

  let idx = self.freeHead

  try:
    let
      slot = addr self.slots[int(idx)]
      occupiedVersion = slot.version or 1
    result = (uint32(idx), occupiedVersion)
    slot.value = f(result)
    slot.version = occupiedVersion
    self.freeHead = uint(slot.nextFree)
    self.len = newLen
  except:
    result = (uint32(idx), 1'u32)
    self.slots.add (1'u32, 0'u32, f(result))

    self.freeHead = uint(self.slots.len)
    self.len = newLen

proc removeFromSlot[T](self: var SlotMap[T]; idx: Natural): T =
  let slot = addr self.slots[idx]
  slot.nextFree = uint32(self.freeHead)
  self.freeHead = idx
  dec self.len
  slot.version = slot.version + 1
  slot.value

proc remove*[T](self: var SlotMap[T]; key: Key): T =
  if self.hasKey(key):
    self.removeFromSlot(key.idx)
  else:
    raise newException(KeyError, "invalid SlotMap key")

proc retain*[T](self: var SlotMap[T]; f: (var T) -> bool) =
  let len = self.slots.len
  for idx in 0 ..< len:
    let shouldRemove = block:
      let
        slot = self.slot[idx]
        key = (uint32(idx), slot.version)
      slot.occupied and not f(key, slot.value)
    if shouldRemove:
      self.removeFromSlot(idx)

proc clear*(self: var SlotMap) =
  for slot in self.slots.mitems:
    reset slot
  self.freeHead = 0
  self.len = 0

proc `[]`*[T](self: SlotMap[T], key: Key): T =
  if not self.hasKey(key):
    raise newException(KeyError, "invalid SlotMap key")
  self.slots[int(key.idx)].value

proc `[]`*[T](self: var SlotMap[T], key: Key): var T =
  if not self.hasKey(key):
    raise newException(KeyError, "invalid SlotMap key")
  self.slots[int(key.idx)].value

iterator pairs*[T](self: SlotMap[T]): (Key, T) =
  for idx, slot in self.slots:
    if slot.occupied:
      yield (
        (idx, slot.version),
        slot.value
      )

iterator mpairs*[T](self: var SlotMap[T]): (Key, var T) =
  for idx, slot in self.slots.mpairs:
    if slot.occupied:
      yield (
        (idx, slot.version),
        slot.value
      )

iterator keys*[T](self: SlotMap[T]): Key =
  for idx, slot in self.slots:
    if slot.occupied:
      yield (idx, slot.version)

iterator values*[T](self: SlotMap[T]): T =
  for slot in self.slots:
    if slot.occupied:
      yield slot.value

iterator mvalues*[T](self: var SlotMap[T]): var T =
  for slot in self.slots.mitems:
    if slot.occupied:
      yield slot.value