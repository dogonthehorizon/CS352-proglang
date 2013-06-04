#!/usr/bin/perl -w

###############################
#                             #
# FILE      : file_info2.pl   #
# AUTHOR    : Fernando Freire #
# DATE      : 04/08/2013      #
#                             #
###############################

####################
#                  #
# SHELL: /bin/zsh  #
# OS   : GNU/Linux #
#                  #
####################

use strict;

# Make sure we don't have more than 2 command line arguments.
die "Incorrect number of files arguments.\n" unless $#ARGV < 2;

# Get command line arguments
my $input = shift;
my $output = shift;

# Set the value of $input to the current working directory unless $input already
# contains something.
$input = '.' unless (! $input eq '');

# Set the value of $output to something completely random unless $output already
# contains something. This gets rid of the uninitiliazed warning.
$output = "asdflkjhasdflkjh" unless  (! $output eq '');

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
my @files = `ls -A | sort`;
chomp @files;

# We subtract one here so that we are not accidentally counting
# the current (.) and previous (..) directories.
my $dir_size = $#files-1;

foreach (@files) {
    # Ignore the current (.) and previous (..) directories.
    next if $_ =~ m/^\.\.?$/;

    # Print the sorted list.
    print $OH "$_\n";
}

# See function definition for find_largest_file
my ($largest_file_name, $largest_file_size) = &find_largest_file(@files);

print $OH "\n";
print $OH "Number of files: $dir_size\n";
# -s returns the file size in bytes, so lets convert it to a more
# human readable number in kilobytes.
printf $OH "Largest file: %s %.2fK\n", $largest_file_name, $largest_file_size/1000;

# Close our open handles.
close $OH;

###############
# SUBROUTINES #
###############

##
# find_largest_file
#
# Finds the largest file in the given file list and returns its name and size.
#
sub find_largest_file ($) {
    my $high_name = '';
    my $high_size = 0;

    foreach (@_) {
        # Once again ignore current and previous directories.
        next if $_ =~ /^\.\.?$/;

        # Get the filesize of our current file/directory.
        my $temp = `stat -c \%s $_`;

        # Find our higheste value.
        if($temp > $high_size) {
            $high_name = $_;
            $high_size = $temp;
        }
    }

    return $high_name, $high_size;
}

