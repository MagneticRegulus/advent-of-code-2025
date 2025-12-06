TEST_FILE_NAME = "test-data-6.txt"
FILE_NAME = "data-6.txt"
SEPARATOR = ' '

def is_int?(str)
    str.to_i.to_s == str
end

def calculate(column)
    method = column.pop
    return column.reduce(method)
end

rows = []
lines = []

File.open(FILE_NAME).each do |line|
    rows << line.split(SEPARATOR).map {|item| is_int?(item) ? item.to_i : item.to_sym }
    lines << line.chomp.chars
end

totals = rows.transpose.map {|column| calculate(column)}

puts "Total sum of all answers: #{totals.sum}"

lines.pop # delete methods lines as we already have these
methods = rows.pop
digits = lines.transpose.map {|column| column.join}

cephalopod_problems = []
group = []

digits.each.with_index do |digit, index|
    if digit.strip.empty?
       group << methods.shift
       cephalopod_problems << group
       group = []
    else
        group << digit.to_i

        # not very elegant
        if index == digits.size - 1
            group << methods.shift
            cephalopod_problems << group
        end
    end
end

cephalopod_totals = cephalopod_problems.map {|column| calculate(column)}

puts "Total sum of all cephalopod answers: #{cephalopod_totals.sum}"