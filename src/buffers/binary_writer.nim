import std/strutils
import ./utils

type
  BinaryWriter* = ref object
    buffer: seq[byte]
    position: int


proc newBinaryWriter*(capacity: int = 512): BinaryWriter =
  result = BinaryWriter()
  result.buffer = newSeq[byte](capacity)
  result.position = 0


proc position*(self: BinaryWriter): int = self.position


proc canWrite(self: BinaryWriter, len: int): bool =
  self.position + len <= self.buffer.len


proc expand(self: BinaryWriter) =
  let len = self.buffer.len
  let newBuffer = newSeq[byte](len * 2)
  copy(self.buffer[0].unsafeAddr, 0, newBuffer[0].unsafeAddr, 0, len)
  self.buffer = newBuffer


proc write(self: BinaryWriter, buff: ptr, len: int) =
  if not self.canWrite(len):
    self.expand()

  copy(buff, 0, self.buffer[0].unsafeAddr, self.position, len)
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
  copyMem(result[0].unsafeAddr, self.buffer[0].unsafeAddr, self.position)


proc `$`*(self: BinaryWriter): string =
  result = repeat('\0', self.position)
  copyMem(result[0].unsafeAddr, self.buffer[0].unsafeAddr, self.position)


proc clear*(self: BinaryWriter, newSize = 512) =
  self.buffer = newSeq[byte](newSize)
  self.position = 0
