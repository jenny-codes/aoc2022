# frozen_string_literal: true

task default: %w[run]

desc 'Run the code in a given file. Defaults to today' \
  'For real input, put it in ./data/day[NUM].txt' \
  'For example input, put it in ./data/day[NUM].example'
task :run, [:file, :is_example] do |_t, args|
  code_path = args.file || "day#{Time.now.day}.rb"
  raw_input = read_input_for(code_path, args.is_example)
  runner = fetch_runner(code_path).new(raw_input)

  output1 = runner.do_puzzle1
  output2 = runner.do_puzzle2

  print_output('puzzle 1', output1)
  print_output('puzzle 2', output2)
  puts "\n"
end

desc 'Setup files for the day. Need AOC_SESSION_TOKEN env var.'
task :start, [:day_num] do |_t, args|
  token = ENV.fetch('AOC_SESSION_TOKEN')
  day_num = args.day_num || Time.now.day

  # If one doesn't already exist, create a source code file
  source_code_path = "day#{day_num}.rb"
  `sed s/NUMBER/#{day_num}/ lib/template.rb > #{source_code_path}` unless File.exist?(source_code_path)

  # Create a new input file
  input_path = "data/day#{day_num}.txt"
  `curl --header 'cookie: session=#{token}' -o #{input_path} https://adventofcode.com/2022/day/#{day_num}/input`

  puts "Generated files for day #{day_num} 🧑‍🎄"
  `open https://adventofcode.com/2022/day/#{day_num}`
end

# =========================================
# Helper functions

def read_input_for(source_code_path, is_example)
  ext = is_example ? 'example' : 'txt'
  filename = /day\d*/.match(source_code_path)[0]
  input_path = "data/#{filename}.#{ext}"
  File.read(input_path)
end

def fetch_runner(source_code_path)
  require "./#{source_code_path}"

  filename = /day\d*/.match(source_code_path)[0]
  Object.const_get(filename.capitalize)
end

def print_output(label, output)
  puts "#{label}: #{output}"
end
