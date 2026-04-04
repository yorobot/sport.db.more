

####
ALPHA_RE = %r{ \A
                   \p{L}
                   [\p{L} '.-]*
               \z
              }ix

##
##  J. HARTING               - note: include .
##   Jose BUSTAMANTE-NAVA    - note: include -
##   Yannick N'Djeng         - note: include '
##    Ismail JAKOBS  Ismail JAKOBS

def is_alpha?( name )  ## use is_alpha_name? or is_unialpha? or such??
    ALPHA_RE.match( name ) ? true : false
end



def _norm_name( name )
    ## \u00A0 - non-breaking space
   name = name.gsub( /[\u00A0]/, ' ' )
   name
end

def norm_player( name )
   ##  check player name if include parentheses or such
    ## GILMAR (Gilmar Dos Santos Neves) - 1958 Brazil 
    ##  PELÉ (Edson Arantes do Nascimento)
  
   name = _norm_name( name )

   ## ROMÁRIO (Romário de Souza Faria)
  
   name = 'GILMAR'  if name == 'GILMAR (Gilmar Dos Santos Neves)'
   name = 'PELÉ'    if name == 'PELÉ (Edson Arantes do Nascimento)'
  
   name = 'ROMÁRIO'   if name == 'ROMÁRIO (Romário de Souza Faria)'

   name = 'EUSEBIO'   if name == 'EUSEBIO (Eusebio da Silva Ferreira)'
  
   name
end

def norm_official( name )
     # for referees (in matches) and  coaches (in squads)
    name = _norm_name( name )
    name
end


def norm_team( name )

   name = _norm_name( name )
   
    ##
    ## simple mapping - make for generic!
    name = 'West Germany'   if name == 'Germany FR'
    name = 'East Germany'   if name == 'German DR'
    
    name = 'South Korea'   if name == 'Korea Republic'
    name = 'North Korea'   if name == 'Korea DPR'
    
    name = 'China'     if name == 'China PR'
    name = 'Ireland'   if name == 'Republic of Ireland'
  
    name = 'Iran'      if name == 'IR Iran' 
 ## !! ASSERT FAILED - team records NOT matching - 
 ##    {:id=>"43817", :name=>"Iran", :abbrev=>"IRN", :count=>7}
 ## != {:id=>"43817", :name=>"IR Iran", :abbrev=>"IRN"}   

    name = 'USA'     if name == 'United States'
  
    name
end


def norm_stadium( name, city_name: )

      name      = _norm_name( name )
      city_name = _norm_name( city_name ) 
  

     name = 'Arena AufSchalke'  if name == 'FIFA World Cup Stadium, Gelsenkirchen'

     name = 'Maracanã'       if name == 'Maracanã - Estádio Jornalista Mário Filho'
     name = 'Independencia'  if name == 'Independencia - Estádio Raimundo Sampaio'
     name = 'Eucaliptos'     if name == 'Eucaliptos - Estádio Ildo Meneghetti'

     name = 'El Monumental'  if name == 'El Monumental - Estadio Monumental Antonio Vespucio Liberti'
     name = 'Arroyito'   if name == 'Arroyito - Estadio Dr. Lisandro de la Torre'

     name = 'Bombonera'    if name == 'Bombonera - Estadio Nemesio Diez'
     name = 'Nou Camp'     if name == 'Nou Camp - Estadio León'

     city_name = 'Recife'          if city_name == 'RECIFE'
     city_name = 'León'             if city_name == 'LEON'
     city_name = 'Berlin West'      if city_name == 'BERLIN WEST'
     city_name = 'Lyon'             if city_name == 'LYON'
     city_name = 'Lens'             if city_name == 'LENS'

     city_name = 'Paris (Colombes)'    if city_name == 'Colombes' &&
                                            name == 'Stade Olympique'
     city_name = 'Paris (Saint-Denis)' if city_name == 'Saint-Denis' &&
                                            name == 'Stade de France'
                                            

      if city_name == 'New York' &&
         name == 'New York/New Jersey Stadium'
         city_name = 'New York/New Jersey (East Rutherford)'
         name      = 'Giants Stadium'
      end 

      if city_name == 'Los Angeles' &&
         name == 'Rose Bowl Stadium'
        city_name = 'Los Angeles (Pasadena)' 
        name      = 'Rose Bowl'  
      end

      
     city_name = 'Los Angeles (Pasadena)' if city_name == 'Pasadena'
                                              name == 'Rose Bowl'

     city_name = 'Boston (Foxborough)'    if city_name == 'Boston' && 
                                               name  == 'Foxboro Stadium' 

     city_name = 'New York/New Jersey (East Rutherford)'  if city_name == 'New York' &&
                                                              name == 'Giants Stadium'  

     city_name = 'Detroit (Pontiac)'     if city_name == 'Detroit' &&
                                            name == 'Pontiac Silverdome'  

     city_name = 'San Francisco (Stanford)'  if city_name == 'San Francisco' &&
                                                 name == 'Stanford Stadium' 

    [name, city_name]                                                
end




def norm_stage( stageName, groupName,
                     team1:,
                     team2:,
                     date:  )
  ##########
  ## worldcup 1934   - mark replays!!!
    stageName = 'Quarter-final, Replay'  if date == '1934-06-01' &&
                                            stageName == 'Quarter-final' &&
                                            team1[:name] == 'Italy' &&
                                            team2[:name] == 'Spain'
                                            
  ########## 
  ## worldcup 1938   - mark replays!!!
    stageName = '1st Round, Replays'  if date == '1938-06-09' &&
                                            stageName == '1st Round' &&
                                            team1[:name] == 'Cuba' &&
                                            team2[:name] == 'Romania'
                                            
    stageName = '1st Round, Replays'  if date == '1938-06-09' && 
                                            stageName == '1st Round' &&
                                            team1[:name] == 'Switzerland' &&
                                            team2[:name] == 'Germany'
                                            
   stageName = 'Quarter-final, Replay' if date == '1938-06-14' && 
                                            stageName == 'Quarter-final' &&
                                            team1[:name] == 'Brazil' &&
                                            team2[:name] == 'Czechoslovakia'
                                            
   ############
   ## worldcup 1954     - mark group play-offs (deciders)!!!
   groupName = 'Group 2, Play-off'     if date == '1954-06-23' && 
                                           groupName == 'Group 2'  &&
                                            team1[:name] == 'West Germany' &&
                                            team2[:name] == 'Turkey' 
                                            
   groupName = 'Group 4, Play-off'     if date == '1954-06-23' && 
                                            groupName == 'Group 4'  &&
                                            team1[:name] == 'Switzerland' &&
                                            team2[:name] == 'Italy'
                                            
   ##############
   ## worldcup 1958     - mark group play-offs (deciders)!!!
   groupName = 'Group 1, Play-off'     if date == '1958-06-17' && 
                                           groupName == 'Group 1'  &&
                                            team1[:name] == 'Northern Ireland' &&
                                            team2[:name] == 'Czechoslovakia'
                                            
   groupName = 'Group 3, Play-off'     if date == '1958-06-17' && 
                                            groupName == 'Group 3'  &&
                                            team1[:name] == 'Wales' &&
                                            team2[:name] == 'Hungary'                                          
 
   groupName = 'Group 4, Play-off'     if date == '1958-06-17' && 
                                            groupName == 'Group 4'  &&
                                            team1[:name] == 'Soviet Union' &&
                                            team2[:name] == 'England'                                             

    [stageName, groupName]                                        
end


