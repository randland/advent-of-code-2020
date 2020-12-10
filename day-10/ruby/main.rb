# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n").map(&:to_i)

def full_list(list)
  sorted_list = list.sort
  [0] + sorted_list + [sorted_list[-1] + 3]
end

def part_1(data)
  counts = Hash.new { 0 }
  full_list(data).tap do |list|
    (list.size - 1).times { |idx| counts[list[idx + 1] - list[idx]] += 1 }
  end
  counts[1] * counts[3]
end

def valid_list?(list)
  (0...list.size - 1).map { |idx| list[idx + 1] - list[idx] }.all? { |n| n <= 3 }
end

def count_permutations(list)
  mid = list[1..-2]
  (2**mid.size).times.map do |change_code|
    changes = change_code.to_s(2).rjust(5, "0").reverse.chars.map { |c| c == "1" }
    [list[0]] + mid.select.with_index { |num, idx| changes[idx] } + [list[-1]]
  end.select(&method(:valid_list?)).count
end

def part_2(data)
  partitioned_list = full_list(data).slice_when { |a, b| b - a == 3 }
  partitioned_list.map(&method(:count_permutations)).inject(:*)
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
