###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'

class TestVersion < MiniTest::Test

  def test_version
    pp Webget::Module::Football::VERSION
    pp Webget::Module::Football.banner
    pp Webget::Module::Football.root
  end

end # class TestVersion
