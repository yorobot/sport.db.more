require 'cocos'   ## check if incl webclient already?
require 'webclient'


def write_json_v2( path, data )

   ## hack - use pretty_inspect for json pretty print         
    txtjson =  data.pretty_inspect 
 
    txtjson = txtjson.gsub( '=>', ': ' )
    txtjson = txtjson.gsub( /\bnil\b/, 'null' )

    ## double check for syntax errors
    json = JSON.parse( txtjson )

    write_text( path, txtjson )
end


def fetch_json( url, path=nil, headers: nil )
  res = if headers
            Webclient.get( url, headers: headers )
        else
            Webclient.get( url )
        end

  if res.status.ok?
    data = res.json
    pp data
    puts "OK - fetching #{url}"

    write_json_v2( path, data )    if path

    data
  else
    puts "   #{url}"
    puts "!! ERROR  #{res.status.code} #{res.status.message}"
    exit 1
  end
end


def fetch_json_if( url, outpath )
   delay_in_secs = 1   ## 1 sec
   
   if File.exist?( outpath )
     puts "CACHE HIT - #{outpath}"
     return
   end 

   fetch_json( url, outpath )
   puts "  sleeping #{delay_in_secs} sec(s)..."
   sleep( delay_in_secs )
end


###
##  our own code

require_relative 'fifadat/api'  ## base

require_relative 'fifadat/helper'
require_relative 'fifadat/players'
require_relative 'fifadat/teams'
require_relative 'fifadat/stadiums'





