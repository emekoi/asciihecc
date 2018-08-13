##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import sets, hashes, sequtils
import util/[slotmap, uuid]

type
  Entity* = Key

  Component* = ref object of RootObj

  System* = ref object of RootObj
    world*: World

  World* = ref object
    entities*: SlotMap[seq[Component]]
    systems*: HashSet[System]

proc getComponent*(self: World; entity: Entity, filter: typedesc[Component]): Component =
  for component in self.entities[entity]:
    if component of filter:
      return component

proc getComponents*(self: World; entity: Entity, filter: openarray[typedesc[Component]]): seq[Component] =
  result = newSeqOfCap(filter.len)
  for component in filter:
    result.add self.getComponent(entity, component)

proc hash(x: System): Hash =
  result = result !& hash(unsafeAddr x)
  result = !$result

method init*(self: System) {.base.} =
  raise newException(Exception, "overide init")

method update*(self: System; dt: float) {.base.} =
  raise newException(Exception, "overide update")

proc newWorld*(): World =
  new result
  result.entities = newSlotMap[seq[Component]]()
  result.systems = initSet[System]()

proc newEntity*(self: World): Entity =
  self.entities.insert(@[])

proc addComponent*(self: World; entity: Entity; component: Component) =
  var components = self.entities[entity]
  components.add(component)

proc addSystem*(self: World; system: typedesc[System]) =
  let instance = new system
  instance.world = self
  instance.init()
  self.systems.incl(instance)

proc update*(self: World; dt: float) =
  for system in self.systems:
    system.update(dt)