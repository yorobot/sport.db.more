
def _fmt_score( m )

  ## m = (full) match hash incl.  IdMatch, etc.
  ##  returns string e.g.  4-4  or 4-3 a.e.t etc

  score = m['score']


  if score.nil?
          ''
  elsif score.is_a?(Hash)

  #            0 =>  no result / not played yet
  #            1 => regular (90 mins)
  #            2 => aet (120 mins), win on pens
  #            3 => aet (120 mins)
  #            8 =>  same as 3?  -aet with golden goal/silver goal in 1998 FRA-PAR


    if score.empty?
              ''
    elsif score.key?( 'et' ) && score.key?( 'p' ) &&  !score.key?('ft')
             "#{score['et'][0]}-#{score['et'][1]} a.e.t., " +
             "#{score['p'][0]}-#{score['p'][1]} pen."
    elsif score.key?('et') && !score.key?('p') &&  !score.key?('ft')
             "#{score['et'][0]}-#{score['et'][1]} a.e.t."
    elsif score.key?('ft') && !score.key?('et') && !score.key?('p')
             "#{score['ft'][0]}-#{score['ft'][1]}"
     else
              raise ArgumentError, "unknown/unexpected score hash type #{score} #{score.class.name}"
     end
   else
              raise ArgumentError, "unknown/unexpected score type #{score} #{score.class.name}"
   end
end
