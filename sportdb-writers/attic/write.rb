SOURCES = {
  'one'        => { path: '../../stage/one' },
  'one/o'      => { path: '../apis/o' },     ## "o" debug version

  'two'        => { path: '../../stage/two' },
  'two/o'      => { path: '../cache.weltfussball/o' },      ## "o"   debug version
  'two/tmp'    => { path: '../cache.weltfussball/tmp' },    ## "tmp" debug version

  'leagues'    => { path: '../../../footballcsv/cache.leagues' },
  'leagues/o'  => { path: '../cache.leagues/o' },    ## "o"  debug version

  'soccerdata' => { path:   '../../../footballcsv/cache.soccerdata',
                    format: 'century', # e.g. 1800s/1888-89
                  }
}

source_info = SOURCES[ source ]
if source_info.nil?
  puts "!! ERROR - no source found for >#{source}<; sorry"
  exit 1
end




