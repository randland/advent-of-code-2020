# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

class PassRow
  PASS_REGEX = /\A(?<crit_a>\d+)-(?<crit_b>\d+) (?<char>\w): (?<password>\w+)\Z/

  attr_reader :crit_a, :crit_b, :char, :password

  def initialize(row)
    row.match(PASS_REGEX).tap do |matches|
      @crit_a = matches[:crit_a].to_i
      @crit_b = matches[:crit_b].to_i
      @char = matches[:char]
      @password = matches[:password]
    end
  end
end

def part_1(data)
  data.map(&PassRow.method(:new)).select do |row|
    (row.crit_a..row.crit_b).include?(row.password.count(row.char))
  end
end

def part_2(data)
  data.map(&PassRow.method(:new)).select do |row|
    [row.crit_a, row.crit_b].map { |idx| row.password[idx - 1] }.count(row.char) == 1
  end
end

puts "Part 1: #{part_1(DATA).count}"
puts "Part 2: #{part_2(DATA).count}"
