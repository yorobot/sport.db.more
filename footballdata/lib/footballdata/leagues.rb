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
end   #  module Footballdata

