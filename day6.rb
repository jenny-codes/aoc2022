# frozen_string_literal: true

require './lib/runner'

class Day6 < Runner
  def find_uniq_sequence(input_str, uniq_length)
    buffer_size = uniq_length - 1
    input_str
      .split('')
      .each_with_index
      .each_with_object([]) do |item, buffer|
      char, idx = item

      next buffer << char if buffer.count < buffer_size

      if buffer.include?(char) || buffer.uniq.count < buffer_size
        buffer.shift
        buffer << char
        next
      end

      return idx + 1
    end
  end

  def do_puzzle1
    find_uniq_sequence(@input, 4)
  end

  def do_puzzle2
    find_uniq_sequence(@input, 14)
  end

  def parse(raw_input)
    raw_input
  end
end
