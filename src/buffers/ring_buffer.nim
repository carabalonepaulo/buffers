import ./utils

type
  RingBuffer* = ref object
    buffer*: seq[byte]
    writePos: int
    readPos: int
    availableToRead: int
    availableToWrite: int


proc newRingBuffer*(capacity: int): RingBuffer =
  result = RingBuffer(
    buffer: newSeq[byte](capacity),
    writePos: 0,
    readPos: 0,
    availableToWrite: capacity,
    availableToRead: 0
  )


proc copy(src: seq[byte], srcPos: int, dest: seq[byte], destPos: int, len: int) =
  copy(src[0].unsafeAddr, srcPos, dest[0].unsafeAddr, destPos, len)


proc clone*(self: RingBuffer): seq[byte] =
  result = newSeq[byte](self.buffer.len)
  copy(self.buffer, 0, result, 0, self.buffer.len)


proc canWrite*(self: RingBuffer, len: int): bool = self.availableToWrite >= len


proc canRead*(self: RingBuffer, len: int): bool = self.availableToRead >= len


proc advanceWriter(self: RingBuffer, len: int) =
  self.writePos += len
  self.availableToRead += len
  self.availableToWrite -= len


proc advanceReader(self: RingBuffer, len: int) =
  self.readPos += len
  self.availableToRead -= len
  self.availableToWrite += len


proc write*(self: RingBuffer, buff: seq[byte]) =
  let len = buff.len
  if not self.canWrite(len): raise newException(Exception, "Out of space to write.")

  if self.writePos + len >= self.buffer.len:
    let firstChunkLen = self.buffer.len - self.writePos
    let secondChunkLen = len - firstChunkLen

    copy(buff, 0, self.buffer, self.writePos, firstChunkLen)
    self.advanceWriter(firstChunkLen)
    self.writePos = 0

    copy(buff, firstChunkLen, self.buffer, self.writePos, secondChunkLen)
    self.advanceWriter(secondChunkLen)

    return

  copy(buff, 0, self.buffer, self.writePos, len)
  self.advanceWriter(len)


proc read*(self: RingBuffer, len: int): seq[byte] =
  if not self.canRead(len): raise newException(Exception, "No data available.")
  result = newSeq[byte](len)

  if self.readPos + len >= self.buffer.len:
    let firstChunkLen = self.buffer.len - self.readPos
    let secondChunkLen = len - firstChunkLen

    copy(self.buffer, self.readPos, result, 0, firstChunkLen)
    self.advanceReader(firstChunkLen)
    self.readPos = 0

    copy(self.buffer, self.readPos, result, firstChunkLen, secondChunkLen)
    self.advanceReader(secondChunkLen)
    return

  copy(self.buffer, self.readPos, result, 0, len)
  self.advanceReader(len)
