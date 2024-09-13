

module Worldfootball

def self.map_stage( stage, league:, season: )
   @stages ||= begin
                   stages = {}
                   recs = read_csv( "#{Worldfootball.root}/config/stages.csv" )
                   recs.each do |rec|
                      stages[ rec['key'] ] ||= Hash.new
                      stages[ rec['key'] ][ rec['name1'] ] = rec['name2']
                   end
                   stages
               end

    ## pp @stages

    league_code = league.to_s.downcase

    name = nil
    name = @stages[league_code][ stage ]  if @stages.has_key?( league_code )
    name = @stages['*'][stage]            if name.nil?    ## try generic (*) lookup
    name
end


def self.map_round( round, league:, season: )
    @rounds ||= begin
                    rounds = {}
                    recs = read_csv( "#{Worldfootball.root}/config/rounds.csv" )
                    recs.each do |rec|
                       rounds[ rec['key'] ] ||= Hash.new
                       rounds[ rec['key'] ][ rec['name1'] ] = rec['name2']
                    end
                    rounds
                end

     ## pp @stages

     league_code = league.to_s.downcase

     name = nil
     name = @rounds[league_code][ round ]  if @rounds.has_key?( league_code )
     name = @rounds['*'][round]            if name.nil?    ## try generic (*) lookup
     name
end
end   # module Worldfootball
