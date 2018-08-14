##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

import sets, hashes, sequtils, macros
import util/[slotmap, uuid]

export slotmap

when not defined(release):
  import util/logger
  export logger

  logger.addLogger(stdout)

type
  Entity* = Key

  Component* = ref object of RootObj

  System* = ref object of RootObj
    world*: World
    cache*: HashSet[Entity]

  World* = ref object
    components*: SlotMap[Component]
    entities*: SlotMap[seq[Key]]
    systems*: HashSet[System]

proc addEntity*(self: World): Entity {.inline.} =
  self.entities.reserve()

proc addEntity*(self: World; components: openarray[Component]): Entity =
  result = self.addEntity()
  self.entities[result] = newSeqOfCap[Key](components.len)
  for component in components:
    let key = self.components.insert(component)
    self.entities[result].add(key)

proc deleteEntity*(self: World; entity: Entity) =
  for component in self.entities[entity]:
    self.components.delete(component)
  self.entities.delete(entity)

proc addComponent*(self: World; entity: Entity; component: Component) =
  let key = self.components.insert(component)
  self.entities[entity].add(key)

proc deleteComponent*(self: World; entity: Entity; component: Key) =
  self.components.delete(component)
  var components = self.entities[entity]
  for idx in 0 ..< components.len:
    if components[idx] == component:
      components.del(idx)

proc getComponent*(self: World; entity: Entity, filter: typedesc[Component]): auto =
  for key in self.entities[entity]:
    let component = self.components[key]
    if component of filter:
      return filter(component)

# proc getComponents*(self: World; entity: Entity, filter: openarray[typedesc[Component]]): seq[Component] =
#   result = newSeqOfCap(filter.len)
#   for component in filter:
#     result.add self.getComponent(entity, component)

# template hasComponentImpl(self: World; entity: Entity, filter: typedesc[Component]): untyped =
#   for key in self.entities[entity]:
#     let component = self.components[key]
#     if component of filter:
#       return true

proc hasComponent*(self: World; entity: Entity, filter: typedesc[Component]): bool =
  for key in self.entities[entity]:
    let component = self.components[key]
    if component of filter:
      return true

proc andv*(values: varargs[bool]): bool =
  result = true
  for b in values:
    result = result and b

macro hasComponents*(self: World; entity: Entity, filter: varargs[untyped]): untyped =
  result = nnkStmtList.newTree()
  var call = nnkCall.newTree(newIdentNode("andv"))
  for component in items(filter):
    call.add nnkCall.newTree(
      nnkDotExpr.newTree(
        nnkDotExpr.newTree(
          newIdentNode("self"),
          newIdentNode("world")
        ),
        newIdentNode("hasComponent")
      ),
      newIdentNode("e"),
      newIdentNode($component)
    )
  result.add(call)

proc hash*(x: System): Hash =
  result = result !& hash(unsafeAddr x)
  result = !$result

method init*(self: System) {.base.} =
  discard

method update*(self: System; dt: float) {.base.} =
  raise newException(Exception, "overide update")

proc addSystem*(self: World; system: typedesc[System]) =
  let instance = new system
  instance.world = self
  instance.cache = initSet[Entity]()
  instance.init()
  self.systems.incl(instance)

proc newWorld*(): World =
  new result
  result.components = newSlotMap[Component](1024)
  result.entities = newSlotMap[seq[Key]](1024)
  result.systems = initSet[System]()

proc update*(self: World; dt: float) =
  for system in self.systems:
    system.update(dt)
