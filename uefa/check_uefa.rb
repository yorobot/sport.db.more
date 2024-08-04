require_relative 'boot'




datasets = Dir.glob( "./teams/**/*.csv")
puts "   #{datasets.size} datafile(s)"


totals = Hash.new(0)

datasets.each_with_index do |path,i|

  basename = File.basename( path, File.extname( path ))
  code = basename 
   
  country = Country.find_by( code: code )
  puts
  puts "===> #{i+1}/#{datasets.size}"
  pp country
 
     recs = read_csv( path )
     puts "   #{recs.size} record(s)"
  ###
  ## todo - use unaccent to avoid duplicates with different accents/diacritics/etc.
  missing_clubs = Hash.new(0)  ## index by league code

  

  recs.each_with_index do |rec,j|
     
    names = rec['names'].split( '|' )
    names  = names.map { |name| name.strip }

    names.each do |name|

      m = Club.match_by( name: name, country: country )
 
      if m.empty?
         puts "!! #{name}   -  #{names.join('|')}"
         missing_clubs[ name ] += 1
      elsif m.size > 1
          puts
          puts "!! too many matches (#{m.size}) for club >#{name}<:"
          pp m
          exit 1
      else  # bingo; match
          print "     OK "
          if name != m[0].name
              print "%-28s => %-28s" % [name, m[0].name] 
          else
              print name
          end
          print "\n"
      end
    end
   end

   if missing_clubs.size > 0
     puts
     pp missing_clubs
     puts "  #{missing_clubs.size} record(s)"

     puts
     puts "---"
     missing_clubs.each do |name, _|
       puts name
     end
     puts

     ## adding missing clubs for country to totals
     totals[country.name] = missing_clubs 
   end
end



if totals.size > 0
   puts 
   puts "totals:"
   pp totals

   totals.each do |country_name, clubs|
      puts "  #{clubs.size} club name(s) in #{country_name}"
   end
end


puts "bye"