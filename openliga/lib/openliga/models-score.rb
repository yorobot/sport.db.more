module Openliga



######
##  todo/fix - reuse a "generic" score (and/or result) class

class Score
  ##
  ## for generic add add reported (score) too
  ##    use if score line undefined/unknown


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
          buf << "#{@et[0]}-#{@et[1]} a.e.t."
        end
        if ft?
          buf << " "  unless buf.empty?
          buf << "(#{@ft[0]}-#{@ft[1]}"
          buf << ", #{@ht[0]}-#{@ht[1]}"  if ht?
          buf << ")"
        end
        buf << ", "   unless buf.empty?
        buf << "#{@pen[0]}-#{@pen[1]} pen."
    elsif et?
        buf << "#{@et[0]}-#{@et[1]} a.e.t."
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

end   ## module Openliga
