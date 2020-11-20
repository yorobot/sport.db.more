
module Fbref

def self.build( rows, league:, season: )
  season = Season( season )  ## cast (ensure) season class (NOT string, integer, etc.)

  raise ArgumentError, "league key as string expected"  unless league.is_a?(String)  ## note: do NOT pass in league struct! pass in key (string)

  print "  #{rows.size} rows - build #{league} #{season}"
  print "\n"


  recs = []
  rows.each do |row|

    stage  =  row[:stage] || ''

    ## todo/check:  assert that only matchweek or round can be present NOT both!!
    round  =  if row[:matchweek] && row[:matchweek].size > 0
                row[:matchweek]
              elsif row[:round] && row[:round].size > 0
                row[:round]
              else
                ''
              end

    date_str  = row[:date]
    time_str  = row[:time]
    team1_str = row[:team1]
    team2_str = row[:team2]
    score_str = row[:score]

    ## convert date from string e.g. 2019-25-10
    date = Date.strptime( date_str, '%Y-%m-%d' )

    comments = row[:comments]
    ht, ft, et, pen, comments = parse_score( score_str, comments )


    venue_str =      row[:venue]
    attendance_str = row[:attendance]


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
              venue_str,
              attendance_str,
              comments]
  end

  recs
end


def self.parse_score( score_str, comments )

  ## split score
  ft  = ''
  ht  = ''
  et  = ''
  pen = ''

  if score_str.size > 0
    ## note: replace unicode "fancy" dash with ascii-dash
    #  check other columns too - possible in teams?
    score_str = score_str.gsub( /[–]/, '-' ).strip

    if score_str =~ /^\(([0-9]+)\)
                        [ ]+ ([0-9]+) - ([0-9+]) [ ]+
                      \(([0-9]+)\)$/x
      ft  = '?'
      et  = "#{$2}-#{$3}"
      pen = "#{$1}-#{$4}"
    else  ## assume "regular" score e.g. 0-0
          ## check if notes include extra time otherwise assume regular time
      if comments =~ /extra time/i
        ft = '?'
        et = score_str
      else
        ft = score_str
      end
    end
  end

  [ht, ft, et, pen, comments]
end

end # module Fbref
