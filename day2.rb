# frozen_string_literal: true

require './lib/runner'

CHOICE_SCORE = {
  rock: 1, # Rock
  paper: 2, # Paper
  scissors: 3 # Scissors
}

OUTCOME_SCORE = {
  lose: 0,
  tie: 3,
  win: 6
}

PLAY = {
  %i[rock rock] => :tie,
  %i[rock paper] => :win,
  %i[rock scissors] => :lose,
  %i[paper rock] => :lose,
  %i[paper paper] => :tie,
  %i[paper scissors] => :win,
  %i[scissors rock] => :win,
  %i[scissors paper] => :lose,
  %i[scissors scissors] => :tie
}

REVERSE_PLAY = {
  %i[win rock] => :paper,
  %i[win paper] => :scissors,
  %i[win scissors] => :rock,
  %i[tie rock] => :rock,
  %i[tie paper] => :paper,
  %i[tie scissors] => :scissors,
  %i[lose rock] => :scissors,
  %i[lose paper] => :rock,
  %i[lose scissors] => :paper
}

CHOICE_TO_SHAPE = ->(c) {
  case c
  when 'A', 'X'
    :rock
  when 'B', 'Y'
    :paper
  when 'C', 'Z'
    :scissors
  end
}

CHOICE_TO_OUTCOME = {
  'X' => :lose,
  'Y' => :tie,
  'Z' => :win
}

# Part 1
Round = Data.define(:pair) do
  def total_score
    outcome = PLAY[pair]
    OUTCOME_SCORE[outcome] + CHOICE_SCORE[pair.last]
  end
end

# Part 2
RoundWithOutcome = Data.define(:other_choice, :outcome) do
  def total_score
    choice = REVERSE_PLAY[[outcome, other_choice]]
    OUTCOME_SCORE[outcome] + CHOICE_SCORE[choice]
  end
end

class Day2 < Runner
  def do_puzzle1
    @input
      .map { |pair| pair.map { |c| CHOICE_TO_SHAPE[c] } }
      .map { |pair| Round.new(pair).total_score }
      .sum
  end

  def do_puzzle2
    @input
      .map do |pair|
        other_choice = CHOICE_TO_SHAPE[pair.first]
        outcome = CHOICE_TO_OUTCOME[pair.last]
        RoundWithOutcome.new(other_choice, outcome).total_score
      end.sum
  end

  def parse(raw_input)
    raw_input.split("\n").map { _1.split(' ') }
  end
end
