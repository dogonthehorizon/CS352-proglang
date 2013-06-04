#!/usr/bin/env ruby

###############################
#                             #
# FILE      : file_info.pl    #
# AUTHOR    : Fernando Freire #
# DATE      : 04/08/2013      #
#                             #
###############################

# Make sure we don't have more than 2 command line arguments
unless ARGV.size <= 2
    abort "Incorrect number of arguments."
end

input, output = ARGV

if input.nil? then input = "." end

unless File.directory?(input)
    abort "Error opening #{input}, no such directory."
end

