import std/streams
import unittest
import buffers


test "read bytes":
  let writer = newStringStream()
  writer.write([10'u8, 20, 30])

  let reader = newBinaryReader(writer.data)
  check reader.readBytes(3) == @[10'u8, 20, 30]


test "read int":
  let writer = newStringStream()
  writer.write(10'u8)
  writer.write(20'u16)
  writer.write(30'u32)

  let reader = newBinaryReader(writer.data)
  check reader.readU8() == 10'u8
  check reader.readU16() == 20'u16
  check reader.readU32() == 30'u32


test "read bool":
  let writer = newStringStream()
  writer.write(false)
  writer.write(true)

  let reader = newBinaryReader(writer.data)
  check reader.readBool() == false
  check reader.readBool() == true


test "read string":
  let writer = newStringStream()
  writer.write(6'u16)
  writer.write("soreto")

  let reader = newBinaryReader(writer.data)
  check reader.readString() == "soreto"


test "unread":
  let writer = newStringStream()
  writer.write([10'u8, 20, 30])

  let reader = newBinaryReader(writer.data)
  check reader.unread[:seq[byte]]() == @[10'u8, 20, 30]

  discard reader.readU8()

  check reader.unread[:seq[byte]]() == @[20'u8, 30]
