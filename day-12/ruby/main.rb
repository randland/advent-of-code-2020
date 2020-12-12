# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

class ShipNav
  DIRS = %w[E N W S]

  attr_reader :ship, :waypoint

  def initialize(rules, ship: [0, 0], dir: "E", waypoint: [10, 1])
    @rules = rules
    @ship = ship
    @dir_idx = DIRS.index(dir)
    @waypoint = waypoint
  end

  def sail(commands)
    commands.map(&method(:parse_command)).each { |op, count| rules[op].call(self, count) }
    self
  end

  def move_ship(*deltas)
    @ship = ship.zip(deltas).map(&:sum)
    self
  end

  def move_waypoint(*deltas)
    @waypoint = waypoint.zip(deltas).map(&:sum)
    self
  end

  def rotate_left
    @dir_idx += 1
    @waypoint = [-waypoint[1], waypoint[0]]
    self
  end

  def rotate_right
    @dir_idx -= 1
    @waypoint = [waypoint[1], -waypoint[0]]
    self
  end

  def dir
    DIRS[dir_idx % 4]
  end

  def dist
    ship.map(&:abs).sum
  end

  private

  attr_reader :dir_idx, :rules

  def parse_command(command)
    [command[0], command[1..].to_i]
  end
end

def part_1(data)
  rules = {
    "E" => ->(nav, n) { nav.move_ship(n, 0) },
    "N" => ->(nav, n) { nav.move_ship(0, n) },
    "W" => ->(nav, n) { nav.move_ship(-n, 0) },
    "S" => ->(nav, n) { nav.move_ship(0, -n) },
    "L" => ->(nav, n) { (n / 90).times { nav.rotate_left } },
    "R" => ->(nav, n) { (n / 90).times { nav.rotate_right } },
    "F" => ->(nav, n) { rules[nav.dir].call(nav, n) }
  }

  ShipNav.new(rules, dir: "E").sail(data).dist
end

def part_2(data)
  rules = {
    "E" => ->(nav, n) { nav.move_waypoint(n, 0) },
    "N" => ->(nav, n) { nav.move_waypoint(0, n) },
    "W" => ->(nav, n) { nav.move_waypoint(-n, 0) },
    "S" => ->(nav, n) { nav.move_waypoint(0, -n) },
    "L" => ->(nav, n) { (n / 90).times { nav.rotate_left } },
    "R" => ->(nav, n) { (n / 90).times { nav.rotate_right } },
    "F" => ->(nav, n) { n.times { nav.move_ship(*nav.waypoint) } }
  }

  ShipNav.new(rules, waypoint: [10, 1]).sail(data).dist
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"

#############
# Code Golf #
#############

def part_1_golf(l)
  x, y, d, ds, ms = 0, 0, 0, %w[E N W S], {
    "E" => ->(n) { x += n },
    "N" => ->(n) { y += n },
    "W" => ->(n) { x -= n },
    "S" => ->(n) { y -= n },
    "L" => ->(n) { d += n / 90 },
    "R" => ->(n) { d -= n / 90 },
    "F" => ->(n) { ms[ds[d % 4]].(n) }
  }

  l.each { |c| ms[c[0]].(c[1..].to_i) }

  x.abs + y.abs
end

def part_2_golf(l)
  x, y, a, b, ms = 0, 0, 10, 1, {
    "E" => ->(n) { a += n },
    "N" => ->(n) { b += n },
    "W" => ->(n) { a -= n },
    "S" => ->(n) { b -= n },
    "L" => ->(n) { (n / 90).times { a, b = -b, a } },
    "R" => ->(n) { (n / 90).times { a, b = b, -a } },
    "F" => ->(n) { x, y = x+a*n, y+b*n }
  }

  l.each { |c| ms[c[0]].(c[1..].to_i) }

  x.abs + y.abs
end

puts "Part 2 (golf): #{part_1_golf(DATA)}"
puts "Part 2 (golf): #{part_2_golf(DATA)}"
