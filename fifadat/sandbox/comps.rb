require_relative '../helper'



###
#  ageType
#   0 -  ??
#
#   1 -   U17     U-17 World Cup / U17 National Team Friendlies
#                   MLS Generation Cup U17
#   2 -   U18     U18 National Team Friendlies
#                      U18 Premier League Cup
#   3-    U19     U19 Championship Qualification
#   4 -   U20     U-20 World Cup / CONMEBOL U20

#   5  -  ??        Olympic Football Tournament / Olympics Intercontinental Play-offs /
#                   AFC U23 Asian Cup

#  10 -   U15     U15 National Team Friendlies
#                  MLS Generation Cup U15
#  11 -   U16     U16 National Team Friendlies
#  12 -   U21     U21 Championship / Tournoi Maurice Revello /
#                     U21 National Team Friendlies
#                     Premier League 2

#  14 -   ?? U23     U23 National Team Friendlies /  Asian Games
#    




##
##   get all datasets

files = Dir.glob( "./competitions/*.json" )

puts "  #{files.size} competition(s)"

rows        = []
rows_m_nati = []
rows_f_nati = []
rows_m_club = []
rows_f_club = []
rows_more   = []   ## u16, etc.

files.each_with_index do |file, i|

    puts "==> [#{i+1}/#{files.size}]..."
    data = read_json( file )

    if data.nil?
       puts "!! no data in #{file}"
      exit 1
    end

     footballType = data['FootballType']
    # 1 - Futsal
    # 2 - Beach Soccer

    ## skip futsal & beach soccer !!!
    next if footballType == 1 || footballType == 2

    assert( [0,1,2].include?(footballType),
              "expected FootballType 0/1/2; got #{data.pretty_inspect}" )

      gender   = data['Gender'] 
      teamType = data['TeamType']
      ageType  = data['AgeType']

      assert( [1,2].include?(gender),
              "expected Gender 1/2; got #{data.pretty_inspect}" )
     assert( [0,1].include?(teamType),
              "expected TeamType 0/1; got #{data.pretty_inspect}" )

    values = [
        data['IdOwner'],
        gender.to_s,
        teamType.to_s,
        data['CompetitionType'].to_s,
        ageType.to_s,
        data['IdCompetition'],
        data['IdConfederation'].join('|'),
        data['IdMemberAssociation'].join('|'),
        desc( data['Name'] ),
    ]


    if gender == 1 && teamType == 0 && [0,7].include?( ageType )
       rows_m_club << values
    elsif gender == 1 && teamType == 1 && [0,7].include?( ageType )
       rows_m_nati << values
    elsif gender == 2 && teamType == 0 && [0,7].include?( ageType )
       rows_f_club << values
    elsif gender == 2 && teamType == 1 && [0,7].include?( ageType )
       rows_f_nati << values
    else 
       rows_more << values
    end

    rows << values
end

headers = ['IdOwner',    #0
           'Gender',     #1
           'TeamType',   #2
           'CompetitionType',  #3
           'AgeType',          #4
           'IdCompetition',    #5
           'IdConfederation',   #6
           'IdMemberAssociation',  #7
           'Name',                 #8
          ]
   

def sort_comps( rows )
    rows.sort do |l,r|
              res = l[0] <=> r[0]                 # idOwner
              res = l[1] <=> r[1]   if res == 0   # gender 1=m/2=f 
              res = r[2] <=> l[2]   if res == 0   # team type (0=club,1=nati)
              res = l[7] <=> r[7]   if res == 0   # idMemberAssociation
              res
    end
end

## write_csv( "./competitions.csv", rows, headers: headers )
write_csv( "./competitions_m_nati.csv", sort_comps(rows_m_nati), headers: headers )
write_csv( "./competitions_m_club.csv", sort_comps(rows_m_club), headers: headers )
write_csv( "./competitions_f_nati.csv", sort_comps(rows_f_nati), headers: headers )
write_csv( "./competitions_f_club.csv", sort_comps(rows_f_club), headers: headers )
write_csv( "./competitions_more.csv", sort_comps(rows_more), headers: headers )

puts "bye"