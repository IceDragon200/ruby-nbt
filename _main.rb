require 'zlib'
require_relative 'lib/nbt/reader/reader'

result = nil
Zlib::GzipReader.open('data/GRC-Fishtrap.schematic') do |reader|
  result = Nbt.read(reader)
end

p result
