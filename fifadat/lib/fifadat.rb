require 'cocos'   ## check if incl webclient already?
require 'webclient'


def read_json_v2( path )
  txt = read_text( path )

  ## \u00A0 - non-breaking space
  txt = txt.gsub( /[\u00A0]/, ' ' )

  ## check for non-breaking space
  ## fix-fix-fix add unicode normalize!!


  parse_json( txt )
end



def _deep_stringify_keys(obj)
  case obj
  when Hash
    obj.transform_keys(&:to_s)
       .transform_values { |v| _deep_stringify_keys(v) }
  when Array
    obj.map { |v| _deep_stringify_keys(v) }
  else
    obj
  end
end

def write_json_v2( path, data )
  ## note - always stringify keys for now
  ##            e.g. { name: "" } => { "name": "" }
    data = _deep_stringify_keys( data )

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
    ## pp data
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
     return nil
   end

   data = fetch_json( url, outpath )
   puts "  sleeping #{delay_in_secs} sec(s)..."
   sleep( delay_in_secs )

   data
end


###
##  our own code

require_relative 'fifadat/api'  ## base

## more
require_relative 'fifadat/helper'
require_relative 'fifadat/norm'

require_relative 'fifadat/prepare'   ## "all-in-one" prepare (download cache) helpers etc.


require_relative 'fifadat/stages'
require_relative 'fifadat/teams'
require_relative 'fifadat/stadiums'
require_relative 'fifadat/players'

require_relative 'fifadat/officials'   ## aka referees
require_relative 'fifadat/goals'
require_relative 'fifadat/substitutions'



require_relative 'fifadat/ppconvert'
require_relative 'fifadat/ppconvert-reports'

require_relative 'fifadat/pphelper'
require_relative 'fifadat/ppdebug'
