# frozen_string_literal: true

INPUT_1 = File.read(ARGV[0] || "day-14/input.ex1.txt")
INPUT_2 = File.read(ARGV[1] || ARGV[0] || "day-14/input.ex2.txt")

def part_1(data)
  result = {}
  mask = nil
  data.split("\n").each do |row|
    if row =~ /\Amem\[(\d*)\] = (\d*)\z/
      loc = $1
      input  = $2.to_i.to_s(2).chars
      output = mask.reverse.zip(input.reverse).map { |m, i| m || i || 0 }.join.reverse.to_i(2)
      result[loc] = output
    else
      mask = row.split(" = ").last.chars.map { |c| c.to_i unless c == "X" }
    end
  end

  result.values.sum
end

def dec_perm(chars)
  perms = 2 ** chars.count("X")
  indicies = chars.each_index.select { |i| chars.reverse[i] == "X" }

  perms.times.map do |perm_code|
    short_mask = perm_code.to_s(2).rjust(20, "0").chars
    map = Hash[indicies.zip(short_mask.reverse)]
    chars.reverse.map.with_index { |c, idx| map[idx] || c }
  end.map(&:reverse).map(&:join)
end

def part_2(data)
  mem = {}
  mask = nil
  data.split("\n").each do |row|
    if row =~ /\Amem\[(\d*)\] = (\d*)\z/
      address_bin = $1.to_i.to_s(2).chars
      input  = $2.to_i.to_s(2).chars
      applied_mask = mask.reverse.zip(address_bin.reverse).map { |m, i| m == "0" ? (i || "0") : m }.reverse
      dec_perm(applied_mask).count
      dec_perm(applied_mask).each do |address|
        mem[address.to_i(2)] = input.join.to_i(2)
      end
    else
      mask = row.split(" = ").last.chars
    end
  end

  mem.values.sum
end

puts "Part 1: #{part_1(INPUT_1)}"
puts "Part 2: #{part_2(INPUT_2)}"

# >> Part 1: 165
# >> Part 2: 208
