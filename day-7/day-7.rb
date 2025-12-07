TEST_FILE_NAME = "test-data-7.txt"
FILE_NAME = "data-7.txt"
CURRENT_FILE = FILE_NAME
ENTRY = 'S'
EMPTY = '.'
SPLITTER = '^'
BEAM = "|"

def beam_indices(manifold_line)
    return manifold_line.chars.each_index.select {|index| manifold_line[index] == BEAM || manifold_line[index] == ENTRY }
end

manifold = []
beam_indices = []

File.open(CURRENT_FILE).each do |line|
    manifold << line.chomp
end

counter = 0

manifold.each.with_index do |line, index|
    if index == 0
        beam_indices = beam_indices(line)
        next
    end

    beam_indices.each do |beam_index|
        if line[beam_index] == SPLITTER
            line[beam_index - 1] = BEAM
            line[beam_index + 1] = BEAM
            counter += 1
        else
            line[beam_index] = BEAM
        end
    end

    beam_indices = beam_indices(line)
end

puts "Count of splits: #{counter}"

start = Time.now
lines =[]

File.open(CURRENT_FILE).each do |line|
    lines << line.chomp
end

timelines = lines.map {|line| line.chars.map {|char| char == EMPTY ? 0 : char} }

timelines.each.with_index do |line, index|
    if index == 0
        line[line.index(ENTRY)] = 1
        # puts "#{timelines[index]}"
        next
    end

    previous = timelines[index - 1]

    splitters = line.each_index.select {|index| line[index] == SPLITTER }
    # puts "#{splitters}"
    splitters.each do |split|
        above = previous[split]
        if above > 0
            line[split - 1] += above
            line[split + 1] += above
        end
    end

    beam_lines = previous.each_index.select {|index| !splitters.include?(index) && previous[index].class == Integer && previous[index] > 0}
    beam_lines.each do |beam_idx|
        line[beam_idx] += previous[beam_idx]
    end

    # puts "#{timelines[index]}"
end

puts "Timelines: #{timelines.last.sum}"
puts "Seconds: #{Time.now - start}"

=begin 
# I tried to brut force it...it did not work
lines.each.with_index do |line, index|
    next if index > 1 && index.odd?

    if index == 0
        timelines[index] = [line.index(ENTRY)]
        next
    end

    dimensions = timelines.last
    timelines[index] = []
    
    dimensions.each do |beam_index|
        if line[beam_index] == SPLITTER
            timelines[index] << beam_index - 1
            timelines[index] << beam_index + 1
        else
            timelines[index] << beam_index
        end
    end

    puts "Line #{index + 1} has #{timelines.last.size} timelines" if index % 10 == 0
end
=end