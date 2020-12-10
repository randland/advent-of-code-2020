# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

PART_1_SLOPES = [[3, 1]]
PART_2_SLOPES = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]
TREE = "#"

def run(data, slopes)
  width = data.first.length
  height = data.count

  slopes.map do |x_delta, y_delta|
    (height / y_delta).times.count do |iter|
      x_pos = iter * x_delta % width
      y_pos = iter * y_delta
      data[y_pos][x_pos] == TREE
    end
  end.inject(:*)
end

puts "Part 1: #{run(DATA, PART_1_SLOPES)}"
puts "Part 2: #{run(DATA, PART_2_SLOPES)}"

#############
# Code Golf #
#############

def golf(d, xy)
  xy.map { |x, y| (0..(d.size-1)/y).count { |i| d[i*y][i*x%d[0].size] == TREE } }.inject(:*)
end

puts "Part 1 (golf): #{golf(DATA, PART_1_SLOPES)}"
puts "Part 2 (golf): #{golf(DATA, PART_2_SLOPES)}"
