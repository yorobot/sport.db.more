
##
##  check - maybe add Heights (e.g. 195.0)



POS = {
   0 => 'GK',  # goalkeeper
   1 => 'DF',  # defender
   2 => 'MF',  # midfielder
   3 => 'FW',  # forward
   4 => '?',   # unknown !!!
}

def pp_squads( slug:, 
               season:,
                opt_jerseys: true,
                opt_country: false )
    
   data = read_json( "./#{slug}/misc/#{season}_squads.json" )
   data = data['Results']

puts "  #{data.size} result(s)"


buf = String.new
buf << "# #{data.size} Teams\n\n"


 puts "#{slug} #{season}  # #{data.size} Teams"



data.each_with_index do |h,i|

    team = desc( h['TeamName'])
    country = h['IdCountry']

    ## e.g. Germany FR => West Germany, etc.
    team = norm_team( team )



    players = h['Players']

    if opt_country
      buf << "== #{team} (#{country})"
    else   
      buf << "== #{team}"
    end
 
    buf << "     # #{players.size} Players\n\n"
    



    puts  "== [#{i+1}/#{data.size}]  #{team} - #{players.size} player(s)" 

    players =  players.sort do |l,r|
                    res = l['Position'] <=> r['Position']
                    if res == 0 && opt_jerseys 
                       res = (l['JerseyNum']||999) <=> (r['JerseyNum']||999)
                    end
                    res
               end

     ## use max country - why? why not?
     ##  1934 Austria first is not AUT - check??
     
     firstIdCountry = players[2]['IdCountry']
     last_pos = nil
   
     players.each do |player|
    
        name = desc( player['PlayerName'])

        name = norm_player( name )

##
##  check player name if include parentheses or such
## GILMAR (Gilmar Dos Santos Neves) - 1958 Brazil 
##  PELÉ (Edson Arantes do Nascimento)
  
## ROMÁRIO (Romário de Souza Faria)
##   only allow  alpha and space
      if !is_alpha?( name )
        puts "!! invalid player name:"
        pp player
        pp name
           exit 1
      end


        pos  = player['Position'] 
        jersey = player['JerseyNum']

        assert( [0,1,2,3,4].include?(pos), 
           "pos 0/1/2/3/4 expected; got #{player.pretty_inspect}" )

        ## note - birth_date is OPTIONAL (not available for all)
        bday = player['BirthDate'] ? parse_date( player['BirthDate']) : nil


       idCountry = player['IdCountry']

 #      if lastIdCountry 
 #        assert( idCountry == lastIdCountry, 
 #             "country code do NOT match #{idCountry} != #{lastIdCountry}" )
 #      end
         
   
        ## add a blank line between GK/DF/MF/FW/? (unknown) 
       buf << "\n"  if last_pos && last_pos != pos


        name_col = if opt_country
                      ## check if player country is different from team country
                       if country != idCountry
                          "#{name} (#{idCountry}),"
                       else
                          "#{name},"                    
                       end
                   else 
                     if firstIdCountry != idCountry
                        ## ignore country code - why? why not?
                       puts  "!! country code do NOT match #{idCountry}; #{firstIdCountry} expected" 
                       pp player

                        ## "#{name} (#{idCountry}),"
                        "#{name},"
                     else
                        "#{name},"
                     end
                  end

        cols = [name_col,
                "#{POS[pos]},",
                bday ? "b. #{bday.strftime('%Y/%m/%d')}" :
                       "" 
               ]
             
        if opt_jerseys
           cols = ["#{jersey},"]  + cols
           buf << "   %6s %-30s %-4s %-10s" % cols
        else
           buf << "   %-30s %-4s %-10s" % cols
        end

        buf << "\n"

        last_pos = pos
    end


    officials = h['Officials']  ## coaches 

    if officials.size > 0
       
        buf << "\n"

      officials.each do |official|

        name = desc( official['Name'])
        name = norm_official( name )  ## replace non-breaking spaces
  
        if !is_alpha?( name )
          puts "!! invalid official name:"
          pp official
          pp name
          exit 1
        end

  
        role  = official['Role'] 
        idCountry = official['IdCountry']

        assert( [0,1].include?(role), 
           "role 0/1 expected; got #{official.pretty_inspect}" )

         ## skip co-coaches - why? why not?
         next if role == 1
         #    "  skip co-coach: #{official.pretty_inspect}"
        

  
        ## note - birth_date is OPTIONAL (not available for all)
        bday = official['BirthDate'] ? parse_date( official['BirthDate']) : nil


         ## 0 -> mg = manager
         ## 1 -> am = assistant manager  
         ## or use   co (coach), ac (assistiant coach) ??


         ##
         ## for now add country code (cc) to all managers/coaches

         ## firstIdCountry != idCountry ? "#{name} (#{idCountry})," :  "#{name},"

        cols = [ "#{name} (#{idCountry}),",
                role == 0 ? "MG," : "AM,",
                bday ? "b. #{bday.strftime('%Y/%m/%d')}" :
                       "" 
               ]
    
       if opt_jerseys
           cols = ["-,"]  + cols
           buf << "   %6s %-30s %-4s %-10s" % cols
        else
           buf << "   %-30s %-4s %-10s" % cols
        end
        buf << "\n"
     
      end
      buf << "\n\n"
    end



   end
    buf
end


