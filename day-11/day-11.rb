require 'set'

TEST_FILE_NAME = "test-data-11.txt"
TEST_FILE_NAME_2 = "test-data-11-2.txt"
FILE_NAME = "data-11.txt"
SPLIT = ' '
SELECTOR = ':'
START_DEVICE = "svr"
END_DEVICE = "out"
DAC = "dac"
FFT = "fft"

class Device
    attr_accessor :items, :name, :outputs
    def initialize(line)
        @items = line.chomp.delete(SELECTOR).split(SPLIT)
        @name = @items[0]
        @outputs = @name == END_DEVICE ? [] : @items[1..-1]        
    end

    def to_s
        "#{name} has #{outputs}"
    end
end

class Link
    @@instances = 0

    attr_accessor :device, :linked_devices, :linked_names, :dac, :fft, :visited, :sum
    alias_method :visited?, :visited

    def initialize(device)
        @device = device
        @linked_devices = Set[]
        @linked_names = Set.new(device.outputs)
        @dac = device.name == DAC
        @fft = device.name == FFT
        @visited = false
        @sum = 0

        @@instances += 1
    end

    def self.total
        @@instances
    end

    def add_links(links)
        links.each {|link| add_link(link) }
    end

    def add_link(link)
        if @linked_names.member?(link.device.name)
            @linked_devices << link
        end
    end

    def find_outs(end_device)
        if @device.name == end_device
            return 1
        elsif visited?
            return @sum
        else 
            @sum = @linked_devices.sum {|link| link.find_outs(end_device) }
            @visited = true
            return @sum
        end
    end
end

start = Time.now

devices = []

File.open(FILE_NAME).each do |line|
    devices << Device.new(line)
end

devices << Device.new("out:")

puts "Total devices: #{devices.size}"
queue = devices.clone.map{|dev| Link.new(dev) }
# create links outside of the map? or collect and grab the links once they are added and only add to those links
# links = devices.clone.map {|link|}
current_links = queue.select {|link| link.device.name == START_DEVICE }
start_link = current_links.first
end_link = queue.select {|link| link.device.name == END_DEVICE}.first
dac_link = queue.select {|link| link.device.name == DAC}.first
fft_link = queue.select {|link| link.device.name == FFT}.first
#puts "Got you?: #{current_devices}"
#puts "A link?: #{you_link}"
#gets
new_names = []

while !current_links.empty? do
    new_names = current_links.map {|link| link.device.outputs }.flatten.uniq

    #puts "queue: #{queue.size} names: #{new_names} cumulative seconds: #{(Time.now - start).round(2)}"
    new_links =  queue.select {|link| new_names.include?(link.device.name) }
    current_links.each {|link| link.add_links(new_links) }
    #start_link.add_links(new_links)
    current_links = new_links
end

puts "Total links #{Link.total}, total devices #{devices.size}"

start_fft = start_link.find_outs(FFT)
puts "From #{START_DEVICE} to #{FFT}: #{start_fft} cumulative seconds: #{(Time.now - start).round(2)}"
queue.each {|link| link.visited = false}
fft_dac = fft_link.find_outs(DAC)
puts "From #{FFT} to #{DAC}: #{fft_dac} cumulative seconds: #{(Time.now - start).round(2)}"
queue.each {|link| link.visited = false}
puts "From #{DAC} to #{FFT}: #{dac_link.find_outs(FFT)}?"
queue.each {|link| link.visited = false}
dac_end = dac_link.find_outs(END_DEVICE)
puts "From #{DAC} to #{END_DEVICE}: #{dac_end} cumulative seconds: #{(Time.now - start).round(2)}"
puts "Is it #{start_fft * fft_dac * dac_end}?"

queue.each {|link| link.visited = false}
puts "From #{START_DEVICE} to #{END_DEVICE}: #{start_link.find_outs(END_DEVICE)} cumulative seconds: #{(Time.now - start).round(2)}"

#puts queue.map {|link| "#{link.device.name} has #{link.linked_devices.size} assigned links: #{link.linked_devices.map {|dev| dev.device.name}}"}

#puts "Total paths #{start_link.find_outs(END_DEVICE)}"
puts "In seconds: #{(Time.now - start).round(2)}"

#puts "Total paths: #{you_link.find_outs}"

=begin
class Link
    attr_accessor :device, :linked_devices
    def initialize(device, dac = false, fft = false)
        @device = device
        @linked_devices = []
        @dac = device.name == DAC || dac
        @fft = device.name == FFT || fft
    end

    def add_links(devices)
        devices.each {|dev| add_link(dev, @dac, @fft) }
    end

    def add_link(output_device, visited_dac, visited_fft)
        if @device.outputs.include?(output_device.name)
            @linked_devices << Link.new(output_device, visited_dac, visited_fft)
            puts "Added #{output_device.name} to #{@device.name} with #{@device.outputs}"
        elsif @linked_devices.empty?
            return
        else
            @linked_devices.each {|link| link.add_link(output_device, (@dac || visited_dac), (@fft || visited_fft))}
        end
    end

    def find_outs
        if @device.outputs.one?(END_DEVICE) && visited_both?
            return 1
        else 
            return @linked_devices.sum {|link| link.find_outs }
        end
    end

    def visited_both?
        return @dac && @fft
    end
end
=end