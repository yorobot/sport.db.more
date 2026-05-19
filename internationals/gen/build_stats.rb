

def calc_stats( matches )
  stats = {  'date' =>  { 'start_date' => nil,
                          'end_date'   => nil, },
             'teams' => Hash.new(0),
              }

  matches.each do |rec|
      date = Date.strptime( rec['date'], '%Y-%m-%d' )

       stats['date']['start_date'] ||= date
       stats['date']['end_date']   ||= date

       stats['date']['start_date'] = date  if date < stats['date']['start_date']
       stats['date']['end_date']   = date  if date > stats['date']['end_date']


     [rec['home_team'], rec['away_team']].each do |team|
        stats['teams'][ team ] += 1
     end
  end

  stats
end
