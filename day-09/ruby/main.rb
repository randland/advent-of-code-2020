# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n").map(&:to_i)

def first_invalid_num(list, preamble)
  (preamble...list.size).each do |idx|
    sums = list[idx - preamble, preamble].combination(2).map(&:sum)
    return list[idx] unless sums.include?(list[idx])
  end
end

def part_1(data)
  first_invalid_num(data, 25)
end

def find_contig_list(list, target)
  a, b = 0, 0
  list[a..b].sum > target ? a += 1 : b += 1 while list[a..b].sum != target
  list[a..b]
end

def part_2(data)
  find_contig_list(data, part_1(data)).yield_self { |result| result.min + result.max }
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
