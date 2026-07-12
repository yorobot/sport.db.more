
module Footballdata





def self.convert_json( league:, season: )

  season = Season( season )   ## cast (ensure) season class (NOT string, integer, etc.)

  ### note - find_league returns the metal_league_code
  league_code = find_league!( league )

  matches_url = Metal.competition_matches_url( league_code, season.start_year )
  teams_url   = Metal.competition_teams_url(   league_code, season.start_year )

  data           = Webcache.read_json( matches_url )
  data_teams     = Webcache.read_json( teams_url )


  ## note - for international club tournaments
  ##         auto-add (fifa) country code e.g.
  ##      Liverpool FC  => Liverpool FC (ENG)
  ##
  ##  todo/fix -  move flag to league_info via .csv config - why? why not?
  ## clubs_intl  =  ['uefa.cl',
  ##                 'copa.l'].include?(league.downcase) ? true : false

  ## build a team lookup by name (& short_name)

  teams = Teams.new
  teams.add( data_teams['teams'] )
  puts "#{teams.size} team(s)"

  ## add/update match counts
  teams.add_matches( data['matches'] )


  stages = Stages.new
  stages.add_matches( data['matches'] )


  recs = []


  ## track (meta stats) stage, match status et
  stats = {  status: Hash.new(0),   ## e.g. TIMED,etc
             score:  Hash.new(0),   ## e.g.  REGULAR,etc.
           }




  data[ 'matches'].each do |m|

     ## use ? or N.N. or ? for nil  - why? why not?
     team1_name = m['homeTeam']['name']
     team2_name = m['awayTeam']['name']

     team1 = team1_name ? teams.find_by!(name: team1_name ) : { name: 'N.N.' }
     team2 = team2_name ? teams.find_by!(name: team2_name ) : { name: 'N.N.' }


  stage = m['stage']
  group = m['group']

  matchday = m['matchday']
  matchday = nil       if matchday == 0   ## change 0 to nil (empty) too


    stats[:status][m['status']]           += 1  ## track status counts
    stats[:score][m['score']['duration']] += 1

    case m['status']
    when 'SCHEDULED', 'TIMED',
         'PAUSED',    'IN_PLAY'   ## IN_PLAY, PAUSED
      score = []
    when 'FINISHED'
      score = convert_score_to_hash( m['score'] )
    when 'AWARDED'   # AWARDED
      assert( m['score']['duration'] == 'REGULAR', 'score.duration REGULAR expected' )
      score = [m['score']['fullTime']['home'],
               m['score']['fullTime']['away']]
    when 'CANCELLED'
      ## note cancelled might have scores!! -- add/fix later!!!
      ##   ht only or ft+ht!!!  (see fr 2021/22)
      ## score = convert_score_to_hash( m['score'] )
      ##
      ##  note - there is cancelled (e.g. not/played)  AND
      ##                  annulled/voided (e.g. played!! with score)
      score = []
    when 'POSTPONED'
      score = []
    else
      raise ArgumentError,
              "unsupported match status >#{m['status']}< - sorry: #{m.pretty_inspect}"
    end



    rec = {
        status: m['status'],
        stage:    stage
    }


    utc = UTC.strptime( m['utcDate'], '%Y-%m-%dT%H:%M:%SZ' )
    assert( utc.strftime( '%Y-%m-%dT%H:%M:%SZ' ) == m['utcDate'], 'utc time mismatch' )


    ## do NOT add time if status is SCHEDULED
    ##                        or POSTPONED for now
    ##   otherwise assume time always present - why? why not?
    ##
    ## assume NOT valid utc time if 00:00
    if utc.hour == 0 && utc.min == 0 &&
       ['SCHEDULED','POSTPONED'].include?( m['status'] )
       ## assume local date - why? why not?
       rec[:date]     = utc.strftime( '%Y-%m-%d' )
    else
       rec[:date_utc] = utc.strftime( '%Y-%m-%dT%H:%M:%SZ' )
    end



    rec[:group]     =   group      if group
    rec[:matchday]  =   matchday   if matchday

    rec[:team1] =  team1[:name]
    rec[:team2] =  team2[:name]

    rec[:score] = score     unless score.empty?


    recs << rec
  end


  stats[:matches] = recs.size
  stats[:teams]   = teams.size

  data = {
     slug:   league,
     season: season.to_s,
     meta:   stats,
     stages: stages.as_json,
     teams:  teams.as_json,
     matches: recs
  }


  path = "#{config.convert.out_dir}/#{season.to_path}/#{league.downcase}.json"
  ## note: change season_key from 2019/20 to 2019-20  (for path/directory!!!!)
  puts "  writing to >#{path}<"
  write_json( path, data )
end   # method convert_json


end #  module Footballdata
