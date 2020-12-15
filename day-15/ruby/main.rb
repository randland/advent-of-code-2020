# frozen_string_literal: true

INPUT_1 = File.read(ARGV[0] || "day-15/input.ex1.txt")
INPUT_2 = File.read(ARGV[1] || ARGV[0] || "day-15/input.ex1.txt")

def part_1(data, count)
  data.split(",").map(&:to_i).tap do |list|
    while list.size < count
      last_idx = list.reverse[1..].index(list.last)
      list << (last_idx&.succ || 0)
    end
  end.last
end

def part_2(data, count)
  list = data.split(",").map(&:to_i)
  speak = (list.reverse[1..].index(list.last)&.succ || 0)
  idx = list.size + 1

  play_memo = list.each_index.each_with_object({}) do |idx, memo|
    num = list[idx]
    memo[num] ||= []
    memo[num] << idx + 1
  end

  while idx < count
    last_idx = play_memo[speak]&.last
    if last_idx.nil?
      play_memo[speak] = [idx]
      speak = 0
    else
      play_memo[speak] << idx
      play_memo[speak] = play_memo[speak][-2..]
      speak = idx - last_idx
    end
    idx += 1
  end

  speak
end

puts "Part 1: #{part_1(INPUT_1, 2020)}"
puts "Part 2: #{part_2(INPUT_2, 2020)}"
# puts "Part 2: #{part_2(INPUT_2, 30_000_000)}"

##############
## Code Golf #
##############

def part_1_golf(d, c)
  d.split(",").map(&:to_i).tap { |l| l << (l.reverse[1..].index(l.last)&.succ || 0) while l.size < c }.last
end

def part_2_golf(d, c)
  l = d.split(",").map(&:to_i)
  s = l.reverse[1..].index(l[-1])&.succ || 0
  h = l.each_index.inject({}) { |m, i| m.merge(l[i] => [i]) }
  (h.size...c-1).each { |i| h[s]&.last.tap { |o| h[s], s = (o.nil? ? [[i], 0] : [[h[s][1], i], i - o]) } }
  s
end

puts "Part 1 (golf): #{part_1_golf(INPUT_1, 2020)}"
puts "Part 2 (golf): #{part_2_golf(INPUT_2, 2020)}"
# puts "Part 2 (golf): #{part_2_golf(INPUT_2, 30_000_000)}"

require "benchmark"

Benchmark.realtime do
  5000.times do
    part_2_golf(INPUT_2, 2020)
  end
end # => 4.358302999986336

Benchmark.realtime do
  5000.times do
    part_2_golf_trim(INPUT_2, 2020)
  end
end # => 4.539112999977078

# >> Part 1: 436
# >> Part 2: 436
# >> Part 1 (golf): 436
# >> Part 2 (golf): 436
