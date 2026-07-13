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
            ## note - do NOT convert to integer!!!
            ## e.g. a5rfzm8qpy3ca8d8wxlkkdslw
            ##   keep as string
            idComp   = row['id_comp']   || row['IdCompetition']
            idSeason = row['id_season'] || row['IdSeason']

            ## e.g. '2026' or '2026/27' etc.
            ##   normalize season
            season   = Season.parse( row['season'] ).to_s

            seasons = comps[idComp] ||={}

            seasons[ season ]      = {  season:         season,
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
                                "#{root}/fifadat/config/leagues.csv",
                              )
   pp COMPETITIONS



def self.read_codes( path )
    comps = {}

        rows = read_csv( path )

        rows.each do |row|
            ## note - do NOT convert to integer!!!
            ## e.g. a5rfzm8qpy3ca8d8wxlkkdslw
            ##   keep as string

            ## todo/fix
            ##   allow alternatives e.g.
            ##     world|worldcup
            ##     eng|eng.1  etc.

            code     = row['code']
            idComp   = row['id_comp']   || row['IdCompetition']

            comps[code] = idComp
        end
    comps
  end

   COMPETITION_ID = read_codes( "#{root}/fifadat/config/codes.csv" )
   pp COMPETITION_ID


   def self._idComp_by!( name: )
       ## note - downcase and remove all spaces from name
       ##  e.g. WORLD CUP => worldcup
       q = name.downcase.gsub( ' ', '' )
       idComp = COMPETITION_ID[ q ]
       if idComp.nil?
         raise ArgumentError, "no idCompetition found for #{name}; sorry"
       end

       idComp
   end


   def self._idSeason_by!( name:, season: )
        ## note - lookup season key is a string
        season = Season( season ).to_s

       idComp = _idComp_by!( name: name )
       rec = COMPETITIONS[ idComp ][ season ]
       if rec.nil?
         raise ArgumentError, "no idSeason found for #{name} #{season}; sorry"
       end

       rec[:idSeason]
   end

end  # class Fifa