require 'prime'

TEST_FILE_NAME = "test-data-2.txt"
FILE_NAME = "data-2.txt"

class IdRange
    attr_reader :range_string, :range, :ids
    attr_accessor :invalid_ids, :current_digit_count
    
    def initialize(range_string)
        @range_string = range_string
        @range = convert_to_range(range_string)
        @ids = Array(@range)
        @invalid_ids = find_invalid_ids

        # not a good way of doing this, but was in a rush
        @current_digit_count = 0
        @current_divisors = []
    end

    def convert_to_range(range_string)
        range_values = range_string.split('-').map {|value| value.to_i }
        return (range_values.first..range_values.last)
    end

    def find_invalid_ids
        return @ids.filter {|id| invalid?(id)}
    end

    def invalid?(id)
        digit_count = id.digits.length

        if digit_count != @current_digit_count
            @current_digit_count = digit_count
            @current_divisors = get_divisors(digit_count)
        end

        @current_divisors.each do |divisor|
            sliced_id = slice_id(id, digit_count, divisor)
            #puts "#{sliced_id}"
            if sliced_id.uniq.length == 1
                return true
            end
        end
        
        # faster way for part one
        # if digit_count.even?
        #    mod = get_mod(digit_count)
        #    # puts "#{id} % #{mod} = #{id % mod}"
        #    return id % mod == 0
        # end

        return false
    end

    def get_mod(digit_count)
        count_zeroes = (digit_count / 2) - 1
        return "1#{"0"*count_zeroes}1".to_i
    end

    # slower but easier
    # https://stackoverflow.com/a/51006576
    def slice_id(id, size, divisor)
        id.to_s.chars.each_slice(size / divisor).map(&:join)
    end

    # https://github.com/chweeks/Codewars-Ruby/blob/master/6-kyu/Find%20the%20Divisors.rb
    def get_divisors(num)
        return (2..num).select{|numbers| num % numbers == 0}
    end

    def to_s
        "#{range} #{invalid_ids}"
    end
end

def get_data(file_name)
    return File.open(file_name).readline.strip
end

def get_ranges(data)
    return data.split(',')
end

time_start = Time.now

data = get_data(FILE_NAME)
ranges = get_ranges(data)
invalid_id_sum = 0

ranges.each do |range|
    id_range = IdRange.new(range)
    # puts id_range # for testing
    invalid_id_sum += id_range.invalid_ids.sum
end


puts invalid_id_sum

puts "In seconds: #{(Time.now - time_start)}"

# some notes below for a faster way of doing this, but became complex in part 2

# 22 (2) / 2 (1) = 11 (2)
# 1010 (4) / 10 (2) = 101 (3)
# 222222 (6) / 222 (3) = 1001 (4)
# 38593859 (8) / 3859 (4) = 10001 (5)
# 1188511885 (10) / 11885 (5) = 100001 (6) 
# 123456123456 (12) / 123456 (6) = 1000001 (7)

# 22 (2) / 2 (1) = 11 (2) --> prime
# 999 (3) / 9 (1) = 111 (3) --> prime
# 1111 (4) / 1 (1) = 1111 (4)
# 1010 (4) / 10 (2) = 101 (3)
# 11111 (5) / 1 (1) = 11111 (5) --> prime
# 333333 (6) / 3 (1) = 111111 (6)
# 565656 (6) / 56 (2) = 10101 (5)
# 446446 (6) / 446 (3) = 1001 (4)
# 88888888 (8) / 8 (1) = 11111111 (8)
# 81818181 (8) / 81 (2) = 1010101 (7)
# 81238123 (8) / 8123 (4) = 10001 (5)
# 1212121212 (10) / 12 (2) = 101010101 (9)
# 9 digits 3 times = 1001001 - 1 2 1 2 1 (7)
# 15 digits 3 times = 10000100001 - 1 4 1 4 1 (11)
# 15 digits 5 times = 1001001001001 - 1 2 1 2 1 2 1 2 1 (13)