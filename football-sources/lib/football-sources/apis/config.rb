
module Footballdata

### add some more config options / settings
  class Configuration
    #########
    ## nested configuration classes - use - why? why not?
    class Convert
       def out_dir()       @out_dir || './o'; end
       def out_dir=(value) @out_dir = value; end
    end

   def convert()  @convert ||= Convert.new; end
  end # class Configuration


end # module Footballdata
