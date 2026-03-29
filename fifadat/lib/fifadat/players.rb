

####
ALPHA_RE = %r{ \A
                   \p{L}
                   [\p{L} .-]*
               \z
              }ix

##
##  J. HARTING               - note: include .
##   Jose BUSTAMANTE-NAVA    - note: include -
##    Ismail JAKOBS  Ismail JAKOBS

def is_alpha?( name )  ## use is_alpha_name? or is_unialpha? or such??
    ALPHA_RE.match( name ) ? true : false
end


def norm_name( name )
    ## \u00A0 - non-breaking space
   name = name.gsub( /[\u00A0]/, ' ' )
   name
end

def norm_player( name )
   ##  check player name if include parentheses or such
    ## GILMAR (Gilmar Dos Santos Neves) - 1958 Brazil 
    ##  PELÉ (Edson Arantes do Nascimento)
  
   name = norm_name( name )

   ## ROMÁRIO (Romário de Souza Faria)
  
   name = 'GILMAR'  if name == 'GILMAR (Gilmar Dos Santos Neves)'
   name = 'PELÉ'    if name == 'PELÉ (Edson Arantes do Nascimento)'
  
   name = 'ROMÁRIO'   if name == 'ROMÁRIO (Romário de Souza Faria)'

   name = 'EUSEBIO'   if name == 'EUSEBIO (Eusebio da Silva Ferreira)'
  
   name
end



 MINUTE_RE = %r{  \A
                       (?<minute>\d{1,3}) '
                        ( \+
                          (?<offset>\d{1,2}) '
                        )?
                   \z
                 }x 


def _parse_minute( str )
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


  
  
  
def build_penalty( h, players: )
    ## split into minute
    ##  and offset (stoppage/injury time)    
    ##  e.g. 90'+11'

    minute, offset = _parse_minute( h['MatchMinute'] )

     type = h['Type']

     ##########
     ##  0 - goal   (when penalty awared used before)
     ## 41 - penalty goal
     ## 46 - penalty missed
     ##   Dragan STOJKOVIC (Yugoslavia) rattles the crossbar from the spot!
     ## 51 - penalty missed
     ##    JULIO CESAR (Brazil) hits the post from the spot!
     ## 60 - penalty missed
     ##    COMAN (France) sees his penalty saved by the goalkeeper. 
     ##    Maxime BOSSIS (France) misses from the penalty spot! and many more
     ## 65 - penalty missed
     ##      TCHOUAMENI (France) misses from the penalty spot!
  
  
     assert( [0,41,46,51,60,65].include?(type), 
             "event type 0/41/46/51/60/65 expected; got #{type}")

    rec = { type:      type,
            pen: [h['HomePenaltyGoals'], 
                  h['AwayPenaltyGoals']],
            player:    players.find!( h['IdPlayer'] ),
            minute:    minute,
            # timestamp:  h['Timestamp'], 
            # period:     h['Period'],   ## note - use 11 (for pen kicks!!!)
          }

     rec[ :offset] = offset   if offset  ## add optional offset (stoppage/injury time)
     rec    
end

def build_penalties( recs, players: )
     ################
     ## type:
     ##  6 -  penalty awarded
     ##       weirdo format - followed by 0 - goald or 60 - penalty missed!
     ## 2 -   yellow card
     ## 3 -   red card
     ## 8 -   end time
   
     recs = recs.select do |h|
                              if h['Period'] == 11   ## penalty shoot-out
                                assert( [0,2,3,6,8,41,46,51,60,65].include?( h['Type'] ),
                                   "expected event type 2/3/8/41/46/51/60/65 for pens; got #{h.pretty_inspect}"
                                 )
                                [0,41,46,51,60,65].include?( h['Type'] ) ? true : 
                                                                   false
                              else
                                 false
                              end
                        end


    recs = recs.map { |h| build_penalty( h, players: players ) }
    recs
end



def build_goal( h, players: )

    ## split into minute
    ##  and offset (stoppage/injury time)    
    ##  e.g. 90'+11'

     minute_str = h['Minute']

     if minute_str.nil? || minute_str.empty?



      ## todo/fix - find minute
      ##   in interconti cup 2024-12-1
        if h['Period'] == 11    ## realy penalty shoot out!!!
                                   ## skip - why? why not?
            minute_str =  "121'"                       
        else
           puts "!! minute in goal is nil or empty:"
           pp h
           exit 1
        end
      end


    minute, offset = _parse_minute( minute_str )

    ## check for weird minute 0 e.g.
    ##   Germany-Austria 1934 
    minute = 1  if h['Minute'] == "0'" 

  
    rec = { type:      h['Type'],
            minute:    minute, 
          }

     rec[ :offset] = offset   if offset  ## add optional offset (stoppage/injury time)

      idPlayer = h['IdPlayer']

      if idPlayer.nil?
         puts "!! no idPlayer for goal!"
         pp h
          ##exit 1
          ## use 'N.N.'

          rec[ :player ] = {
                             name: 'N.N.',
                           }
                     
      else
        rec[ :player ] = players.find!( idPlayer ) 
      end
     rec    
end


def build_goals( recs, players:,  penalties: false )
    recs = recs.map  { |h| build_goal( h, players: players ) }

    ## note - filter out penalties (from shoot-out)!!
    ##    min > 120  (e.g. 121, etc.)
    if penalties == false
       recs = recs.select { |rec| rec[:minute] <= 120 }
    end

    ## sort by minutes
    ##  may not be sorted

    recs = recs.sort do |l,r|
                 res = l[:minute] <=> r[:minute]
                 res = (l[:offset]||0) <=> (r[:offset]||0)  if res == 0 && 
                                                              (l[:minute] == 45 ||
                                                               l[:minute] == 90 ||
                                                               l[:minute] == 105 ||  ## check - if possible stoppage in 1st half extra-time??
                                                               l[:minute] == 120)
                 res
           end
    recs
end


def pp_goals( recs )
   players = {}

   ## "fold" multiple goals of player
   recs.each do |rec|
      player_name = rec[:player][:name]

      goal = String.new
      goal << _fmt_minute( rec[:minute], rec[:offset] )

      ## check for goal type (og) or (p)
      ##  1 -  "penalty"
      ##  2 -  "regular"
      ##  3 -  "own goal"
  
      goal << "(p)"   if rec[:type] == 1
      goal << "(og)"  if rec[:type] == 3

      player_rec = players[ player_name ] ||= { name: player_name, goals: [] }
      player_rec[:goals] << goal
   end


   buf =  players.map do |_,player| 
                    "#{player[:name]} #{player[:goals].join(', ')}" 
                end.join( ', ' )
   buf
end


=begin
  "Officials": 
     [{"IdCountry": "URU",
       "OfficialId": "61038",
       "NameShort": [{"Locale": "en-GB", "Description": "Domingo LOMBARDI"}],
       "Name": [{"Locale": "en-GB", "Description": "Domingo LOMBARDI"}],
       "OfficialType": 1,
       "TypeLocalized": [{"Locale": "en-GB", "Description": "Referee"}]},
      {"IdCountry": "BEL",
       "OfficialId": "60664",
       "NameShort": [{"Locale": "en-GB", "Description": "Henry CRISTOPHE"}],
       "Name": [{"Locale": "en-GB", "Description": "Henry CRISTOPHE"}],
       "OfficialType": 2,
       "TypeLocalized": 
        [{"Locale": "en-GB", "Description": "Assistant Referee 1"}]},
      {"IdCountry": "BRA",
       "OfficialId": "61289",
       "NameShort": [{"Locale": "en-GB", "Description": "Gilberto REGO"}],
       "Name": [{"Locale": "en-GB", "Description": "Gilberto REGO"}],
       "OfficialType": 3,
       "TypeLocalized": 
        [{"Locale": "en-GB", "Description": "Assistant Referee 2"}]}],
  
=end

def build_official( h )
    name = desc( h['Name'] )
    name = norm_name( name )

    idCountry = h['IdCountry']
    type      = h['OfficialType']


    assert( is_alpha?( name), "official name alpha expected; got #{name.inspect}" )
    assert( [1,2,3,4,5,6,7,8,9,10].include?( type ), "official type 1/2/3/4/5/6/7/8/9/10 expected; got #{type}" )

    rec = {
            id: h['OfficialId'],
            name:      name,
            idCountry: idCountry,
            type:      type
          }

    rec
   end


def build_officials( recs )  ## use referees?
    recs = recs.map  { |h| build_official( h ) }
   
    ## skip fourth official (4) for now
    recs = recs.select { |h|  [1,2,3].include?( h[:type] ) }

    ## sort by type 1/2/3
    ##  1 - referee
    ##  2 - assistant referee 1
    ##  3 - assistant referee 2
    ##  4 - fourth official
    ##  5 - video assistant referee (var)  
    ##  6 - reserve referee
    ##  7 - offside var
    ##  8 - assistant var
    ##  9 - support var
    ## 10 - reserve assistant referee
    

    recs = recs.sort { |l,r|  l[:type] <=> r[:type] }  
   
    recs
end


def ppofficials( recs )
   recs.map do |rec| 
                ppofficial( rec )
            end.join( ', ' )
end

def ppofficial( h )
   "#{h[:name]} (#{h[:idCountry]})"
end




def build_player( h )
   name       = desc( h['PlayerName'] )
   name = norm_player( name )

   short_name = desc( h['ShortName'] )

   rec = { id:      h['IdPlayer'],
           name:        name,
           short_name:  short_name,
           status:     h['Status'],
           pos:        h['Position'],
        }

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

   def lineup
      recs = @recs.values.select { |rec| rec[:status] == 1 }

      recs
   end

   def add_bookings( bookings )  ##  yellow/red cards
      bookings.each do |b|
     
         card = b['Card']
         assert( [1,2,3].include?( card ), "card 1/2/3 expected; got #{b.pretty_inspect}")

         idPlayer = b['IdPlayer']
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



   def add_subs( subs )
        subs.each do |sub|

          idPlayerOff = sub['IdPlayerOff']
          idPlayerOn  = sub['IdPlayerOn']
         
          ## note - parse & reformat minute for keep same format 
          minute =   _fmt_minute( *_parse_minute( sub['Minute'] ))

          player_off = @recs[ idPlayerOff ]
          player_on  = @recs[ idPlayerOn ]
          
##
##   note - skip special case for now
##              with NO PLAYER ON (e.g. idPlayerOn is nil!!)
           next if idPlayerOn.nil?
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
          ## id:     player_on[:id],
          ##         name:   player_on[:name] 

        end
   end
 


   def dump
      pp @recs.values
      puts "  #{@recs.size} player(s)"
   end

   def size() @recs.size; end

end  # class Players





def _ppplayer( player )
   buf = String.new
   buf << "#{player[:name]}"
   buf << " [c]"  if player[:captain]

   ## check for y/r/yr cards
   buf << " [Y #{player[:y][:minute]}]"      if player[:y]
   buf << " [Y/R #{player[:yr][:minute]}]"   if player[:yr]
   buf << " [R #{player[:r][:minute]}]"      if player[:r]

    ## check for sub (recursive)
    sub = player[:sub] 
    if sub
       buf << " (#{sub[:minute]} #{_ppplayer( sub[:player_ref])})"
    end

   buf
end


def pplineup( players, indent: 6 )
    lines = []
    line = String.new

    players.each_with_index do |player,i|
        if line.length > 68   ## start a new line
            lines << line.rstrip
            line = String.new
        end
        line  << _ppplayer( player ) 
           
        next_player = players[i+1]
        if next_player
           if next_player[:pos] != player[:pos]
               line << " - "  ## separate gk/def/mid/forw 
           else 
               line  << ", "
           end    
        end
    end

    lines << line.rstrip
    lines

    lines.join( "\n#{' '*indent}" )
end



def _pppen( pen1, pen2 )
   buf = String.new
   
   if pen1[:type] == 0 || pen1[:type] == 41   ## scored 
     buf << "#{pen1[:pen][0]}-#{pen1[:pen][1]} #{pen1[:player][:name]}"
   else
     buf << "    #{pen1[:player][:name]} (missed)"
   end  

   if pen2
      buf << ", "
      if pen2[:type] == 0 || pen2[:type] == 41   ## scored 
        buf << "#{pen2[:pen][0]}-#{pen2[:pen][1]} #{pen2[:player][:name]}"
      else
       buf << "    #{pen2[:player][:name]} (missed)"
      end
   end  

   buf
end


def pppenalties( pens, indent:  )
      lines = []
      line = String.new
      
      pens.each_slice(2) do |pen1, pen2|
           lines << _pppen( pen1, pen2 )
      end

      lines.join( ",\n#{' '*indent}" )
end
