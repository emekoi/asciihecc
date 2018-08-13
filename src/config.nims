##  Copyright (c) 2017 emekoi
##
##  This library is free software; you can redistribute it and/or modify it
##  under the terms of the MIT license. See LICENSE for details.
##

switch("nimcache", "bin/nimcache")
switch("threads", "on")

when defined(release):
  # when defined(windows):
  #   switch("link", "nimcache/*.res")
  # switch("define", "useRealtimeGC")
  # switch("passC", "-flto")
  switch("app", "gui")
  switch("dynlibOverride", "SDL_gpu")
  switch("passC", "-lSDL_gpu.a")
