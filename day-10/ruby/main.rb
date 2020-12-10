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

def valid_permutation?(list)
  contig_pairs = list.each_cons(2)

  contig_pairs.all? { |a, b| (1..MAX_GAP).include?(b - a) }
end

def valid_permutations_count(list)
  return 1 if list.size == 1

  mid_list = list[1..-2]
  perm_count = 2 ** mid_list.size

  perm_count.times.count do |perm_idx|
    perm_binary = perm_idx.to_s(2)
    kept_nums = perm_binary.chars.reverse.map { |c| c == "1" }
    mid_perm = mid_list.select.with_index { |_, idx| kept_nums[idx] }

    valid_permutation?([list.first] + mid_perm + [list.last])
  end
end

def part_2(data)
  list_partitioned_by_max_gap = full_list(data).slice_when { |a, b| b - a == MAX_GAP }

  list_partitioned_by_max_gap.map do |sublist|
    valid_permutations_count(sublist)
  end.inject(:*)
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"

#############
# Code Golf #
#############

def golf_list(list)
  [0] + list.sort + [list.max + 3]
end

def part_1_golf(data)
  golf_list(data).each_cons(2).map { |a, b| b - a }.yield_self { |c| c.count(1) * c.count(3) }
end

def perm_count(list)
  return 1 if list.size < 3

  (2**(list.size - 2)).times.map do |v|
    [list[0]] + list[1..-2].select.with_index { |_, i| v.to_s(2)[-i-1] == "1" } + [list[-1]]
  end.select { |list| list.each_cons(2).all? { |a, b| b - a < 4 } }.count
end

def part_2_golf(data)
  golf_list(data).slice_when { |a, b| b - a == 3 }.map(&method(:perm_count)).inject(:*)
end

puts "Part 1 (golf): #{part_1_golf(DATA)}"
puts "Part 2 (golf): #{part_2_golf(DATA)}"
