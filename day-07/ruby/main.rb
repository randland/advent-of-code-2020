# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

EMPTY_BAG_STR = "no other bags."
RULE_DELIM = " bags contain "
CONTENTS_DELIM = ", "
CONTENT_REGEX = /\A(?<count>\d+) (?<color>.*) bags?[,\.]?\Z/

def generate_graph(data)
  data.each_with_object({}) do |rule_str, graph|
    container, contents_str = rule_str.split(RULE_DELIM)
    graph[container] = extract_contents(contents_str)
  end
end

def extract_contents(contents_str)
  return {} if contents_str == EMPTY_BAG_STR

  contents_str.split(CONTENTS_DELIM).each_with_object({}) do |content_str, contents|
    content_str.match(CONTENT_REGEX).tap do |matches|
      contents[matches[:color]] = matches[:count].to_i
    end
  end
end

def find_all_containers(graph, contents)
  found_containers = graph.select { |color, containers| (containers.keys & contents).any? }.keys
  all_containers = (contents + found_containers).uniq
  return contents if contents == all_containers

  find_all_containers(graph, all_containers)
end

def count_contents(graph, target)
  return 0 if graph[target].nil? || graph[target].empty?

  graph[target].map { |color, count| count + count * count_contents(graph, color) }.inject(:+)
end

def part_1(data, target)
  find_all_containers(generate_graph(data), [target]).count - 1
end

def part_2(data, target)
  count_contents(generate_graph(data), target)
end

puts "Part 1: #{part_1(DATA, "shiny gold")}"
puts "Part 2: #{part_2(DATA, "shiny gold")}"
