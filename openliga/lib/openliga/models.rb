module Openliga


Match = Struct.new( :team1,
                    :team2,
                    :date,    # assumes Date class
                    :time,    # assumes String class (00:00)
                    :timezone,   ## use tz ?
             ###       :datetime_utc,
                    :score,
                    :goals,
                    :round,    ## is stage/round/group
                    :city,
                    :ground,   ## use stadium (or venue?)
                    :att,     ## attendance (numberOfViewers)
                    :finished    ### todo/check - use status (is really only END or false)
                  ) do
end




Goal = Struct.new(  :team,  ## expect 1|2 or nil
                    :name,
                    :score,   ## expect array e.g. [0,1]
                    :m, :stoppage,
                   :pen, :og,
                   :comment ) do

   def pen?()  @pen == true; end
   def og?()   @og  == true; end


   ## print goal as single line
   ##   e.g.
   ##    (0-1 Yorbe Vertessen 37'
   ##     0-2 Yorbe Vertessen 48')

   def calc_stoppage( m )
      if    m >= 120  then   [120, m%120]
      elsif m >= 105  then   [105, m%105]
      elsif m >= 90   then   [90, m%90]
      else                   [45, m%45]    ## assume 45
      end
   end



   def to_s
      buf = String.new

      ## score required !!!
      buf << "#{score[0]}-#{score[1]} "
      buf <<  (name ? name : 'N.N.')      ## note - if no name use N.N. for now!!
      if m
         if stoppage
            _m,_stoppage = calc_stoppage(m)
            puts "!! INFO - auto-calc stoppage  #{m}+  =>  #{_m}+#{_stoppage}"
            buf << " #{_m}+#{_stoppage}'"
         else
          buf << " #{m}'"
         end
      end

      buf << " (og)"   if og
      buf << " (p)"    if pen

      buf
   end

end



######
##  todo/fix - reuse a "generic" score (and/or result) class

class Score
  ##
  ## for generic add add reported (score) too
  ##    use if score line undefined/unknown

  attr_reader :ht, :ft, :et, :pen

  def initialize( ht: [], ft:[], et: [], pen: [])
    @ht, @ft, @et, @pen = ht, ft, et, pen

    ##  ( ..., extra_time: nil)
    ## extra_time flag - e.g.  copa america has penalty shootouts
    ##                             BUT no extra time (only in final)
    ##
    ##  add a reg (90min) flag too -
    ## @extra_time  = extra_time
  end


  def pen?()   @pen.is_a?( Array ) && @pen.size == 2; end
  def et?()    @et.is_a?( Array ) && @et.size == 2; end
  def ft?()    @ft.is_a?( Array ) && @ft.size == 2; end
  def ht?()    @ht.is_a?( Array ) && @ht.size == 2; end


  def pretty_print( q )
      q.group(1, "<Score", ">") do
         q.text( " ht: #{@ht}")  if ht?
         q.text( " ft: #{@ft}")  if ft?
         q.text( " et: #{@et}")  if et?
         q.text( " pen: #{@pen}")  if pen?
      end
  end



  def to_s
    buf = String.new
    if pen?
        if et?
          buf << "#{@et[0]}-#{@et[1]} aet"
          if ft?
            buf << " (#{@ft[0]}-#{@ft[1]}"
            buf << ", #{@ht[0]}-#{@ht[1]}"  if ht?
            buf << ")"
          end
        elsif ft?
          ###  pen without et e.g. in copa
          ##          use  2-2 (1-1), 5-3 pen. or such
          buf << " "  unless buf.empty?
          buf << "#{@ft[0]}-#{@ft[1]}"
          buf << " (#{@ht[0]}-#{@ht[1]})"  if ht?
        end
        buf << ", "   unless buf.empty?
        buf << "#{@pen[0]}-#{@pen[1]} pen"
    elsif et?
        buf << "#{@et[0]}-#{@et[1]} aet"
        if ft?
            buf << " (#{@ft[0]}-#{@ft[1]}"
            buf << ", #{@ht[0]}-#{@ht[1]}"  if ht?
            buf << ")"
          end
    elsif ft?
       buf << "#{@ft[0]}-#{@ft[1]}"
       buf << " (#{@ht[0]}-#{@ht[1]})"  if ht?
    else
       ## note - return empty string on no score for now
    end

    buf
  end
end  # class Score



end ## module Openliga
