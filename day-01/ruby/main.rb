# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n").map(&:to_i)

def result_display(part_num, note, vals)
  "Part #{part_num} (#{note}): #{vals.inject(:*)}, [#{vals.join(", ")}]"
end

def naive_find(array, target, count)
  array.combination(count).find { |arr| arr.inject(:+) == target }
end

puts result_display(1, "naive", naive_find(DATA, 2020, 2))
puts result_display(2, "naive", naive_find(DATA, 2020, 3))

def iterative_find_2(array, target)
  array[0 .. -2].each_with_index do |a, idx|
    array[idx + 1 .. -1].each do |b|
      return [a, b] if a + b == target
    end
  end
end

puts result_display(1, "iterative", iterative_find_2(DATA, 2020))

def iterative_find_3(array, target)
  array[0 .. -3].each.with_index do |a, idx_a|
    array[idx_a + 1 .. -2].each.with_index do |b, idx_b|
      array[idx_a + idx_b + 2 .. -1].each do |c|
        return [a, b, c] if a + b + c == target
      end
    end
  end
end

puts result_display(2, "iterative", iterative_find_3(DATA, 2020))

def recursive_find(array, target, remaining)
  if remaining == 1
    return array.include?(target) ? [target] : nil
  end

  array.each_with_index do |num, idx|
    next if num > target

    found = recursive_find(array[idx + 1 .. -1], target - num, remaining - 1)
    return [num] + found unless found.nil?
  end

  nil
end

puts result_display(1, "recursive", recursive_find(DATA, 2020, 2))
puts result_display(2, "recursive", recursive_find(DATA, 2020, 3))
puts result_display(3, "recursive", recursive_find(DATA, 2020, 4))

#############
# Code Golf #
#############

def part_1_golf(a, t)
  a & a.map { |n| t - n unless t - n == n }
end

def part_2_golf(a, t)
  a.map { |n| [n] + part_1_golf(a - [n], t - n) }.select { |l| l.size > 1 }[0]
end

puts result_display(1, "golf", part_1_golf(DATA, 2020))
puts result_display(2, "golf", part_2_golf(DATA, 2020))
