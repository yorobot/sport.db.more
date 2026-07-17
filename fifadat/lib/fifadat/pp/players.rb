


def build_players( recs )
    recs = recs.map  { |h| build_player( h ) }
    recs
end


# TYPE_PLAYER_POS = {
#   0 => 'GK',
#   1 => 'DF',
#   2 => 'MF',
#   3 => 'FW',
#   4 => '??',
#   5 => '??',
#   6 => '??'
# }

def build_player( h )
   name       = desc( h['PlayerName'] )

   if name.nil?
     ## "PlayerName"=>[],
     ## "ShortName"=>[{"Locale"=>"en-gb", "Description"=>"S. Lainer"}],

     ## hack:
     ##  use shortname
      name = desc( h['ShortName'] )
   end

   if name.nil?
      ## puts "name is nil:"
      ## pp h
      ## exit 1
      ##  report/log error/warn
      ##
      ## quick fix use N.N. for now
      name = 'N.N.'
   end

   ## name = norm_player( name )


   short_name = desc( h['ShortName'] )

   ##
   ##  todo/check - add IdCountry if available??


   status = h['Status']
   assert( [1,2].include?( status ), "player status 1,2 expected; got #{h.inspect}")

   ## what is pos 6 ??
   ## e.g.
   ##   !! ASSERT FAILED
   ## {"IdPlayer"=>"419456", "IdTeam"=>"32759", "ShirtNumber"=>4, "Status"=>1,
   ## "PlayerName"=>[{"Locale"=>"en-GB", "Description"=>"Ismaila COULIBALY"}],
   ##  "ShortName"=>[{"Locale"=>"en-GB", "Description"=>"Ismaila COULIBALY"}],
   ## "Position"=>6, "PlayerPicture"=>nil,
   ## "FieldStatus"=>2, "LineupX"=>nil, "LineupY"=>nil}
   ##
   ## what is pos 5 ??
   ##  e.g.
   ## {"IdPlayer"=>"7czui1ih46j3zitzysxvjqjv8", "IdTeam"=>"2000019848", "ShirtNumber"=>33,
   ##  "Status"=>1,
   ## "PlayerName"=>[{"Locale"=>"en-gb", "Description"=>"Maximilian Hennig"}],
   ## "ShortName"=>[{"Locale"=>"en-gb", "Description"=>"M. Hennig"}],
   ## "Position"=>5, "PlayerPicture"=>nil, "FieldStatus"=>2, "LineupX"=>nil, "LineupY"=>nil}
   ##
   ## what is pos 4 ??
   ##  {"IdPlayer"=>"254150", "IdTeam"=>"2000017585", "ShirtNumber"=>15,
   ## "Status"=>2, "SpecialStatus"=>nil, "Captain"=>false,
   ## "PlayerName"=>[{"Locale"=>"en-GB", "Description"=>"Nemanja RNIC"}],
   ## "ShortName"=>[{"Locale"=>"en-gb", "Description"=>"N. Rnić"}],
   ## "Position"=>4, "PlayerPicture"=>nil, "FieldStatus"=>1, "LineupX"=>nil, "LineupY"=>nil}


   pos = h['Position']
   assert( [0,1,2,3,4,5,6].include?( pos ), "player pos 0,1,2,3,4,5,6 expected; got #{h.inspect}" )

   ##    0 - is always goal keeper
   ##   check meaning of 1 to 6
   ##     on website !!!
   ##       pos is NOT (simply) matching tactics/formation (index number)!!

   rec = { id:      h['IdPlayer'],
           name:        name,
           short_name:  short_name,
           status:      status,
           pos:         pos,
        }

    ## check for shirtNumber too
    num = h['ShirtNumber']
    rec[:num]     = num  if num

    rec[:captain]  = true   if h['Captain']

  rec
end



class Players
   def initialize
      @recs = {}
   end

   def add( recs )    ## rename to collect - why? why not?
      recs.each { |h| _add( build_player(h)) }
   end


   def _add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          rec[:count] = 1   ## add counter - why? why not?
          @recs[ new_rec[:id]] = new_rec

      else
          rec[:count] += 1
          ## assert attributes equal - why? why not?

          assert( new_rec[:name] == rec[:name] &&
                  new_rec[:short_name] == rec[:short_name],
                  "player records NOT matching - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end

   def find!( id_player )
       rec = @recs[ id_player ]
       raise ArgumentError, "no player w/ id >#{id_player}< found; sorry"  if rec.nil?
       rec
   end


   ###
   ## todo/check
   ##    add alias (or rename) starter  ??
   ##   add new subs to  status == 2  - why? why not?
   def lineup
      recs = @recs.values.select { |rec| rec[:status] == 1 }

      recs = recs.map {|rec| rec.except( :id, :status, :count ) }
      recs
   end

   def bench
      recs = @recs.values.select { |rec| rec[:status] == 2 }

      recs = recs.map {|rec| rec.except( :id, :status, :count ) }
      recs
   end



   ## all players with red or red-yellow card (sent off)
   def sentoff
      recs = @recs.values.select { |rec| rec[:r] || rec[:yr] }

=begin
       "id": "395516",
          "name": "Cesar MONTES",
          "short_name": "Cesar MONTES",
          "status": 1,
          "pos": 1,
          "captain": true,
          "count": 1,
          "r": {
            "minute": "90+2'"
=end

  ## todo/check - add a flag for yellow-red card (e.g. yr=true) - why? why not?

        recs = recs.map do |rec|
                   minute = if rec[:r]
                              rec[:r][:minute]
                             elsif rec[:yr]
                               rec[:yr][:minute]
                             else
                               raise ArgumentError, "r or yr card expected; got #{rec.inspect}"
                             end
                  { name:   rec[:name],
                    minute: minute }
               end

         recs
   end


   def redcards
      recs = @recs.values.select { |rec| rec[:r] }

        recs = recs.map do |rec|
                  { name:   rec[:name],
                    minute: rec[:r][:minute] }
               end
         recs
   end

   def yellowcards
      recs = @recs.values.select { |rec| rec[:y] }

        recs = recs.map do |rec|
                  { name:   rec[:name],
                    minute: rec[:y][:minute] }
               end
         recs
   end

   def yellowredcards
      recs = @recs.values.select { |rec| rec[:yr] }

        recs = recs.map do |rec|
                  { name:   rec[:name],
                    minute: rec[:yr][:minute] }
               end
         recs
   end



   def add_bookings( bookings )  ##  yellow/red cards
      bookings.each do |b|

         card = b['Card']
         assert( [0,1,2,3].include?( card ), "card 0/1/2/3 expected; got #{b.pretty_inspect}")

         ##
         ## what is card 0?  ignore for now
         ##  Palmeiras v FC Porto  0-0   - 2025-06-15T18:00:00+00:00
         ## !! ASSERT FAILED - card 1/2/3 expected; got {"Card"=>0,
         ## "Period"=>5,
         ## "IdEvent"=>nil,
         ## "EventNumber"=>nil,
         ## "IdPlayer"=>"495048",
         ## "IdCoach"=>nil,
         ## "IdTeam"=>"1884426",
         ## "Minute"=>"72'",
         ## "Reason"=>nil}
         next if card == 0


         idPlayer = b['IdPlayer']

         ## booking (card) for coach or stuff!!!!
         ##   skip for now
         next   if idPlayer.nil? && (b['IdCoach'] || b['IdStaff'])


         player = @recs[ idPlayer ]
         assert( player, "booking player not found; sorry - #{b.pretty_inspect}" )

           ## note - parse & reformat minute for keep same format
          ## _fmt_minute( *_parse_minute( b['Minute'] ))
         minute = _build_minute( b )

          if card == 1      ## yellow
             player[ :y ] = { minute: minute }
          elsif card == 2   ## red
             player[ :r ] = { minute: minute }
          elsif card == 3   ## yellow/red
             player[ :yr ] = { minute: minute }
          end
      end
   end



 def add_subs( subs )
        subs.each do |sub|

          idPlayerOff = sub['IdPlayerOff']
          idPlayerOn  = sub['IdPlayerOn']

          ## note - parse & reformat minute for keep same format
          minute  = _build_sub_minute( sub )

          player_off = @recs[ idPlayerOff ]
          player_on  = @recs[ idPlayerOn ]

##
##   note - skip special case for now
##              with NO PLAYER ON (e.g. idPlayerOn is nil!!)
       ##    next if idPlayerOn.nil?
           ##  todo/fix - report/log warning!!!


          if player_off.nil?
             puts "!! player_off >#{idPlayerOff}< not found in:"
             pp sub
             puts "---"
             pp @recs.values
             exit 1
          end

          if player_on.nil?
             puts "!! player_on >#{idPlayerOn}< not found in:"
             pp sub
             puts "---"
             pp @recs.values
             exit 1
          end

          assert( player_off && player_on,
                  "subs player_off or player_on not found; sorry" )

          player_off[ :sub ] = { minute: minute,
                                 player_ref: player_on }
        end
   end


   def dump
      pp @recs.values
      puts "  #{@recs.size} player(s)"
   end

   def size() @recs.size; end

end  # class Players
