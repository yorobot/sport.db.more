

### shared root datadir
DATA_DIR = '/sports/more/worldcup/data-csv'


def fmt_name( rec )
    if rec['given_name'] != 'not applicable'
            "#{rec['given_name']} #{rec['family_name']}"
    else
           "#{rec['family_name']}"
    end
end

def fmt_minute( rec )
    if rec['minute_stoppage'] != 0
        "#{rec['minute_regulation']}+#{rec['minute_stoppage']}'"
    else
         "#{rec['minute_regulation']}'"
    end
end




class LineBuffer
   def initialize( indent: 3, width: 70 )
      @indent = indent
      @width  = width
      @lines = [String.new]
   end

   def add( str )
     line = @lines[-1]   ## last
     if line.size + str.size > @width   ## start a new line (if overflow)
        @lines <<  (line=String.new)  
        line << ' ' * @indent
        line << str
     else
        line << str
     end
  end

  def to_s
      @lines.join( "\n" )
  end
end  # class LineBuffer



class Worldcup    ## todo - use a more generic name e.g League or such - why? why not?

  def initialize
    @data = {}   ## data by leagues/cups
  end
 
  def _get_match( tournament_id, match_id )
    matches = @data[ tournament_id ] ||= Hash.new

    m = matches[ match_id ] ||= { 'match_id' => match_id,
                                      'team1'  => {
                                        'starter'    => [],
                                        'substitute' => [],
                                      },
                                      'team2'  => {
                                        'starter'    => [],
                                        'substitute' => [],                                     
                                      },
                                      'subs1'  => [],
                                      'subs2'  => [],                                     
                                      'goals1'  => [],
                                      'goals2'  => [],                                     
                                      'penalties1'  => [],
                                      'penalties2'  => [],                                     
                                      'bookings1'  => [],
                                      'bookings2'  => [],                                     
                             }
    m  
  end


  def []( tournament_id )
    @data[tournament_id].values
  end
 
  def data() @data; end

  
  def collect_subs( recs )
  ### note - records must be pairs!!  in and out 
  ##                  going_off and coming_on

  rec_offs = []

  recs.each_with_index do |rec,i|

    ## print "."
    ## print "[#{i}]"  if i % 100 == 0


    ## skip women's worldcup for now; sorry
    next if rec['tournament_name'].index('Women')

    if rec['going_off'] == '1'
      rec_offs << rec
      next
    end

    raise ArgumentError, "coming_on expected"          if rec['coming_on'] != '1'
    
    if rec_offs.size == 0
      pp rec
      raise ArgumentError, "no going off pair in queue"  
    end

    ## get first going off to get pairs
    rec_on   = rec
    rec_off  = rec_offs.shift     ## get first element

    if rec_on['minute_label'] != rec_off['minute_label'] ||
       rec_on['match_id']     != rec_off['match_id']
       pp rec_off
       pp rec_on
       raise ArgumentError, "sub off/on mismatch"  
    end


    tournament_id = rec['tournament_id']
    match_id      = rec['match_id']
    m = _get_match( tournament_id, match_id )


    subs = if rec['home_team'] == '1' && rec['away_team'] == '0'
              m['subs1'] 
           elsif rec['home_team'] == '0' && rec['away_team'] == '1'
              m['subs2']
           else
              pp rec
              raise ArgumentError, "expected home_team/away_team 0|1"
           end 

    sub = { 'off' => {  'shirt_number' => rec_off['shirt_number'].to_i(10),
                        'given_name'   => rec_off['given_name'],
                        'family_name'  => rec_off['family_name'],
                     },
            'on'  => {    'shirt_number' => rec_on['shirt_number'].to_i(10),
                          'given_name'   => rec_on['given_name'],
                          'family_name'  => rec_on['family_name'],},
            'minute_label' => rec['minute_label'],
            'minute_regulation'=> rec['minute_regulation'].to_i(10),
            'minute_stoppage'=> rec['minute_stoppage'].to_i(10),            
    }

    subs << sub
  end
end


POS = [
   'GK',
   'DF',   ## Definsive
   'MF',   ## Midfielder
   'FW',   ## Forward
   ## --- or more specific
   'RB',   ##  Right Back  -  Defensive
   'CB',   ##  Center Back
   'LB',   ##  Left Back
   'SW',   ##  Sweeper
   'RWB',  ##  Right Wing Back
   'LWB',  ##  Left Wing Back
   ## ---
   'DM',   ##    Defensive Midfielder
   'CM',   ##    Central Midfielder
   'AM',   ##  Attacking Midfielder
   'RM',   ##   Right Midfielder
    'LM',  ##   Left Midfielder
    ## ---
    'RW',  ## Right Wing
    'LW', ## Left Wing
    'LF',  ## Left Forward
    'CF',  ## Center Forward
    'RF',  ## Right Forward
    'SS', ## Second Striker
]

## find a different name e.g pos slot pos array or such?
POS_INDEX = {
   'GK'  => 0,
   'DF'  => 1,   ## Defensive
   'MF'  => 2,   ## Midfielder
   'FW'  => 3,   ## Forward
   ## --- or more specific
   'RB'  => 1,   ##  Right Back  -  Defensive
   'CB'  => 1,   ##  Center Back
   'LB'  => 1,   ##  Left Back
   'SW'  => 1,   ##  Sweeper
   'RWB' => 1,  ##  Right Wing Back
   'LWB' => 1,  ##  Left Wing Back
   ## ---
   'DM'  => 2,   ##    Defensive Midfielder
   'CM'  => 2,   ##    Central Midfielder
   'AM'  => 2,   ##  Attacking Midfielder
   'RM'  => 2,   ##   Right Midfielder
    'LM' => 2,  ##   Left Midfielder
    ## ---
    'RW' => 3,  ## Right Wing
    'LW' => 3, ## Left Wing
    'LF' => 3,  ## Left Forward
    'CF' => 3,  ## Center Forward
    'RF' => 3,  ## Right Forward
    'SS' => 3, ## Second Striker
}



SORT_POS = [
   'GK',

   'SW',   ##  Sweeper
   'DF',   ## Definsive
   'RB',   ##  Right Back  -  Defensive
   'CB',   ##  Center Back
   'LB',   ##  Left Back
   'RWB',  ##  Right Wing Back
   'LWB',  ##  Left Wing Back

   'MF',   ## Midfielder
   'DM',   ##    Defensive Midfielder
   'LM',  ##   Left Midfielder
   'CM',   ##    Central Midfielder
   'RM',   ##   Right Midfielder
   'AM',   ##  Attacking Midfielder

   'SS', ## Second Striker
   'FW',   ## Forward
   'RW',  ## Right Wing
   'LF',  ## Left Forward
   'LW', ## Left Wing
    'CF',  ## Center Forward
    'RF',  ## Right Forward
]

SORT_POS_INDEX = SORT_POS.each_with_index.to_h { |pos, index| [index, pos] }
pp SORT_POS_INDEX



def collect_lineups( recs )
  recs.each do |rec|
    ## skip women's worldcup for now; sorry
    next if rec['tournament_name'].index('Women')

    tournament_id = rec['tournament_id']
    match_id      = rec['match_id']
 
    m = _get_match( tournament_id, match_id )

    ## add date
    m['date'] = rec['match_date']


    team = if rec['home_team'] == '1' && rec['away_team'] == '0'
              m['team1'] 
           elsif rec['home_team'] == '0' && rec['away_team'] == '1'
              m['team2']
           else
              pp rec
              raise ArgumentError, "expected home_team/away_team 0|1"
           end 

    team['name'] = rec['team_name'] 


    lineup =   if rec['starter'] == '1' && rec['substitute'] == '0'
                   team['starter']
               elsif rec['starter'] == '0' && rec['substitute'] == '1'
                   team['substitute']
               else
                 pp rec
                 raise ArgumentError, "expected starter/substitute 0|1"
               end


    pos = rec['position_code']
    
    unless POS.include?( pos )
        pp rec
        raise ArgumentError, "unknown position_code"
    end


    player = { 'shirt_number'  => rec['shirt_number'].to_i(10),
               'position_code' => rec['position_code'],
               'given_name'    => rec['given_name'],
               'family_name'   => rec['family_name']
            }

    lineup << player
  end
end



def collect_goals( recs )
  recs.each do |rec|
    ## skip women's worldcup for now; sorry
    next if rec['tournament_name'].index('Women')

    tournament_id = rec['tournament_id']
    match_id      = rec['match_id']    
    m = _get_match( tournament_id, match_id )
    

    goals = if rec['home_team'] == '1' && rec['away_team'] == '0'
              m['goals1'] 
           elsif rec['home_team'] == '0' && rec['away_team'] == '1'
              m['goals2']
           else
              pp rec
              raise ArgumentError, "expected home_team/away_team 0|1"
           end 

    goal = {
             'shirt_number' => rec['shirt_number'].to_i(10),
             'given_name'   => rec['given_name'],
             'family_name'  => rec['family_name'],
             'minute_label' => rec['minute_label'],
              'minute_regulation'=> rec['minute_regulation'].to_i(10),
              'minute_stoppage'=>  rec['minute_stoppage'].to_i(10),
              'match_period'=> rec['match_period'],
              'own_goal'=> rec['own_goal'] == '1',
              'penalty'=>  rec['penalty'] == '1',
    }

    goals << goal
  end
end



def collect_penalties( recs )
  recs.each do |rec|
    ## skip women's worldcup for now; sorry
    next if rec['tournament_name'].index('Women')

    tournament_id = rec['tournament_id']
    match_id      = rec['match_id']
    m = _get_match( tournament_id, match_id )
    

    penalties = if rec['home_team'] == '1' && rec['away_team'] == '0'
              m['penalties1'] 
           elsif rec['home_team'] == '0' && rec['away_team'] == '1'
              m['penalties2']
           else
              pp rec
              raise ArgumentError, "expected home_team/away_team 0|1"
           end 

    pen = {
             'shirt_number' => rec['shirt_number'].to_i(10),
             'given_name'   => rec['given_name'],
             'family_name'  => rec['family_name'],
              'converted'=> rec['converted'] == '1',
    }

    penalties << pen
  end
end



def collect_bookings( recs )
  recs.each do |rec|
    ## skip women's worldcup for now; sorry
    next if rec['tournament_name'].index('Women')

    tournament_id = rec['tournament_id']
    match_id      = rec['match_id']
    m = _get_match( tournament_id, match_id )


    bookings = if rec['home_team'] == '1' && rec['away_team'] == '0'
              m['bookings1'] 
           elsif rec['home_team'] == '0' && rec['away_team'] == '1'
              m['bookings2']
           else
              pp rec
              raise ArgumentError, "expected home_team/away_team 0|1"
           end 

    booking = {
             'shirt_number' => rec['shirt_number'].to_i(10),
             'given_name'   => rec['given_name'],
             'family_name'  => rec['family_name'],
              'minute_label' => rec['minute_label'],
              'minute_regulation'=> rec['minute_regulation'].to_i(10),
              'minute_stoppage'=> rec['minute_stoppage'].to_i(10),
              'yellow_card'        => rec['yellow_card'] == '1',
              'red_card'           => rec['red_card'] == '1',
              'second_yellow_card' => rec['second_yellow_card'] == '1',
              'sending_off'        => rec['sending_off'] == '1'            
    }

    ## only add sending off for now (red card or 2nd_yellow_card)
    bookings << booking    if booking['sending_off']
  end
end




end # class Worldcup

