import std/strutils
import ./utils

type
  BinaryWriter* = ref object
    buffer: pointer
    position: int
    capacity: int


proc newBinaryWriter*(capacity: int = 512): BinaryWriter =
  result = BinaryWriter()
  result.buffer = alloc(capacity)
  result.capacity = capacity
  result.position = 0


proc position*(self: BinaryWriter): int = self.position


proc canWrite(self: BinaryWriter, len: int): bool =
  self.position + len <= self.capacity


proc expand(self: BinaryWriter) =
  self.capacity *= 2
  let newBuffer = alloc(self.capacity)
  copy(self.buffer, 0, newBuffer, 0, self.position)
  dealloc(self.buffer)
  self.buffer = newBuffer


proc dispose*(self: BinaryWriter) =
  self.buffer.dealloc()


proc write(self: BinaryWriter, buff: ptr, len: int) =
  if not self.canWrite(len):
    self.expand()

  copy(buff, 0, self.buffer, self.position, len)
  self.position += len


proc write*(self: BinaryWriter, value: seq[byte]) =
  self.write(value[0].unsafeAddr, value.len)


proc write*(self: BinaryWriter, value: int8) =
  self.write(value.unsafeAddr, 1)


proc write*(self: BinaryWriter, value: uint8) =
  self.write(value.unsafeAddr, 1)


proc write*(self: BinaryWriter, value: int16) =
  self.write(value.unsafeAddr, 2)


proc write*(self: BinaryWriter, value: uint16) =
  self.write(value.unsafeAddr, 2)


proc write*(self: BinaryWriter, value: int32) =
  self.write(value.unsafeAddr, 4)


proc write*(self: BinaryWriter, value: uint32) =
  self.write(value.unsafeAddr, 4)


proc write*(self: BinaryWriter, value: int64) =
  self.write(value.unsafeAddr, 8)


proc write*(self: BinaryWriter, value: uint64) =
  self.write(value.unsafeAddr, 8)


proc write*(self: BinaryWriter, value: float32) =
  self.write(value.unsafeAddr, 4)


proc write*(self: BinaryWriter, value: float64) =
  self.write(value.unsafeAddr, 8)


proc write*(self: BinaryWriter, value: bool) =
  self.write(value.unsafeAddr, 1)


proc write*(self: BinaryWriter, value: string, raw = false) =
  if not raw:
    self.write(value.len.uint16)
  self.write(value[0].unsafeAddr, value.len)


proc buffer*(self: BinaryWriter): seq[byte] =
  result = newSeq[byte](self.position)
  copyMem(result[0].unsafeAddr, self.buffer, self.position)


proc `$`*(self: BinaryWriter): string =
  result = repeat('\0', self.position)
  copyMem(result[0].unsafeAddr, self.buffer, self.position)


proc clear*(self: BinaryWriter, newSize = 512) =
  self.buffer.dealloc()
  self.buffer = alloc(newSize)
  self.position = 0
  self.capacity = newSize
