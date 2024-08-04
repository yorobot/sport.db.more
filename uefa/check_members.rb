require_relative 'boot'


###
##  fix:
##   add (new) alt names!!!
##    {"name"=>"Türki̇ye", "code"=>"TUR", "key"=>"tr"}
##    {"name"=>"Czechia", "code"=>"CZE", "key"=>"cz"}


##
##  change key for Kosovo (xk v. kos) - why? why not?
##    {"name"=>"Kosovo", "code"=>"KOS", "key"=>"kos"}
##   <Country: xk - Kosovo (KVX)|KOS, fifa|uefa)>
## <Country: xk - Kosovo (KVX)|KOS, fifa|uefa)>
## !! ERROR - (fifa) code do NOT match
## !! ERROR - key do NOT match
##
## ISO affirms that no code beginning with "X" 
##    will ever be standardised as a country code
##    if/when Kosovo is recognised, 
##    this XK (XKK/XKX) code will need to be replaced 
##    with one beginning with another letter.


recs = read_csv( './more/members.csv' )
puts "   #{recs.size} member(s)"    # 55 member(s)


recs.each_with_index do |rec,i|

   name = rec['name']
   code = rec['code']
   key  = rec['key']

   pp rec
   
   country = Country.find_by( name: name )
    pp country

    if country
      ## check matching codes
      
      puts "!! ERROR - (fifa) code do NOT match"  if code != country.code
      puts "!! ERROR - key do NOT match"          if key  != country.key
    end    
end


puts "bye"