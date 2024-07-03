module Writer

####################
# England


def self.eng1( season )
  case season    ## todo/fix: - use cast e.g. Season(season) - make sure it's a season obj
  when Season('1888/89')..Season('1891/92') ## single league (no divisions)
    {name:     'English Football League',
     basename: '1-footballleague'}
  when Season('1892/93')..Season('1991/92')  ## start of division 1 & 2
    {name:     'English Division One',
     basename: '1-division1'}
  else  ## starts in season 1992/93
    {name:     'English Premier League',
     basename: '1-premierleague'}
  end
end

def self.eng2( season )
  case season
  when Season('1892/93')..Season('1991/92')
    {name:     'English Division Two',  ## or use English Football League Second Division ???
     basename: '2-division2'}
  when Season('1992/93')..Season('2003/04')   ## start of premier league
    {name:     'English Division One',
     basename: '2-division1'}
  else # starts in 2004/05
    {name:     'English Championship',  ## rebranding divsion 1 => championship
     basename: '2-championship'}
  end
end


LEAGUES.merge!(
  'eng.1' => { name:     ->(season) { eng1( season )[ :name ]     },
               basename: ->(season) { eng1( season )[ :basename ] },
             },
  'eng.2' => { name:     ->(season) { eng2( season )[ :name ]     },
               basename: ->(season) { eng2( season )[ :basename ] },
             },
  'eng.3' => { name:     'English League One',
               basename: '3-league1',
             },
  'eng.4' => { name:     'English League Two',
               basename: '4-league2',
             },
  'eng.5' => { name:     'English National League',
               basename: '5-nationalleague',
           },
  'eng.cup' => { name:  'English FA Cup',
                 basename: 'facup',
               }
)

end   # module Writer

