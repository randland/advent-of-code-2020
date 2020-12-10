# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n").map(&:to_i)

def full_list(list)
  sorted_list = list.sort
  [0] + sorted_list + [sorted_list[-1] + 3]
end

def part_1(data)
  counts = full_list(data).each_cons(2).map { |a, b| b - a }
  counts.count(1) * counts.count(3)
end

def valid_list?(list)
  list.each_cons(2).all? { |a, b| b - a <= 3 }
end

def valid_perm_count(list)
  return 1 if list.size < 3

  (2**(list.size - 2)).times.map do |change_code|
    changes = change_code.to_s(2).reverse.chars.map { |c| c == "1" }
    [list[0]] + list[1..-1].select.with_index { |num, idx| changes[idx] } + [list[-1]]
  end.select(&method(:valid_list?)).count
end

def part_2(data)
  full_list(data).slice_when { |a, b| b - a == 3 }.map(&method(:valid_perm_count)).inject(:*)
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
