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
  data.map(&method(:get_seat_num)).sort.each_cons(2) do |seat_a, seat_b|
    return seat_a + 1 if seat_b != seat_a + 1
  end
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"

#############
# Code Golf #
#############

def part_2_golf(data)
  data.map(&method(:get_seat_num)).sort.each_cons(2) { |a, b| return a + 1 if b - a > 1 }
end

puts "Part 2 (golf): #{part_2_golf(DATA)}"
