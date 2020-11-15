module Writer

class Configuration
   def out_dir()        @out_dir   || './tmp'; end
   def out_dir=(value)  @out_dir = value; end
end # class Configuration


## lets you use
##   Write.configure do |config|
##      config.out_dir = "??"
##   end

def self.configure()  yield( config ); end

def self.config()  @config ||= Configuration.new;  end

end   # module Writer