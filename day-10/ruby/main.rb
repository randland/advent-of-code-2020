# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n").map(&:to_i)

MAX_GAP = 3

def full_list(list)
  sorted_list = list.sort

  [0] + sorted_list + [sorted_list.last + MAX_GAP]
end

def part_1(data)
  counts = Hash.new { 0 }
  contig_pairs = full_list(data).each_cons(2)
  contig_pairs.each { |a, b| counts[b - a] += 1 }

  counts[1] * counts[3]
end

def part_2(data)
  perm_counts = { 0 => 1 }
  list = full_list(data)[1..-1]

  list.each do |plug|
    possible_prevs = (1..MAX_GAP).map { |diff| plug - diff }
    perm_counts[plug] = perm_counts.slice(*possible_prevs).values.sum
  end

  perm_counts.values.last
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"

#############
# Code Golf #
#############

def part_1_golf(l)
  ([0] + l.sort + [l.max + 3]).each_cons(2).map { |a, b| b - a }.yield_self { |c| c.count(1) * c.count(3) }
end

def part_2_golf(l)
  (l.sort + [l.max + 3]).inject({ 0 => 1 }) { |o, e| o.merge(e => (e-3...e).sum { |i| o[i] || 0 }) }.values.last
end

puts "Part 1 (golf): #{part_1_golf(DATA)}"
puts "Part 2 (golf): #{part_2_golf(DATA)}"
