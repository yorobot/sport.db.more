$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
require 'webget'

Webcache.root = '/sports/cache'


## 3rd party
require 'nokogiri'



def assert( cond, msg )
  if cond
  else
    puts "!! ASSERT FAILED - #{msg}"
    exit 1
  end
end



paths = Dir.glob( "./slugs.teams/**/*.json")
puts "   #{paths.size} datafile(s)"



paths.each do |path|
   basename = File.basename( path, File.extname( path ))


   data = read_json( path )
   puts "==> #{data['title']}  -  #{data['clubs'].count} club(s)..."

   ## e.g. https://www.uefa.com/nationalassociations/teams/64277--aberystwyth/


   rows = []

   data['clubs'].each do |rec|
     name = rec['name']
     ref  = rec['ref'] 
     team_url = "https://www.uefa.com/nationalassociations/teams/#{ref}/"

      ##  note - only numbers are / lead to valid team pages
      ##    61eplt09k35dsd1f168i7jbop--fc-pas-de-la-casa

      if ref =~ /^\d+--/
        html = Webcache.read( team_url ) 
        ## pp html[0,100]

        ## note: if we use a fragment and NOT a document -
        ##   no access to  page head (and meta elements and such)
 
        doc =  Nokogiri::HTML( html )

        puts
        title =  doc.css( 'title' ).first.text
        pp title

        els = doc.css( 'span.team-name' )
        assert( els.size == 2, "two span.team-name expected" )
        names = els.map { |el| el.text }

        ## check if same and remove duplicates
        names = names.uniq
        pp names

        ## country code
        els  = doc.css( 'span.team-country-name' )
        assert( els.size == 1, "one span.team-country-name expected" )
        
        code = els.first.text
        pp code

        rows << [ names.join(' | ' ), code]

      else
         ## no team page available
         ## todo/fix - add (fifa) country code too
         rows << [name, '???' ]
      end
   end

   buf = String.new
   buf << "# #{data['title']} - #{data['clubs'].count} club(s)\n\n"
   buf << "names, code\n"
   rows.each do |values|
      buf << values.join( ', ' )
      buf << "\n"
   end

   outpath = "./teams/#{basename}.csv"
   write_text( outpath, buf)

end


puts "bye"

