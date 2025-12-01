def print_line(line)
    puts line
end

def get_direction(line)
    line[0]
end

def strip_distance(line)
    line.strip[1, line.length - 1].to_i
end

def get_distance(line)
    zero_click_count = 0
    
    distance = strip_distance(line)
    loop do
        break if distance < 100
        distance -= 100
        zero_click_count += 1
    end

    return distance, zero_click_count
end

def turn_dial(current_place, direction, distance)
    if (direction == 'L')
        new_place = current_place - distance
        if new_place < 0
            return new_place + 100, current_place != 0
        end
    else
        new_place = current_place + distance
        if new_place >= 100
            return new_place - 100, current_place != 0
        end
    end

    return new_place, false
end

current_place = 50
zero_count = 0

File.open("data-1.txt").each do |line|
    direction = get_direction(line)
    distance, zero_click_count = get_distance(line)
    zero_count += zero_click_count

    current_place, pass_zero = turn_dial(current_place, direction, distance)
    zero_count += current_place == 0 || pass_zero ? 1 : 0
    
    # for testing
    # print_line("#{direction} #{distance} #{current_place} #{pass_zero} #{line}")
end

print_line("Total zeros: #{zero_count}")