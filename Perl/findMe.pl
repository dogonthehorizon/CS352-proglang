#!/usr/bin/perl -w

###############################
#                             #
# FILE      : findMe.pl       #
# AUTHOR    : Fernando Freire #
# DATE      : 04/08/2013      #
#                             #
###############################

# Make sure we have at least command line argument.
die "Usage: $0 FILE [FILE+]\n" unless $#ARGV >= 0;

# The hash that will store our "dictionary".
my %hash;

# The filenames of all our supplied arguments.
my @files;

# Iterate over each of the files provided at invocation.
foreach my $file (@ARGV) {

    open FILE, "<", $file or die "Could not open $file for reading.\n";

    # Store the filename for use in our event loop.
    push @files, $file;

    my @lines = <FILE>;

    foreach my $line (@lines){
        # Split the line on each non-word character.
        my @words = split /\W+/, $line;

        foreach my $word (@words) {
            # Just in case there are any stray whitespace characters.
            chomp $word;

            # Make sure all the words are lowercase.
            $word = lc $word;

            # Let's also skip over any stop words.
            next if $word =~ m/and|a|an|the/;

            # Create our distinct hash key.
            my $key = $file.$word;

            # Increment the occurrence of the word,
            # if it doesn't exist then set its value to 1.
            if(exists $hash{$key}) {
                $hash{$key}++;
            } else {
                $hash{$key} = 1;
            }
        }
    }

    close FILE;
}

print "Press Ctrl+D to end the process.\n";
print "Search for: ";

# Accept input from STDIN until the user presses Ctrl+D
while (<STDIN>) {
    # These values will store our highest occurring word.
    my $high_value = 0;
    my $filename = '';

    # Sanitize input.
    chomp;
    my $search = lc;

    # Iterate over each of our files and craft our key name.
    foreach (@files) {
        my $key = $_.$search;

        # If the key/val pair exists, compare them to the highest value.
        # Otherwise, continue to the next iteration.
        next if !exists $hash{$key};

        if ($hash{$key} > $high_value) {
            $filename = $_;
            $high_value = $hash{$key};
        }
    }

    # If we found a match, print it; otherwise let the user know we failed.
    if ($high_value != 0) {
        print "$filename (matches: $high_value)\n";
    } else {
        print "No documents match.\n";
    }

    # Prompt the user for input.
    print "Search for: ";

}


