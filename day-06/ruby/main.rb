# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n\n")

def part_1(data)
  data.sum { |group| group.split("\n").map(&:chars).flatten.uniq.count }
end

def part_2(data)
  data.sum { |group| group.split("\n").map(&:chars).inject(:&).count }
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
