import unittest
import buffers


test "write bytes":
  let writer = newBinaryWriter(3)
  writer.write(@[10'u8, 20, 30])

  let reader = newBinaryReader(writer.buffer)
  check reader.readU8() == 10'u8
  check reader.readU8() == 20'u8
  check reader.readU8() == 30'u8


test "write int":
  let writer = newBinaryWriter(7)
  writer.write(10'u8)
  writer.write(20'u16)
  writer.write(30'u32)

  let reader = newBinaryReader(writer.buffer)
  check reader.readU8() == 10'u8
  check reader.readU16() == 20'u16
  check reader.readU32() == 30'u32


test "write string":
  let writer = newBinaryWriter(8)
  writer.write("soreto")

  let reader = newBinaryReader(writer.buffer)
  check reader.readString() == "soreto"


test "write bool":
  let writer = newBinaryWriter(2)
  writer.write(false)
  writer.write(true)

  let reader = newBinaryReader(writer.buffer)
  check reader.readBool() == false
  check reader.readBool() == true
