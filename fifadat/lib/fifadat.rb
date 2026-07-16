require 'cocos'   ## check if incl webclient already?
require 'webclient'

require 'season-formats'


def read_json_v2( path )
  txt = read_text( path )

  ## \u00A0 - non-breaking space
  txt = txt.gsub( /[\u00A0]/, ' ' )

  ## (auto-)remove ™ (e.g. FIFA World Cup™)
  txt = txt.gsub( '™', '' )

  ## check for non-breaking space
  ## fix-fix-fix add unicode normalize!!
  txt = txt.unicode_normalize(:nfc)


## !! ASSERT FAILED - official name alpha expected; got "Luí­s Carlos Mateus Filipe"
##   Luí­s Carlos Mateus Filipe
##    "Luí­s Carlos

##   Luí­s Carlos Mateus Filipe
#        [{"Locale": "en-gb", "Description": "Luí­s Carlos Mateus Filipe"}],
## !! ASSERT FAILED - official name alpha expected;
##   got >Luí­s Carlos Mateus Filipe<
## => L (76) | u (117) | í (237) | ­ (173) | s (115) |   (32) | C (67) | a (97) | r (114) | l (108) | o (111) | s (115) |   (32) | M (77) | a (97) | t (116) | e (101) | u (117) | s (115) |   (32) | F (70) | i (105) | l (108) | i (105) | p (112) | e (101) |

  ## You have run straight into a textbook encoding double-decode bug.
  ## The actual issue is even more interesting than it looks:
  ##  Character 173 (0xAD) shouldn't even be there.
  ## It only exists in your text because a clean UTF-8 string
  ## was forced through a bad translation process,
  ##  ripping the letter í completely in half.
  ##
  # Clean the string by removing character 173
  ##    encoding error in   pt/2025-26_matches.json
  ##     double check upstream source
  txt = txt.gsub(/\u{AD}/, '')
  ### # Or using delete
  ##  txt = txt.delete("\u{AD}")

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

require_relative 'fifadat/api-config'  ## base
require_relative 'fifadat/api'  ## base
require_relative 'fifadat/helper'
require_relative 'fifadat/prepare'   ## "all-in-one" prepare (download cache) helpers etc.

require_relative 'fifadat/ppdebug'
require_relative 'fifadat/ppmatch'

require_relative 'fifadat/types'


#####
## more
require_relative 'fifadat/pp/norm'

require_relative 'fifadat/pp/stages'
require_relative 'fifadat/pp/teams'
require_relative 'fifadat/pp/stadiums'
require_relative 'fifadat/pp/players'

require_relative 'fifadat/pp/officials'   ## aka referees
require_relative 'fifadat/pp/goals'
require_relative 'fifadat/pp/substitutions'


require_relative 'fifadat/pp/build_report'
require_relative 'fifadat/pp/convert'
require_relative 'fifadat/pp/convert-reports'

require_relative 'fifadat/pp/helper'
require_relative 'fifadat/pp/helper-score'
