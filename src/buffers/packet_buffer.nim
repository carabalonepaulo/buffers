import std/deques
import ./ring_buffer

type
  PacketBuffer*[T] = ref object
    buffer: RingBuffer
    packets*: Deque[seq[byte]]
    expected: int
    headerSize: int


proc peek*[T](srcBuff: seq[byte], pos: int = 0): T =
  let len = sizeof(T)
  let buff = alloc(len)
  buff.copyMem(srcBuff[pos].unsafeAddr, len)
  result = cast[ptr T](buff)[]
  dealloc(buff)


proc newPacketBuffer*[T](capacity: int): PacketBuffer[T] =
  result = PacketBuffer[T](
    buffer: newRingBuffer(capacity),
    packets: initDeque[seq[byte]](),
    expected: 0,
    headerSize: sizeof(T)
  )


proc tryRead[T](self: PacketBuffer[T]): bool =
  if self.expected == 0:
    if not self.buffer.canRead(self.headerSize): return false

    let buff = self.buffer.read(self.headerSize)
    self.expected = peek[T](buff, 0).int

  if not self.buffer.canRead(self.expected): return false
  self.packets.addLast(self.buffer.read(self.expected))

  result = true


proc push*[T](self: PacketBuffer[T], buff: seq[byte]) =
  self.buffer.write(buff)
  while self.tryRead(): discard
