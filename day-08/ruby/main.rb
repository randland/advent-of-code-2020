# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

class CodeRunner
  attr_reader :accumulator

  def initialize(program)
    @accumulator = 0
    @program = program
    @ptr = 0
    @ran_ptrs = []
  end

  def run
    until ptr >= program.count
      return if ran_ptrs.include?(ptr)
      op, val = program[ptr].split(" ")
      ran_ptrs << ptr

      case op
      when "acc"
        @accumulator += val.to_i
        @ptr += 1
      when "jmp"
        @ptr += val.to_i
      when "nop"
        @ptr += 1
      else
        raise "WTF"
      end
    end

    accumulator
  end

  private

  attr_reader :ptr, :program, :ran_ptrs
end

def attempt_fix(data, broken_ptr)
  result = data.clone
  op, val = result[broken_ptr].split(" ")

  case op
  when "jmp"
    result[broken_ptr] = "nop #{val}"
  when "nop"
    result[broken_ptr] = "jmp #{val}"
  else
    return nil
  end

  result
end

def part_1(data)
  runner = CodeRunner.new(data)
  runner.run
  runner.accumulator
end

def part_2(data)
  data.count.times do |broken_ptr|
    next if (fix = attempt_fix(data, broken_ptr)).nil?

    result = CodeRunner.new(fix).run
    return result unless result.nil?
  end
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
