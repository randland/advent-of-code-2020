# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n\n")

def parse_passports(data)
  data.map do |row|
    Hash[row.split(/\s/).map { |tuple| tuple.split(":") }]
  end
end

def part_1(data, required_fields)
  parse_passports(data).count { |passport| (required_fields - passport.keys).empty? }
end

def part_2(data, field_requirements)
  parse_passports(data).count do |passport|
    next if (field_requirements.keys - passport.keys).any?

    field_requirements.all? { |field, req| req.call(passport[field]) }
  end
end

part_1_fields = %w{byr iyr eyr hgt hcl ecl pid}
puts "Part 1: #{part_1(DATA, part_1_fields)}"

part_2_constraints = {
  byr: ->(byr) { byr.length == 4 && (1920..2002).include?(byr.to_i) },
  iyr: ->(iyr) { iyr.length == 4 && (2010..2020).include?(iyr.to_i) },
  eyr: ->(eyr) { eyr.length == 4 && (2020..2030).include?(eyr.to_i) },
  hgt: ->(hgt) { hgt =~ /\A\d{2,3}(cm|in)\Z/ &&
                 ($1 == "cm" ? (150..193) : (59..76)).include?(hgt.to_i) },
  hcl: ->(hcl) { hcl =~ /\A#[\da-f]{6}\Z/ },
  ecl: ->(ecl) { ecl =~ /\A(amb|blu|brn|gry|grn|hzl|oth)\Z/ },
  pid: ->(pid) { pid =~ /\A\d{9}\Z/ }
}.transform_keys(&:to_s)
puts "Part 2: #{part_2(DATA, part_2_constraints)}"
