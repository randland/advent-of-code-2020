# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n").map(&:to_i)

def naive_find(array, target, count)
  array.combination(count).find { |arr| arr.inject(:+) == target }
end

def iterative_find_2(array, target)
  array[0 .. -2].each_with_index do |a, idx|
    array[idx + 1 .. -1].each do |b|
      return [a, b] if a + b == target
    end
  end
end

def iterative_find_3(array, target)
  array[0 .. -3].each.with_index do |a, idx_a|
    array[idx_a + 1 .. -2].each.with_index do |b, idx_b|
      array[idx_a + idx_b + 2 .. -1].each do |c|
        return [a, b, c] if a + b + c == target
      end
    end
  end
end

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

def rec_find(a, t, r)
  return (a.include?(t) ? [t] : nil) if r == 1
  a.each_with_index do |n, i|
    n <= t && rec_find(a[i+1..-1], t-n, r-1).yield_self { |f| !f.nil? and return([n]+f) }
  end && nil
end

def result_display(part_num, note, vals)
  "Part #{part_num} (#{note}): #{vals.inject(:*)} (#{vals.join(", ")})"
end

puts result_display(1, "naive", naive_find(DATA, 2020, 2))
puts result_display(1, "iterative", iterative_find_2(DATA, 2020))
puts result_display(1, "recursive", recursive_find(DATA, 2020, 2))
puts result_display(1, "golf", rec_find(DATA, 2020, 2))
puts
puts result_display(2, "naive", naive_find(DATA, 2020, 3))
puts result_display(2, "iterative", iterative_find_3(DATA, 2020))
puts result_display(2, "recursive", recursive_find(DATA, 2020, 3))
puts result_display(2, "golf", rec_find(DATA, 2020, 3))
