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
        puts "#{light_diagram}"
        calculate_fewest_presses
    end

    def split_numbers(item)
        item[1..-2].split(INNER_SPLIT).map {|num| num.to_i }
    end

    def calculate_fewest_presses
        current_lowest = 20

        starting_buttons = @buttons.select {|button| button.intersect?(@on_indexs) }

        puts "#{starting_buttons}"

        starting_buttons.each do |button|
            lights = reset_lights
            puts "Pre-press: #{lights}"
            press_count = 0
            press(lights, button)
            press_count += 1
            puts "#{button} #{lights}"
            last = button

            until lights.all?(true) || press_count > current_lowest do
                next_button = find_next(@buttons, lights, last)
                press(lights, next_button)
                press_count += 1
                puts "#{next_button} #{lights}"
                last = next_button
            end

            current_lowest = press_count if press_count < current_lowest
            puts "#{current_lowest}"
            break if current_lowest == 2
        end

        @fewest_presses = current_lowest
        puts fewest_presses
    end

    def press(lights, toggles)
        lights.map!.with_index {|light, index| toggles.include?(index) ? !light : light }
    end

    def indexes_to_fix(lights)
        lights.map.with_index {|light, index| index if !light}.reject{|light| light == nil}
    end

    def sort_buttons(buttons, lights)
        buttons.sort {|a, b| b.intersection(indexes_to_fix(lights)).size <=> a.intersection(indexes_to_fix(lights)).size}
    end

    def get_max_differences(buttons, lights)
        sorted = sort_buttons(buttons, lights)
        max_intersection_size = sorted.first.intersection(indexes_to_fix(lights))

        sorted.take_while {|button| button.intersection(indexes_to_fix(lights)) == max_intersection_size}
    end

    def find_next(buttons, lights, last)
        to_fix = indexes_to_fix(lights)

        get_max_differences(buttons.reject {|button| button == last}, lights).sort {|button| button.size }.tap {|c| puts "Could change #{c}: #{to_fix}"}.first
    end

    def reset_lights
        lights = Array.new(@light_diagram.size, true)
        press(lights, @on_indexs)
        return lights
    end

end

machines = []

File.open(TEST_FILE_NAME).each do |line|
    machines << Machine.new(line)
end
=begin
puts "#{machines[0].light_diagram}"
# puts "#{machines.map {|machine| machine.joltage }}"
# puts "#{machines.map {|machine| machine.buttons }}"
puts "#{machines[0].on_indexs }"
machines[0].calculate_fewest_presses
=end

puts "#{machines.map {|machine| machine.fewest_presses }}"