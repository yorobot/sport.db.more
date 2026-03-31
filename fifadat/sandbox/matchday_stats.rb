require_relative '../helper'



GENDER = { 1 => 'M', 2 => 'F' }
TEAM_TYPE = { 0 => 'CLUB', 1 => 'NATI', 2 => 'UNKOWNN' }

=begin
   "AgeType": 11,
      "TeamName": [{"Locale": "en-gb", "Description": "Tahiti U16"}],
   "AgeType": 3,
      "TeamName": [{"Locale": "en-gb", "Description": "Tahiti U19"}], 
   "ageType": 0  - maybe unknown??  for teamType == 2 (unknown ???) &&
                                        gender == nil &&
                                        footballType == nil

MatchStatus"=>{0=>9653, 
               1=>50,
                7=>159, 
                8=>32, 
                9=>13, 
                99=>5, 
               },

 "ResultType"=>{0=>1,
               1=>9612,    -- 90 min 
               2=>76,       -- 
               3=>15,       -- 
               4=>184, 
               5=>11,
               12=>13,  
               },


=end

def mk_stats
  {         ## match stats
             'SeasonName' => Hash.new(0),
             'MatchStatus' => Hash.new(0),
             'ResultType' => Hash.new(0),
             'MatchStatus/ResultType' => Hash.new(0),
             ## team stats
            'TeamType' => Hash.new(0),
            'AgeType' => Hash.new(0),
            'FootballType' => Hash.new(0),
            'Gender' => Hash.new(0),
            'TeamType/AgeType/FootballType/Gender' => Hash.new(0),
   }
end

def collect_stats( matches, stats: mk_stats()) 

   matches.each do |m|
      gender = m['Home']['Gender'] || gender = m['Away']['Gender']  
      teamType = m['Home']['TeamType']
      teamType = m['Away']['TeamType']  if teamType == 2

      seasonName = "#{GENDER[gender]}/#{TEAM_TYPE[teamType]} #{desc(m['SeasonName'])} (#{m['IdCompetition']})"
      stats['SeasonName'][seasonName] += 1

      stats['MatchStatus'][m['MatchStatus']] += 1
      stats['ResultType'][m['ResultType']] += 1
      stats['MatchStatus/ResultType']["#{m['MatchStatus']}/#{m['ResultType']}"] += 1 

      stats['TeamType'][m['Home']['TeamType']] += 1
      stats['AgeType'][m['Home']['AgeType']] += 1
      stats['FootballType'][m['Home']['FootballType']] += 1
      stats['Gender'][m['Home']['Gender']] += 1
      
      stats['TeamType/AgeType/FootballType/Gender'][
            "#{m['Home']['TeamType']}/"+
            "#{m['Home']['AgeType']}/"+
            "#{m['Home']['FootballType']}/"+
            "#{m['Home']['Gender']}"
       ] += 1
       
      stats['TeamType'][m['Away']['TeamType']] += 1
      stats['AgeType'][m['Away']['AgeType']] += 1
      stats['FootballType'][m['Away']['FootballType']] += 1
      stats['Gender'][m['Away']['Gender']] += 1
      
      stats['TeamType/AgeType/FootballType/Gender'][
            "#{m['Away']['TeamType']}/"+
            "#{m['Away']['AgeType']}/"+
            "#{m['Away']['FootballType']}/"+
            "#{m['Away']['Gender']}"
       ] += 1
    end

   stats
end

year = 2026
date = Date.new( year, 1, 1 )

total_stats = mk_stats()

loop do

  from = "#{date.strftime('%Y-%m-%d')}T00:00:00Z"
  to   = "#{date.strftime('%Y-%m-%d')}T23:59:59Z"

  print "==> %03d" % date.yday 
  print "  #{from} - #{to} "
  
  
  outpath = "./matchday/#{date.year}/#{'%03d' % date.yday}_#{date.strftime('%Y-%m-%d')}.json"
  data = read_json( outpath )
  data = data['Results']
  print " -- #{data.size} match(es)\n"
  
  stats = collect_stats( data )
  pp stats

   collect_stats( data, stats: total_stats )

   date += 1

   break      if date >= Date.new( year, 3, 30 )
end


puts
puts "total:"
pp total_stats


puts "bye"