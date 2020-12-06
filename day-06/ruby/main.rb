# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n\n")

def parse_group(group)
  group.split("\n").map { |row| row.split("").uniq }
end

def part_1(data)
  data.map(&method(:parse_group)).map { |group| group.flatten.uniq.count }.inject(:+)
end

def part_2(data)
  data.map(&method(:parse_group)).map { |group| group.inject(:&).count }.inject(:+)
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
