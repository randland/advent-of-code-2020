# frozen_string_literal: true

require 'pry'

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n").map(&:chars)

PART_1_RULES = { sit: 0, leave: 4 }
PART_2_RULES = { sit: 0, leave: 5 }

class SeatLayout
  SEAT_STATES = [EMPTY = "L", OCCUPIED = "#"]
  DIRS = [[-1, -1], [-1,  0], [-1,  1],
          [ 0, -1],           [ 0,  1],
          [ 1, -1], [ 1,  0], [ 1,  1]]

  attr_reader :data

  def initialize(data, rules:, neighbors: nil, adjacent_only: true)
    @data = data
    @rules = rules
    @adjacent_only = adjacent_only
    @neighbors = neighbors || detect_neighbor_seats

    @next_data = data.map(&:dup)
  end

  def step_until_stable
    next_layout = step
    return self if next_layout.data == data

    next_layout.step_until_stable
  end

  def step
    neighbors.each_with_index do |row, y|
      row.each_with_index do |neighbors, x|
        neighbor_count = neighbors.map { |x, y| at(x, y) }.count(OCCUPIED)

        case at(x, y)
        when EMPTY then set(x, y, OCCUPIED) if neighbor_count <= rules[:sit]
        when OCCUPIED then set(x, y, EMPTY) if neighbor_count >= rules[:leave]
        end
      end
    end

    if adjacent_only
      self.class.new(next_data, rules: rules, neighbors: neighbors)
    else
      self.class.new(next_data, rules: rules, adjacent_only: false)
    end
  end

  def occupied_count
    data.flatten.count(OCCUPIED)
  end

  private

  attr_reader :adjacent_only, :neighbors, :next_data, :rules

  def width
    data.first.size
  end

  def height
    data.size
  end

  def at(x, y)
    return if [x, y].any?(&:negative?)

    data[y]&.at(x)
  end

  def set(x, y, val)
    next_data[y][x] = val
  end

  def offset(x, y, dir, dist)
    [x + dist * dir[0],
     y + dist * dir[1] ]
  end

  def detect_neighbor_seats
    data.map.with_index do |row, y|
      row.map.with_index do |_, x|
        DIRS.map do |dir|
          spot, dist = 0, 0

          until spot.nil? || SEAT_STATES.include?(spot)
            dist += 1
            spot = at(*offset(x, y, dir, dist))
            break if adjacent_only
          end
          next if spot.nil?

          offset(x, y, dir, dist)
        end.compact
      end
    end
  end
end

def part_1(data)
  SeatLayout.new(data, rules: PART_1_RULES).step_until_stable.occupied_count
end

def part_2(data)
  SeatLayout.new(data, rules: PART_2_RULES, adjacent_only: false).step_until_stable.occupied_count
end

puts "Part 1: #{part_1(DATA)}"
puts "Part 2: #{part_2(DATA)}"

##############
## Code Golf #
##############

D = [-1, 0, 1].repeated_permutation(2)
O = "#"
E = "L"

def step(s, o)
  s == E && o < 1 ? O : s == O && o > 4 ? E : s
end

def o?(l, x, y, xd, yd, d=1)
  x+xd*d >= 0 && y+yd*d >= 0 && l[y+yd*d]&.at(x+xd*d) == O
end

def part_1_golf(l)
  n = l
  begin
    c = n
    n = c.map.with_index { |r, y| r.map.with_index { |s, x| step(s, D.count { |d| o?(c, x, y, *d) }) } }
  end while c != n
  c.flatten.count(O)
end

def part_2_golf(l)
  n = l
  begin
    c = n
    n = c.map.with_index do |r, y|
          r.map.with_index do |s, x|
            o = D.count do |xd, yd|
              xd == 0 && yd == 0 ? next : d = 0
              until x+xd*d < 0 || y+yd*d < 0
                d += 1
                break if [O, E, nil].include?(c[y+yd*d]&.at(x+xd*d))
              end 
              o?(c, x, y, xd, yd, d)
            end
            step(s, o)
          end
        end
  end while c != n
  c.flatten.count(O)
end

puts "Part 1 (golf): #{part_1_golf(DATA)}"
puts "Part 2 (golf): #{part_2_golf(DATA)}"
