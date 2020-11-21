
module Fbref
  class Configuration
    # nothing here for now
  end # class Configuration

  ## lets you use
  ##   Fbref.configure do |config|
  ##      config.convert.out_dir = './o'
  ##   end

  def self.configure() yield( config ); end
  def self.config()    @config ||= Configuration.new;  end
end # module Fbref
