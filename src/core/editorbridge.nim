import flatty
import std/[options, net]
import worlds
export options, net
const
  editorPort = Port(34213)
  gamePort = Port(25422)
  footerMessage = "levelended"

proc toFlatty[T](s: var string; x: set[T]) =
  let startPos = s.len
  s.setLen(s.len + sizeof(x))
  copyMem(s[startPos].addr, x.unsafeAddr, sizeof(x))

proc fromFlatty[T](s: string; i: var int, x: var set[T]) =
  copyMem(x.addr, s[i].unsafeAddr, sizeof(x))
  inc i, sizeof(x)

proc createGameSocket*(): Socket =
  result = newSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
  result.bindAddr(gamePort)

proc sendWorld*(world: World) =
  let socket = newSocket(AF_INET, SOCK_DGRAM, IPPROTO_UDP)
  try:
    let
      data = world.toFlatty
      dataSize = data.len
    socket.sendTo("127.0.0.1", gamePort, dataSize.unsafeAddr, sizeof(int))
    socket.sendTo("127.0.0.1", gamePort, data)
    socket.sendTo("127.0.0.1", gamePort, footerMessage)
  except:
    echo getCurrentExceptionMsg()
  finally:
    socket.close()

proc getWorld*(socket: Socket): Option[World] =
  try:
    var size = 0
    let read = socket.recv(size.addr, sizeof(int), 1)
    if read == sizeof(int):
      let
        buf = newString(size)
        bufRead = socket.recv(buf[0].addr, size)
      var footer = newString(footerMessage.len)
      discard socket.recv(footer[0].addr, footerMessage.len, 1)
      if bufRead == size and footer == footerMessage:
        result = some fromFlatty(buf, World)
  except TimeoutError:
    result = none(World)

