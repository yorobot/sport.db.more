

class Player

  def self.build( h )

##    rec = { id:      h['IdPlayer'],
##
##    status:     h['Status'],
##    pos:        h['Position'],

     new(
           name:        h['name'],
           short_name:  h['short_name'],
           captain:     h['captain'],
           id:          h['id']
     )
  end



  attr_reader :id,
              :name, :short_name,
              :alt_names,
              :captain,            ## true|false
              :pos,
              :y, :yr, :r,  ## cards/bookings - yellow, yellow-red, red
              :sub          ## (recursive) sub(stitution) record

  attr_accessor :status      ## e.g. 1-starter, 2-bench



  def initialize( name:, short_name: nil,
                  captain: false,
                  id: nil )
     @alt_names  = []

     norm = norm_name( name )
     if norm != name
       puts "  NORM PLAYER NAME >#{name}<  =>  >#{norm}<"
       @alt_names << name
       name = norm
     end

     @name       = name
     @short_name = short_name

     @captain    = captain

     @id  = id

     @pos     = nil  ## fix-fix-fix - add pos(ition)
     @status  = nil  ##  e.g. starter/bench|sub/etc.

     ## todo/check - add "generic" sentoff  for pre-cards era - why? why not?
     @y, @yr, @r  = nil,nil,nil

     @sub     = nil
  end

   ## get lookup keys (id+name+alt_names)
   def keys
      keys = []
      keys << @id                if @id
      keys << slugify(@name)
      keys += @alt_names.map {|name| slugify(name)}   unless @alt_names.empty?

      ##  note - make sure keys are unique
      keys.uniq
   end




  def captain?()  @captain; end
  def starter?()  @status == 1; end
  def bench?()    @status == 2; end
  ##  add is_ variants - why? why not?
  alias_method :is_starter?, :starter?
  alias_method :is_bench?,   :bench?


  def yellow?()    @y;  end
  def yellowred?() @yr; end
  def red?()       @r;  end


   class Booking  ## (nested) booking record/struct
       ## add :reason or such later
       attr_reader :minute
       def initialize( minute: nil )
          @minute = minute
       end
   end ## (nested) booking record/struct

   def add_yellow( minute: nil )    @y  = Booking.new( minute: minute ); end
   def add_yellowred( minute: nil ) @yr = Booking.new( minute: minute ); end
   def add_red( minute: nil )       @r  = Booking.new( minute: minute ); end



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
      @recs   = []
      @lookup = {}
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


###
#  note:
#    PAK Nam Chol  - North Korea  is two players with same name in the same team!!
#                      with different jersey number 4/14

   def _add( new_rec )
      @recs << new_rec

      new_rec.keys.each do |key|
         rec  =  @lookup[ key ]
         if rec.nil?
            @lookup[ key ] = new_rec
         else
           if key == 'paknamchol'
              ## ignore for now
              ##   fix later (use/prefer numeric ids!!!)
           else
             raise ArgumentError,
               "duplicate player records  #{rec.pretty_inspect} == #{new_rec.pretty_inspect}"
           end
         end
      end
   end


   def find( q )
      key = slugify( q )
      @lookup[ key ]
   end



   def add_subs( subs )
        subs.each do |sub|

          player_off = find( sub['off'] )
          player_on  = find( sub['on'] )

          minute = sub['minute']

          if player_off.nil?
             puts "!! player_off not found in:"
             pp sub
             puts "---"
             pp @recs
             exit 1
          end

          if player_on.nil?
             ### quick fix for N.N.
             if sub['on'] == 'N.N.'
               player_on = Player.build( { 'name' => 'N.N.'} )
             else
               puts "!! player_on not found in:"
               pp sub
               puts "---"
               pp @recs
               exit 1
             end
          end

          assert( player_off && player_on,
                  "subs player_off or player_on not found; sorry" )

          player_off.add_sub( player: player_on,
                              minute: minute )
        end
   end


   def add_yellow( bookings)     _add_bookings( bookings, type: 'y' ); end
   def add_yellowred( bookings)  _add_bookings( bookings, type: 'yr' ); end
   def add_red( bookings)        _add_bookings( bookings, type: 'r' ); end

      def _add_bookings( bookings, type: )
      bookings.each do |b|

          ## note - ignores cards coach and stuff for now upstream!!!
          player = find( b['name'])
          assert( player, "booking player not found; sorry- #{b.pretty_inspect}" )

          minute =  b['minute']

          case type.to_sym
          when :y   then  player.add_yellow( minute: minute )
          when :r   then  player.add_red( minute: minute )
          when :yr  then  player.add_yellowred( minute: minute )
          else
              raise ArgumentError,
                "expected :y|:r|:yr - unknown card type for booking: #{b.pretty_inspect}"
          end
      end
   end



  ###
   ## todo/check
   ##    add alias (or rename) starter  ??
   ##   add new subs to  status == 2  - why? why not?
   def lineup
      recs = @recs.select { |rec| rec.starter? }
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
=end


   def size() @recs.size; end

end  # class Players
