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

def part_1(data)
  runner = CodeRunner.new(data)
  runner.run
rescue CodeRunner::InfiniteLoopError => ex
  runner.accumulator
end

class CodeFixer
  def initialize(program, &modification)
    @program = program.freeze
    @modification = modification
  end

  def run
    program.length.times do |test_pointer|
      next unless test_program = apply_modification(test_pointer)

      return CodeRunner.new(test_program).run
    rescue CodeRunner::InfiniteLoopError => ex
      next
    end
  end

  private

  attr_reader :modification, :program

  def apply_modification(test_pointer)
    program.dup.tap do |test_program|
      test_program[test_pointer] = modification.call(test_program[test_pointer])

      return nil if test_program[test_pointer] == program[test_pointer]
    end
  end
end

def part_2(data)
  CodeFixer.new(data) { |inst| inst.sub("jmp", "nop") }.run ||
    CodeFixer.new(data) { |inst| inst.sub("nop", "jmp") }.run
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"

#############
# Code Golf #
#############

InfLoop = Class.new(StandardError)

def golf_run(prog)
  acc, ptr, ran = 0, 0, []

  until ptr >= prog.length
    ran.include?(ptr) ? raise(InfLoop, acc) : ran << ptr
    op, val = prog[ptr].split(" ")

    case op
    when "acc" then acc += val.to_i; ptr += 1
    when "jmp" then ptr += val.to_i
    else            ptr += 1
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
rescue InfLoop => ex
  ex.message
end

def part_2_golf(data)
  golf_fix(data, "nop" => "jmp", "jmp" => "nop")
end

puts "Part 1 (golf): #{part_1_golf(DATA)}"
puts "Part 2 (golf): #{part_2_golf(DATA)}"
