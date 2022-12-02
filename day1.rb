# frozen_string_literal: true

require './lib/runner'

class Day1 < Runner
  def do_puzzle1
    @input.map { _1.split("\n").map(&:to_i).sum }.max
  end

  def do_puzzle2
    @input.map { _1.split("\n").map(&:to_i).sum }.max(3).sum
  end

  def parse(raw_input)
    raw_input.split("\n\n")
  end
end
