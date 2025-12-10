TEST_FILE_NAME = "test-data-9.txt"
FILE_NAME = "data-9.txt"
SPLIT = ','

class TileRectangle
    attr_reader :a, :b, :tiles, :area, :inner_x_range, :inner_y_range

    def initialize(a, b)
        @a = a
        @b = b
        @tiles = [a, b]
        @area = calculate_area
        set_valid_tile_ranges
    end

    def calculate_area
        w = (@a[:x] - @b[:x]).abs + 1
        h = (@a[:y] - @b[:y]).abs + 1
        
        return w * h
    end

    def set_valid_tile_ranges
        minx = @tiles.map {|tile| tile[:x] }.min
        maxx = @tiles.map {|tile| tile[:x] }.max
        miny = @tiles.map {|tile| tile[:y] }.min
        maxy = @tiles.map {|tile| tile[:y] }.max

        @inner_x_range = ((minx + 1)...maxx)
        @inner_y_range = ((miny + 1)...maxy)

        # puts "Failed to get valid_tiles for #{@a} x #{@b}" if valid_tiles.count != calculate_area
    end
end

class TileConnection
    attr_reader :a, :b, :tiles, :x_range, :y_range
    
    def initialize(a, b)
        @a = a
        @b = b
        @tiles = [@a, @b]
        set_green_tiles
    end

    def set_green_tiles        
        if @a[:x] == @b[:x]
            
            min = @tiles.map {|tile| tile[:y] }.min
            max = @tiles.map {|tile| tile[:y] }.max

            #puts "y min max: #{min}, #{max}"
            
            ((min + 1)...max).each do |y|
                @tiles << {color: 'green', x: @a[:x], y: y}
            end

            @x_range = (@a[:x]..@a[:x])
            @y_range = (min..max)

        elsif @a[:y] == @b[:y]
            min = @tiles.map {|tile| tile[:x] }.min
            max = @tiles.map {|tile| tile[:x] }.max

            #puts "x min max: #{min}, #{max}"

            ((min + 1)...max).each do |x|
                @tiles << {color: 'green', x: x, y: @a[:y]}
            end

            @x_range = (min..max)
            @y_range = (@a[:y]..@a[:y])
        end
    end

    def simple_tiles
        return @tiles.map {|tile| {x: tile[:x], y: tile[:y]}}
    end

    def connection_made?
        return @tiles.size > 2 || (@a[:color] == 'red' && @b[:color] == 'red')
    end

    def get_green_tiles
        return @tiles.select {|tile| tile[:color] == 'green'}
    end
end

red_tiles = []

File.open(FILE_NAME).each do |line|
    ints = line.chomp.split(SPLIT).map {|coordinate| coordinate.to_i }
    red_tiles << {color: 'red', x: ints[0], y: ints[1]}
end

total_red_tiles = red_tiles.size
puts "Total red tiles: #{total_red_tiles}"
red_tiles_copy = red_tiles.clone

rectangles = []

total_red_tiles.times do
    atile = red_tiles_copy.shift
    red_tiles_copy.each do |btile|
        rectangles << TileRectangle.new(atile, btile)
    end
end

rectangles_by_largest_area = rectangles.sort_by! {|rect| rect.area }.reverse!

puts "Largest area: #{rectangles_by_largest_area.first.area}"

connections = []

red_tiles.each.with_index do |tile, index|
    if red_tiles.size == index + 1
        connections << TileConnection.new(tile, red_tiles[0]) if red_tiles.size == index + 1
    else
        connections << TileConnection.new(tile, red_tiles[index + 1])
    end
end

puts "Total red connections: #{connections.size}"

largest_valid_area = 0
total_green_tiles = connections.map {|c| c.get_green_tiles }.flatten.uniq

rectangles_by_largest_area.each do |rectangle|
    puts "Checking #{rectangle.tiles} #{rectangle.area}"
    
    next if total_green_tiles.any? {|tile| rectangle.inner_x_range.cover?(tile[:x]) && rectangle.inner_y_range.cover?(tile[:y])}

    largest_valid_area = rectangle.area
    break
end

puts "Largest area in shape: #{largest_valid_area}"

=begin
current_valid_tiles = connections.map {|c| c.tiles}.flatten
min_x = current_valid_tiles.map {|tile| tile[:x]}.min
min_y = current_valid_tiles.map {|tile| tile[:y]}.min
max_x = current_valid_tiles.map {|tile| tile[:x]}.max
max_y = current_valid_tiles.map {|tile| tile[:y]}.max

outline_x_range = (min_x..max_x)
outline_y_range = (min_y..max_y)

puts outline_x_range
puts outline_y_range




=begin
green_tiles = connections.map {|c| c.get_green_tiles }.flatten
puts "Total green tiles pre-filling in: #{green_tiles.size}"

green_tiles.size.times do
    atile = green_tiles.shift
    green_tiles.each do |btile|
        connections <<  TileConnection.new(atile, btile) if atile[:x] == btile[:x] || atile[:y] == btile[:y]
    end

    puts "Total left: #{green_tiles.size}" if green_tiles.size % 1000 == 0
end

puts "ALL GREEN CONNECTIONS MADE PANIC ATTACK"
puts "Total connections: #{connections.size}"

valid_tiles = connections.map {|c| c.simple_tiles }.flatten.uniq

puts "Total valid area: #{valid_tiles.size}"
#puts valid_tiles

puts "NOW LOOKING FOR THE LARGEST VALID ONE"

rectangles_by_largest_area.each do |rectangle|
    if rectangle.get_valid_tiles.all? {|tile| valid_tiles.include?(tile)}
        puts "Largest valid area: #{rectangle.area}"
        break
    end
end
=end