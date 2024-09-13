
module Worldfootball


def self.convert( league:, season: )
  season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

  league = find_league!( league )
  pages  = league.pages!( season: season )


    recs = []
    pages.each do |slug, stage|
      ## note: stage might be nil
      ## todo/fix: report error/check if stage is nil!!!
      stage ||= ''

      ## try to map stage name if new name defined/found
      unless stage.empty?
         stage_new  =  map_stage( stage, league: league.key,
                                         season: season )
         stage = stage_new  if stage_new
      end


      print "  parsing #{slug}..."

      # unless File.exist?( path )
      #  puts "!! WARN - missing stage >#{stage_name}< source - >#{path}<"
      #  next
      # end

      page = Page::Schedule.from_cache( slug )
      print "  title=>#{page.title}<..."
      print "\n"

      rows = page.matches
      stage_recs = build( rows,
                          season: season,
                          league: league.key,
                          stage: stage )

      pp stage_recs[0]   ## check first record
      recs += stage_recs
    end


##   note:  sort matches by date before saving/writing!!!!
##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
## note: assume date is third column!!! (stage/round/date/...)
recs = recs.sort { |l,r| l[2] <=> r[2] }
## reformat date / beautify e.g. Sat Aug 7 1993
recs.each do |rec|
         rec[2] = Date.strptime( rec[2], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' )
       end

   ## remove unused columns (e.g. stage, et, p, etc.)
   recs, headers = vacuum( recs )

   puts headers
   pp recs[0]   ## check first record

   out_path = "#{config.convert.out_dir}/#{season.path}/#{league.key}.csv"

   puts "write #{out_path}..."
   write_csv( out_path, recs, headers: headers )
end
end # module Worldfootball

