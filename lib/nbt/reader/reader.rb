require 'zlib'
require 'bindata'
require_relative 'nbt_tag'

module Nbt
  module TagId
    TAG_END = 0
    TAG_BYTE = 1
    TAG_SHORT = 2
    TAG_INT = 3
    TAG_LONG = 4
    TAG_FLOAT = 5
    TAG_DOUBLE = 6
    TAG_BYTE_ARRAY = 7
    TAG_STRING = 8
    TAG_LIST = 9
    TAG_COMPOUND = 10
    TAG_INT_ARRAY = 11
  end

  BREAK = Object.new

  def self.read_tag_by_id(reader, tag_id)
    case tag_id
    when TagId::TAG_END
      return nil, BREAK
    when TagId::TAG_BYTE
      return NbtByte.read(reader).val, nil
    when TagId::TAG_SHORT
      return NbtShort.read(reader).val, nil
    when TagId::TAG_INT
      return NbtInt.read(reader).val, nil
    when TagId::TAG_LONG
      return NbtLong.read(reader).val, nil
    when TagId::TAG_FLOAT
      return NbtFloat.read(reader).val, nil
    when TagId::TAG_DOUBLE
      return NbtDouble.read(reader).val, nil
    when TagId::TAG_BYTE_ARRAY
      return NbtByteArray.read(reader).val, nil
    when TagId::TAG_STRING
      return NbtString.read(reader).string.to_s, nil
    when TagId::TAG_LIST
      h = NbtListHead.read(reader)
      result = []
      h.a_length.times.map do
        value, err = *read_tag_by_id(reader, h.tag_id)
        break if err
        result << value
      end
      return result, nil
    when TagId::TAG_COMPOUND
      result = {}
      loop do
        break if reader.eof?
        key, value, err = *read_compound_tag(reader)
        break if BREAK == err
        result[key] = value
      end
      return result, nil
    when TagId::TAG_INT_ARRAY
      return NbtIntArray.read(reader), nil
    else
      raise "Unsupported tag: #{tag_id}"
    end
  end

  def self.read_compound_tag(reader)
    head = NbtTagHead.read(reader)
    return nil, nil, BREAK if head.tag_id == TagId::TAG_END
    key, err = *read_tag_by_id(reader, TagId::TAG_STRING)
    raise if err
    value, err = *read_tag_by_id(reader, head.tag_id)
    return key, value, err
  end

  def self.read_tags(reader)
    value, err = read_tag_by_id(reader, TagId::TAG_COMPOUND)
    value
  end

  def self.read(reader)
    read_tags(reader)
  end
end
