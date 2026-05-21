

class NameHistoryLookup

    def self.read( path )
       recs = read_csv( path )
       new( recs )
    end

    def initialize( recs )
       @recs_by_name = {}

       recs.each do  |rec|
           by_name = @recs_by_name[rec['current']] ||= []

           ## note - convert date from string to date!!
           rec['start_date'] = Date.strptime(rec['start_date'], '%Y-%m-%d')
           rec['end_date']   = Date.strptime(rec['end_date'], '%Y-%m-%d')

           by_name << rec
       end
    end

    ##
    ## todo - add current_name_by_date lookup method too - why? why not?

    ## alias to former_name_by_date too - why? why not?
    def historic_name_by_date( name, date: )
        recs = @recs_by_name[name]
        if recs
            recs.each do |rec|
               if date >= rec['start_date'] &&
                  date <= rec['end_date']
                  return rec['former']   ## bingo; return former/historic name
               end
            end
            ## no historic record matching, use name as is (return nil? why? why not?)
            name
        else
          ## no historic records found; use name as is
          ##  return nil - why? why not?
          name
        end
    end
end    ## class NameHistoryLookup
