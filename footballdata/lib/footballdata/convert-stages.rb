
class Stages
   def initialize
      @recs = {}
   end

   def add_matches( matches )
       matches.each do |m|
            name  =  m['stage']
            rec =  @recs[name] ||= { name: name,
                                     count: 0    }
            rec[:count] +=1
       end
   end

   def as_json() @recs.values; end

   def size() @recs.size; end

end  # class Stages
