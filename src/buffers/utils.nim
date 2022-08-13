import std/strutils


type AllowedTypes* =
  uint8 | int8 |
  uint16 | int16 |
  uint32 | int32 |
  uint64 | int64 |
  float | float64 |
  bool


proc copy*(src: pointer, srcPos: int, dest: pointer, destPos: int, len: int) =
  copyMem(cast[pointer](cast[int](dest) + destPos),
      cast[pointer](cast[int](src) + srcPos), len)


proc getStringBuffer*[T](v: T): string =
  let len = sizeof(T)
  result = repeat('\0', len)
  copy(v.unsafeAddr, 0, result[0].unsafeAddr, 0, len)


proc getBytes*[T](v: T): seq[byte] =
  result = newSeq[byte](sizeof(T))
  copy(v.unsafeAddr, 0, result[0].unsafeAddr, 0, result.len)
