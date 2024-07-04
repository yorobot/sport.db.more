###
#  to run use
#     ruby test/test_version.rb


require_relative 'helper'

class TestVersion < Minitest::Test

  def test_version
    pp FootballSources::VERSION
    pp FootballSources.banner
    pp FootballSources.root
  end

end # class TestVersion
