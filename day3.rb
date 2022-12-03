# frozen_string_literal: true

require './lib/runner'

PRIORITY_LOOKUP = (('a'..'z').zip(1..26) + ('A'..'Z').zip(27..53)).to_h

class Day3 < Runner
  def do_puzzle1
    @input
      .split("\n")
      .map(&:chars)
      .map { |rucksack| rucksack.each_slice(rucksack.count / 2).to_a }
      .map { |halves| find_common_elem(halves) }
      .map { |c| PRIORITY_LOOKUP[c] }
      .sum
  end

  def do_puzzle2
    @input
      .split("\n")
      .map(&:chars)
      .each_slice(3)
      .map { |rucksacks| find_common_elem(rucksacks) }
      .map { |c| PRIORITY_LOOKUP[c] }
      .sum
  end

  def find_common_elem(containers)
    containers
      .map { |container| Set.new(container) }
      .reduce { |memo, curr| memo & curr }
      .first
  end

  def parse(raw_input)
    raw_input
  end
end
