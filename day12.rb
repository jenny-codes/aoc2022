# frozen_string_literal: true

require './lib/runner'

class HeightMap
  START_CHAR = 'S'
  END_CHAR = 'E'
  Coord = Data.define(:row, :col) do
    def inspect
      [row, col]
    end
  end

  Height = Data.define(:value) do
    TRANSFORMATION = ('a'..'z').to_a.each_with_index.to_h.tap do |table|
      table[START_CHAR] = table['a']
      table[END_CHAR] = table['z']
    end

    def too_steep_from?(other_height)
      (TRANSFORMATION.fetch(value) - TRANSFORMATION.fetch(other_height.value)) > 1
    end

    def inspect
      value
    end
  end
  attr_reader :start, :finish, :lookup

  def self.from(input_str)
    lookup = input_str
             .split("\n")
             .each_with_index
             .each_with_object({}) do |row_pair, hm|
      row, row_idx = row_pair
      row.chars.each_with_index do |height, col_idx|
        coord = Coord.new(row_idx, col_idx)
        hm[coord] = Height.new(height)
      end
    end
    new(lookup)
  end

  def initialize(lookup)
    @lookup = lookup
    @start = lookup.key(Height.new(START_CHAR)) || raise('No start char')
    @finish = lookup.key(Height.new(END_CHAR)) || raise('No end char')
  end

  def neighbors_of(coord)
    [
      Coord.new(coord.row, coord.col - 1),
      Coord.new(coord.row, coord.col + 1),
      Coord.new(coord.row - 1, coord.col),
      Coord.new(coord.row + 1, coord.col)
    ].filter_map do |c|
      @lookup.key?(c) ? c : nil
    end
  end

  def find(coord)
    @lookup.fetch(coord)
  end

  def inspect
    'Muted height map'
  end
end

class Day12 < Runner
  def do_puzzle1
    height_map = HeightMap.from(@input)
    climb(height_map, { height_map.start => 0 }, [height_map.start], 1)
  end

  def climb(height_map, steps, curr_coords, curr_step)
    nexts = curr_coords.flat_map do |c|
      height_map.neighbors_of(c).filter_map do |n|
        return curr_step if n == height_map.finish

        next false if steps[n] && steps[n] <= curr_step
        next false if height_map.find(n).too_steep_from?(height_map.find(c))

        steps[n] = curr_step
        n
      end
    end

    climb(height_map, steps, nexts, curr_step + 1)
  end

  def do_puzzle2
    'Not yet implemented'
  end

  def parse(raw_input)
    raw_input
  end
end
