# Package

version       = "0.1.0"
author        = "Jason"
description   = "A new awesome nimble package"
license       = "GPL-3.0-or-later"
srcDir        = "src"
bin           = @["mindthegap3d"]


# Dependencies

requires "nim >= 1.6.0"
requires "truss3d"
requires "constructor"
requires "easings" # Odd library that could be pure Nim