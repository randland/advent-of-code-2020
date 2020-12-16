# frozen_string_literal: true

INPUT_1 = File.read(ARGV[0] || "day-16/input.ex1.txt")
INPUT_2 = File.read(ARGV[1] || ARGV[0] || "day-16/input.ex1.txt")

class TicketProblem
  RULE_REGEX = /\A([^:]*): (\d+)-(\d+) or (\d+)-(\d+)\z/

  attr_reader :rules, :ticket, :other_tickets

  def initialize(data, other_tickets: nil)
    parse_data(data)
  end

  def invalid_values
    other_tickets.map(&method(:invalid_values_for)).flatten.compact
  end

  def discard_invalid_tickets
    @other_tickets.reject! { |t| (t & invalid_values).any?  }
  end

  def determine_ticket_layout
    unknown_fields = rules.keys
    unknown_indices = (0...rules.size).to_a
    field_map = {}

    while unknown_fields.any?
      unknown_fields.each do |field|
        idxs = unknown_indices.select do |idx|
          values = all_values_at(idx)
          values.all? { |val| rules[field].any? { |range| range.include?(val) } }
        end

        if idxs.size == 1
          field_map[field] = idxs.first
          unknown_fields.delete(field)
          unknown_indices.delete(idxs.first)
        end
      end
    end

    field_map
  end

  private

  def parse_data(data)
    raw_rules, raw_ticket, raw_other_tickets = data.split("\n\n")
    @rules = parse_rules(raw_rules)
    @ticket = parse_ticket(raw_ticket)
    @other_tickets = parse_other_tickets(raw_other_tickets)
  end

  def parse_rules(raw_rules)
    @rules = raw_rules.split("\n").each_with_object({}) do |row, rule_hash|
      name, range_1_min, range_1_max, range_2_min, range_2_max = row.match(RULE_REGEX).captures
      rule_hash[name] = [(range_1_min.to_i..range_1_max.to_i),
                         (range_2_min.to_i..range_2_max.to_i)]
    end
  end

  def parse_ticket(raw_ticket)
    raw_ticket.split("\n")[1].split(",").map(&:to_i)
  end

  def parse_other_tickets(raw_other_tickets)
    raw_other_tickets.split("\n")[1..].map { |t| t.split(",").map(&:to_i) }
  end

  def invalid_values_for(ticket)
    ticket.select do |val|
      rules.values.flatten.none? do |range|
        range.include?(val)
      end
    end
  end

  def all_values_at(idx)
    [ticket[idx]] + other_tickets.map { |t| t[idx] }
  end
end

def part_1(data)
  TicketProblem.new(INPUT_1).invalid_values.sum
end

def part_2(data)
  ticket_problem = TicketProblem.new(INPUT_1)
  ticket_problem.discard_invalid_tickets
  layout = ticket_problem.determine_ticket_layout
  keys = layout.keys.select { |k| k =~ /\Adeparture/ }
  values = layout.slice(*keys).values.map { |idx| ticket_problem.ticket[idx] }
  values.inject(:*)
end

puts "Part 1: #{part_1(INPUT_1)}"
puts "Part 2: #{part_2(INPUT_2)}"

##############
## Code Golf #
##############

def part_1_golf(d)
  rr, rt, ro = d.split("\n\n").map { |s| s.split("\n") }
  r = rr.map do |row|
    row =~ / (.*)-(.*) or (.*)-(.*)\z/
    [($1.to_i..$2.to_i), ($3.to_i..$4.to_i)]
  end.flatten
  ro[1..].map { |row| row.split(",").map(&:to_i) }.flatten.
    select { |n| r.none? { |ra| ra.include?(n) } }.sum
end

def part_2_golf(d)
  rr, rt, ro = d.split("\n\n").map { |s| s.split("\n") }
  r = rr.each.inject({}) do |m, row|
    row =~ /\A(.*): (.*)-(.*) or (.*)-(.*)\z/
    m.merge($1 => [($2.to_i..$3.to_i), ($4.to_i..$5.to_i)])
  end
  o = ro[1..].map { |row| row.split(",").map(&:to_i) }.
      select { |p| p.all? { |v| r.values.flatten.any? { |ra| ra.include?(v) } } }
  a = [rt[1].split(",").map(&:to_i)] + o
  uk, ui, f = r.keys, (0...r.size).to_a, {}
  while uk.any?
    uk.each do |k|
      is = ui.select { |i| a.map { |l| l[i] }.all? { |v| r[k].any? { |ra| ra.include?(v) } } }
      if is.size == 1
        f[k] = ui.delete(is[0])
        uk.delete(k)
      end
    end
  end
  f.select { |k, _| k =~ /\Adeparture/}.map { |_, v| o[0][v] }.inject(:*)
end

puts "Part 1 (golf): #{part_1_golf(INPUT_1)}"
puts "Part 2 (golf): #{part_2_golf(INPUT_2)}"

# >> Part 1: 71
# >> Part 2: 
# >> Part 1 (golf): 71
# >> Part 2 (golf): 
