
## old lookup by name only (requires mods for int'l tournaments)

## mods uefa.cl
mods = SportDb::Import.catalog.clubs.build_mods(
                  { 'Liverpool | Liverpool FC' => 'Liverpool FC, ENG',
                    'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
                    'Barcelona'                => 'FC Barcelona, ESP',
                    'Valencia'                 => 'Valencia CF, ESP'  
                  })
pp mods

## mods copa.l 
mods = SportDb::Import.catalog.clubs.build_mods(
                  { 'Club Nacional'        => 'Club Nacional, PAR', # Paraguay
                    'Universidad Catolica' => 'Universidad Catolica, ECU',  ## Ecuador
                    'CA River Plate'       => 'CA River Plate, ARG',   ## Argentina
                    'Liverpool FC'         => 'Liverpool FC, URU',  ## Uruguay
                  })
pp mods


## mods eng, etc.
mods = SportDb::Import.catalog.clubs.build_mods(
                  { 'Liverpool | Liverpool FC' => 'Liverpool FC, ENG',
                    'Arsenal  | Arsenal FC'    => 'Arsenal FC, ENG',
                  })
pp mods




###

   ## note: first check mods!!! e.g. Liverpool
   club = mods[ team_name ] || SportDb::Import.catalog.clubs.find( team_name )
   if club.nil?
    puts "!! ERROR: no mapping found for club >#{team_name}<:"
    pp team_hash
    ## exit 1
   else
    if team_name != club.name
       puts "!! #{i+1} -   #{team_name} | #{team_hash[:short]}  =>  #{club.name}"  
       puts  "             @ #{team_hash[:address]} > #{team_hash[:country]}"
    else
      puts "    #{i+1} -   #{team_name}, #{team_hash[:country]} == #{club.country.name}"
    end 
   end
