

class Fifa

   BASE_URL = 'https://api.fifa.com/api/v3'


   def self.search_matches_url( from:, to:, count: 500 )
##
##  https://api.fifa.com/api/v3/calendar/matches?from=2026-03-24T00%3A00%3A00Z
##                                                  &to=2026-03-31T23%3A59%3A59Z
##                                                  &language=en
##                                                  &count=100

        from_encoded = URI.encode_www_form_component( from )
        to_encoded =  URI.encode_www_form_component( to )

        "#{BASE_URL}/calendar/matches?"+
          "from=#{from_encoded}"+
          "&to=#{to_encoded}"+
          "&language=en"+
          "&count=#{count}"
   end



   def self.search_seasons_url( name: )
     ## API_ROOT/seasons/search?name=FIFA%20U-20%20Women%20World%20Cup
     ## todo/fix - url encode name!!!

      ## note - encodes spaces as plus (+) NOT %20
     name_encoded = URI.encode_www_form_component( name )

     "#{BASE_URL}/seasons/search?name=#{name_encoded}&count=500"
   end


   def self.competitions_url   ## list first 50 comps
      "#{BASE_URL}/competitions/?language=en"
   end


   def self.competition_url( name: )   ## note - singular !! (not plural)
      idCompetition = _idCompetition_by!( name: name.downcase )
      Metal.competition_url( idCompetition: idCompetition )
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
