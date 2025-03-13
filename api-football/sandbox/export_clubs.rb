
require_relative 'helper'


def build_clubs( clubs, country:  )

    clubs = clubs['response']  if clubs.has_key?( 'response' )   ## flatten if envelope passed in

   ## filter  - must be national=false
    clubs = clubs.select { |club| club['team']['national'] == false }


    buf = String.new

    buf << "= #{country.name}\n\n"

##  get status - count locations

    buf << "  # Clubs   #{clubs.size}\n\n"


  ##  sort
  ##    first by venue name
  ##    and   than club name

      clubs = clubs.sort do |l,r|
                        ## puts "==> sort:"
                        ## pp l,r
                        res =  (l['venue']['city'] || 'Zzz') <=> (r['venue']['city'] || 'Zzz')
                        ## pp res
                        res = l['team']['name']  <=> r['team']['name']   if res == 0
                        ## pp res
                        res
            end


     clubs.each do |club|
       ## pp venue
=begin
       "name": "Hertha",
        "code": null,
        "country": "Austria",
        "founded": null,
=end
         club_name = club['team']['name']
         founded   = club['team']['founded']

=begin 
    "venue": {
        "id": 5842,
        "name": "HUBER Arena",
        "address": "Primelstrasse 30",
        "city": "Wels",
        "capacity": 3000,
        "surface": "grass",
=end      
       venue = club['venue']

       venue_name     = venue['name']
       address  = venue['address']
       city     = venue['city']
       country  = venue['country']
       capacity = venue['capacity']
       surface  = venue['surface']

       ## replace commad with > 
       city = city.gsub( ',', ' ›' )    if city


       buf << "#{club_name}"
       buf << ", #{founded}"        if founded
       buf << ",  @ #{venue_name}"  if venue_name
       buf << ",  #{city}"          if city
       buf << "\n"
       buf << "    @ #{address}\n"   if address
       ## buf << "\n"                     

     end
    buf
end


outdir = './o'
# outdir = '/sports/openfootball/world.more'


countries = [
  'Austria',
  'Germany',
  'England',
  'Scotland',
  'Belgium',
  'Luxembourg',
  'Spain',

  ## -- america
  'Mexico',
  'USA',
  'Canada',
  'Brazil',
]

countries.each_with_index do |country_name,i|
  pp country_name
 
  puts "==> #{i+1}/#{countries.size}  #{country_name}"
   ## get country record
  cty = Fifa.world.find_by_name( country_name )
  if cty.nil?
    puts "!! ERROR - no country found for >#{country_name}<"
    exit 1
  end
  pp cty

  teams = ApiFootball.teams_by_country( country_name )
  puts "  #{teams['response'].size} record(s)"

  buf = build_clubs( teams, country: cty)
  outpath = "#{outdir}/basics/#{cty.key}.clubs.txt"
  write_txt( outpath, buf )
end



puts "bye"
