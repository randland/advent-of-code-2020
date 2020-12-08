# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

class CodeRunner
  InfiniteLoopError = Class.new(StandardError)

  attr_reader :accumulator

  def initialize(program)
    @accumulator = 0
    @program = program
    @pointer = 0
    @ran_pointers = []
  end

  def run
    loop do
      break if pointer >= program.length
      raise InfiniteLoopError if ran_pointers.include?(pointer)
      ran_pointers << pointer

      op, val = program[pointer].split(" ")
      send("op_#{op}", val)
    end

    accumulator
  end

  private

  attr_accessor :program, :pointer, :ran_pointers

  def op_acc(val)
    @accumulator += val.to_i
    @pointer += 1
  end

  def op_jmp(val)
    @pointer += val.to_i
  end

  def op_nop(val)
    @pointer += 1
  end
end

def attempt_fix(data, broken_pointer)
  result = data.clone
  op, val = result[broken_pointer].split(" ")

  case op
  when "jmp"
    result[broken_pointer] = "nop #{val}"
  when "nop"
    result[broken_pointer] = "jmp #{val}"
  else
    return nil
  end

  result
end

def part_1(data)
  runner = CodeRunner.new(data)
  runner.run
rescue CodeRunner::InfiniteLoopError => ex
  runner.accumulator
end

def part_2(data)
  data.length.times do |broken_pointer|
    fix_attempt = attempt_fix(data, broken_pointer)
    next if fix_attempt.nil?

    runner = CodeRunner.new(fix_attempt)
    runner.run
    return runner.accumulator
  rescue CodeRunner::InfiniteLoopError => ex
    next
  end
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"
