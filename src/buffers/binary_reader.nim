import ./utils
import std/strutils

type
  BinaryReader* = ref object
    buffer: seq[byte]
    position: int


proc read*[T](srcBuff: seq[byte], pos: int = 0): T =
  let len = sizeof(T)
  let buff = alloc(len)
  buff.copyMem(srcBuff[pos].unsafeAddr, len)
  result = cast[ptr T](buff)[]
  dealloc(buff)


proc newBinaryReader*(buff: seq[byte]): BinaryReader =
  result = BinaryReader()
  result.buffer = buff
  result.position = 0


proc newBinaryReader*(buff: string): BinaryReader =
  result = BinaryReader()
  result.buffer = cast[seq[byte]](buff)
  result.position = 0


proc readBytes*(self: BinaryReader, len: int): seq[byte] =
  result = newSeq[byte](len)
  for i in 0..<len:
    result[i] = self.buffer[self.position + i]
  self.position += len


proc read[T](self: BinaryReader): T =
  let len = sizeof(T)
  var buff = self.readBytes(len)
  result = cast[ptr T](buff[0].unsafeAddr)[]


proc readU8*(self: BinaryReader): uint8 =
  result = self.buffer[self.position]
  inc self.position


proc readI8*(self: BinaryReader): int8 =
  result = cast[int8](self.buffer[self.position])
  inc self.position


proc readU16*(self: BinaryReader): uint16 = read[uint16](self)


proc readI16*(self: BinaryReader): int16 = read[int16](self)


proc readU32*(self: BinaryReader): uint32 = read[uint32](self)


proc readI32*(self: BinaryReader): int32 = read[int32](self)


proc readU64*(self: BinaryReader): uint64 = read[uint64](self)


proc readI64*(self: BinaryReader): int64 = read[int64](self)


proc readF32*(self: BinaryReader): float = read[float](self)


proc readF64*(self: BinaryReader): float64 = read[float64](self)


proc readString*(self: BinaryReader): string =
  let len = self.read[:uint16]()
  let buff = self.readBytes(len.int)
  result = cast[string](buff)


proc readBool*(self: BinaryReader): bool = self.readU8() != 0


proc unread*[T: string | seq[byte]](self: BinaryReader): T =
  let len = self.buffer.len - self.position
  when T is seq[byte]:
    result = newSeq[byte](len)
  else:
    result = repeat('\0', len)
  copy(self.buffer[0].unsafeAddr, self.position, result[0].unsafeAddr, 0, len)
