

class Player

  def self.build( h )

##    rec = { id:      h['IdPlayer'],
##
##    status:     h['Status'],
##    pos:        h['Position'],

     new(
           name:        h['name'],
           short_name:  h['short_name'],
           captain:     h['captain']
     )
  end



  attr_reader :id,
              :name, :short_name,
              :captain,
              :pos,
              :sub    ## (recursive) sub(stitution) record

  attr_accessor :status



  def initialize( name:, short_name: nil,
                  captain: false )
     @name       = name
     @short_name = short_name
     @captain    = captain

     @id  = slugify( @name )

     @pos     = nil  ## fix-fix-fix - add pos(ition)
     @status  = nil  ##  e.g. starter/bench|sub/etc.

     @sub     = nil
  end


  def captain?()  @captain; end
  def starter?()  @status == 1; end
  def bench?()    @status == 2; end
  ##  add is_ variants - why? why not?
  alias_method :is_starter?, :starter?
  alias_method :is_bench?,   :bench?


  class Sub  ## (nested) sub(stitution) record/struct
     attr_reader :minute,
                 :player
     def initialize( player:,
                     minute: nil )
         @player = player
         @minute = minute
     end
  end  ## (nested) class Sub

  def add_sub( player:,  minute: nil )
      @sub = Sub.new( player: player,
                      minute: minute )
  end
end  ## class Player







class Players
   def initialize
      @recs = {}
   end

   def add_starter( recs )
      recs.each do |h|
         rec = Player.build( h )
         rec.status = 1  ## set status to starter flag (1)
        _add( rec )
      end
   end

   def add_bench( recs )
      recs.each do |h|
         rec = Player.build( h )
         rec.status = 2
        _add( rec )
      end
   end


   def add_subs( subs )
        subs.each do |sub|

          player_off = @recs[ slugify( sub['off']) ]
          player_on  = @recs[ slugify( sub['on'])  ]

          minute = sub['minute']

          if player_off.nil?
             puts "!! player_off not found in:"
             pp sub
             puts "---"
             pp @recs.values
             exit 1
          end

          if player_on.nil?
             puts "!! player_on not found in:"
             pp sub
             puts "---"
             pp @recs.values
             exit 1
          end

          assert( player_off && player_on,
                  "subs player_off or player_on not found; sorry" )

          player_off.add_sub( player: player_on,
                              minute: minute )
        end
   end




   def _add( new_rec )
      rec =  @recs[ new_rec.id ]
      if rec.nil?
          rec = new_rec
          @recs[ new_rec.id] = new_rec
      else
          assert( false,
                  "duplicate player records  - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end


  ###
   ## todo/check
   ##    add alias (or rename) starter  ??
   ##   add new subs to  status == 2  - why? why not?
   def lineup
      recs = @recs.values.select { |rec| rec.starter? }
      recs
   end


=begin
   def find!( id_player )
       rec = @recs[ id_player ]
       raise ArgumentError, "no player w/ id >#{id_player}< found; sorry"  if rec.nil?
       rec
   end



   ## all players with red or red-yellow card (sent off)
   def sentoff
      recs = @recs.values.select { |rec| rec[:r] || rec[:yr] }
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
         assert( player, "booking player not found; sorry- #{b.pretty_inspect}" )

           ## note - parse & reformat minute for keep same format
          minute =   _fmt_minute( *_parse_minute( b['Minute'] ))

          if card == 1      ## yellow
             player[ :y ] = { minute: minute }
          elsif card == 2   ## red
             player[ :r ] = { minute: minute }
          elsif card == 3   ## yellow/red
             player[ :yr ] = { minute: minute }
          end
      end
   end



   def dump
      pp @recs.values
      puts "  #{@recs.size} player(s)"
   end
=end


   def size() @recs.size; end

end  # class Players
