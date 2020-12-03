# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")
TREE = "#"

def run(data, *delta_tuples)
  delta_tuples.map do |x_delta, y_delta|
    (0 .. (data.count - 1) / y_delta).count do |iter|
      data[iter * y_delta][iter * x_delta % data.first.length] == TREE
    end
  end.inject(:*)
end

puts "Part 1: #{run(DATA, [3, 1])}"
puts "Part 2: #{run(DATA, [1, 1], [3, 1], [5, 1], [7, 1], [1, 2])}"
