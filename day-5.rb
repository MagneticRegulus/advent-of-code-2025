TEST_FILE_NAME = "test-data-5.txt"
FILE_NAME = "data-5.txt"
SPLIT = '-'

def convert_to_range(range_string)
    range_values = range_string.split('-').map {|value| value.to_i }
    return Range.new(range_values.first, range_values.last)
end

def uniq_ids(ids)
    return ids.flatten.uniq
end

def get_intersection(ids, valid_ids)
    return ids.intersection(uniq_ids(valid_ids))
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