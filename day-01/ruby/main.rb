# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n").map(&:to_i)

def part_1(target)
  DATA[0..-2].each_with_index do |a, idx|
    DATA[idx+1..-1].each do |b|
      return "#{a * b} (#{a}, #{b})" if a + b == target
    end
  end
end

def part_2(target)
  DATA[0..-3].each.with_index do |a, idx_a|
    DATA[idx_a+1..-2].each.with_index do |b, idx_b|
      DATA[idx_a+idx_b+2..-1].each do |c|
        return "#{a * b * c} (#{a}, #{b}, #{c})" if a + b + c == target
      end
    end
  end
end

puts "Part 1: #{part_1(2020)}"
puts "Part 2: #{part_2(2020)}"
