###
#  to run use
#     ruby -I ./lib -I ./test test/test_version.rb


require 'helper'

class TestVersion < MiniTest::Test

  def test_version
    pp SportDb::Module::Writers::VERSION
    pp SportDb::Module::Writers.banner
    pp SportDb::Module::Writers.root
  end

end # class TestVersion
