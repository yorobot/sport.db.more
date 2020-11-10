
module Worldfootball



def self.convert( league:, season:, offset: nil )  ## check: rename (optional) offset to time_offset or such?
  season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

  league = find_league( league )

  pages = league.pages( season: season )

  # note: assume stages if pages is an array (of hash table/records)
  #         (and NOT a single hash table/record)
  if pages.is_a?(Array)
    recs = []
    pages.each do |page_meta|
      slug       = page_meta[:slug]
      stage_name = page_meta[:stage]
      ## todo/fix: report error/check if stage.name is nil!!!

      print "  parsing #{slug}..."

      # unless File.exist?( path )
      #  puts "!! WARN - missing stage >#{stage_name}< source - >#{path}<"
      #  next
      # end

      page = Page::Schedule.from_cache( slug )
      print "  title=>#{page.title}<..."
      print "\n"

      rows = page.matches
      stage_recs = build( rows, season: season, league: league.key, stage: stage_name )

      pp stage_recs[0]   ## check first record
      recs += stage_recs
    end
  else
    page_meta = pages
    slug = page_meta[:slug]

    print "  parsing #{slug}..."

    page = Page::Schedule.from_cache( slug )
    print "  title=>#{page.title}<..."
    print "\n"

    rows = page.matches
    recs = build( rows, season: season, league: league.key )

    pp recs[0]   ## check first record
  end

  recs = recs.map { |rec| fix_date( rec, offset ) }    if offset

##   note:  sort matches by date before saving/writing!!!!
##     note: for now assume date in string in 1999-11-30 format (allows sort by "simple" a-z)
## note: assume date is third column!!! (stage/round/date/...)
recs = recs.sort { |l,r| l[2] <=> r[2] }
## reformat date / beautify e.g. Sat Aug 7 1993
recs.each { |rec| rec[2] = Date.strptime( rec[2], '%Y-%m-%d' ).strftime( '%a %b %-d %Y' ) }

   ## remove unused columns (e.g. stage, et, p, etc.)
   recs, headers = vacuum( recs )

   puts headers
   pp recs[0]   ## check first record

   out_path = "#{config.convert.out_dir}/#{season.path}/#{league.key}.csv"

   puts "write #{out_path}..."
   Cache::CsvMatchWriter.write( out_path, recs, headers: headers )
end



## helper to fix dates to use local timezone (and not utc/london time)
def self.fix_date( row, offset )
  return row    if row[3].nil? || row[3].empty?   ## note: time (column) required for fix

  col = row[2]
  if col =~ /^\d{4}-\d{2}-\d{2}$/
    date_fmt = '%Y-%m-%d'   # e.g. 2002-08-17
  else
    puts "!!! ERROR - wrong (unknown) date format >>#{col}<<; cannot continue; fix it; sorry"
    ## todo/fix: add to errors/warns list - why? why not?
    exit 1
  end

  date = DateTime.strptime( "#{row[2]} #{row[3]}", "#{date_fmt} %H:%M" )
  ## NOTE - MUST be -7/24.0!!!! or such to work
  date = date + (offset/24.0)

  row[2] = date.strftime( date_fmt )  ## overwrite "old"
  row[3] = date.strftime( '%H:%M' )
  row   ## return row for possible pipelining - why? why not?
end

end # module Worldfootball
