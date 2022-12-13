# frozen_string_literal: true

require './lib/runner'

class HeightMap
  START_CHAR = 'S'
  END_CHAR = 'E'

  Coord  = Data.define(:row, :col)
  Height = Data.define(:value) do
    TRANSFORMATION = ('a'..'z').to_a.each_with_index.to_h.tap do |table|
      table[START_CHAR] = table['a']
      table[END_CHAR] = table['z']
    end

    def too_steep_from?(other_height)
      (TRANSFORMATION.fetch(value) - TRANSFORMATION.fetch(other_height.value)) > 1
    end
  end

  attr_reader :start_coord, :end_coord, :lookup

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
    @start_coord = lookup.key(Height.new(START_CHAR))
    @end_coord = lookup.key(Height.new(END_CHAR))
    @lookup = lookup
  end

  def neighbors_of(coord)
    [
      Coord.new(coord.row, coord.col - 1),
      Coord.new(coord.row, coord.col + 1),
      Coord.new(coord.row - 1, coord.col),
      Coord.new(coord.row + 1, coord.col)
    ].filter_map { |c| @lookup.key?(c) ? c : nil }
  end

  def find(coord)
    @lookup.fetch(coord)
  end
end

class Day12 < Runner
  def do_puzzle1
    height_map = HeightMap.from(@input)
    climb(height_map, { height_map.start_coord => 0 }, [height_map.start_coord], 1)
  end

  def climb(height_map, steps, curr_coords, curr_step)
    nexts = curr_coords.flat_map do |c|
      height_map.neighbors_of(c).filter_map do |n|
        return curr_step if n == height_map.end_coord

        next if steps.key?(n)
        next if height_map.find(n).too_steep_from?(height_map.find(c))

        steps[n] = curr_step
        n
      end
    end

    climb(height_map, steps, nexts, curr_step + 1)
  end

  def do_puzzle2
    target = HeightMap::Height.new('a')
    height_map = HeightMap.from(@input)
    descend(height_map, { height_map.end_coord => 0 }, [height_map.end_coord], 1, target)
  end

  def descend(height_map, steps, curr_coords, curr_step, target)
    nexts = curr_coords.flat_map do |c|
      height_map.neighbors_of(c).filter_map do |n|
        next if steps.key?(n)
        next if height_map.find(c).too_steep_from?(height_map.find(n))

        return curr_step if height_map.find(n) == target

        steps[n] = curr_step
        n
      end
    end

    descend(height_map, steps, nexts, curr_step + 1, target)
  end

  def parse(raw_input)
    raw_input
  end
end
