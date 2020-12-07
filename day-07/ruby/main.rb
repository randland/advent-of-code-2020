# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

class BagRules
  def initialize(data)
    @graph = parse_rule_data(data)
  end

  def all_possible_containers_of(*contents)
    found_containers = contents + immediate_containers_of(contents)
    return found_containers if found_containers == contents

    all_possible_containers_of(*found_containers)
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

    contents_str.split(", ").inject({}) do |contents_hash, content_str|
      content_str.match(/\A(\d+) (.*) bag/)
      contents_hash.merge($2 => $1.to_i)
    end.freeze
  end

  def immediate_containers_of(contents)
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
