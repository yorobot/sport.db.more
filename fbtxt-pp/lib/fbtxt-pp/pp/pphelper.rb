
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
    elsif score.key?( 'et' ) && score.key?( 'p' )
             if score.key?( 'ft' ) && score.key?( 'ht')
               "#{score['et'][0]}-#{score['et'][1]} a.e.t." +
               " (#{score['ft'][0]}-#{score['ft'][1]}, #{score['ht'][0]}-#{score['ht'][1]}), " +
               "#{score['p'][0]}-#{score['p'][1]} pen."
             elsif score.key?( 'ft' )
               "#{score['et'][0]}-#{score['et'][1]} a.e.t." +
               " (#{score['ft'][0]}-#{score['ft'][1]}), " +
               "#{score['p'][0]}-#{score['p'][1]} pen."
            else
               "#{score['et'][0]}-#{score['et'][1]} a.e.t., " +
               "#{score['p'][0]}-#{score['p'][1]} pen."
             end
    elsif score.key?('et') && !score.key?('p')
             if score.key?( 'ft' ) && score.key?( 'ht')
                "#{score['et'][0]}-#{score['et'][1]} a.e.t."+
                " (#{score['ft'][0]}-#{score['ft'][1]}, #{score['ht'][0]}-#{score['ht'][1]})"
             elsif score.key?( 'ft' )
                "#{score['et'][0]}-#{score['et'][1]} a.e.t."+
                " (#{score['ft'][0]}-#{score['ft'][1]})"
             else
                "#{score['et'][0]}-#{score['et'][1]} a.e.t."
             end
    elsif  score.key?('ft') &&  !score.key?('et') && !score.key?('p')
              if score.key?( 'ht')
                "#{score['ft'][0]}-#{score['ft'][1]} (#{score['ht'][0]}-#{score['ht'][1]})"
              else
               "#{score['ft'][0]}-#{score['ft'][1]}"
              end
     else
              raise ArgumentError, "unknown/unexpected score hash type #{score} #{score.class.name}"
     end
   else
              raise ArgumentError, "unknown/unexpected score type #{score} #{score.class.name}"
   end
end
