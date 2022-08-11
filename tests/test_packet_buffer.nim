import std/deques
import unittest
import buffers


test "reading packets":
  let writer = newBinaryWriter()
  writer.write("soreto")

  let buff = newPacketBuffer[uint16](8)
  buff.push(writer.buffer)

  check buff.packets.len == 1
  check buff.packets.popFirst() == @[115'u8, 111, 114, 101, 116, 111]

