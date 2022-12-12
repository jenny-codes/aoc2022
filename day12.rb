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

  def inspect
    'Muted height map'
  end
end

class Day12 < Runner
  def do_puzzle1
    height_map = HeightMap.from(@input)
    steps = climb(height_map, {}, height_map.start, 0)
    steps[height_map.finish]
  end

  def climb(height_map, steps, curr_coord, curr_step)
    # puts "#{curr_coord}, #{steps[curr_coord]}"
    # return steps if steps[height_map.finish]

    existing_step = steps[curr_coord]
    return steps if existing_step && existing_step <= curr_step

    steps[curr_coord] = curr_step

    height_map.neighbors_of(curr_coord).reduce(steps) do |memo, next_coord|
      next memo if height_map.lookup[next_coord].too_steep_from?(height_map.lookup[curr_coord])

      climb(height_map, memo, next_coord, curr_step + 1)
    end
  end

  def do_puzzle2
    'Not yet implemented'
  end

  def parse(raw_input)
    raw_input
  end
end
