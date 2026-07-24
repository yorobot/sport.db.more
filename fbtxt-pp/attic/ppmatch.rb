
##
 ##  move to ppdebug (or ppdump??) !!
 #  buf = String.new
 #  buf << "             #{stageName}"
 #  buf <<  ", #{groupName}"  if groupName
 #  buf << " \##{matchDay}" if matchDay
 #  buf << " (#{matchNumber})"  if matchNumber


 ## move to convert !!!
  ## resultType  = m['ResultType']
  ##  assert( [0, 1,2,3,4,8].include?(resultType), "resultType 1,2,3,4 expected; got #{resultType}" )


      ## matches = data['matches']  ## only use results (match) array

   ## puts "  #{matches.size} match(es) in season #{season}"



#   stageName, groupName = norm_stage( stageName, groupName,
#                             team1: team1,
#                             team2: team2,
#                             date: localDateTime.strftime( '%Y-%m-%d') )



#   if group && (last_group.nil? || last_group != group)
#
#      buf << "▪▪ #{group}\n"
#
#      last_group = group
#   end


=begin
     use_date_utc = false    # true

##
## e.g. sample with DAY SHIFT!!!
##          Sat Jan 6 22:00 -300 (01:00 UTC, +1d)

   if use_date_utc
    ##  Fri Jan 7 20:30 +200 (18:30 UTC)
     buf << localDateTime.strftime( '%a %b %-e %H:%M' )
     buf << " %+d00" % diff_in_hours

     if localDateTime.hour    != dateTime.hour &&
        localDateTime.minutes != dateTime.minutes
       buf << " (#{dateTime.strftime( '%H:%M')} UTC"
       buf << ", %+dd" % -diff_in_days   if diff_in_days != 0
       buf << ")"
     end
   else
        ## use Fir Jan 7 20:30 UTC+1  or 20:30 UTC-3
     buf << localDateTime.strftime( '%a %b %-e %H:%M' )
     buf << " UTC%+d" % diff_in_hours
   end

=end