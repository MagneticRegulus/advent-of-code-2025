TEST_FILE_NAME = "test-data-5.txt"
FILE_NAME = "data-5.txt"
SPLIT = '-'

def convert_to_range(range_string)
    range_values = range_string.split('-').map {|value| value.to_i }
    return Range.new(range_values.first, range_values.last)
end

def merge_ranges(a, b)
    mins = [a.min, b.min]
    maxs = [a.max, b.max]
    return mins.min..maxs.max
end

valid_ranges = []
ids = []
intersection = []


File.open(FILE_NAME).each do |line|
    next if line.empty?
    if line.include?(SPLIT)
        valid_ranges << convert_to_range(line)
    else
        ids << line.to_i
    end
end

ids.each do |id|
    if valid_ranges.any? {|range| range.cover?(id)}
        intersection << id
    end
end

puts "Fresh ingredients: #{intersection.count}"

# Can't take credit for this part, tweaked from
# https://stackoverflow.com/a/6018744
# But I was reminded of syntax I had forgotten about
merged_ranges = valid_ranges.sort_by(&:begin).inject([]) do |ranges, next_range|
    if !ranges.empty? && ranges.last.overlap?(next_range)
        ranges[0...-1] << merge_ranges(ranges.last, next_range)
    else
        ranges << next_range
    end
end

puts "Fresh ingredient IDs: #{merged_ranges.sum {|range| range.size }}"