# frozen_string_literal: true

require './lib/runner'

class Day8 < Runner
  def count(grid)
    column_highest = []
    grid.each_with_index.each_with_object(Set.new) do |y, memo|
      row, y_idx = y
      row_highest = -1
      row.each_with_index.each do |value, x_idx|
        column_highest[x_idx] = -1 if column_highest[x_idx].nil?
        memo << [x_idx, y_idx] if value > row_highest || value > column_highest[x_idx]

        row_highest = value if value > row_highest
        column_highest[x_idx] = value if value > column_highest[x_idx]
      end
    end
  end

  def reverse_coord(coord)
    coord.map { 98 - _1 }
  end

  def do_puzzle1
    grid = @input.split("\n").map { _1.split('').map(&:to_i) }
    set = count(grid)
    reverse_set = count(grid.map(&:reverse).reverse).map { reverse_coord(_1) }
    (set | reverse_set).count
  end

  def do_puzzle2
    'Not yet implemented'
  end

  def parse(raw_input)
    raw_input
  end
end
