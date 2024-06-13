module Footballdata

  class Configuration
    ## note: nothing here for now
  end # class Configuration


  ## lets you use
  ##   Footballdata.configure do |config|
  ##      config.convert.out_dir = './o'
  ##   end

  def self.configure()  yield( config ); end

  def self.config()  @config ||= Configuration.new;  end

end   # module Footballdata