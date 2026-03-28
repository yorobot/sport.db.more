require_relative 'fifa'


## download match reports (via live/football)

args = ARGV

season =  if args.size == 1
              args[0].to_i
          else
             1950 # 2022 # 1930  # 2014 ## 2022  ## 2014  # 2022 # 1930 # 2022 
          end


cup = read_json( "./fifa/#{season}_matches.json" )

## pp cup['Results']
match_count = cup['Results'].size

puts "  #{match_count} match(es) in season #{season}"





def assert( test, msg )
    if test
    else
        puts "!! ASSERT FAILED - #{msg}"
        exit 1
    end
end


def parse_date( date_str )
    date = DateTime.strptime( date_str, '%Y-%m-%dT%H:%M:%S%z' )

    assert( date_str == date.strftime('%Y-%m-%dT%H:%M:%SZ'), 
              "date parse expected #{date_str} - got #{date.inspect}" )
    date
end


def desc( data )   ## get description
    return nil if data.nil? || (data.is_a?(Array) && data.empty?)

    row = data[0]   ## assume first entry is en-GB
    locale = row['Locale']
    assert( locale == 'en-GB' || locale == 'en-gb',
              "locale en-GB expected in data[0] - got #{data}")

    row['Description']
end





###
##   sort results by group if present

## add "old" sort index
cup['Results'] = cup['Results'].each_with_index.map {|m,i| m['sort']=i+1; m }


cup['Results'] =  cup['Results'].sort do |l,r|

   lhs_stageName =  desc( l['StageName'] )
   rhs_stageName =  desc( r['StageName'] )

   lhs_groupName  = desc( l['GroupName'] )  # optional
   rhs_groupName  = desc( r['GroupName'] )  # optional


   if lhs_groupName && rhs_groupName && (lhs_stageName == rhs_stageName) 
       res = lhs_groupName <=> rhs_groupName
       ## same group; sort by old index (or) date??
       res = l['sort'] <=> r['sort']   if res == 0
       res 
   else
       l['sort'] <=> r['sort']   ## keep as is
   end
end


cup['Results'].each_with_index do |m, i|
  idCompetition = m['IdCompetition']
  idSeason      = m['IdSeason']
  idStage       = m['IdStage']
  idMatch       = m['IdMatch']

  stageName   = desc( m['StageName'] )

  teamName1, teamCode1  = if m['Home']
                            [ desc( m['Home']['TeamName'] ), 
                               m['Home']['Abbreviation']
                            ]
                           else
                              ['?', '?']
                           end

  
  teamName2, teamCode2   = if m['Away']
                             [  desc( m['Away']['TeamName'] ),
                                m['Away']['Abbreviation']
                             ]
                           else
                              ['?', '?']
                           end


  resultType  = m['ResultType']
  assert( [0, 1,2,3,8].include?(resultType), "resultType 1,2,3 expected; got #{resultType}" )

  # resultType 
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

  score = if resultType == 2   ## aet, win on pens 
             "#{m['HomeTeamScore']}-#{m['AwayTeamScore']}" +
             " (aet, win #{m['HomeTeamPenaltyScore']}-#{m['AwayTeamPenaltyScore']} on pens)"
           elsif resultType == 3 || resultType == 8  ## aet
             "#{m['HomeTeamScore']}-#{m['AwayTeamScore']} (aet)"
           elsif  resultType == 1  ## assume 1 - regular (90 mins+stoppage/injury time)
              "#{m['HomeTeamScore']}-#{m['AwayTeamScore']}"
           elsif  resultType == 0
              ""
           else
              raise ArgumentError, "unknown/unexpected result type #{resultType}"
           end       
  

   matchNumber = m['MatchNumber']       # optional
   matchDay  =  m['MatchDay']           # optional 
   groupName =  desc( m['GroupName'] )  # optional
  
  ### todo/check MatchNumber  ## optional  (see 2022!!)

 # "Date": "2026-06-12T19:00:00Z",
 #   "LocalDate": "2026-06-12T15:00:00Z",
   
    dateTime       = parse_date( m['Date'] )    ## utc   
    localDateTime  = parse_date( m['LocalDate'] )

     assert( dateTime.sec == 0 &&
            localDateTime.sec == 0, "sec 00 expected" )
  
    
 
    date       = "%d/%d/%d" % [dateTime.day, dateTime.month, dateTime.year] 
    date_local = "%d/%d/%d" % [localDateTime.day, localDateTime.month, localDateTime.year]

    wday_local = localDateTime.strftime( '%a' )
    time       = dateTime.strftime( '%H:%M' )
    time_local = localDateTime.strftime( '%H:%M' ) 

    ## note:  returns Rational (e.g. 3/1 or 1/4 etc.) use to_f/to_i to convert
    diff_in_hours = ((localDateTime - dateTime) * 24).to_f
    diff_in_days  =  localDateTime.jd - dateTime.jd 
    ## pp [diff_in_hours, diff_in_days]

    if !(dateTime.month == localDateTime.month &&
         dateTime.day   == localDateTime.day) 
       puts "   !!! daytime border - date #{dateTime} != localDate #{localDateTime}" 
    end

  # "HomeTeamPenaltyScore"=>3,
  # "AwayTeamPenaltyScore"=>4,


   stadiumName = desc( m['Stadium']['Name'] )
   cityName    = desc( m['Stadium']['CityName'])



##
## e.g. sample with DAY SHIFT!!! 
##          Sat 14/6/2014 22:00 -300 (01:00 UTC, +1d)

   print "[#{i+1}/#{match_count}] #{idCompetition}/#{idSeason}/#{idStage}" 
 
   print "  #{wday_local} #{date_local} #{time_local} %+02d00" % diff_in_hours
   if time != time_local
     print " (#{time} UTC" 
     print ", %+dd" % -diff_in_days   if diff_in_days != 0   
     print ")"
   end 
   
   print " @ #{stadiumName}, #{cityName}"
   print "\n"
 
   buf = String.new
   buf << "             #{stageName}"
   buf <<  ", #{groupName}"  if groupName
   buf << " \##{matchDay}" if matchDay
   buf << " (#{matchNumber})"  if matchNumber
   
   print  "%-40s" % buf
   print  "  #{teamName1} (#{teamCode1}) v #{teamName2} (#{teamCode2})  #{score}"
   print "\n\n"




###
##  
   
  outpath = "./matches/#{season}/#{localDateTime.strftime('%Y-%m-%d')}_#{teamCode1}-#{teamCode2}__#{idMatch}.json"   
  ## puts outpath


 
  sleep( 1 )


  url = Fifa._live_url( idCompetition: idCompetition, 
                        idSeason:      idSeason,
                        idStage:       idStage, 
                        idMatch:       idMatch )
   
  fetch_json( url, outpath )
end



puts "bye"