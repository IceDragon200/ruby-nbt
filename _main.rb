require 'zlib'
require_relative 'lib/nbt/reader/reader'

result = nil
Zlib::GzipReader.open('data/GRC-Fishtrap.schematic') do |reader|
  result = Nbt.read(reader)
end

sch = result.fetch('Schematic')
# minecraft uses the y coord for layers, however I prefer the z coord, so
# a bit of unrolling here and walla
xsize, ysize, zsize = sch['Width'], sch['Length'], sch['Height']
metadata = sch['Data']
data = sch['Blocks']

id_to_char = {
  0   => ' ', # air
  2   => 'g', # grass
  3   => 'd', # dirt
  4   => 'c', # cobblestone
  5   => 'p', # planks
  9   => '~', # water
  17  => 'x', # log
  33  => 'T', # piston
  50  => '*', # torch
  53  => 'S', # stairs
  54  => ' ', # chest - must be handled externally
  64  => ' ', # door - must be handled externally
  68  => '#', # wall sign
  85  => 'f', # fence
  96  => '+', # trap door
  102 => 'I', # glass pane
  111 => 'y', # lilypad
  125 => '=', # double slab
  126 => '-', # slab
  194 => '?', # <unknown>
}

chardata = data.map { |id| id_to_char.fetch(id) }
#p result
