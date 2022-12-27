# frozen_string_literal: true

require './lib/runner'

Coord = Data.define(:x, :y) do
  def to(other)
    x1, x2 = [x, other.x].sort
    y1, y2 = [y, other.y].sort

    (x1..x2).flat_map do |new_x|
      (y1..y2).map do |new_y|
        Coord.new(new_x, new_y)
      end
    end
  end

  def inspect = [x, y]
end

START = Coord.new(500, 0)

class Cave
  AIR  = '.'
  SAND = 'o'
  ROCK = '#'

  POSSIBLE_DROPS = ->(coord) {
    [
      Coord.new(coord.x, coord.y + 1),
      Coord.new(coord.x - 1, coord.y + 1),
      Coord.new(coord.x + 1, coord.y + 1)
    ]
  }

  def initialize(cave_map)
    @map = cave_map
  end

  def settle_sands
    coord = START
    while coord.y <= boundaries[:ye]
      next_coord = POSSIBLE_DROPS[coord].find { |c| !@map.key?(c) }
      if next_coord
        coord = next_coord
      else
        @map[coord] = SAND
        coord = START
      end
    end

    self
  end

  def fill_to_start
    floor = boundaries[:ye] + 2
    coord = START

    until @map.key?(START)
      next_coord = coord.y + 1 >= floor ? nil : POSSIBLE_DROPS[coord].find { |c| !@map.key?(c) }

      next coord = next_coord if next_coord

      @map[coord] = SAND
      coord = START
    end

    self
  end

  def draw
    (boundaries[:ys]..boundaries[:ye]).map do |y|
      (boundaries[:xs]..boundaries[:xe]).map do |x|
        coord = Coord.new(x, y)
        @map[coord] || AIR
      end.join.prepend("#{y} ")
    end.join("\n").prepend("\n")
  end

  def count_sand
    @map.count { |_, v| v == SAND }
  end

  private

  def boundaries
    return @boundaries if @boundaries

    x_start, x_end = @map.keys.minmax_by(&:x).map(&:x)
    y_start, y_end = @map.keys.minmax_by(&:y).map(&:y)

    @boundearies = {
      xs: x_start,
      xe: x_end,
      ys: y_start,
      ye: y_end
    }
  end
end

class Day14 < Runner
  def do_puzzle1
    Cave.new(@input.dup)
        .settle_sands
        .count_sand
  end

  def do_puzzle2
    Cave.new(@input.dup)
        .fill_to_start
        .count_sand
  end

  def parse(raw_input)
    raw_input
      .split("\n")
      .map { _1.split(' -> ').map { |pair| Coord.new(*pair.split(',').map(&:to_i)) } }
      .each_with_object({}) do |strip, data|
        strip.each_cons(2) do |first_coord, second_coord|
          first_coord.to(second_coord).each do |coord|
            data[coord] = Cave::ROCK
          end
        end
      end
  end
end
