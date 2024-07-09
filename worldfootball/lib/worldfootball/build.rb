
module Worldfootball


ROUND_TO_EN = {
  '1. Runde'      => 'Round 1',
  '2. Runde'      => 'Round 2',
  '3. Runde'      => 'Round 3',
  '4. Runde'      => 'Round 4',
  '5. Runde'      => 'Round 5',
  '6. Runde'      => 'Round 6',
  '7. Runde'      => 'Round 7',
  'Achtelfinale'  => 'Round of 16',
  'Viertelfinale' => 'Quarterfinals',
  'Halbfinale'    => 'Semifinals',
  'Finale'        => 'Final',
}


## todo/check:  english league cup/trophy has NO ET - also support - make more flexible!!!

## build "standard" match records from "raw" table rows
def self.build( rows, season:, league:, stage: '' )   ## rename to fixup or such - why? why not?
   season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

   raise ArgumentError, "league key as string expected"  unless league.is_a?(String)  ## note: do NOT pass in league struct! pass in key (string)

   print "  #{rows.size} rows - build #{league} #{season}"
   print " - #{stage}" unless stage.empty?
   print "\n"


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
  elsif row[:round] =~ /^(    
                          [1-9]\.[ ]Runde|
                          Achtelfinale|
                          Viertelfinale|
                          Halbfinale|
                          Finale
                         )$
                        /x
    puts
    print '[%03d] ' % (i+1)
    print row[:round]

    round = ROUND_TO_EN[ row[:round] ]
    print " => #{round}"
    print "\n"

    if round.nil?
      puts "!! ERROR: no mapping for round to english (en) found >#{row[:round]}<:"
      pp row
      exit 1
    end
  else
    puts
    print '[%03d] ' % (i+1)
    print row[:round]
    print "\n"

    puts "!! WARN: unknown round >#{row[:round]}< for league >#{league}<:"
    pp row
    round = row[:round]
  end


    date_str  = row[:date]
    time_str  = row[:time]
    team1_str = row[:team1]
    team2_str = row[:team2]
    score_str = row[:score]

    ## convert date from string e.g. 2019-25-10
    date = Date.strptime( date_str, '%Y-%m-%d' )


    ### check for score_error; first (step 1) lookup by date
    score_error = score_errors[ date.strftime('%Y-%m-%d') ]
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


    ## check for 0:3 Wert.   - change Wert. to awd.  (awarded)
    score_str = score_str.sub( /Wert\./i, 'awd.' )

    ## clean team name (e.g. remove (old))
    ##   and asciify (e.g. ’ to ' )
    team1_str = norm_team( team1_str )
    team2_str = norm_team( team2_str )

    team1_str = mods[ team1_str ]   if mods[ team1_str ]
    team2_str = mods[ team2_str ]   if mods[ team2_str ]




    ht, ft, et, pen, comments = parse_score( score_str )



    recs <<  [stage,
              round,
              date.strftime( '%Y-%m-%d' ),
              time_str,
              team1_str,
              ft,
              ht,
              team2_str,
              et,              # extra: incl. extra time
              pen,             # extra: incl. penalties
              comments]
   end  # each row
   recs
end  # build



def self.parse_score( score_str )
  comments = String.new     ## check - rename to/use status or such - why? why not?

  ## split score
  ft  = ''
  ht  = ''
  et  = ''
  pen = ''
  if score_str == '---'   ## in the future (no score yet) - was -:-
    ft = ''
    ht = ''
  elsif score_str == 'n.gesp.' ||   ## cancelled (british) / canceled (us)
        score_str == 'ausg.'   ||   ## todo/check: change to some other status ????
        score_str == 'annull.'      ## todo/check: change to some other status (see ie 2012) ????
    ft = '(*)'
    ht = ''
    comments = 'cancelled'
  elsif score_str == 'abgebr.'  ## abandoned  -- waiting for replay?
    ft = '(*)'
    ht = ''
    comments = 'abandoned'
  elsif score_str == 'verl.'   ## postponed
    ft = ''
    ht = ''
    comments = 'postponed'
  # 5-4 (0-0, 1-1, 2-2) i.E.
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                      \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                        ([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                       ([0-9]+) [ ]*-[ ]* ([0-9]+)\)
                          [ ]*
                       i\.E\.
                     /x
    pen = "#{$1}-#{$2}"
    ht  = "#{$3}-#{$4}"
    ft  = "#{$5}-#{$6}"
    et  = "#{$7}-#{$8}"
  # 3-2 (0-0, 1-1) i.E.   - note: no extra time!!! only ht,ft!!!
  #                         "popular" in southamerica & mexico 
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                      \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                       ([0-9]+) [ ]*-[ ]* ([0-9]+)\)
                          [ ]*
                       i\.E\.
                     /x
    pen = "#{$1}-#{$2}"
    ht  = "#{$3}-#{$4}"
    ft  = "#{$5}-#{$6}"
    et  = ''
  # 2-1 (1-0, 1-1) n.V
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                      [ ]*
                    \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                       [ ]*,[ ]*
                      ([0-9]+) [ ]*-[ ]* ([0-9]+)
                      \)
                       [ ]*
                       n\.V\.
                     /x
    et  = "#{$1}-#{$2}"
    ht  = "#{$3}-#{$4}"
    ft  = "#{$5}-#{$6}"
  ### auto-patch fix drop last score 
  ## 1-3 (0-1, 1-1, 0-2) n.V.  => 1-3 (0-1, 1-1) n.V.
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                      [ ]*
                    \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                       [ ]*,[ ]*
                      ([0-9]+) [ ]*-[ ]* ([0-9]+)  
                       [ ]*,[ ]* 
                      ([0-9]+) [ ]*-[ ]* ([0-9]+)
                      \)
                       [ ]*
                       n\.V\.
                     /x
    et  = "#{$1}-#{$2}"
    ht  = "#{$3}-#{$4}"
    ft  = "#{$5}-#{$6}"

    puts "!! WARN - auto-fix/patch score - >#{score_str}<"  
    ### todo/fix - log auto-patch/fix - for double checking!!!!!
  elsif score_str =~ /([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                      \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                      \)
                     /x
    ft = "#{$1}-#{$2}"
    ht = "#{$3}-#{$4}"
  elsif  score_str =~ /([0-9]+)
                         [ ]*-[ ]*
                       ([0-9]+)
                         [ ]*
                        ([a-z.]+)
                       /x
    ft = "#{$1}-#{$2} (*)"
    ht = ''
    comments = $3
  elsif score_str =~ /^([0-9]+)-([0-9]+)$/
     ft = "#{$1}-#{$2}"     ## e.g. see luxemburg and others
     ht = ''
  ## auto-fix/patch
  # 3-3 (0-3, 3-3)  =>  3-3 (0-3) - drop last score 
  elsif score_str =~ /^([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*
                      \(([0-9]+) [ ]*-[ ]* ([0-9]+)
                          [ ]*,[ ]*
                        ([0-9]+) [ ]*-[ ]* ([0-9]+)   
                      \)$
                     /x
    ft = "#{$1}-#{$2}"
    ht = "#{$3}-#{$4}"

    puts "!! WARN - auto-fix/patch score - >#{score_str}<"  
    ### todo/fix - log auto-patch/fix - for double checking!!!!!
  else
     puts "!! ERROR - unsupported score format >#{score_str}< - sorry; maybe add a score error fix/patch"
     exit 1
  end

  [ht, ft, et, pen, comments]
end

end # module Worldfootball
