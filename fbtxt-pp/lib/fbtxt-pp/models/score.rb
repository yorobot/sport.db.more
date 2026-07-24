
class Score


def self.build( score )
  if score.nil?
        raise ArgumentError, "Score.build - expected Hash or Array; got nil"
  elsif score.is_a?(Hash)
      new( **score.transform_keys(&:to_sym) )
  elsif score.is_a?(Array)
       new( reported: score )
  else
       raise ArgumentError, "Score.build - expected Hash or Array; got type #{score} #{score.class.name}"
  end
end



attr_reader   :ht, :ft, :et, :p, :agg,
              :reported


def initialize( ht: nil, ft: nil, et: nil, p: nil, agg: nil,
               reported: nil )
   @ht, @ft, @et, @p, @agg = ht, ft, et, p, agg

   ##
   ## note: use reported for "generic" score where
   ##             period is not known (might be  full-time or aet)
   ##          or undefined e.g. for  abandoned or awarded (administered) score
   @reported = reported
end



def to_s
    if @reported
        ## check for ary empty - why? why not?
        "#{@reported[0]}-#{@reported[1]}"
    else
      if @et && @p
             if @ft && @ht
               "#{@et[0]}-#{@et[1]} a.e.t." +
               " (#{@ft[0]}-#{@ft[1]}, #{@ht[0]}-#{@ht[1]}), " +
               "#{@p[0]}-#{@p[1]} pen."
             elsif @ft
               "#{@et[0]}-#{@et[1]} a.e.t." +
               " (#{@ft[0]}-#{@ft[1]}), " +
               "#{@p[0]}-#{@p[1]} pen."
            else
               "#{@et[0]}-#{@et[1]} a.e.t., " +
               "#{@p[0]}-#{@p[1]} pen."
             end
      elsif @et && @p.nil?
             if @ft && @ht
                "#{@et[0]}-#{@et[1]} a.e.t."+
                " (#{@ft[0]}-#{@ft[1]}, #{@ht[0]}-#{@ht[1]})"
             elsif @ft
                "#{@et[0]}-#{@et[1]} a.e.t."+
                " (#{@ft[0]}-#{@ft[1]})"
             else
                "#{@et[0]}-#{@et[1]} a.e.t."
             end
      elsif  @ft &&  @et.nil? && @p.nil?
              if @ht
                "#{@ft[0]}-#{@ft[1]} (#{@ht[0]}-#{@ht[1]})"
              else
               "#{@ft[0]}-#{@ft[1]}"
              end
      else
           ## raise error/warn - about unknown (or empty) score type - why? why not?
            ''
      end
    end
end


end  # class Score
