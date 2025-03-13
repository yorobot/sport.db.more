
require_relative 'helper'


def build_stadiums( venues, country:  )

    venues = venues['response']  if venues.has_key?( 'response' )   ## flatten if envelope passed in


    buf = String.new

    buf << "= #{country.name}\n\n"

##  get status - count locations

    buf << "  # Stadiums   #{venues.size}\n\n"

### sort by capacity for now
     venues = venues.sort do |l,r|
                                    r['capacity'] <=> l['capacity']
                          end

     venues.each do |venue|
       ## pp venue

       name     = venue['name']
       address  = venue['address']
       city     = venue['city']
       country  = venue['country']
       capacity = venue['capacity']
       surface  = venue['surface']

       ## replace commad with > 
       city = city.gsub( ',', ' ›' )    if city


       buf << "#{name}, #{capacity},   #{city}\n"
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

  venues = ApiFootball.venues( country: country_name )
  puts "  #{venues['response'].size} record(s)"

  buf = build_stadiums( venues, country: cty)
  outpath = "#{outdir}/basics/#{cty.key}.stadiums.txt"
  write_txt( outpath, buf )
end



puts "bye"
