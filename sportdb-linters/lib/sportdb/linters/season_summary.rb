
module SportDb
class SeasonSummary  ## rename to AssertSummary or CheckSummary or ????

    ####
  ###  fix: move "upstream" to "canonical" catalog
  ###    add option preload (or use different) wording
  ##    check rails for classes option name?
  ##   use catalog( preload: true  or preload: ['events'])
  def self.catalog
    @@catalog ||= begin
       ## pre-load (on deman) first call
       Import.catalog.events    ## force pre-load

       Import.catalog
    end
  end
  def catalog() self.class.catalog; end



      def self.build( path )
        new( path ).build
      end

      def initialize( path )
        @path = path
      end


      def build
        datafiles = Dir[ "#{@path}/**/*.csv" ]  ## fix: always use Dir.glob - why? why not?
        puts "#{datafiles.size} datafiles"

        errors = []
        buf = String.new('')
        buf << "```\n"   ## enclose in fenced code block


        datafiles.each do |datafile|
          league_q  = File.basename( datafile, File.extname( datafile ))
          season_q  = File.basename( File.dirname( datafile ))

          ## try mapping of league here - why? why not?
          league    = catalog.leagues.find!( league_q )
          season    = Season.parse( season_q )  ## normalize season


          ## check if event info exits
          event = catalog.events.find_by( league: league, season: season )
          next if event.nil?    ## skip if not event info found

          ## check if any counter is not nil/null
          if event.teams || event.matches || event.goals
            buf <<  "  #{season_q}/#{league_q} => #{season.key} | #{league.key.upcase} (#{league.name})\n"

            matches    = CsvMatchParser.read( datafile )

            more_buf, more_errors = build_event( event, matches )
            buf << more_buf

            if more_errors.size > 0
               more_errors.each do |msg|
                 errors << "#{season.key} | #{league.key.upcase} (#{league.name}) - #{msg}"
               end
            end
          end
        end  # each datafile
        buf << "```\n\n"   ## enclose in fenced code block


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
    end # method build


    ##############################
    # helper methods

    def build_event( event, matches )
        matchlist  = Import::Matchlist.new( matches )

        errors = []
        buf = String.new('')

        if event.teams
            team_count = matchlist.teams.count
            if event.teams == team_count
                buf << "    OK  #{team_count} teams\n"
            else
                msg = "got #{team_count} teams; expected #{event.teams}"

                buf << "!!  #{msg}\n"
                errors << msg
            end
        end

        if event.matches
            match_count = matches.size
            if event.matches == match_count
                buf << "    OK  #{match_count} matches\n"
            else
                msg = "got #{match_count} matches; expected #{event.matches}"

                buf << "!!  #{msg}\n"
                errors << msg
            end
        end

        if event.goals
            goal_count = matchlist.goals
            if event.goals == goal_count
                buf << "    OK  #{goal_count} goals\n"
            else
                msg = "got #{goal_count} goals; expected #{event.goals}"

                buf << "!!  #{msg}\n"
                errors << msg
            end
        end

        [buf, errors]
    end  # method build_event

end # class SeasonSummary
end # module SportDb

