


class Counter
  def initialize( types )
    @types = types
    @counter = Hash.new(0)
  end

  def [](key)        @counter[key]; end
  def []=(key,value) @counter[key]=value; end

  def pretty_print(q)
      q.group(1, "{", "}") do
## sort by keys
            pairs = @counter.sort_by { |key,_| key }
            pairs.each_with_index do |(key,count),i|
                 q.breakable(', ')   if i != 0
                 q.text( "#{key}-#{(@types[key]||'??')}=>#{count}")
            end
      end
  end

end ## class Counter



def mk_stats
 stats = {
            ## match stats
              'MatchStatus' => Counter.new( MATCH_STATUS ),
              'ResultType'  => Counter.new( RESULT_TYPE ),
              'TimeDefined' => Hash.new(0),

              'MatchDay'    => Hash.new(0),
              'MatchNumber' => Hash.new(0),
              'Leg'         => Hash.new(0),
              'IsHomeMatch' => Hash.new(0),

              'Attendance'  => Hash.new(0),
              'Weather'     => Hash.new(0),

              ## add stage & group
              ##  add agg score and pen score!!


            ## team stats
           ##   'TeamType'     => Hash.new(0),
           ##   'AgeType'      =>  Hash.new(0),
           ##   'FootballType' => Hash.new(0),
            }

      stats
end



def collect_stats( data, stats: )

    ## use results (match) array
   data['Results'].each_with_index do |m, i|


     ##
     ## check usage
     stats[ 'MatchStatus' ][m['MatchStatus']] +=1
     stats[ 'ResultType'][m['ResultType']]    +=1

     stats[ 'TimeDefined'][m['TimeDefined']] +=1


     stats[ 'MatchDay'][!m['MatchDay'].nil?] +=1
     stats[ 'MatchNumber'][!m['MatchNumber'].nil?] +=1

     stats[ 'Leg'][m['Leg']] +=1
     stats[ 'IsHomeMatch'][m['IsHomeMatch']] +=1

     stats[ 'Attendance'][!m['MatchDay'].nil?] +=1
     stats[ 'Weather'][!m['Weather'].nil?] +=1

=begin
    if m['Home']
      stats[ 'TeamType'][m['Home']['TeamType']] +=1
      stats[ 'AgeType'][m['Home']['AgeType']] +=1
      stats[ 'FootballType'][m['Home']['FootballType']] +=1
    end
    if m['Away']
      stats[ 'TeamType'][m['Away']['TeamType']] +=1
      stats[ 'AgeType'][m['Away']['AgeType']] +=1
      stats[ 'FootballType'][m['Away']['FootballType']] +=1
    end
=end

   end

   stats
end
