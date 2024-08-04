$LOAD_PATH.unshift( '../../../rubycocos/webclient/webget/lib' )
require 'webget'
require 'cocos'





BASE_URL = 'https://www.uefa.com/nationalassociations'



def redirect_loc( code )
    url = "#{BASE_URL}/#{code}/domestic/"

    response = Webclient.get( url )
    pp response
    
    if response.status.code == 301

    ## fix - add location header accessor upstream!!!!
    ## loc = response.headers.location
    ## pp loc

     ## /nationalassociations/alb/domestic/league/1058/
      loc = nil

      ## dump headers
      pp response.headers
      response.headers.each do |k,v|
        puts ">#{k}<  =>  >#{v}<"
        loc = v   if k == 'location'
      end

      puts
      puts "  =>  #{loc}"
      loc
    else
      puts "!! ASSERT - HTTP 301 Moved Permanently expected; got:"
      pp response
      exit 1
   end
end


recs = read_csv( './more/countries.csv' )

pp recs
puts "    #{recs.size} record(s)"   #=> 55 record(s)




redirects = {}
recs.each_with_index do |rec,i|

    fifa = rec['fifa']
    code = rec['code']
    name = rec['name']

    puts "===> #{i+1}/#{recs.size}  #{code} - #{name} (#{fifa})..."

    loc = redirect_loc( fifa.downcase )
    ## cut off leading /nationalassociations/ and
    ##         trailing /
    loc = loc.sub( %r{^/nationalassociations/}, '' )
    loc = loc.sub( %r{/$}, '' )
    redirects["#{code}.1"] = loc
end

puts
pp redirects
puts


puts "bye"
