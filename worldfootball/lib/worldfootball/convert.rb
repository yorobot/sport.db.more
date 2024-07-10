
module Worldfootball


#################
# todo/fix -  use timezone instead of offset !!!
#  e.g
=begin
   TIMEZONES = {
  'eng.1' => 'Europe/London',  
  'eng.2' => 'Europe/London',

  'es.1'  => 'Europe/Madrid',

  'de.1'  => 'Europe/Berlin',
  'fr.1'  => 'Europe/Paris', 
  'it.1'  => 'Europe/Rome',
  'nl.1'  => 'Europe/Amsterdam',

  'pt.1'  => 'Europe/Lisbon',   

  ## todo/fix - pt.1
  ##  one team in madeira!!! check for different timezone??
  ##  CD Nacional da Madeira 

  'br.1'  => 'America/Sao_Paulo',
  ## todo/fix - brazil has 4 timezones
  ##           really only two in use for clubs
  ##             west and east (amazonas et al)
  ##           for now use west for all - why? why not?
}
=end

## todo - find "proper/classic" timezone ("winter time")

##  Brasilia - Distrito Federal, Brasil  (GMT-3)  -- summer time?
##  Ciudad de México, CDMX, México       (GMT-5)  -- summer time?
##  Londres, Reino Unido (GMT+1)
##   Madrid -- ?
##   Lisboa -- ?
##   Moskow -- ?
##
## todo/check - quick fix timezone offsets for leagues for now
##   - find something better - why? why not?
## note: assume time is in GMT+1
OFFSETS = {
  'eng' => -1,
  'eng.1' => -1,
  'eng.2' => -1,
  'eng.3' => -1,
  'eng.4' => -1,
  'eng.5' => -1,

  'ie' =>  -1, 
  'sco' =>  -1,
  
  'pt' => -1, 
  'pt.1'  => -1,
  'pt.2'  => -1,
 
  'fi' => 1, # +1
  'gr' => 1, # +1
  'ro' =>  1, # +1  
  'ua' =>  1, # +1
    
  'ru' =>  2,   # +2
  'tr'   => 2,  # +2 turkey time/moscow time


  'us'      => -6,   # (gmt-5) new york

  'mx'      => -7,
  'mx.1'    => -7,
  'mx.2'    => -7,
  'mx.3'    => -7,
  'mx.cup'  => -7,

  'cr' => -7,    # gmt-6  
  'gt' => -7,    # gmt-6 
  'hn' => -7,    # gmt-6 
  'sv' => -7,    # gmt-6 
  'ni' => -7,    # gmt-6 

  'uy' =>  -4,     #   gmt-3
  'pe' =>  -6,     #  gmt-5
  'ec' =>  -6,     #  gmt-5
  'co' =>  -6,     #  gmt-5 
  'bo' =>  -5,     #  gmt-4
  'cl' =>  -5,     #  gmt-4

  'br'  => -5,    # gmt-3  - change to -4?
  'br.1'  => -5,
  'ar'   => -5,   # gmt-3  - change to -4?
  'ar.1'  => -5,


  'eg' =>   2,  # +2  (gmt+3)
  'jp' =>   8,  # +8  (gmt+9)
  'cn' =>   7,  # +7  (gmt+7)

  ################
  ## int'l tournaments
  # 'uefa.cl' 
  # 'uefa.el' 
  'concacaf.cl'  => -7,   ### use mx time 
  'copa.l'       => -5,    ### use brazil time
  
}


def self.convert( league:, season: )   
  season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

  league = find_league( league )

  pages = league.pages( season: season )

  ## check: rename (optional) offset to time_offset or such?
  offset = OFFSETS[ league ]


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
   write_csv( out_path, recs, headers: headers )
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
