# Advent of Code 2022

Solutions for https://adventofcode.com/2022.

Puzzles are solved with Ruby 3.2 💎

## Running time

This is to get a rough idea of how the code performs.

The numbers are the `total` reading from running `time` command on my local machine (a regular MacBook Air).

Unit is second.

## Automated tasks

There are two tasks defined in Rakefile: `start` and `run`.
- `rake start [day_num]`
  - Create a new file from template.rb for the day.
  - Download the input file into data/ directory.
  - If no argument is provided, `day_num` defaults to the current day.
  - Needs an environmental variable `AOC_SESSION_TOKEN` to fetch the input data.
- `rake run [source_code_path]`
  - Run the code in `source_code_path` and print the result.
  - If no argument is provided, `source_code_path` defaults to the path of current day's puzzle.
