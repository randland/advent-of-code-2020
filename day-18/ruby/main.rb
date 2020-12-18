# frozen_string_literal: true

INPUT_1 = File.read(ARGV[0] || "day-18/input.ex1.txt")
INPUT_2 = File.read(ARGV[1] || ARGV[0] || "day-18/input.ex1.txt")

def collapse_parens(eq, &solver)
  first = eq.index("(")
  last = find_matching_paren(eq, first)
  "#{eq[0...first]}#{solver.call(eq[first+1...last])}#{eq[last+1..]}"
end

def find_matching_paren(str, first_idx = 0)
  depth = 1
  idx = first_idx

  while depth > 0
    idx += 1
    depth += 1 if str[idx] == "("
    depth -= 1 if str[idx] == ")"
  end

  idx
end

def collapse_leftmost(eq)
  eq =~ /\A(\d+)([+*])(\d+)([^\d].*)?\z/
  num_1, op, num_2, right_eq = $1.to_i, $2, $3.to_i, $4
  case op
  when "+" then "#{num_1 + num_2}#{right_eq}"
  when "*" then "#{num_1 * num_2}#{right_eq}"
  else eq
  end
end

def solve_part_1(eq)
  return eq.to_i if eq =~ /\A\d+\z/

  eq = collapse_parens(eq, &method(:solve_part_1)) while eq.index("(")
  eq = collapse_leftmost(eq) while eq.index("+") || eq.index("*")
  eq
end

def collapse_add(eq, &solver)
  eq =~ /\A([^+]*\*)?(\d+)\+(\d+)([^\d].*)?\z/
  left_eq, num_1, num_2, right_eq = $1, $2.to_i, $3.to_i, $4
  "#{left_eq}#{num_1 + num_2}#{right_eq}"
end

def collapse_mult(eq, &solver)
  eq =~ /\A([^*]*\+)?(\d+)\*(\d+)([^\d].*)?\z/
  left_eq, num_1, num_2, right_eq = $1, $2.to_i, $3.to_i, $4
  "#{left_eq}#{num_1 * num_2}#{right_eq}"
end

def solve_part_2(eq)
  return eq if eq =~ /\A\d+\z/

  eq = collapse_parens(eq, &method(:solve_part_2)) while eq.index("(")
  eq = collapse_add(eq) while eq.index("+")
  eq = collapse_mult(eq) while eq.index("*")
  eq
end

def part_1(data)
  data.gsub(" ", "").split("\n").map(&method(:solve_part_1)).map(&:to_i).sum
end

def part_2(data)
  data.gsub(" ", "").split("\n").map(&method(:solve_part_2)).map(&:to_i).sum
end

puts "Part 1: #{part_1(INPUT_1)}"
puts "Part 2: #{part_2(INPUT_2)}"

##############
## Code Golf #
##############

def part_1_golf(d)
end

def part_2_golf(d)
end

puts "Part 1 (golf): #{part_1_golf(INPUT_1)}"
puts "Part 2 (golf): #{part_2_golf(INPUT_2)}"

# >> Part 1: 26386
# >> Part 2: 693942
# >> Part 1 (golf): 
# >> Part 2 (golf): 
