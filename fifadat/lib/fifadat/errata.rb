###
#  known data gotchas/errors


##
#  worldcup 2026 - USA v Belgium
#  -- goal  (period, minute)

=begin
in USA v Belgium
"Type"=>2,
 "IdPlayer"=>"448362",
 "Minute"=>"1'",
 "IdAssistPlayer"=>nil,
 "Period"=>2,
 "IdGoal"=>nil,
 "IdTeam"=>"43935"}

{     "Type": 2,
      "IdPlayer": "448362",
      "Minute": "0'",
      "IdAssistPlayer": null,
      "Period": 2,                ##  change to 3!!!!
      "IdGoal": null,
      "IdTeam": "43935"},

=end


def errata_autofix_goal( h )
   if h['Period']     ==  2 &&
      h['IdPlayer'] == '448362' &&         ##
      h['IdTeam']   == '43935'             ## Belgium
         puts "-- ERRATA - autofix goal  USA v Belgium / Worldcup"
         pp h

         h['Period']  = 3    ## 1ST_HALF
         h['Minute']  = "9'"
   end

   h
end


##
#  clubworldcup
#  -- score (ResultType)


def errata_autofix_score( m )
   ##  pachuca vs salzburg in cwc 2025??
   if m['IdMatch'] == '400019191'  &&        ##  fix for pachuca vs salzburg
      m['ResultType'] == 0
            m['ResultType'] == 1   ## regular   (or use 4-REG/AGG - why? why not?)

            puts "-- ERRATA - autofix score    pachuca vs salzburg / Club Worldcup"
    end

    m
end
