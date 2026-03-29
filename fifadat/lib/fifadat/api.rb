

class Fifa

##
##  read config
##     add to (hash) table indexed by idComp

  def self.root
     ## sport.db.more/fifadat/lib
    File.expand_path( (File.dirname(File.dirname(__FILE__))) )
  end

  def self.read_configs( *paths )
    comps = {}
   
     paths.each do |path|
        rows = read_csv( path )

        rows.each do |row|
             # note - convert ids to integer numbers
            idComp   = (row['id_comp'] || row['IdCompetition']).to_i(10)
            idSeason = (row['id_season'] || row['IdSeason']).to_i(10)
  
            seasons = comps[idComp] ||={}
            seasons[row['season']] = {  season:         row['season'],
                                        idSeason:       idSeason,
                                        idCompetition:  idComp,
                                        name:           row['name'],
                                        start_date:     row['start_date'],
                                        end_date:       row['end_date']  
                                     }
        end
      end
    comps
  end


   COMPETITIONS = read_configs( "#{root}/fifadat/config/worldcup.csv", 
                                "#{root}/fifadat/config/clubworldcup.csv",
                              )
   ##  pp COMPETITIONS


   COMPETITION_ID = {
      'worldcup'  => 17,   
      'clubworldcup' =>  10005, ## note - club world cup is only 2025
      'interconticup' => 107,  ## note - interconti  incl. all "legacy" club world cup 2000, 2005-2023
   }


   def self._idComp_by_name!( name )
       ## note - downcase and remove all spaces from name
       ##  e.g. WORLD CUP => worldcup
       q = name.downcase.gsub( ' ', '' )
       idComp = COMPETITION_ID[ q ]
       raise ArgumentError, "no idCompetition found for #{name}; sorry" if idComp.nil?
       idComp
   end


   def self._worldcup_idSeason_by_year!( season )
        ## note - lookup season key is a string
        season = season.to_s

       idComp = _idComp_by_name!( 'worldcup' )
       rec = COMPETITIONS[ idComp ][ season ]
       raise ArgumentError, "no (worldcup) idSeason found for #{season}; sorry"    if rec.nil?  
       rec[:idSeason]
   end

   def self._idSeason_by_year!( name:, season: )
        ## note - lookup season key is a string
        season = season.to_s

       idComp = _idComp_by_name!( name )
       rec = COMPETITIONS[ idComp ][ season ]
       raise ArgumentError, "no idSeason found for #{name} #{season}; sorry"    if rec.nil?  
       rec[:idSeason]
   end



   BASE_URL = 'https://api.fifa.com/api/v3'


   def self.search_seasons_url( name: )
     ## API_ROOT/seasons/search?name=FIFA%20U-20%20Women%20World%20Cup
     ## todo/fix - url encode name!!!
     "#{BASE_URL}/seasons/search?name=#{name}&count=500"
   end


   def self.competitions_url   ## list first 50 comps
      "#{BASE_URL}/competitions/?language=en"
   end


   def self.competition_url( name: )   ## note - singular !! (not plural)
      idCompetition = _idCompetition_by_name!( name.downcase )
      Metal.competition_url( idCompetition: idCompetition )
   end




   def self.worldcup_season_url( season: )
      Metal.season_url( idSeason: _worldcup_idSeason_by_year!( season ))
   end

   def self.worldcup_squads_url( season: )
      Metal.squads_url( idSeason:      _worldcup_idSeason_by_year!( season ),
                        idCompetition: _idComp_by_name!( 'worldcup' ))
   end
 
   def self.worldcup_matches_url( season: )
      Metal.matches_url( idSeason: _worldcup_idSeason_by_year!( season ))
   end

   def self.worldcup_stages_url( season: )
      Metal.stages_url( idSeason:  _worldcup_idSeason_by_year!( season ))    
   end



class Metal

   def self.competition_url( idCompetition: )  ## note - singular (not plural)
      "#{BASE_URL}/competitions/#{idCompetition}?language=en"
   end

   def self.season_url( idSeason: )
      ##      API_ROOT/seasons/278491
      "#{BASE_URL}/seasons/#{idSeason}"
   end


   def self.squads_url( idSeason:, idCompetition: )
      ## API_ROOT/teams/squads/all/108/278491
      "#{BASE_URL}/teams/squads/all/#{idCompetition}/#{idSeason}"
   end

   def self.matches_url( idSeason: )
       ## note - may add  &idCompetition=17

       "#{BASE_URL}/calendar/matches?"+
        "count=500&idSeason=#{idSeason}" +
        "&language=en"
   end

   def self.stages_url( idSeason: )
       ## note - may add  &idCompetition=17
      
       "#{BASE_URL}/stages?idSeason=#{idSeason}" +
      "&language=en"
   end
   
   def self.live_url( idCompetition:, idSeason:,
                               idStage:, idMatch: )
      "#{BASE_URL}/live/football/#{idCompetition}/#{idSeason}/#{idStage}/#{idMatch}?language=en"
   end
   
   def self.timeline_url( idCompetition:, idSeason:,
                               idStage:, idMatch: )
      #API_ROOT/timelines/108/278491/278493/300424860?language=en-GB
      "#{BASE_URL}/timelines/#{idCompetition}/#{idSeason}/#{idStage}/#{idMatch}?language=en"
   end
end  ## class Metal
end # class Fifa
  

