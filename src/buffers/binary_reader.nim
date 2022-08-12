import ./utils
import std/strutils


type
  BinaryReader* = ref object
    buffer: seq[byte]
    position: int

  AllowedTypes =
    uint8 | int8 |
    uint16 | int16 |
    uint32 | int32 |
    uint64 | int64 |
    float | float64


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
  copy(self.buffer[0].unsafeAddr, self.position, result[0].unsafeAddr, 0, len)
  self.position += len


proc read*[T: AllowedTypes](self: BinaryReader): T =
  let len = sizeof(T)
  copy(self.buffer[0].unsafeAddr, self.position, result.unsafeAddr, 0, len)
  self.position += len


proc readU8*(self: BinaryReader): uint8 =
  result = self.buffer[self.position]
  inc self.position


proc readI8*(self: BinaryReader): int8 =
  result = cast[int8](self.buffer[self.position])
  inc self.position


proc readU16*(self: BinaryReader): uint16 = self.read[:uint16]()


proc readI16*(self: BinaryReader): int16 = self.read[:int16]()


proc readU32*(self: BinaryReader): uint32 = self.read[:uint32]()


proc readI32*(self: BinaryReader): int32 = self.read[:int32]()


proc readU64*(self: BinaryReader): uint64 = self.read[:uint64]()


proc readI64*(self: BinaryReader): int64 = self.read[:int64]()


proc readF32*(self: BinaryReader): float = self.read[:float]()


proc readF64*(self: BinaryReader): float64 = self.read[:float64]()


proc readString*(self: BinaryReader): string =
  cast[string](self.readBytes(self.read[:uint16]().int))


proc readRawString*(self: BinaryReader, len: int): string =
  cast[string](self.readBytes(len))


proc readBool*(self: BinaryReader): bool = self.readU8() != 0


proc unread*[T: string | seq[byte]](self: BinaryReader): T =
  let len = self.buffer.len - self.position
  when T is seq[byte]:
    result = newSeq[byte](len)
  else:
    result = repeat('\0', len)
  copy(self.buffer[0].unsafeAddr, self.position, result[0].unsafeAddr, 0, len)
