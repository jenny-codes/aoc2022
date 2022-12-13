# frozen_string_literal: true

require './lib/runner'

Noop = Data.define
Addx = Data.define(:val)

class Day10 < Runner
  def do_puzzle1
    cycles = generate_cycles(@input)
    output_for(cycles, [20, 60, 100, 140, 180, 220])
  end

  def do_puzzle2
    cycles = generate_cycles(@input)
    "\n" + draw(cycles)
  end

  def output_for(cycles, indexes)
    indexes.sum do |idx|
      cycles[idx - 2] * idx
    end
  end

  def generate_cycles(input)
    x = 1
    buff = []
    input.each_with_object([]) do |inst, memo|
      curr_register = buff.shift
      if curr_register
        x += curr_register
        memo << x
      end

      buff << inst.val if inst.is_a? Addx
      memo << x
    end
  end

  def draw(cycles)
    ((0..39).to_a * 6).zip(cycles).map do |idx, pos|
      # spr = [pos - 1, pos, pos + 1]
      spr = [pos - 2, pos - 1, pos]
      if spr.include?(idx)
        '#'
      else
        '.'
      end
    end.each_slice(40).map(&:join).join("\n")
  end

  def parse(raw_input)
    raw_input.split("\n").map do
      inst, val = _1.split(' ')
      case inst
      when 'addx'
        Addx.new(val.to_i)
      when 'noop'
        Noop.new
      end
    end
  end
end
