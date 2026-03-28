require_relative 'fifa'
require_relative 'fifa_helper'
require_relative 'fifa_stadiums'


## collect (all) stadiums in stadiums.json




seasons = [1930, 1934, 1938,
           1950, 1954, 1958, 1962, 1966, 1970, 1974, 1978,
           1982, 1986, 1990, 1994, 1998, 2002, 2006, 2010,
           2014, 2018, 2022]


stadiums = Stadiums.new

seasons.each do |season|

  cup = read_json( "./fifa/#{season}_matches.json" )

   ## pp cup['Results']
   match_count = cup['Results'].size
   puts "  #{match_count} match(es) in season #{season}"


   collect_stadiums( cup, stadiums )
end


stadiums.dump

## fix/fix/fix -- stringize keys!!!
write_json( "./tmp/stadiums.json", stadiums.recs )

puts "bye"


__END__

:id=>"400221702", :name=>"Allianz Arena", :city_name=>"Munich", :id_country=>"GER", :count=>6},
 {:id=>"400221707",
  :name=>"FIFA World Cup Stadium, Gelsenkirchen",
  :city_name=>"Gelsenkirchen",
  :id_country=>"GER",
  :count=>5},
 {:id=>"400221706", :name=>"Commerzbank Arena", :city_name=>"Frankfurt", :id_country=>"GER", :count=>5},
 {:id=>"400221705", :name=>"Signal-Iduna-Park", :city_name=>"Dortmund", :id_country=>"GER", :count=>6},
 {:id=>"400118994", :name=>"Volksparkstadion", :city_name=>"Hamburg", :id_country=>"GER", :count=>5},
 {:id=>"400221703", :name=>"Zentralstadion", :city_name=>"Leipzig", :id_country=>"GER", :count=>5},
 {:id=>"400119029", :name=>"Frankenstadion", :city_name=>"Nuremberg", :id_country=>"GER", :count=>5},
 {:id=>"400221704", :name=>"Rhein Energie Stadium", :city_name=>"Cologne", :id_country=>"GER", :count=>5},
 {:id=>"400119023", :name=>"Fritz-Walter-Stadion", :city_name=>"Kaiserslautern", :id_country=>"GER", :count=>5},
 {:id=>"400221708", :name=>"HDI-Arena", :city_name=>"Hanover", :id_country=>"GER", :count=>5},
 {:id=>"400119022", :name=>"Mercedes-Benz Arena", :city_name=>"Stuttgart", :id_country=>"GER", :count=>6},

 {:id=>"400221701", :name=>"Olympiastadion", :city_name=>"Berlin", :id_country=>"GER", :count=>6},


 {:id=>"400222268", :name=>"Waldstadion", :city_name=>"Frankfurt", :id_country=>"FRG", :count=>5},
 {:id=>"400222264", :name=>"Olympiastadion", :city_name=>"BERLIN WEST", :id_country=>"FRG", :count=>3},
 {:id=>"400222271", :name=>"Volksparkstadion", :city_name=>"Hamburg", :id_country=>"FRG", :count=>3},
 {:id=>"400222265", :name=>"Westfalenstadion", :city_name=>"Dortmund", :id_country=>"FRG", :count=>4},
 {:id=>"400222266", :name=>"Rheinstadion", :city_name=>"Düsseldorf", :id_country=>"FRG", :count=>5},
 {:id=>"400222267", :name=>"Niedersachsenstadion", :city_name=>"Hanover", :id_country=>"FRG", :count=>4},
 {:id=>"400222269", :name=>"Olympiastadion", :city_name=>"Munich", :id_country=>"FRG", :count=>5},
 {:id=>"400222270", :name=>"Neckarstadion", :city_name=>"Stuttgart", :id_country=>"FRG", :count=>4},
 {:id=>"400222272", :name=>"Parkstadion", :city_name=>"Gelsenkirchen", :id_country=>"FRG", :count=>5}
