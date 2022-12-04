# frozen_string_literal: true

require './lib/runner'

Area = Data.define(:start, :end) do
  def area
    Set.new(start..(self.end))
  end
end

class Day4 < Runner
  def do_puzzle1
    @input.count do |pair|
      pair.first.area.subset?(pair.last.area) || pair.last.area.subset?(pair.first.area)
    end
  end

  def do_puzzle2
    @input.count do |pair|
      pair.first.area.intersect?(pair.last.area)
    end
  end

  def parse(raw_input)
    raw_input
      .split("\n")
      .map { |line| line.split(',').map { |area| Area.new(*area.split('-').map(&:to_i)) } }
  end
end
