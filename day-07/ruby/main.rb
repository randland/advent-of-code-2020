# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

class BagRules
  def initialize(data)
    @graph = parse_rule_data(data)
  end

  def all_possible_containers_of(*contents)
    new_containers = new_containers_of(contents)
    return contents if new_containers.empty?

    all_possible_containers_of(*contents + new_containers)
  end

  def count_contents_of(container)
    return 0 if @graph[container].nil? || @graph[container].empty?

    @graph[container].map do |content, count|
      count * (1 + count_contents_of(content))
    end.inject(:+)
  end

  private

  def parse_rule_data(data)
    data.inject({}) do |rules_hash, rule_str|
      container, contents_str = rule_str.split(" bags contain ")
      rules_hash.merge(container => parse_contents_str(contents_str))
    end.freeze
  end

  def parse_contents_str(contents_str)
    return {} if contents_str == "no other bags."

    contents_str.split(", ").map do |content_str|
      content_str =~ (/\A(\d+) (.*) bag/)
      { $2 => $1.to_i }
    end.inject(&:merge).freeze
  end

  def new_containers_of(contents)
    @graph.select do |container, contained|
      !contents.include?(container) && (contents & contained.keys).any?
    end.keys
  end
end

def part_1(data, target)
  BagRules.new(data).all_possible_containers_of(target).count - 1
end

def part_2(data, target)
  BagRules.new(data).count_contents_of(target)
end

puts "Part 1: #{part_1(DATA, "shiny gold")}"
puts "Part 2: #{part_2(DATA, "shiny gold")}"

#############
# Code Golf #
#############

def parse_rules(rs)
  rs.map do |r|
    b, c = r.gsub(/ bags?/, "").split(" contain ")
    { b => Hash[c.scan(/(\d+) ([^,]+)[,\.]/).map(&:reverse)].transform_values(&:to_i) }
  end.inject(&:merge)
end

def part_1_golf(d, t)
  parse_rules(d).yield_self do |r|
    f = [t]
    loop do
      n = (f + r.select { |b, c| (c.keys & f).any? }.keys).uniq
      f == n ? break : f = n
    end
    f.count
  end - 1
end

def golf_count(r, b)
  1 + (r[b]&.sum { |c, n| n * golf_count(r, c) } || 0)
end

def part_2_golf(d, t)
  parse_rules(d).yield_self { |r| golf_count(r, t) } - 1
end

puts "Part 1 (golf): #{part_1_golf(DATA, "shiny gold")}"
puts "Part 2 (golf): #{part_2_golf(DATA, "shiny gold")}"
