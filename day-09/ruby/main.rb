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
  list.each_index do |idx|
    size = 1
    begin 
      size += 1
      sublist = list[idx, size]
    end while sublist.inject(:+) < target
    return sublist if sublist.inject(:+) == target
  end
end

def part_2(data)
  find_contig_list(data.map(&:to_i), part_1(data)).tap { |result| return result.min + result.max }
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
