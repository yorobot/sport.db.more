


## defaults
FORMAT_OPTS_DEFAULTS = {
    country:  false,
    city:     false,
    stadium:  false,
    timezone: false,
}

FORMAT_OPTS_FULL_DEFAULTS = {
    country:       false,
    city:          true,
    stadium:       true,
    timezone:      true,

    show_teams:    false,
    show_stadiums: false,
}

def _parse_format_opts( str )
    h = {}
   keys = str.split( /[ ]*\|[ ]*/ )
   keys.each do |key|
       case key.to_sym
       when :country  then h[:country] = true
       when :city     then h[:city]    = true
       else
         raise ArgumentError, "unknown key #{key} in format opts"
       end
   end
   h
end


def read_config_pp( *paths )
  config = {}
  paths.each do |path|
    recs = read_csv( path )

    recs.each do |rec|
      key = rec['code']
      h = {
            slug:      key,
            name:      rec['name'],
            seasons:   rec['seasons'],
            opts:      {}.merge( FORMAT_OPTS_DEFAULTS,      _parse_format_opts( rec['opts'] )),
            opts_full: {}.merge( FORMAT_OPTS_FULL_DEFAULTS, _parse_format_opts( rec['opts_full'] )),
      }

      config[ key ] = h
    end
  end
  config
end


CONFIGS = {}
more_configs = read_config_pp( "#{Fbtxt::Module::Fbpp.root}/lib/fbtxt-pp/config_clubs.csv" )
pp more_configs
CONFIGS.merge!( more_configs )
