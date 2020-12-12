# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

class ShipNav
  DIRS = [EAST = "E", NORTH = "N", WEST = "W", SOUTH = "S"]

  attr_reader :ship, :waypoint

  def initialize(rules, dir: NORTH, waypoint: [0, 1])
    @rules = rules
    @ship = [0, 0]
    @dir_idx = DIRS.index(dir)
    @waypoint = waypoint
  end

  def sail(commands)
    commands.each do |command|
      op, count = command[0], command[1..].to_i
      rules[op].call(self, count)
    end

    self
  end

  def move_ship(vector)
    @ship = ship.zip(vector).map(&:sum)
    self
  end

  def rotate_left(n = 1)
    @dir_idx += n
    self
  end

  def rotate_right(n = 1)
    @dir_idx -= n
    self
  end

  def move_waypoint(vector)
    @waypoint = waypoint.zip(vector).map(&:sum)
    self
  end

  def swing_waypoint_left(n = 1)
    n.times { @waypoint = [-waypoint[1], waypoint[0]] }
    self
  end

  def swing_waypoint_right(n = 1)
    n.times { @waypoint = [waypoint[1], -waypoint[0]] }
    self
  end

  def east_vector(n = 1)
    [n, 0]
  end

  def north_vector(n = 1)
    [0, n]
  end

  def west_vector(n = 1)
    [-n, 0]
  end

  def south_vector(n = 1)
    [0, -n]
  end

  def dir_vector(n = 1)
    case DIRS[dir_idx % 4]
    when EAST then east_vector(n)
    when NORTH then north_vector(n)
    when WEST then west_vector(n)
    when SOUTH then south_vector(n)
    end
  end

  def waypoint_vector(n = 1)
    [waypoint[0] * n, waypoint[1] * n]
  end

  def dist_from_origin
    ship.map(&:abs).sum
  end

  private

  attr_reader :dir_idx, :rules
end

def part_1(command_list)
  rules = {
    "E" => ->(nav, n) { nav.move_ship(nav.east_vector(n)) },
    "N" => ->(nav, n) { nav.move_ship(nav.north_vector(n)) },
    "W" => ->(nav, n) { nav.move_ship(nav.west_vector(n)) },
    "S" => ->(nav, n) { nav.move_ship(nav.south_vector(n)) },
    "L" => ->(nav, n) { nav.rotate_left(n / 90) },
    "R" => ->(nav, n) { nav.rotate_right(n / 90) },
    "F" => ->(nav, n) { nav.move_ship(nav.dir_vector(n)) }
  }

  ShipNav.new(rules, dir: ShipNav::EAST).
    sail(command_list).
    dist_from_origin
end

def part_2(command_list)
  rules = {
    "E" => ->(nav, n) { nav.move_waypoint(nav.east_vector(n)) },
    "N" => ->(nav, n) { nav.move_waypoint(nav.north_vector(n)) },
    "W" => ->(nav, n) { nav.move_waypoint(nav.west_vector(n)) },
    "S" => ->(nav, n) { nav.move_waypoint(nav.south_vector(n)) },
    "L" => ->(nav, n) { nav.swing_waypoint_left(n / 90) },
    "R" => ->(nav, n) { nav.swing_waypoint_right(n / 90) },
    "F" => ->(nav, n) { nav.move_ship(nav.waypoint_vector(n)) }
  }

  ShipNav.new(rules, waypoint: [10, 1]).
    sail(command_list).
    dist_from_origin
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
