module Footballdata

  def self.find_league!( league )
     @leagues ||= begin
                     recs = read_csv( "#{FootballdataApi.root}/config/leagues_tier1.csv" )
                     leagues = {}
                     recs.each do |rec|
                        leagues[ rec['key'] ] = rec['code']
                     end
                     leagues
                  end

     key = league.downcase
     code =  @leagues[ key ]
     if code.nil?
        puts "!! ERROR - no code/mapping found for league >#{league}<"
        puts "     mappings include:"
        pp @leagues
        exit 1
     end
     code
  end

###
#  quick (and dirty) hack - return seasons by league code
#     - todo/fix - use one find_league_info method for all or such
 def self.find_league_seasons!( league )
     @league_seasons ||= begin
                     recs = read_csv( "#{FootballdataApi.root}/config/leagues_tier1.csv" )
                     leagues = {}
                     recs.each do |rec|
                        leagues[ rec['key'] ] = rec['seasons']
                     end
                     leagues
                  end

     key = league.downcase
     seasons =  @league_seasons[ key ]
     if seasons.nil?
        puts "!! ERROR - no code/mapping found for league >#{league}<"
        puts "     mappings include:"
        pp @league_seasons
        exit 1
     end

     ### split string into array
     seasons = seasons.split( /[ ]+/ )
     seasons
  end
end   #  module Footballdata

