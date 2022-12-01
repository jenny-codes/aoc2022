# frozen_string_literal: true

# A helper class that changes the order of execution, allowing pipe-like operations.
# Suppose we want to pass data to functions a, b, c in this order,
# in normal Ruby we'd write `c(b(a(data)))`.
# With Pipe we can write `Pipe[data][a][b][c].run`,
# which reads more nicely.
class Pipe
  def self.[](x)
    new([x])
  end

  def self.run(data)
    data
  end

  def initialize(args)
    @args = args
  end

  def [](x)
    self.class.new(@args << x)
  end

  def run(data = nil)
    if data
      (Array[data] + @args).reduce { |memo, arg| arg.call(memo) }
    else
      @args.reduce { |memo, arg| arg.call(memo) }
    end
  end
end
