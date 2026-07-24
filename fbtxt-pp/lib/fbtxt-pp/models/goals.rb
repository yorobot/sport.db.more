

class Goal
  def self.build( h )
    ## split into minute
    ##  and offset (stoppage/injury time)
    ##  e.g. 90'+11'

    ##
    ##  keep minute as string and incl. stoppage/injury time - why? why not?

    new( name:   h['name'],
         minute: h['minute'],
         og:     h['og'],   # true|false
         pen:    h['pen']  # true|false
         )
  end


  attr_reader :name,
              :minute, :og, :pen

  def initialize( name:, minute:,
                  og: false, pen: false )
    @name     = name
    @minute   = minute

    @og, @pen = og, pen
  end

  def og?()  @og; end
  def pen?() @pen; end

end # class Goal





=begin
    ## sort by minutes
    ##  may not be sorted

    recs = recs.sort do |l,r|
                 res = l[:minute] <=> r[:minute]
                 res = (l[:offset]||0) <=> (r[:offset]||0)  if res == 0 &&
                                                              (l[:minute] == 45 ||
                                                               l[:minute] == 90 ||
                                                               l[:minute] == 105 ||  ## check - if possible stoppage in 1st half extra-time??
                                                               l[:minute] == 120)
                 res
           end
=end
