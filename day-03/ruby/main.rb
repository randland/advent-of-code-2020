# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")
TREE = "#"

def readable(data, slopes)
  x_count = data.first.length
  y_count = data.count

  slopes.map do |x_delta, y_delta|
    (y_count / y_delta).times.count { |iter| data[iter * y_delta][iter * x_delta % x_count] == TREE }
  end.inject(:*)
end

def golf(d, xy)
  xy.map { |x, y| (0..(d.count-1)/y).count { |i| d[i*y][i*x%d[0].length] == TREE } }.inject(:*)
end

part_1_slopes = [[3, 1]]
part_2_slopes = [[1, 1], [3, 1], [5, 1], [7, 1], [1, 2]]

puts "Part 1 (readable): #{readable(DATA, part_1_slopes)}"
puts "Part 1 (golf): #{golf(DATA, part_1_slopes)}"
puts
puts "Part 2 (readable): #{readable(DATA, part_2_slopes)}"
puts "Part 2 (golf): #{golf(DATA, part_2_slopes)}"
