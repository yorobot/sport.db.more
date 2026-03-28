
require_relative 'helper'


class Fifa

   BASE_URL = 'https://api.fifa.com/api/v3'

   ## world cup fifa idSeasons 
   WORLDCUP_SEASON_ID = {
      1930 => 1,        ## uruguay
      1934 => 3,        ## italy
      1938 => 5,        ## france
      1950 => 7,        ## brazil
      1954 => 9,        ## switzerland
      1958 => 15,       ## sweden
      1962 => 21,       ## chile
      1966 => 26,       ## england
      1970 => 32,       ## mexico
      1974 => 39,       ## west germany
      1978 => 50,       ## argentina
      1982 => 59,       ## spain
      1986 => 68,       ## mexico
      1990 => 76,       ## italy
      1994 => 84,       ## usa
      1998 => 1013,     ## france
      2002 => 4395,     ## south korea & japan
      2006 => 9741,     ## germany
      2010 => 249715,   ## south africa
      2014 => 251164,   ## brazil
      2018 => 254645,   ## russia
      2022 => 255711,   ## qatar
      2026 => 285023,    ## usa
      2030 => 289085,    ## morocco, portugal, spain 
                         ##  (+ argentina, paraguay, uruguay)  
      2034 => 289087     ## saudi arabia
   }
 
   def self.season_url( season: )
      ##      API_ROOT/seasons/278491
      idSeason = _idSeason_by_year!( season )
      "#{BASE_URL}/seasons/#{idSeason}"
   end

   def self.search_seasons_url( name: )
     ## API_ROOT/seasons/search?name=FIFA%20U-20%20Women%20World%20Cup
     ## todo/fix - url encode name!!!
     "#{BASE_URL}/seasons/search?name=#{name}&count=500"
   end


   def self.squads_url( season: )
      ## API_ROOT/teams/squads/all/108/278491
      idSeason = _idSeason_by_year!( season )
      "#{BASE_URL}/teams/squads/all/17/#{idSeason}"
   end

   def self.matches_url( season: )
       ## note - may add  &idCompetition=17

       idSeason = _idSeason_by_year!( season )
     
       "#{BASE_URL}/calendar/matches?"+
        "count=500&idSeason=#{idSeason}" +
        "&language=en"
   end


   def self.stages_url( season: )
       ## note - may add  &idCompetition=17
 
       idSeason = _idSeason_by_year!( season )
     
       "#{BASE_URL}/stages?idSeason=#{idSeason}" +
      "&language=en"
   end

  

   def self.competitions_url   ## list first 50 comps
      "#{BASE_URL}/competitions/?language=en"
   end

   COMPETITION_ID = {
      'worldcup'  => 17,   
   }

   def self.competition_url( name: )   ## note - singular !! (not plural)
      idCompetition = _idCompetition_by_name!( name.downcase )
      "#{BASE_URL}/competitions/#{idCompetition}?language=en"
   end

   
   def self._live_url( idCompetition:, idSeason:,
                               idStage:, idMatch: )
      "#{BASE_URL}/live/football/#{idCompetition}/#{idSeason}/#{idStage}/#{idMatch}?language=en"
   end
   
   def self._timeline_url( idCompetition:, idSeason:,
                               idStage:, idMatch: )
      #API_ROOT/timelines/108/278491/278493/300424860?language=en-GB
      "#{BASE_URL}/timelines/#{idCompetition}/#{idSeason}/#{idStage}/#{idMatch}?language=en"
   end




############
### "private" helpers
   def self._idCompetition_by_name!( name )
       idCompetition = COMPETITION_ID[ name.downcase ]
       raise ArgumentError, "no idCompetition found for #{name}; sorry"    if idCompetition.nil?  
       idCompetition
   end

   def self._idSeason_by_year!( season )
       idSeason = WORLDCUP_SEASON_ID[ season ]
       raise ArgumentError, "no (worldcup) idSeason found for #{season}; sorry"    if idSeason.nil?  
       idSeason
   end


end # class Fifa
  

