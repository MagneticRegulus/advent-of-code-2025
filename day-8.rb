TEST_FILE_NAME = "test-data-8.txt"
FILE_NAME = "data-8.txt"
SPLIT = ','
TOTAL_PAIRS = 1000
TAKE_LARGEST = 3

class BoxPair
    attr_accessor :p, :q, :boxes, :connected
    alias_method :connected?, :connected

    def initialize(p, q)
        @p = p
        @q = q
        @boxes = [p, q]
        @connected = false
    end

    def distance
        return Math.sqrt(((@p[:x] - @q[:x])**2)+((@p[:y] - @q[:y])**2)+((@p[:z] - @q[:z])**2))
    end

    def box_ids
        return @boxes.map {|box| box[:id]}
    end
end

junction_boxes = []

File.open(FILE_NAME).each.with_index do |line, index|
    ints = line.chomp.split(SPLIT).map {|coordinate| coordinate.to_i }
    junction_boxes << {id: index, x: ints[0], y: ints[1], z: ints[2]}
end

pairs = []
total_junction_boxes = junction_boxes.size

# collect the pairs of junction boxes
total_junction_boxes.times do
    pbox = junction_boxes.shift
    junction_boxes.each do |qbox|
        pairs << BoxPair.new(pbox, qbox)
    end
end

puts "Total junction boxes: #{total_junction_boxes} | Total pairs: #{pairs.size}"

# Get the top TOTAL_PAIRS with the shortest distances
pairs.sort_by! {|pair| pair.distance}
top_shortest_connections = pairs.take(TOTAL_PAIRS)

circuits = []

# connect the circuits
top_shortest_connections.each do |connection|
    connection.connected = true
    ids = connection.box_ids

    if circuits.any? {|circuit| circuit.intersect?(ids)}
        selected = circuits.select {|circuit| circuit.intersect?(ids)}
        circuits.reject! {|circuit| circuit.intersect?(ids)}
        circuits << ids.union(selected.flatten)
    else
        circuits << ids
    end
end

# Get the TAKE_LARGEST with the largest circuit sizes and multiply them together
circuit_sizes = circuits.sort_by! {|circuit| circuit.size }.reverse!.map {|circuit| circuit.size}
largest_sizes = circuit_sizes.take(TAKE_LARGEST)
product = largest_sizes.inject(1) {|result, size| result * size}

puts "Product: #{product}"