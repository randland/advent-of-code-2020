# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

PASS_REGEX = /\A(?<crit_a>\d+)-(?<crit_b>\d+) (?<char>\w): (?<pass>\w+)\Z/

def extract_row(row)
  row.match(PASS_REGEX).named_captures.yield_self do |captures|
    [captures["crit_a"].to_i, captures["crit_b"].to_i, captures["char"], captures["pass"]]
  end
end

def part_1(data)
  data.map(&method(:extract_row)).select do |crit_a, crit_b, char, pass|
    (crit_a..crit_b).include?(pass.count(char))
  end
end

def part_2(data)
  data.map(&method(:extract_row)).select do |crit_a, crit_b, char, pass|
    [pass[crit_a - 1], pass[crit_b - 1]].count(char) == 1
  end
end

puts "Part 1: #{part_1(DATA).count}"
puts "Part 2: #{part_2(DATA).count}"

#############
# Code Golf #
#############

GOLF_REGEX = /\A(\d+)-(\d+) (\w): (\w+)\Z/

def part_1_golf(d)
  d.select { |r| r =~ GOLF_REGEX && ($1.to_i..$2.to_i).include?($4.count($3)) }
end

def part_2_golf(d)
  d.select { |r| r =~ GOLF_REGEX && [$4[$1.to_i-1], $4[$2.to_i-1]].count($3) == 1 }
end

puts "Part 1 (golf): #{part_1_golf(DATA).count}"
puts "Part 2 (golf): #{part_2_golf(DATA).count}"
