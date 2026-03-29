

def build_stadium( h )
     id         = h['IdStadium']
     id_country = h['IdCountry']
 ##    id_city    = h['IdCity']
  
     name      = desc( h['Name'] )
     city_name = desc( h['CityName'] )
   

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




   rec = { id:         id,
 ##          id_city:    id_city, 
           name:      name,
           city_name: city_name,
           id_country: id_country, 
        }

  rec
end



class Stadiums
   def initialize
      @recs = {}
    
      ## track by cities
      @by_city = {}
   end

   def add( new_rec )
      rec =  @recs[ new_rec[:id] ]
      if rec.nil?
          rec = new_rec
          rec[:count] = 1   ## add counter - why? why not?
          @recs[ new_rec[:id]] = new_rec

          city_rec = @by_city[ new_rec[:city_name]] ||= []
          city_rec << new_rec
      else
          rec[:count] += 1
          ## assert attributes equal - why? why not?

         assert( new_rec[:name] == rec[:name] &&
                  new_rec[:city_name] == rec[:city_name] &&
                  new_rec[:id_country] == rec[:id_country],
                  "stadium records NOT matching - #{rec.pretty_inspect} != #{new_rec.pretty_inspect}")
      end
   end


   def recs( sort: true, stringify: false )
      recs = @recs.values
      if sort
        recs = recs.sort do |l,r|
                res = l[:id_country] <=> r[:id_country]
                res = l[:city_name] <=> r[:city_name]  if res == 0
                res
             end
      end
      ## fix/fix/fix - stringify keys!!!
      recs
   end
   
 
   def dump
      recs = recs( stringify: false )
      pp recs
      puts "  #{recs.size} stadiums(s)"
   end

   def size() @recs.size; end

   def cities() @by_city.keys; end

end  # class Stadiums



def collect_stadiums( data, stadiums )
  data.each_with_index do |m, i|

    stadium = build_stadium( m['Stadium'] )
    
    stadiums.add( stadium )
  end
end



