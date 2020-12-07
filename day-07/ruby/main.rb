# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n")

class BagRules
  def initialize(data)
    @graph = parse_rule_data(data)
  end

  def find_containers(*contents)
    found_containers = contents + find_immediate_containers_of(contents)
    return found_containers if found_containers == contents

    find_containers(*found_containers)
  end

  def count_contents_of(container)
    return 0 if @graph[container].nil? || @graph[container].empty?

    @graph[container].map do |content, count|
      count + count * count_contents_of(content)
    end.inject(:+)
  end

  private

  RULE_DELIM = " bags contain "
  EMPTY_BAG_STR = "no other bags."
  CONTENTS_DELIM = ", "
  CONTENT_REGEX = /\A(?<count>\d+) (?<content>.*) bags?[,\.]?\Z/
  private_constant :RULE_DELIM, :EMPTY_BAG_STR, :CONTENTS_DELIM, :CONTENT_REGEX

  def parse_rule_data(data)
    data.each_with_object({}) do |rule_str, rules_hash|
      rule_str.split(RULE_DELIM).tap do |container, contents_str|
        rules_hash[container] = parse_contents_str(contents_str)
      end
    end.freeze
  end

  def parse_contents_str(contents_str)
    return {} if contents_str == EMPTY_BAG_STR

    contents_str.split(CONTENTS_DELIM).each_with_object({}) do |content_str, contents_hash|
      matches = content_str.match(CONTENT_REGEX)
      contents_hash[matches[:content]] = matches[:count].to_i
    end.freeze
  end

  def find_immediate_containers_of(contents)
    @graph.select do |container, contained|
      !contents.include?(container) && (contained.keys & contents).any?
    end.keys
  end
end

def part_1(data, target)
  BagRules.new(data).find_containers(target).count - 1
end

def part_2(data, target)
  BagRules.new(data).count_contents_of(target)
end

puts "Part 1: #{part_1(DATA, "shiny gold")}"
puts "Part 2: #{part_2(DATA, "shiny gold")}"
