

class Fifa

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

 ## idComp is 10005!! (not 107!)  
 ##  289175 10005 -- FIFA Club World Cup 2025

=begin
    CLUBWORLDCUP_SEASON_ID = {
     2022 => 286466107   ## -- FIFA Club World Cup Morocco 2022
287833 107 -- FIFA Club World Cup Saudi Arabia 2023

4735 107 -- FIFA Club World Championship Toyota Cup Japan 2005

285345 107 -- FIFA Club World Cup UAE 2021
250695 107 -- FIFA Club World Cup Japan 2008

259689 107 -- FIFA Club World Cup Morocco 2014
275724 107 -- FIFA Club World Cup Japan 2015
252901 107 -- FIFA Club World Cup UAE 2009

276100 107 -- FIFA Club World Cup Japan 2016
276136 107 -- FIFA Club World Cup UAE 2018
283878 107 -- FIFA Club World Cup Qatar 2019
259665 107 -- FIFA Club World Cup Morocco 2013
249926 107 -- FIFA Club World Cup Japan 2007
284690 107 -- FIFA Club World Cup Qatar 2020
254476 107 -- FIFA Club World Cup UAE 2010
258492 107 -- FIFA Club World Cup Japan 2012
276118 107 -- FIFA Club World Cup UAE 2017
257425 107 -- FIFA Club World Cup Japan 2011
248388 107 -- FIFA Club World Cup Japan 2006

=end


   def self._idSeason_by_year!( season )
       idSeason = WORLDCUP_SEASON_ID[ season ]
       raise ArgumentError, "no (worldcup) idSeason found for #{season}; sorry"    if idSeason.nil?  
       idSeason
   end


   COMPETITION_ID = {
      'worldcup'  => 17,   
   }

   def self._idCompetition_by_name!( name )
       idCompetition = COMPETITION_ID[ name.downcase ]
       raise ArgumentError, "no idCompetition found for #{name}; sorry"    if idCompetition.nil?  
       idCompetition
   end



   def self.worldcup_season_url( season: )
      Metal.season_url( idSeason: _idSeason_by_year!( season ))
   end

   def self.worldcup_squads_url( season: )
      Metal.squads_url( idSeason:     _idSeason_by_year!( season ),
                        idCompetition: 17)
   end
 
   def self.worldcup_matches_url( season: )
      Metal.matches_url( idSeason: _idSeason_by_year!( season ))
   end

   def self.worldcup_stages_url( season: )
      Metal.stages_url( idSeason:  _idSeason_by_year!( season ))    
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
  

