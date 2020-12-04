# frozen_string_literal: true

INPUT = File.read(ARGV[0])
DATA = INPUT.split("\n\n")

def parse_data_into_passport_hashes(data)
  data.map { |row| Hash[row.gsub("\n", " ").split(" ").map { |tuple| tuple.split(":") }] }
end

def part_1(data, *required_fields)
  parse_data_into_passport_hashes(data).count do |passport|
    ([required_fields].flatten - passport.keys).empty?
  end
end

def part_2(data, **field_requirements)
  parse_data_into_passport_hashes(data).count do |passport|
    if (field_requirements.keys.map(&:to_s) - passport.keys).any?
      false
    else
      field_requirements.all? { |field, req| req.call(passport[field.to_s]) }
    end
  end
end

part_1_fields = %w{byr iyr eyr hgt hcl ecl pid}
puts "Part 1: #{part_1(DATA, part_1_fields)}"

part_2_constraints = {
  byr: ->(byr) { byr.length == 4 && (1920..2002).include?(byr.to_i) },
  iyr: ->(iyr) { iyr.length == 4 && (2010..2020).include?(iyr.to_i) },
  eyr: ->(eyr) { eyr.length == 4 && (2020..2030).include?(eyr.to_i) },
  hgt: ->(hgt) { hgt.match(/\A\d{2,3}(cm|in)\Z/) && ($1 == "cm" ? (150..193) : (59..76)).include?(hgt.to_i) },
  hcl: ->(hcl) { hcl.match(/\A#[0-9a-f]{6}\Z/) },
  ecl: ->(ecl) { ecl.match(/\A(amb|blu|brn|gry|grn|hzl|oth)\Z/) },
  pid: ->(pid) { pid.match(/\A[0-9]{9}\Z/) }
}
puts "Part 2: #{part_2(DATA, part_2_constraints)}"
