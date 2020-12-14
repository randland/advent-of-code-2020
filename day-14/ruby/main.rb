# frozen_string_literal: true

INPUT_1 = File.read(ARGV[0] || "day-14/input.ex1.txt")
INPUT_2 = File.read(ARGV[1] || ARGV[0] || "day-14/input.ex2.txt")

class BitMask
  def initialize(mask)
    @rev_mask = mask.chars.reverse
  end

  def apply_to(bin, rules)
    mask_bit_pairs = rev_mask.zip(bin.chars.reverse)

    mask_bit_pairs.map do |m, b|
      rules[m].call(b)
    end.join.reverse
  end

  def mask
    rev_mask.join.reverse
  end

  private

  attr_reader :rev_mask
end

class DockingProgram
  attr_writer :mask_rules

  def initialize(code)
    @code = code.split("\n")
    @mask_rules = {}
    @memory = {}
  end

  def run(rules)
    code.each do |instruction|
      rules.each do |regex, op|
        captures = instruction.match(regex)&.captures
        next if captures.nil?

        op.call(self, *captures)
      end
    end
  end

  def mask=(mask)
    @mask = BitMask.new(mask)
  end

  def apply_mask_to(bin)
    mask.apply_to(bin, mask_rules)
  end

  def set_mem(addr, val)
    @memory[addr] = val
  end

  def get_mem(addr)
    memory[addr]
  end

  def mem_val_sum
    memory.values.map(&:to_i).sum
  end

  private

  attr_reader :code, :mask, :mask_rules, :memory
end

X = "X"
ONE = "1"
ZERO = "0"

MASK_REGEX = /mask = (.+)\z/
MEM_REGEX = /mem\[(\d+)\] = (\d+)\z/

def part_1(data)
  dock = DockingProgram.new(data)
  dock.mask_rules = {
    ZERO => ->(_)   { ZERO },
    ONE  => ->(_)   { ONE },
    X    => ->(bit) { bit || ZERO }
  }

  dock.run(
    MASK_REGEX => ->(dock, mask) do
      dock.mask = mask
    end,

    MEM_REGEX => ->(dock, addr, val) do
      bin = val.to_i.to_s(2)
      masked_bin = dock.apply_mask_to(bin)
      new_val = masked_bin.to_i(2)
      dock.set_mem(addr, new_val)
    end
  )

  dock.mem_val_sum
end

def bin_perm(bin)
  return bin if bin.index(X).nil?

  [ZERO, ONE].map do |variant|
    new_bin = bin.dup
    new_bin[X] = variant
    bin_perm(new_bin)
  end
end

def part_2(data)
  dock = DockingProgram.new(data)
  dock.mask_rules = {
    ZERO => ->(bit) { bit || ZERO },
    ONE  => ->(_)   { ONE },
    X    => ->(_)   { X }
  }

  dock.run(
    MASK_REGEX => ->(dock, mask) do
      dock.mask = mask
    end,

    MEM_REGEX => ->(dock, addr, val) do
      bin = addr.to_i.to_s(2)
      masked_bin = dock.apply_mask_to(bin)
      addrs = bin_perm(masked_bin)
      addrs.each do |addr|
        dock.set_mem(addr, val.to_i)
      end
    end
  )

  dock.mem_val_sum
end

puts "Part 1: #{part_1(INPUT_1)}"
puts "Part 2: #{part_2(INPUT_2)}"

##############
## Code Golf #
##############

X = "X"
Z = "0"
GOLF_REGEX = /mem\[(\d+)\] = (\d+)\z/

def part_1_golf(p)
  r, m = {}
  p.split("\n").each do |o|
    if o =~ GOLF_REGEX
      r[$1] = m.zip($2.to_i.to_s(2).chars.reverse).map { |n, v| n || v || Z }.join.reverse.to_i(2)
    else
      m = o.split(" = ").last.chars.reverse.map { |c| c.to_i unless c == X }
    end
  end
  r.values.sum
end

def part_2_golf(p)
  r, m = {}
  x = ->(b) { b[X] ? %w[0 1].map { |i| x.(b.dup.tap { |b0| b0[X] = i }) } : b }
  p.split("\n").each do |o|
    if o =~ GOLF_REGEX
      a, v = $1.to_i.to_s(2), $2.to_i
      x.(m.reverse.chars.zip(a.reverse.chars).map { |mp, ap| mp == Z ? (ap || Z) : mp&.to_s }.join).
        flatten.each { |b| r[b.to_i(2)] = v }
    else
      m = o.split(" = ").last
    end
  end
  r.values.sum
end

puts "Part 1 (golf): #{part_1_golf(INPUT_1)}"
puts "Part 2 (golf): #{part_2_golf(INPUT_2)}"

# >> Part 1: 165
# >> Part 2: 202
# >> Part 1 (golf): 165
# >> Part 2 (golf): 208
