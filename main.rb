require 'httparty'
Distance_Key = File.read("Distance_Key.txt").chomp
Distance_Unit = "imperial"

class DistanceMapper
    include HTTParty
    base_uri 'https://maps.googleapis.com'

    def initialize(origins, destinations, units, key)
        @options = { query: {origins: origins, destinations: destinations, units: units, key: key}}
    end

    def distancematrix
        self.class.get("/maps/api/distancematrix/json", @options)
    end
end

def distance_parser(mapped_object)
    mapped_object.distancematrix["rows"][0]["elements"][0]["distance"]["text"]
end

def time_parser(mapped_object)
    mapped_object.distancematrix["rows"][0]["elements"][0]["duration"]["text"]
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

# Checks to ensure if request is valid
abort("You did not enter both the origin and destination, please try again!") unless g.distancematrix["status"] == "OK"

# Checks to see if it can find origin and destination can be found
abort("Could not find either the origin or destination with information provided, please try again!") unless g.distancematrix["rows"][0]["elements"][0]["status"] == "OK"


origin_to_destination_distance = distance_parser(g)
origin_to_destination_time = time_parser(g)

puts "Ok, so the distance between #{g.distancematrix["origin_addresses"].to_s} and #{g.distancematrix["destination_addresses"].to_s} is: #{origin_to_destination_distance}. The total time to get there is: #{origin_to_destination_time}." 
