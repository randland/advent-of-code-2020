# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")


def generate_graph(data)
  data.each_with_object({}) do |rule, graph|
    color, contents = rule.match(/\A(.*) bags contain (.*)\.\Z/).captures
    graph[color] = extract_contents(contents)
  end
end

def extract_contents(contents)
  return {} if contents == "no other bags"

  contents.split(", ").inject({}) do |results, bag_str|
    bag_str.match(/\A(\d+) (.*) bags?\Z/)
    results.merge($2 => $1.to_i)
  end
end

def extract_containers(graph, targets)
  (targets + graph.select { |color, containers| (containers.keys & targets).any? }.keys).uniq
end

def part_1(data, target)
  graph = generate_graph(data)

  containers = [target]
  container_containers = extract_containers(graph, containers)

  while containers != container_containers
    containers = container_containers
    container_containers = extract_containers(graph, containers)
  end

  containers.count - 1
end

def count_contents(graph, target)
  return 0 if graph[target].empty?

  graph[target].map { |color, count| count + count * count_contents(graph, color) }.inject(:+)
end

def part_2(data, target)
  count_contents(generate_graph(data), target)
end

puts "Part 1: #{part_1(DATA, "shiny gold")}"
puts "Part 2: #{part_2(DATA, "shiny gold")}"
