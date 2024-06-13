
class Metal

    BASE_URL = 'https://www.footballsquads.co.uk'


   def self.league_url( country:, league:, season: )
      ## https://www.footballsquads.co.uk/austria/2023-2024/ausbun.htm  

      "#{BASE_URL}/#{country}/#{season}/#{league}.htm" 
   end 

   def self.league( country:, league:, season:,
                             cache: true )
      url = league_url( country: country, league: league, season: season )

      ## check check first
      if cache && Webcache.cached?( url )
        ## puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
      else
        download_page( url )
      end
   end

  def self.squad_url( country:, league:, season:,
                       team: )
      ## https://www.footballsquads.co.uk/austria/2023-2024/bundes/austvien.htm  
      "#{BASE_URL}/#{country}/#{season}/#{league}/#{team}.htm"
   end

   def self.squad( country:, league:, season:,
                            team:,
                            cache: true )
     url = squad_url( country: country, league: league, season: season,
                      team: team ) 

     ## check check first
     if cache && Webcache.cached?( url )
        ## puts "  reuse local (cached) copy >#{Webcache.url_to_id( url )}<"
     else
        download_page( url )
     end
   end

end   # class Metal