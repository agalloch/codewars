require 'pry'
require 'pp'

def parse_data
  data = $data_file.dup

  location_groups = data.split("\n").reject(&:empty?)
    .chunk_while { |prev_token, next_token| prev_token != next_token }
    .map { |chunk| chunk.reject { |token| token =~ /^#+$/ } }
    .map do |chunk|
      chunk.each_with_object({}) do |token, record|
        case token
        when /^Location:/
          record[:location] = parse_location token
        when /Ammonia:/
          record[:ammonia] = parse_substance token, 'Ammonia'
        when /Nitrogen Oxide:/
          record[:nitrogen] = parse_substance token, 'Nitrogen Oxide'
        when /Carbon Monoxide:/
          record[:carbon_monoxide] = parse_substance token, 'Carbon Monoxide'
        else
        end
      end
    end.group_by { |record| record[:location] }
      .map do |location, values|
        {
          location: location,
          ammonia: values.reduce(0) { |sum, hash| sum + hash[:ammonia] },
          nitrogen: values.reduce(0) { |sum, hash| sum + hash[:nitrogen] },
          carbon_monoxide: values.reduce(0) { |sum, hash| sum + hash[:carbon_monoxide] },
        }
      end

  [
    report_amonia(location_groups),
    report_nitrogen(location_groups),
    report_carbon_monoxide(location_groups),
  ].join ' '
end

def parse_substance(token, substance)
  m = token.match /#{substance}: (\d+) particles/

  m[1].to_i if m
end

def parse_location(token)
  m = token.match /^Location: (\w+)/

  m[1] if m
end

def report(substance, locations)
  "#{substance} levels in #{locations.join(', ')} are too high."
end

def report_amonia(locations)
  report 'Ammonia', extract_top_locations(locations, :ammonia)
end

def report_nitrogen(locations)
  report 'Nitrogen Oxide', extract_top_locations(locations, :nitrogen)
end

def report_carbon_monoxide(locations)
  report 'Carbon Monoxide', extract_top_locations(locations, :carbon_monoxide)
end

def extract_top_locations(locations, criteria)
  locations.sort_by { |group| group[criteria] }
    .chunk_while { |p, n| p[criteria] == n[criteria] }
    .to_a.last
    .map { |report| report[:location] }
end

"Ammonia levels in USA, CHN are too high. Nitrogen Oxide levels in DEU are too high. Carbon Monoxide levels in AUS, BHS, CRI are too high."


$data_file = """
##################################
Location: DEU
##################################
 Ammonia: 023 particles
 Nitrogen Oxide: 919 particles
 Carbon Monoxide: 027 particles
##################################
##################################
Location: USA
##################################
 Ammonia: 422 particles
 Nitrogen Oxide: 220 particles
 Carbon Monoxide: 130 particles
##################################
##################################
Location: AUS
##################################
 Ammonia: 122 particles
 Nitrogen Oxide: 102 particles
 Carbon Monoxide: 399 particles
##################################
##################################
Location: BHS
##################################
 Ammonia: 323 particles
 Nitrogen Oxide: 363 particles
 Carbon Monoxide: 399 particles
##################################
##################################
Location: BRB
##################################
 Ammonia: 344 particles
 Nitrogen Oxide: 324 particles
 Carbon Monoxide: 314 particles
##################################
##################################
Location: CHN
##################################
 Ammonia: 422 particles
 Nitrogen Oxide: 477 particles
 Carbon Monoxide: 398 particles
##################################
##################################
Location: COG
##################################
 Ammonia: 044 particles
 Nitrogen Oxide: 144 particles
 Carbon Monoxide: 244 particles
##################################
##################################
Location: CRI
##################################
 Ammonia: 092 particles
 Nitrogen Oxide: 099 particles
 Carbon Monoxide: 399 particles
##################################
##################################
Location: ISL
##################################
 Ammonia: 021 particles
 Nitrogen Oxide: 009 particles
 Carbon Monoxide: 077 particles
##################################
##################################
Location: VEN
##################################
 Ammonia: 102 particles
 Nitrogen Oxide: 103 particles
 Carbon Monoxide: 022 particles
##################################
"""

pp parse_data