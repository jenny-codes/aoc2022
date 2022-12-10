# frozen_string_literal: true

require './lib/runner'

Coord = Data.define(:x, :y) do
  def close_enough?(other_coord)
    [1, 0, -1].map { _1 + x }.include?(other_coord.x) &&
      [1, 0, -1].map { _1 + y }.include?(other_coord.y)
  end

  def move_close_to(other_coord)
    diff_x = other_coord.x - x
    diff_y = other_coord.y - y
    new_x, new_y = case [diff_x.abs, diff_y.abs]
                   in [2, 2]
                     [x + (diff_x / 2), y + (diff_y / 2)]
                   in [2, 1]
                     [x + (diff_x / 2), y + diff_y]
                   in [1, 2]
                     [x + diff_x, y + (diff_y / 2)]
                   in [2, 0]
                     [x + (diff_x / 2), y]
                   in [0, 2]
                     [x, y + (diff_y / 2)]
                   end
    Coord.new(new_x, new_y)
  end

  def inspect
    [x, y]
  end
end

MOVE = {
  'U' => ->(c) { Coord.new(c.x, c.y + 1) },
  'D' => ->(c) { Coord.new(c.x, c.y - 1) },
  'R' => ->(c) { Coord.new(c.x + 1, c.y) },
  'L' => ->(c) { Coord.new(c.x - 1, c.y) }
}

Motion = Data.define(:direction, :step)

class Day9 < Runner
  def do_puzzle1
    calculate_tail_visited(@input, 2).count
  end

  def do_puzzle2
    calculate_tail_visited(@input, 10).count
  end

  def calculate_tail_visited(input, snake_length)
    snake = [Coord.new(0, 0)] * snake_length
    input.each_with_object(Set.new) do |motion, visited|
      motion.step.times do
        snake[0] = MOVE[motion.direction][snake.first]

        snake_length.times.each_cons(2) do |ahead, behind|
          break if snake[behind].close_enough?(snake[ahead])

          snake[behind] = snake[behind].move_close_to(snake[ahead])
        end

        visited << snake.last
      end
      visited
    end
  end

  def parse(raw_input)
    raw_input.split("\n").map do |inst|
      _, direction, step = inst.match(/(U|D|R|L) (\d+)/).to_a
      Motion.new(direction, step.to_i)
    end
  end
end
