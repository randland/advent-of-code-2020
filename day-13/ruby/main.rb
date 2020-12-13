# frozen_string_literal: true

INPUT = File.read(ARGV[0] || "day-13/input.txt")

def part_1(data)
  start, buses = data.split("\n")
  start = start.to_i
  buses = buses.split(",").map(&:to_i) - [0]

  bus_hash = buses.inject({}) { |hash, bus| hash.merge(bus => start + (bus - start % bus)) }
  bus_hash.invert[bus_hash.values.min] * (bus_hash.values.min - start)
end

def comb_period(a, a_d, b, b_d)
  gcd, s = ext_gcd(a, b)
  diff = a_d - b_d
  q = diff / gcd
  c = a / gcd * b
  cd = (a_d - s*q*a) % c
  [c, cd]
end

def ext_gcd(r0, r1, s0 = 1, s1 = 0, t0 = 0, t1 = 1)
  begin
    q, r = r0.divmod(r1)
    r0, r1 = r1, r
    s0, s1 = s1, s0 - q*s1
    t0, t1 = t1, t0 - q*t1
  end until r1 == 0

  [r0, s0]
end

def part_2(data)
  buses = data.split("\n").last.split(",").map(&:to_i)
  buses.each_with_index.inject([1, 0]) do |period, (bus, offset)|
    next period if bus == 0
    comb_period(period[0], period[1], bus, -offset)
  end.last
end

puts "Part 1: #{part_1(INPUT)}"
puts "Part 2: #{part_2(INPUT)}"

# >> Part 1: 2215
# >> Part 2: 1058443396696792
