

def calc_stats( matches )
  stats = {  'date' =>  { 'start_date' => nil,
                          'end_date'   => nil, },
             'teams' => Hash.new(0),
              }

  matches.each do |rec|
      date = rec['date']

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


def build_stats( matches )
         stats = calc_stats( matches )

         buf = String.new

         buf << "# Date       "
         start_date = stats['date']['start_date']
         end_date   = stats['date']['end_date']

         if start_date.year != end_date.year
           buf << "#{start_date.strftime('%a %b %-d %Y')} - #{end_date.strftime('%a %b %-d %Y')}"
         else
           buf << "#{start_date.strftime('%a %b %-d')} - #{end_date.strftime('%a %b %-d %Y')}"
         end
         buf << " (#{end_date.jd-start_date.jd}d)"   ## add days
         buf << "\n"

         buf << "# Teams      #{stats['teams'].size}\n"
         buf << "# Matches    #{matches.size}\n"
         buf
end