TEST_FILE_NAME = "test-data-10.txt"
FILE_NAME = "data-10.txt"
SPLIT = ' '
INNER_SPLIT = ','
OFF = '.'
ON = '#'

class Machine
    attr_reader :light_diagram, :on_indexs, :buttons, :joltage, :fewest_presses
    
    def initialize(line)
        manual_line = line.chomp.split(SPLIT)

        @light_diagram = manual_line.shift[1..-2].chars.map {|char| char == ON }
        @on_indexs = @light_diagram.map.with_index {|light, index| index if light }.reject {|idx| idx == nil }
        @joltage = split_numbers(manual_line.pop)
        @buttons = manual_line.map {|button| split_numbers(button)}
        @fewest_presses = -1
        # puts "#{light_diagram}"
    end

    def build_tree
        if @buttons.include?(@on_indexs)
            @fewest_presses = 3 
            return
        end

        current_step = 0
        start_node = Node.new(start_lights, @light_diagram, [], @buttons, current_step, [])
        start_node.add_children
        current_step += 1

        current_buttons = start_node.children

        while current_buttons.none? {|button| button.end? } || current_step < 2 do
            #puts "Step: #{current_step} #{current_buttons.size}"
            #gets
            
            current_buttons.each {|button| button.add_children }
            current_step += 1
            current_buttons = current_buttons.map {|button| button.children }.flatten
            if current_buttons.empty? && current_buttons.none? {|button| button.end? }
                puts "Failure"
                return
            end
        end

        #puts "Final: #{current_step} #{current_buttons.size}"
        #puts
        #gets

        @fewest_presses = current_step
    end

    def start_lights
        Array.new(@light_diagram.size, false)
    end

    def split_numbers(item)
        item[1..-2].split(INNER_SPLIT).map {|num| num.to_i }
    end
end

class Node
    attr_accessor :state, :desired, :pressed_button, :buttons, :children, :end, :step, :old_states
    alias_method :end?, :end
    
    def initialize(current_state, desired_state, button, buttons, step, old_states)
        @pressed_button = button
        @buttons = buttons.reject {|b| b == button}

        @state = press(current_state, button)
        @desired = desired_state

        @step = step
        @children = []

        @old_states = old_states

        @end = @state == @desired
        #@dead = stale_branch? #@state.all? {|light| !light }
        
        # have to do this last
        #@old_states << @state
    end

    def press(lights, toggles)
        lights.map.with_index {|light, index| toggles.include?(index) ? !light : light }
    end

    def indexes_to_fix
        @state.map.with_index {|light, index| index if light != @desired[index]}.reject{|light| light == nil}
    end

    def add_children
        #children_buttons = buttons.reject {|button| button == @pressed_button } # do first if needed .select {|button| button.intersect?(indexes_to_fix) }
        @old_states << @state
        @children = @buttons.select {|button| button.intersect?(indexes_to_fix) }
                           .map {|button| Node.new(@state, @desired, button, @buttons, @step + 1, @old_states)}
                           .reject {|button| button.dead? }
    end

    def no_children?
        @children.empty?
    end

    def dead?
        @old_states.include?(@state)
    end

    def to_s
        "#{@step} #{@state}"
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
    #gets
end

puts "Fewest Presses: #{machines.map {|machine| machine.fewest_presses }.sum}"
puts "In seconds: #{Time.now - start.round(2)}"