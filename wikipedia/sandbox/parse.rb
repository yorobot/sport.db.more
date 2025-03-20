######
#  to run use:
#    $ ruby sandbox/parse.rb


require_relative 'helper'



## require_relative 'footballbox'



def parse_footballboxes( lines )
  text = lines.join( "\n" )

  puts "==> parse #{lines.size} line(s):"
  puts text
  puts
  nodes = Wikiscript.parse( text )

  puts 
  puts "--- nodes:"
  boxes = []

  nodes.each do |node|
    if node.is_a?( Wikitree::Template )
      puts "OK template - #{node.name}"
=begin      
      if node.name == 'Football box'
        puts "==> BINGO - try parse/to_json"
        box = Wikiscript::Footballbox.new( node )
        pp box.to_json   ## fix - change to as_json
        boxes << box.to_json
      end
=end
    else
      ## puts "other skip - #{node.class.name}"
    end
  end
  boxes
end


def parse( title )
  slug = slugify( title )
  path = "./pages/match/#{slug}.txt"

  nodes = Wikiscript::OutlineReader.read( path )
  ## pp nodes

  nodes.each do |node|
     node_type = node[0]
     if [:h1,:h2,:h3,:h4].include?( node_type )
       ## todo - print heading for debugging here
       next
     end    

     if node_type == :p
             lines = node[1]
             boxes = parse_footballboxes( lines )
             ## puts "add to #{inside_heading}  #{boxes.size} box(es)"
             ## data[ inside_heading ] += boxes
     else
             ## skip other (non-paragraph) nodes
     end
  end

  # write_json( "./o/#{slug}.json", data )
end



titles = [
  '1930_FIFA_World_Cup_Group_1', 
]

titles.each do |title|
   parse( title )
end

puts "bye"