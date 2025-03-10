require_relative 'helper'


##
## in the future for special names allow - why? why not?
##   Ashford Town (Middlesex) =>  <Ashford Town (Middlesex)>  or such 
##   Pro:Direct Stadium       =>  <Pro:Direct Stadium> 


texts = [
    "CITY ARENA – Štadión Antona Malatinského",
    "CITY ARENA - Štadión Antona Malatinského",
    "Sport- und Freizeitzentrum Traiskirchen",
    "K’s Denki Stadium",
    "Jeugdterreinen KSV Sottegem Terrein 1 – Kunstgras",
    "Pro:Direct Stadium",
    "Ashford Town (Middlesex)",
    "Westfield (Surrey)",
    "Bradford (Park Avenue)",
    "St Pauls’ Sports Ground",
]


texts.each do |text|
  puts "==> #{text}"
  puts "    #{ApiFootball.norm_name(text)}" 
end



puts "bye"