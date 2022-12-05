# frozen_string_literal: true

require './lib/runner'

Procedure = Data.define(:num, :from, :to)

class Day5 < Runner
  def do_puzzle1
    raw_form, raw_procedure = @input.split("\n\n")
    form = raw_form
           .split("\n")
           .map { _1.split('') }
           .transpose
           .select { |line| line.any? { |elem| elem =~ /\w/ } }
           .each_with_object({}) do |stack, memo|
      memo[stack.pop.to_i] = stack.reject { |cargo| cargo == ' ' }.reverse
    end

    procedures = raw_procedure.split("\n").map do
      Procedure.new(*(_1.split(' ').map(&:to_i).select do |elem|
                        !elem.zero?
                      end))
    end
    procedures.each do |procedure|
      move = form[procedure.from].pop(procedure.num).reverse
      form[procedure.to].concat(move)
    end

    (1..9).map { |num| form[num].last }.join
  end

  def do_puzzle2
    raw_form, raw_procedure = @input.split("\n\n")
    form = raw_form
           .split("\n")
           .map { _1.split('') }
           .transpose
           .select { |line| line.any? { |elem| elem =~ /\w/ } }
           .each_with_object({}) do |stack, memo|
      memo[stack.pop.to_i] = stack.reject { |cargo| cargo == ' ' }.reverse
    end

    procedures = raw_procedure.split("\n").map do
      Procedure.new(*(_1.split(' ').map(&:to_i).select do |elem|
                        !elem.zero?
                      end))
    end
    procedures.each do |procedure|
      move = form[procedure.from].pop(procedure.num)
      form[procedure.to].concat(move)
    end

    (1..9).map { |num| form[num].last }.join
  end

  def parse(raw_input)
    raw_input
  end
end
