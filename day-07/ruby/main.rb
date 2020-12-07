# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

EMPTY_BAG_STR = "no other bags."
RULE_DELIM = " bags contain "
CONTENTS_DELIM = ", "
CONTENT_REGEX = /\A(?<count>\d+) (?<color>.*) bags?[,\.]?\Z/

def parse_rule_str(rule_str)
  container, contents_str = rule_str.split(RULE_DELIM)
  { container => parse_contents_str(contents_str) }
end

def parse_contents_str(contents_str)
  return {} if contents_str == EMPTY_BAG_STR

  contents_str.split(CONTENTS_DELIM).map(&method(:parse_content_str)).inject(:merge)
end

def parse_content_str(content_str)
  matches = content_str.match(CONTENT_REGEX)
  { matches[:color] => matches[:count].to_i }
end

@graph = DATA.map(&method(:parse_rule_str)).inject(:merge).freeze

def find_containers_of(contents)
  @graph.select { |container, contained| (contained.keys & contents).any? }.keys
end

def recursive_find_containers(contents)
  found_containers = (contents + find_containers_of(contents)).uniq
  return found_containers if found_containers == contents

  recursive_find_containers(found_containers)
end

def part_1(target)
  recursive_find_containers([target]).count - 1
end

def count_contents(target)
  return 0 if @graph[target].nil? || @graph[target].empty?

  @graph[target].map { |color, count| count + count * count_contents(color) }.inject(:+)
end

def part_2(target)
  count_contents(target)
end

puts "Part 1: #{part_1("shiny gold")}"
puts "Part 2: #{part_2("shiny gold")}"
