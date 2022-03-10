import resources, directions
import truss3D/textures
import truss3D, pixie
import std/os
import vmath

type
  PickupType* = enum
    single
    closeQuad
    farQuad
    lLeft
    lRight
    tee
    line

const
  assetPath = "assets/pickupblocks"
  imageNames = [
    single: assetPath / "single.png",
    closeQuad: assetPath / "quad_close.png",
    farQuad: assetPath / "quad_far.png",
    lLeft: assetPath / "l_left.png",
    lRight: assetPath / "l_right.png",
    tee: assetPath / "tee.png",
    line: assetPath / "line.png"
  ]
  offsets = [
    single: @[vec3(0)],
    closeQuad: @[vec3(0), vec3(0, 0, 1), vec3(1, 0, 1), vec3(1, 0, 0)],
    farQuad: @[vec3(0), vec3(0, 0, 2), vec3(2, 0, 2), vec3(2, 0, 0)],
    lLeft: @[vec3(0), vec3(1, 0, 0), vec3(0, 0, -1), vec3(0, 0, -2)],
    lRight: @[vec3(0), vec3(-1, 0, 0), vec3(0, 0, -1), vec3(0, 0, -2)],
    tee: @[vec3(0), vec3(1, 0, 0), vec3(0, 0, 1), vec3(-1, 0, 0)],
    line: @[vec3(0), vec3(0, 0, 1), vec3(0, 0, 2), vec3(0, 0, -1)],
  ]

var pickupTextures: array[PickupType, Texture]

addResourceProc:
  for i, _ in pickupTextures.pairs:
    pickupTextures[i] = genTexture()
    let img = readImage(imageNames[i])
    img.copyTo pickupTextures[i]

proc getPickupTexture*(pickupKind: PickupType): Texture = pickupTextures[pickupKind]

iterator positions*(pickUpKind: PickupType, dir: Direction, origin = vec3(0, 0, 0)): Vec3 =
  let rot = dir.asRot
  for point in offsets[pickUpKind]:
    let point = vec3(round(point.x * cos(rot) - point.z * sin(rot)), 0, round(point.z * cos(rot) + point.x * sin(rot)))
    yield point + origin
