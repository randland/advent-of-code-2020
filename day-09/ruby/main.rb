# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

def first_invalid_num(list, block_size)
  (block_size...list.size).each do |idx|
    block_start = idx - block_size
    sums = list[block_start, block_size].combination(2).map { |pair| pair.inject(:+) }
    return list[idx] unless sums.include?(list[idx])
  end
end

def part_1(data)
  first_invalid_num(data.map(&:to_i), 25)
end

def find_contig_list(list, target)
  idx_a, idx_b = 0, 0
  while list[idx_a..idx_b].inject(:+) != target
    list[idx_a..idx_b].inject(:+) < target ? idx_b += 1 : idx_a += 1
  end
  list[idx_a..idx_b]
end

def part_2(data)
  find_contig_list(data.map(&:to_i), part_1(data)).tap { |result| return result.min + result.max }
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
