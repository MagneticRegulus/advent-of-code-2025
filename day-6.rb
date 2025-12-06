require 'matrix'

TEST_FILE_NAME = "test-data-6.txt"
FILE_NAME = "data-6.txt"
SEPARATOR = ' '

def is_int?(str)
    str.to_i.to_s == str
end

def calculate(vector)
    array = vector.to_a
    method = array.pop
    return array.reduce(method.to_sym)
end

rows = []

File.open(FILE_NAME).each do |line|
    rows << line.squeeze(SEPARATOR).split(SEPARATOR).map {|item| is_int?(item) ? item.to_i : item }
end

matrix = Matrix.rows(rows)
totals = matrix.column_vectors().map {|vector| calculate(vector)}

puts "Total sum of all answers: #{totals.sum}"