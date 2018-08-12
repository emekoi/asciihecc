##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import sets, hashes, sequtils
import util/[slotmap, uuid]

type
  Entity* = Key

  Component* = object of RootObj

  System* = ref object of RootObj
    world*: World

  World* = ref object
    entities*: SlotMap[seq[Component]]
    systems*: HashSet[System]

proc getComponent*(self: World; entity: Entity, filter: typedesc[Component]): Component =
  for component in self.entities[entity]:
    if component is filter:
      return component

proc getComponents*(self: World; entity: Entity, filter: openarray[typedesc[Component]]): seq[Component] =
  result = newSeqOfCap(filter.len)
  for component in filter:
    result.add self.getComponent(entity, component)

proc hash(x: System): Hash =
  result = result !& hash(unsafeAddr x)
  result = !$result

method update*(self: System; dt: float) {.base.} =
  raise newException(Exception, "overide update")

proc newWorld*(): World =
  new result
  result.entities = newSlotMap[seq[Component]]()
  result.systems = initSet[System]()

proc newEntity*(self: var World): Entity =
  self.entities.insert(@[])

proc addComponent*(self: var World; entity: Entity; component: Component) =
  var components = self.entities[entity]
  components.add(component)

proc addSystem*(self: var World; system: typedesc[System]) =
  let instance = new system
  instance.world = self
  self.systems.incl(instance)

proc update*(self: var World; dt: float) =
  for system in self.systems:
    system.update(dt)