TEST_FILE_NAME = "test-data-4.txt"
FILE_NAME = "data-4.txt"

class RollPosition
    @@valid_instances = 0
    # @@vertical_limit = 0 # max x coordinate
    # @@horizontal_limit = 0 # max y coordinate
    ROLL_SYMBOL = '@'
    MAX_NEIGHBOURS = 3

    attr_accessor :coordinates, :x, :y, :has_roll, :adjacent_coordinates, :neighbours
    alias_method :has_roll?, :has_roll

    def initialize(coordinates, position)
        @coordinates = coordinates
        @x = coordinates[0]
        @y = coordinates[1]
        @has_roll = position == ROLL_SYMBOL
        @adjacent_coordinates = []
        @neighbours = 0
        
        set_adjacent_coordinates
    end

    # I'm sure there's a better way of doing this
    def set_adjacent_coordinates
        x = 1
        
        loop do
            y = 1
            loop do
                @adjacent_coordinates << [x + @x, y + @y] unless x == 0 && y == 0 
                y -= 1
                
                break if y < -1
            end

            x -= 1
            break if x < -1
        end
    end

    def count_neighbours(rolls)
        @neighbours = rolls.count {|roll| @adjacent_coordinates.include?(roll.coordinates) } if has_roll?

        # puts test + " vvv"
        # neighbours.each do |neighbour|
        #    puts neighbour.test
        # end
        # puts "valid? #{valid?}"
        # puts "-----"

        if valid?
            @@valid_instances += 1
        end
    end

    def valid?
        @neighbours <= MAX_NEIGHBOURS
    end

    def self.total_valid
        @@valid_instances
    end

    def test
        "[#{@x}, #{@y}]: #{@has_roll}, #{valid?}"
    end
end

time_start = Time.now

grid = []

File.open(FILE_NAME).each.with_index do |line, x_index|
    row = line.chars
    row.each.with_index do |position, y_index|
        grid << RollPosition.new([x_index, y_index], position)
    end
end

total_positions = grid.count

rolls = grid.filter {|position| position.has_roll? }

puts "#{total_positions} total positions (#{rolls.count} rolls)"

loop do 

    rolls.each.with_index(1) do |roll, index|
        puts "#{((index.to_f / rolls.count.to_f) * 100).round(0)}% of rolls (#{rolls.count})" if index % 1000 == 0
        roll.count_neighbours(rolls)
    end

    puts RollPosition.total_valid
    puts "================================"
    break if rolls.count { |roll| roll.valid? } == 0
    rolls.reject! {|roll| roll.valid? }
end
puts RollPosition.total_valid
puts "In seconds: #{(Time.now - time_start).round(2)}"