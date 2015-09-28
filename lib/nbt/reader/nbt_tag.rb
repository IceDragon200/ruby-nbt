require 'bindata'

class NbtTagHead < BinData::Record
  uint8 :tag_id
end

class NbtBase < BinData::Record
  endian :big
end

class NbtByte < NbtBase
  int8 :val
end

class NbtShort < NbtBase
  int16 :val
end

class NbtInt < NbtBase
  int32 :val
end

class NbtLong < NbtBase
  int64 :val
end

class NbtFloat < NbtBase
  float :val
end

class NbtDouble < NbtBase
  double :val
end

class NbtByteArray < NbtBase
  int32 :a_length
  array :val, type: :uint8, initial_length: -> { a_length }
end

class NbtString < NbtBase
  uint16 :s_length
  string :string, length: :s_length
end

class NbtListHead < NbtBase
  int8 :tag_id
  int32 :a_length
end

class NbtIntArray < NbtBase
  int32 :a_length
  array :val, type: :int32, initial_length: -> { a_length }
end
