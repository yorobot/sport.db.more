
module Worldfootball


## todo/check:  english league cup/trophy has NO ET - also support - make more flexible!!!

## build "standard" match records from "raw" table rows
def self.build( rows, season:, league:, stage: '' )   ## rename to fixup or such - why? why not?
   season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

   ## note: do NOT pass in league struct! pass in key (string)
   raise ArgumentError, "league key as string expected"  unless league.is_a?(String)

   print "  #{rows.size} row(s) - Worldfootball.build #{league} #{season}"
   print " - #{stage}" unless stage.empty?
   print "\n"


   zone = find_zone!( league: league, season: season )


   ## note: use only first part from key for lookup
   ##    e.g. at.1  => at
   ##         eng.1 => eng
   ##     and so on
   mods = MODS[ league.split('.')[0] ] || {}

   score_errors = SCORE_ERRORS[ league ] || {}


   i = 0
   recs = []
   rows.each do |row|
     i += 1


  if row[:round] =~ /Spieltag/
    puts
    print '[%03d] ' % (i+1)
    print row[:round]

    if (m = row[:round].match( /^(?<num>[0-9]+)\. Spieltag$/ ))
      ## todo/check: always use a string even if number (as a string eg. '1' etc.)
      round = m[:num]  ## note: keep as string (NOT number)
      print " => #{round}"
    else
      puts "!! ERROR: cannot find matchday number in >#{row[:round]}<:"
      pp row
      exit 1
    end
    print "\n"

  ## note - must start line e.g.
  ##            do NOT match => Qual. 1. Runde  (1. Runde)!!!
  else
    puts
    print '[%03d] ' % (i+1)
    print row[:round]

    round_new = map_round( row[:round], league: league, season: season )

    if round_new
      round = round_new
      print " => #{round}"
      print "\n"
    else
      round = row[:round]
      puts "!! WARN: unknown round >#{row[:round]}< for league >#{league} #{season}<:"
      pp row
    end
  end


    date_str  = row[:date]
    time_str  = row[:time]
    team1_str = row[:team1]
    team2_str = row[:team2]
    score_str = row[:score]



    ### check for score_error; first (step 1) lookup by date
    score_error = score_errors[ date_str ]
    if score_error
      if team1_str == score_error[0] &&
         team2_str == score_error[1]
         ## check if team names match too; if yes, apply fix/patch!!
         if score_str != score_error[2][0]
           puts "!! WARN - score fix changed? - expected #{score_error[2][0]}, got #{score_str} - fixing to #{score_error[2][1]}"
           pp row
         end
         puts "FIX - applying score error fix - from #{score_error[2][0]} to => #{score_error[2][1]}"
         score_str = score_error[2][1]
      end
    end


    print '[%03d]    ' % (i+1)
    print "%-10s | " % date_str
    print "%-5s | "  % time_str
    print "%-22s | " % team1_str
    print "%-22s | " % team2_str
    print score_str
    print "\n"



    ## clean team name (e.g. remove (old))
    ##   and asciify (e.g. ’ to ' )
    team1_str = norm_team( team1_str )
    team2_str = norm_team( team2_str )

    team1_str = mods[ team1_str ]   if mods[ team1_str ]
    team2_str = mods[ team2_str ]   if mods[ team2_str ]


    ht, ft, et, pen, comments = parse_score( score_str )


   ###################
   ### calculate date & times
   ## convert date from string e.g. 2019-25-10
   ## date = Date.strptime( date_str, '%Y-%m-%d' )

   if time_str.nil? || time_str.empty?
       ## no time
       ##   assume  00:00:00T
       time_str     = ''
       timezone     = ''
       utc          = ''
   else
      ## note - assume central european (summer) time (cet/cest) - UTC+1 or UTC+2
      cet = CET.strptime( "#{date_str} #{time_str}", '%Y-%m-%d %H:%M' )

      utc = cet.getutc   ## convert to utc
      local =  zone.to_local( utc )  # convert to local via utc
      ## overwrite old with local
      date_str = local.strftime( '%Y-%m-%d' )
      time_str = local.strftime( '%H:%M' )

      ## pretty print timezone
      ###   todo/fix - bundle into fmt_timezone method or such for reuse
      tz_abbr   =  local.strftime( '%Z' )   ## e.g. EEST or if not available +03 or such
      tz_offset =  local.strftime( '%z' )   ##  e.g. +0300

      timezone =  if tz_abbr =~ /^[+-][0-9]+$/   ## only digits (no abbrev.)
                     tz_offset
                  else
                      "#{tz_abbr}/#{tz_offset}"
                  end

      utc      = utc.strftime( '%Y-%m-%dT%H:%MZ' )
   end


    recs <<  [stage,
              round,
              date_str,
              time_str,
              timezone,
              team1_str,
              ft,
              ht,
              team2_str,
              et,              # extra: incl. extra time
              pen,             # extra: incl. penalties
              comments,
              utc]
   end  # each row
   recs
end  # build
end # module Worldfootball
