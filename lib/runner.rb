# frozen_string_literal: true

class Runner
  def initialize(raw_data)
    @input = parse(raw_data)
  end

  def do_puzzle1(_input)
    raise 'Need to implement :do_puzzle1 function'
  end

  def do_puzzle2(_input)
    raise 'Need to implement :do_puzzle2 function'
  end

  def parse(_input)
    raise 'Need to implement :parse function'
  end
end
