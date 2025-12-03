TEST_FILE_NAME = "test-data-3.txt"
FILE_NAME = "data-3.txt"
MINIMUM_BATTERIES = 12 # can be changed to 2 in order to complete the first part

# used in the first part, but not the second
def get_first_digit_index(bank, bank_length)
    valid_batteries = bank[0...(bank_length - 1)]
    max_battery = valid_batteries.max
    return valid_batteries.find_index(max_battery)
end

# naming conventions not great here
def get_next_digit_index(bank, last_index, bank_length, iteration)    
    minimum_maximum = bank_length + iteration
    minimum_inclusive = last_index + 1
    maximum_range = (minimum_inclusive..(minimum_inclusive > minimum_maximum ? minimum_inclusive + 1 : minimum_maximum))

    valid_batteries = bank[maximum_range]
    max_battery = valid_batteries.max
    max_index = valid_batteries.find_index(max_battery)
    return  max_index + minimum_inclusive
end

total_joltage = 0

File.open(FILE_NAME).each do |line|
    bank_array = line.strip.chars.map {|char| char.to_i}
    battery_count = bank_array.length
    minimum_maximum = battery_count - MINIMUM_BATTERIES

    batteries = ''
    previous_index = -1

    MINIMUM_BATTERIES.times do |iteration|
        next_index = get_next_digit_index(bank_array, previous_index, minimum_maximum, iteration)
        batteries += bank_array[next_index].to_s
        previous_index = next_index
    end

    total_joltage += batteries.to_i
end

puts total_joltage