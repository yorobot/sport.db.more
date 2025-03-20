######
#  to run use:
#    $ ruby sandbox/outline.rb


require_relative 'helper'



title = '2022_FIFA_World_Cup_Group_A'


slug = slugify( title )
path = "./pages/match/#{slug}.txt"

=begin
page = Wikiscript.read( path )
## pp page

nodes = page.nodes
pp nodes
=end

puts
puts "--------"
nodes = Wikiscript::OutlineReader.read( path )
pp nodes



puts "bye"