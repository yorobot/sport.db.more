

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



 MINUTE_RE = %r{  \A
                       (?<minute>\d{1,3}) '
                        (  \+   
                          (?<offset>\d{1,2}) '
                        )?
                   \z
                 }x 


def _parse_minute( str )

    ## support weirdo  120'+-30'  -- remove minuts
    str = str.gsub( '-', '' )
  
    m = MINUTE_RE.match( str )
    raise ArgumentError, "unknown goal minute format in #{str.inspect}"  if m.nil?

    minute = m[:minute].to_i(10)  
    offset = m[:offset] ? m[:offset].to_i(10) : nil  
    
    [minute,offset]
end

def _fmt_minute( minute, offset )
     ## pp [minute,offset]

     buf = String.new
     buf << "#{minute}"
     buf << "+#{offset}"   if offset    
     buf << "'"
     buf
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
## helper matches

def collect_dates( data, dates )
  ## collect min/max dates (duration - start/end)
  ##   e.g.
  ##   {  start: <date>,
  ##      end:   <date>
  ##   }


  data.each_with_index do |m, i|

    dateTime       = parse_date( m['Date'] )    ## utc   
    localDateTime  = parse_date( m['LocalDate'] )

    ## note - alway use local datetime for now

   if dates[:start].nil? || localDateTime < dates[:start] 
        dates[:start] = localDateTime
   end

   if dates[:end].nil? || localDateTime > dates[:end] 
        dates[:end] = localDateTime
   end
  end
end


def sort_matches( data )
  ###
  ##   sort results by group if present

  ## add "old" sort index
  data = data.each_with_index.map {|m,i| m['sort']=i+1; m }


  data =  data.sort do |l,r|

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

   data
end




def _fmt_score( m )

  ## m = (full) match hash incl.  IdMatch, etc.
  ##  returns string e.g.  4-4  or 4-3 a.e.t etc

  resultType  = m['ResultType']
 
  # resultType 
  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR

  score = if resultType == 2   ## aet, win on pens 
             "#{m['HomeTeamScore']}-#{m['AwayTeamScore']}" +
             " a.e.t., #{m['HomeTeamPenaltyScore']}-#{m['AwayTeamPenaltyScore']} pen."
           elsif resultType == 3 || resultType == 8  ## aet
             "#{m['HomeTeamScore']}-#{m['AwayTeamScore']} a.e.t."
           elsif  resultType == 1  ||  ## assume 1 - regular (90 mins+stoppage/injury time)
                  m['IdMatch'] == '400019191'  ##  fix for pachuca vs salzburg  
              "#{m['HomeTeamScore']}-#{m['AwayTeamScore']}"
           elsif  resultType == 0
              ##  pachuca vs salzburg in cwc 2025??
               ##  double check if score present
               raise ArgumentError, 
                  " resultType == 0 but score present idMatch #{m['IdMatch']} #{m['HomeTeamScore']}-#{m['AwayTeamScore']}"  if m['HomeTeamScore'] &&
                                                                                                                               m['AwayTeamScore']
              ""
           else
              raise ArgumentError, "unknown/unexpected result type #{resultType}"
           end       
  
  score
end
  

