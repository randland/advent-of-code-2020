# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

def get_seat_num(seat_str)
  seat_str.gsub(/(B|R)/, "1").gsub(/(F|L)/, "0").to_i(2)
end

def part_1(data)
  data.map(&method(:get_seat_num)).max
end

def part_2(data)
  data.map(&method(:get_seat_num)).sort.tap do |seat_nums|
    seat_nums.each_with_index do |num, idx|
      return seat_nums[idx] + 1 if seat_nums[idx + 1] != seat_nums[idx] + 1
    end
  end
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
