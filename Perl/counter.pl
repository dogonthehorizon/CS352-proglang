#/usr/bin/perl -w

###############################
#                             #
# FILE      : counter.pl      #
# AUTHOR    : Fernando Freire #
# DATE      : 04/03/2013      #
#                             #
###############################

use strict;

print "Enter a count: ";
# In compliance with Part One's requirements we will explicity read from
# standard input.
chomp(my $count = <STDIN>);

my @values;
print "Enter a value: ";
while(<>) {
    # We use `unless` here to ensure that we are not printing our prompt
    # too many times.
    print "Enter a value: " unless (@values+1) == $count;
    push(@values,$_);
    last if @values == $count;
}

chomp @values;

my $output = join(', ',@values);

# In compliance with Part One's requirements we will explicity write to
# standard output
print( <STDOUT> , "You entered: $output\n" );

