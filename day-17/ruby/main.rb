# frozen_string_literal: true

INPUT_1 = File.read(ARGV[0] || "day-17/input.ex1.txt")
INPUT_2 = File.read(ARGV[1] || ARGV[0] || "day-17/input.ex1.txt")

class ConwayGame
  ON = "#"

  def self.from_initial_plane(initial_plane, dims = 2)
    result = {}
    initial_plane.split("\n").each_with_index do |row, y|
      row.split("").each_with_index do |state, x|
        next unless state == ON

        tuple = [x, y] + [0] * (dims - 2)
        result[tuple] = true
      end
    end

    new(result, dims)
  end

  def step(n = 1)
    return self if n < 1

    self.class.new(next_on_tuples, dims).step(n - 1)
  end

  def active_count
    on_tuples.size
  end

  private

  attr_reader :on_tuples, :dims

  def initialize(on_tuples, dims)
    @on_tuples = on_tuples
    @dims = dims
  end

  def next_on_tuples
    results = {}
    neighbor_counts.each do |tuple, count|
      results[tuple] = true if will_be_on?(tuple, count)
    end
   
    results
  end

  def neighbor_counts
    results = Hash.new(0)
    on_tuples.keys.each do |on_tuple|
      neighbor_locations(on_tuple).each { |neighbor| results[neighbor] += 1 }
    end

    results
  end

  def neighbor_locations(tuple)
    offsets = (-1..1).to_a.repeated_permutation(tuple.size).to_a
    offsets.delete([0] * tuple.size)

    offsets.map { |tuple_deltas| tuple.zip(tuple_deltas).map(&:sum) }
  end

  def will_be_on?(tuple, count)
    on_tuples[tuple] ? [2, 3].include?(count) : count == 3
  end
end

def part_1(data)
  ConwayGame.from_initial_plane(data, 3).step(6).active_count
end

def part_2(data)
  ConwayGame.from_initial_plane(data, 4).step(6).active_count
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

# >> Part 1: 112
# >> Part 2: 848
# >> Part 1 (golf): 
# >> Part 2 (golf): 
