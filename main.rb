require 'httparty'
Distance_Key = File.read("Distance_Key.txt").chomp
Distance_Unit = "imperial"

class DistanceMapper
    include HTTParty
    base_uri 'https://maps.googleapis.com'

    def initialize(origins, destinations, units, key)
        @options = { query: {origins: origins, destinations: destinations, units: units, key: key}}
    end

    def distance
        self.class.get("/maps/api/distancematrix/json", @options)
    end
end

def distance_parser(mapped_object)
    mapped_object.distance["rows"][0]["elements"][0]["distance"]["text"]
end

Gem.win_platform? ? (system "cls") : (system "clear")

puts "Welcome to the DistanceMapper(v0.1)!"
puts ""

puts "What is the origin address?"
puts ""
origin = gets.to_s.chomp
puts ""

puts "What is the destination address?"
puts ""
destination = gets.to_s.chomp
puts ""

g = DistanceMapper.new(origin, destination, Distance_Unit, Distance_Key)

origin_to_destination = distance_parser(g)

puts "Ok, so the distance between #{g.distance["origin_addresses"].to_s} and #{g.distance["destination_addresses"].to_s} is: #{origin_to_destination}"
