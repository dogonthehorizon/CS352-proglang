#!/usr/bin/perl -w
###############################
#                             #
# FILE      : file_info.pl    #
# AUTHOR    : Fernando Freire #
# DATE      : 04/08/2013      #
#                             #
###############################

use strict;

# Make sure we don't have more than 2 command line arguments.
die "Incorrect number of files arguments.\n" unless $#ARGV < 2;

if ($#ARGV > 2){ die "Incorrect number of file arguments.\n"; }

# Get command line arguments
my $input = shift;
my $output = shift;

# Set the value of $input to the current working directory unless $input already
# contains something.
$input = '.' unless (! $input eq '');

# Set the value of $output to something completely random unless $output already
# contains something.
$output = "asdfasdfasdfasdf" unless  (! $output eq '');

# An interesting aside for the above two lines:
# For whatever reason using the string comparison `ne` will yield warnings when
# using perl -w. However, using the far less semantic ! $input eq ''
# ("$input is not equal to ''") then perl -w seems to be happy.

# Error out unless $input exists.
die "Error opening $input, no such directory.\n" unless -e $input;

# If the file exists, lets open it for appending and assign it to the
# $OH filehandle. Otherwise, $OH should reference STDOUT to avoid
# code duplication.
my $OH;
if ( -e $output ) {
    open($OH, ">>", $output) or die "Could not open $output for writing";
} else {
    $OH = *STDOUT;
}

# Open our input directory so that we can read all of its contents.
opendir DIR, $input or die "Could not open $input for browsing";
my @files = sort readdir DIR;

my $dir_size = $#files+1;
my $largest_file_name = '';
my $largest_file_size = 0;

foreach (@files) {
    # Ignore any file that begins with .
    # This includes the current (.) and previous (..) directories.
    next if $_ =~ m/^\./;
    # Get the largest file size
    my $temp_size = -s $_;
    #print "Current size is $temp_size and largest size is $largest_file_size\n";
    if ( $temp_size > $largest_file_size ) {
        $largest_file_name = $_;
        $largest_file_size = $temp_size;
    }
    # Print the sorted list.
    print $OH "$_\n";
}

# -s returns the file size in bytes, so lets convert it to a more
# human readable number in kilobytes.
$largest_file_size = $largest_file_size / 1000;

print $OH "\n";
print $OH "Number of files: $dir_size\n";
# Let's truncate our human readable file size so the number isn't so long.
printf $OH "Largest file: %s %.2fK\n", $largest_file_name, $largest_file_size;

# Close our open handles.
close $OH;
closedir DIR;

