###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'

class TestVersion < MiniTest::Test

  def test_version
    pp FootballSources::VERSION
    pp FootballSources.banner
    pp FootballSources.root
  end

end # class TestVersion
