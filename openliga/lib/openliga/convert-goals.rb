module Openliga



def self.build_goals( h, team1:, team2: )

    recs = []

     h.each do |rec|

        ## get team index (1|2) from team_id
        team = if    rec['scoringTeamId'].nil?     then  nil
               elsif rec['scoringTeamId'] == team1 then  1
               elsif rec['scoringTeamId'] == team2 then  2
               else
                  raise ArgumentError,
                     "[goal] expected team ids #{[team1,team2].inspect}; got #{h.pretty_inspect}"
               end


        recs << Goal.new( team:   team,
                          name:    _clean_name( rec['goalGetterName']),
                          score:  [rec['scoreTeam1'], rec['scoreTeam2']],
                          m:       rec['matchMinute'],
                          stoppage: rec['isOvertime'],
                          pen:     rec['isPenalty'],
                          og:      rec['isOwnGoal'],
                          comment: _clean( rec[''] ) )
    end

    recs
end


end # module Openliga



__END__

"scoreTeam1"=>0,
  "scoreTeam2"=>0,
  "matchMinute"=>28,
  "goalGetterID"=>19593,
  "goalGetterName"=>"M. Svanberg",
  "scoringTeamId"=>nil,
  "isPenalty"=>false,
  "isOwnGoal"=>false,
  "isOvertime"=>false,


        "goalID": 130535,
        "scoreTeam1": 1,
        "scoreTeam2": 0,
        "matchMinute": 27,
        "goalGetterID": 23135,
        "goalGetterName": "M. Olise",
        "scoringTeamId": 40,
        "isPenalty": false,
        "isOwnGoal": false,
        "isOvertime": false,
        "comment": null
