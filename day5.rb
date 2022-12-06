# frozen_string_literal: true

require './lib/runner'

Procedure = Data.define(:num, :from, :to)

class Day5 < Runner
  def do_puzzle1
    raw_form, raw_procedure = @input.split("\n\n")

    load_cargos = ->(stack, memo) {
      stack_num = stack.pop.to_i
      trimmed_stack = stack.reject { |cargo| cargo == ' ' }.reverse
      memo[stack_num] = trimmed_stack
    }

    form = raw_form
           .split("\n")
           .map { _1.split('') }
           .transpose
           .select { |line| line.any? { |elem| elem =~ /\w/ } }
           .each_with_object({}, &load_cargos)

    extract_numbers = ->(line) {
      line
        .split(' ')
        .map(&:to_i)
        .reject(&:zero?)
    }

    raw_procedure
      .split("\n")
      .map(&extract_numbers)
      .map { Procedure.new(*_1) }
      .each do |procedure|
      move = form[procedure.from].pop(procedure.num).reverse
      form[procedure.to].concat(move)
    end

    (1..9).map { |num| form[num].last }.join
  end

  def do_puzzle2
    raw_form, raw_procedure = @input.split("\n\n")

    load_cargos = ->(stack, memo) {
      stack_num = stack.pop.to_i
      trimmed_stack = stack.reject { |cargo| cargo == ' ' }.reverse
      memo[stack_num] = trimmed_stack
    }

    form = raw_form
           .split("\n")
           .map { _1.split('') }
           .transpose
           .select { |line| line.any? { |elem| elem =~ /\w/ } }
           .each_with_object({}, &load_cargos)

    extract_numbers = ->(line) {
      line
        .split(' ')
        .map(&:to_i)
        .reject(&:zero?)
    }

    raw_procedure
      .split("\n")
      .map(&extract_numbers)
      .map { Procedure.new(*_1) }
      .each do |procedure|
      move = form[procedure.from].pop(procedure.num)
      form[procedure.to].concat(move)
    end

    (1..9).map { |num| form[num].last }.join
  end

  def parse(raw_input)
    raw_input
  end
end
