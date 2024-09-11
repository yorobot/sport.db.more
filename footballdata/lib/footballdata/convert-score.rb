
module Footballdata

def self.convert_score( score )
  ## duration: REGULAR  · PENALTY_SHOOTOUT  · EXTRA_TIME
  ft, ht, et, pen = ["","","",""]

  if score['duration'] == 'REGULAR'
    ft  = "#{score['fullTime']['home']}-#{score['fullTime']['away']}"
    ht  = "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
  elsif score['duration'] == 'EXTRA_TIME'
    et  =  "#{score['regularTime']['home']+score['extraTime']['home']}"
    et << "-"
    et << "#{score['regularTime']['away']+score['extraTime']['away']}"

    ft =  "#{score['regularTime']['home']}-#{score['regularTime']['away']}"
    ht =  "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
  elsif score['duration'] == 'PENALTY_SHOOTOUT'
    if score['extraTime']
      ## quick & dirty hack - calc et via regulartime+extratime
      pen = "#{score['penalties']['home']}-#{score['penalties']['away']}"
      et  = "#{score['regularTime']['home']+score['extraTime']['home']}"
      et << "-"
      et << "#{score['regularTime']['away']+score['extraTime']['away']}"

      ft = "#{score['regularTime']['home']}-#{score['regularTime']['away']}"
      ht = "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
    else  ### south american-style (no extra time)
        ## quick & dirty hacke - calc ft via fullTime-penalties
        pen =  "#{score['penalties']['home']}-#{score['penalties']['away']}"
        ft  =  "#{score['fullTime']['home']-score['penalties']['home']}"
        ft << "-"
        ft << "#{score['fullTime']['away']-score['penalties']['away']}"
        ht  = "#{score['halfTime']['home']}-#{score['halfTime']['away']}"
    end
  else
    puts "!! unknown score duration:"
    pp score
    exit 1
  end

  [ft,ht,et,pen]
end
end  # module Footballdata
