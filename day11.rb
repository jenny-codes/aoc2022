# frozen_string_literal: true

require './lib/runner'

Monkey = Data.define(:id, :op, :test, :div_by) do
  def throw(items, worry_adjustment)
    items.map(&op).map(&worry_adjustment).group_by(&test)
  end
end

class Game
  attr_reader :monkeys, :worry_adjustment, :inspection_counts

  def initialize(monkeys, worry_adjustment)
    @monkeys = monkeys
    @worry_adjustment = worry_adjustment
    @inspection_counts = Array.new(monkeys.count) { 0 }
  end

  def play(items)
    @monkeys.each do |monkey|
      it = items[monkey.id]
      @inspection_counts[monkey.id] += it.count
      items[monkey.id] = []
      item_dist = monkey.throw(it, @worry_adjustment)
      items.merge(item_dist) { |_h, v1, v2| v1.concat(v2) }
    end
  end
end

class Day11 < Runner
  def do_puzzle1
    monkeys, items = init(@input)
    game = Game.new(monkeys, ->(worry_level) { worry_level / 3 })
    20.times { game.play(items) }

    game.inspection_counts.max(2).reduce(&:*)
  end

  def do_puzzle2
    monkeys, items = init(@input)
    worry_adjustment = monkeys.map(&:div_by).reduce(:lcm)
    game = Game.new(monkeys, ->(worry_level) { worry_level % worry_adjustment })
    10_000.times { game.play(items) }

    game.inspection_counts.max(2).reduce(&:*)
  end

  def init(input)
    monkeys = []
    item_lookup = {}
    input.split("\n\n").map do |description|
      d = description.lines.map!(&:strip)
      id = d[0].match(/Monkey (\d)/)[1].to_i
      items = d[1].match(/Starting items: (([\d, ]+))/)[1].split(', ').map(&:to_i)
      op = d[2].match(/new = (old .*)$/)[1].then do |cal|
        ->(old) {
          old
          eval(cal)
        }
      end
      test_div_by = d[3].match(/divisible by (\d+)/)[1].to_i
      test_true_to = d[4].match(/(\d+)/)[1].to_i
      test_false_to = d[5].match(/(\d+)/)[1].to_i

      test = ->(item) {
        item % test_div_by == 0 ? test_true_to : test_false_to
      }

      monkeys << Monkey.new(id, op, test, test_div_by)
      item_lookup[id] = items
    end

    [monkeys, item_lookup]
  end

  def parse(raw_input)
    raw_input
  end
end
