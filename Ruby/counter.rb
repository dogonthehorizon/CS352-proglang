#!/usr/bin/env ruby

###############################
#                             #
# FILE      : counter.rb      #
# AUTHOR    : Fernando Freire #
# DATE      : 04/16/2013      #
#                             #
###############################

print "Enter a count: "
# Get from STDIN, remove the newline, and convert it to an int
count = gets.chomp.to_i

values = []

# Iterate over the values based on the given count
count.times do
    print "Enter a value: "
    values << gets.chomp
end

puts "You entered: #{values.map{ |value| value }.join(', ')}"

