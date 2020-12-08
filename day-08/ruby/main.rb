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

  def op_acc(val) @accumulator += val.to_i
    @pointer += 1
  end

  def op_jmp(val)
    @pointer += val.to_i
  end

  def op_nop(val)
    @pointer += 1
  end
end

def part_1(data)
  runner = CodeRunner.new(data)
  runner.run
rescue CodeRunner::InfiniteLoopError => ex
  runner.accumulator
end

class CodeFixer
  def initialize(program)
    @program = program.freeze
  end

  def run(&modification)
    program.length.times do |test_pointer|
      next unless test_program = apply_modification(test_pointer, &modification)

      return CodeRunner.new(test_program).run
    rescue CodeRunner::InfiniteLoopError => ex
      next
    end
  end

  private

  attr_reader :modification, :program

  def apply_modification(test_pointer, &modification)
    program.dup.tap do |test_program|
      test_program[test_pointer] = modification.call(test_program[test_pointer])

      return nil if test_program[test_pointer] == program[test_pointer]
    end
  end
end

def part_2(data)
  fixer = CodeFixer.new(data)
  fixer.run { |inst| inst.sub("jmp", "nop") } || fixer.run { |inst| inst.sub("nop", "jmp") }
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"

#############
# Code Golf #
#############

def golf_run(prog)
  acc, ptr, ran = 0, 0, []
  until ptr >= prog.length
    ran.include?(ptr) ? raise(acc.to_s) : ran << ptr
    op, val = prog[ptr].split(" ")
    case op
    when "acc" then acc += val.to_i; ptr += 1
    when "jmp" then ptr += val.to_i
    else ptr += 1
    end
  end
  acc
end

def golf_fix(prog, fixes)
  fixes.each do |from, to|
    prog.length.times do |ptr|
      next unless prog[ptr].include?(from)
      prog.dup.tap do |test|
        test[ptr] = test[ptr].sub(from, to)
        return golf_run(test)
      end
    rescue
    end
  end
end

def part_1_golf(data)
  golf_run(data)
rescue => ex
  ex.message
end

def part_2_golf(data)
  golf_fix(data, "nop" => "jmp", "jmp" => "nop")
end

puts "Part 1 (golf): #{part_1_golf(DATA)}"
puts "Part 2 (golf): #{part_2_golf(DATA)}"
