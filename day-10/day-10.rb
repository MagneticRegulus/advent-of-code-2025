require 'set'

TEST_FILE_NAME = "test-data-10.txt"
FILE_NAME = "data-10.txt"
SPLIT = ' '
INNER_SPLIT = ','
OFF = '.'
ON = '#'

class Machine
    attr_accessor :light_diagram, :on_indexs, :buttons, :joltage, :fewest_presses

    def initialize(line)
        manual_line = line.chomp.split(SPLIT)

        @light_diagram = manual_line.shift[1..-2].chars.map {|char| char == ON }
        @on_indexs = @light_diagram.map.with_index {|light, index| index if light }.reject {|idx| idx == nil }
        @joltage = split_numbers(manual_line.pop)
        @buttons = manual_line.map {|button| split_numbers(button)}
        @states = Set[]

        @fewest_presses = 0
    end

    def build_tree
        if @buttons.include?(@on_indexs)
            @fewest_presses = 1
        end

        steps = 0
        start_lights = Lights.new(start_state, steps)
        queue = []
        queue.push(start_lights)

        current_lights = start_lights

        # puts "Desired: #{@light_diagram}"

        while !queue.empty? do
            steps += 1

            # puts "Visited #{@states.size} states, queue is currently #{queue.size}"

            queue.size.times do
                current_lights = queue.shift
                current_lights.visited = true
                @states << current_lights.state

                #puts "Currently checking #{current_lights.state}"

                @buttons.each do |button|
                    press = Press.new(current_lights.state, button)
                    new_lights = Lights.new(press.pressed_state, steps)

                    next if @states.member?(new_lights.state)

                    #puts "Press #{steps} Button #{button} presses to #{new_lights.state}"
                    #gets

                    if new_lights.state == @light_diagram
                        @fewest_presses = new_lights.steps
                        return
                    end

                    queue.push(new_lights)
                end
                
            end
        end
    end

    def start_state
        Array.new(@light_diagram.size, false)
    end

    def split_numbers(item)
        item[1..-2].split(INNER_SPLIT).map {|num| num.to_i }
    end
end

class Press
    attr_accessor :previous_state, :pressed_state, :button

    def initialize(previous_state, button)
        @previous_state = previous_state
        @button = button
        @pressed_state = press
    end

    def press
        @previous_state.map.with_index {|light, index| @button.include?(index) ? !light : light }
    end
end

class Lights
    attr_accessor :state, :steps, :visited
    alias_method :visited?, :visited
    alias_method :eql?, :==

    def initialize(state, steps)
        @state = state
        @steps = steps
        @visited = false # only set when dequeued
    end

    def ==(o)
        o.class == self.class && o.state == state
    end
end

start = Time.now

machines = []

File.open(FILE_NAME).each do |line|
    machines << Machine.new(line)
end

machines.each.with_index(1) do |machine, index|
    machine.build_tree
    puts "Processed #{index} of #{machines.size}: size #{machine.fewest_presses}" #if index % 10 == 0
    # gets
end

puts "Fewest Presses: #{machines.map {|machine| machine.fewest_presses }.sum}"
puts "In seconds: #{Time.now - start.round(2)}"