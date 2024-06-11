module SportDb
class TeamSummary    ### rename to NameSummary, DatafileSummary, etc. why? why not?????

  def self.catalog() Import.catalog; end 
  def self.world()   Import.world;   end


class Names
  def catalog() TeamSummary.catalog; end
  def world()   TeamSummary.world;   end


  def initialize( country_key )
    @names = Hash.new(0)

    @country = world.countries.find( country_key )
    if @country.nil?
      puts "!! ERROR - no country found for key >#{country_key}<"
      exit 1
    end
    pp @country
  end

  def add_matches( matches )
    matches.each do |match|
      @names[ match.team1 ] += 1
      @names[ match.team2 ] += 1
    end
  end

  def build
    buf = String.new('')
    errors = []

    ## sort by count (reverse) and alphabet
    names = @names.sort do |l,r|
      res =  r[1] <=> l[1]
      res =  l[0] <=> r[0]  if res == 0
      res
    end

    buf << "\n\n## #{@country.name} (#{@country.key})\n\n"
    buf << "#{names.size} club names:\n\n"
    buf << "```\n"

    clubs = {}  ## check for duplicates

    names.each do |rec|
      club = catalog.clubs.find_by( name: rec[0], country: @country )
      if club.nil?
        puts "!! ERROR - no club match found for >#{rec[0]}<"
        errors << "#{rec[0]} > #{@country.name}"

        buf << "!!! #{rec[0]} (#{rec[1]})\n"
      else
        if club.historic?
          buf << "xxx "   ### check if year is in name?
        else
          buf << "    "
        end

        buf << "%-28s" %  "#{rec[0]} (#{rec[1]})"
        if club.name != rec[0]
          buf << " => %-25s |" % club.name
        else
          buf << (" #{' '*28} |")
        end

        if club.city
          buf << " #{club.city}"
          buf << " (#{club.district})"   if club.district
        else
          buf << " ?  "
        end

        if club.geos
          buf << ",  #{club.geos.join(' › ')}"
        end

        buf << "\n"

        clubs[club] ||= []
        clubs[club] << rec[0]
      end
    end
    buf << "```\n\n"

    ## check for duplicate clubs (more than one mapping / name)
    duplicates = clubs.reduce( {} ) do |h,(club,rec)|
                                      h[club]=rec  if rec.size > 1
                                      h
                                    end

    if duplicates.size > 0
      buf << "\n\n#{duplicates.size} duplicates:\n"
      duplicates.each do |club, rec|
        buf << "- **#{club.name}** _(#{rec.size})_ #{rec.join(' · ')}\n"
      end
    end

    [buf, errors]
  end
end # class Names



  def self.build( path, start: nil )
    new( path ).build( start: start )
  end

  def initialize( path )
    @path = path
  end


  ##
  #  make more generic to add (quick) mods
  #
  def _quick_mods( matches, country:, season: )    
      matches.map do |m| 
        if country == 'es' || country == 'br'  
          teams = [m.team1,m.team2]
          teams_mods = teams.map do |team|
                         if team == 'Extremadura'   # es
                            ## todo - check if 2010/11 is gt 2010 ??
                            ##             use > 2010/11 - why? why not? 
                           if season > Season( '2010' )
                              'Extremadura UD'    
                           else
                              'CF Extremadura'  ## or CF Extremadura (-2010)
                           end
                          elsif team == 'Bragantino'   # br
                            if season > Season( '2019' )
                              'RB Bragantino'
                            else
                              'CA Bragantino'  ## or CA Bragantino (1928-2019) 
                            end
                          else
                             team
                          end
                        end
            team1, team2 = teams_mods
            m.update( team1: team1,
                      team2: team2 )
        end
        m
      end
  end  # method _quick_mods 
  

  def build( start: nil )
datafiles = Dir[ "#{@path}/**/*.csv" ]  ## fix: always use Dir.glob - why? why not?
puts "#{datafiles.size} datafiles"

 start_season = start ? Season( start ) : nil

countries = {}
datafiles.each do |datafile|
  basename = File.basename( datafile, File.extname( datafile ))
  ##  e.g.  eng.3b.csv or eng3b.csv or ENG3B.csv
  ##         result in eng
  country_key = basename.downcase.scan( /^[a-z]+/ )[0]   ## note: scan return an array; use first item

  dirname = File.basename( File.dirname( datafile ))
  season = Season.parse( dirname )
 
  ##  skip if season is older
  next if start_season && start_season.start_year > season.start_year
  


  countries[ country_key] ||= Names.new( country_key )
  names = countries[ country_key]

  matches = CsvMatchParser.read( datafile )

  matches = _quick_mods( matches, country: country_key,
                                  season:  season, )
  

  pp matches.size
  pp matches[0..2]

  names.add_matches( matches )
end


errors = []
buf = String.new('')

countries.each do |country_key, names|
  more_buf, more_errors = names.build

  buf    << more_buf
  errors += more_errors
end

  header = String.new('')
  header << "# Summary\n\n"
  header << "#{datafiles.size} datafiles\n\n"

  if errors.size > 0
    header << "\n\n**#{errors.size} error(s):**\n"
    errors.each do |msg|
      header << "- **#{msg}**\n"
    end
    header << "\n\n"
  end

  [header+buf, errors]
end
end # class TeamSummary
end # module SportDb
