##
# build summary of country renames

require 'cocos'

recs = read_csv( "./former_names.csv")
puts "  #{recs.size} record(s)"
## pp recs



recs_by_country = {}
recs.each do  |rec|
    by_country = recs_by_country[rec['current']] ||= []
    by_country << rec
end



buf = String.new
buf += "# Country Renames\n\n"

recs_by_country.each do |name, recs|

  buf << "**#{name}**  (#{recs.size}) <br>\n"
  buf << "- "
  recs.each_with_index do |rec,i|
      buf << "**#{rec['former']}**"
      buf << " (#{rec['start_date']} - #{rec['end_date']}) => "
  end
  buf << "**#{name}**"
  buf << "\n\n"
end


puts buf

write_text( "./COUNTRY_RENAMES.md", buf )

root_dir = "/sports/openfootball/internationals"
write_text( "#{root_dir}/COUNTRY_RENAMES.md", buf )




puts "bye"



__END__

##
## sort by end_date
recs = recs.sort do |l,r|
                      l['end_date'] <=> r['end_date']
                  end

pp recs


buf = String.new
buf += "# Countries Timeline\n\n"
buf += "rename, split, join, merge, & more\n\n"


recs.each do |rec|

  buf << "- "
  buf << "#{rec['end_date']}  **#{rec['former']}** (#{rec['start_date']})   =>  **#{rec['current']}**"
  buf << "\n"

end


puts buf
