import unittest
import buffers


test "ring buffer read/write":
  let buff = newRingBuffer(5)
  buff.write(@[10'u8, 20])
  buff.write(@[30'u8, 40, 50])

  check buff.read(1) == @[10'u8]
  check buff.read(1) == @[20'u8]
  check buff.read(1) == @[30'u8]

  buff.write(@[60'u8, 70, 80])

  check buff.read(2) == @[40'u8, 50]
  check buff.read(3) == @[60'u8, 70, 80]
