module Worldfootball


def self.convert_reports( league:, season: )
  season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

  league = find_league( league )

   ## note: use only first part from key for lookup
   ##    e.g. at.1  => at
   ##         eng.1 => eng
   ##     and so on
   mods = MODS[ league.key.split('.')[0] ] || {}



  pages = league.pages( season: season )

  recs = []

  ## if single (simple) page setup - wrap in array
  pages = pages.is_a?(Array) ? pages : [pages]
  pages.each do |page_meta|  # note: use page_info for now (or page_rec or page_meta or such)

    page = Page::Schedule.from_cache( page_meta[:slug] )
    print "  page title=>#{page.title}<..."
    print "\n"

    matches = page.matches

    puts "matches - #{matches.size} rows:"
    pp matches[0]

    puts "#{page.generated_in_days_ago}  - #{page.generated}"


    matches.each_with_index do |match,i|

      report_ref = match[:report_ref]
      if report_ref.nil?
        puts "!! WARN: no match report ref found for match:"
        pp match
        next
      end

      puts "reading #{i+1}/#{matches.size} - #{report_ref}..."
      report = Page::Report.from_cache( report_ref )

      puts
      puts report.title
      puts report.generated

      rows = report.goals
      puts "goals - #{rows.size} records"
      ## pp rows


      if rows.size > 0
        ## add goals
        date = Date.strptime( match[:date], '%Y-%m-%d')

        team1 = match[:team1]
        team2 = match[:team2]

        ## clean team name (e.g. remove (old))
        ##   and asciify (e.g. ’ to ' )
        team1 = norm_team( team1 )
        team2 = norm_team( team2 )

        team1 = mods[ team1 ]   if mods[ team1 ]
        team2 = mods[ team2 ]   if mods[ team2 ]

        match_id = "#{team1} - #{team2} | #{date.strftime('%b %-d %Y')}"


        rows.each do |row|
          extra = if row[:owngoal]
                   '(og)'  ## or use OG or O.G.- why? why not?
                  elsif row[:penalty]
                   '(pen)' ## or use P or PEN - why? why not?
                  else
                    ''
                  end

          rec = [match_id,
                row[:score],
                "#{row[:minute]}'",
                extra,
                row[:player],
                row[:notes]]
          recs << rec
        end
      end
     end #  each match
    end # each page

  ## pp recs

  out_path = "#{config.convert.out_dir}/#{season.path}/#{league.key}~goals.csv"

  headers  = ['Match', 'Score', 'Minute', 'Extra', 'Player', 'Notes']

  puts "write #{out_path}..."
  Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end
end  # module Worldfootballl

