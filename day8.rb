# frozen_string_literal: true

require './lib/runner'

class Tree
  attr_reader :height

  def initialize(height)
    @height = height
  end
end

class ScenicTree < Tree
  attr_reader :views

  def initialize(height)
    @views = []
    super(height)
  end

  def score
    views.reduce(&:*)
  end
end

class Day8 < Runner
  def do_puzzle1
    grid = @input.map { |row| row.map { |val| Tree.new(val) } }
    reverse_grid = grid.map(&:reverse).reverse
    (find_unblocked_trees(grid) | find_unblocked_trees(reverse_grid)).count
  end

  def do_puzzle2
    grid = @input.map { |row| row.map { |val| ScenicTree.new(val) } }

    right = grid
    down = grid.transpose
    up = grid.transpose.map(&:reverse)
    left = grid.map(&:reverse)
    [down, right, up, left].each { calculate_tree_views(_1) }
    grid.flatten.map(&:score).max
  end

  def find_unblocked_trees(grid)
    col_highest = []
    grid.each_with_object(Set.new) do |row, memo|
      row_highest = -1
      row.each_with_index do |tree, col_idx|
        col_highest[col_idx] = -1 if col_highest[col_idx].nil?
        memo << tree if tree.height > row_highest || tree.height > col_highest[col_idx]

        row_highest = tree.height if tree.height > row_highest
        col_highest[col_idx] = tree.height if tree.height > col_highest[col_idx]
      end
    end
  end

  def calculate_tree_views(grid)
    grid.each do |row|
      row.each_with_index do |tree, idx|
        tall_tree_idx = row[...idx].reverse.index { |t| t.height >= tree.height }
        view = tall_tree_idx ? tall_tree_idx + 1 : idx
        tree.views << view
      end
    end
  end

  def parse(raw_input)
    raw_input.split("\n").map { |row| row.split('').map(&:to_i) }
  end
end
