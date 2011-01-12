#!/usr/bin/perl -w

use strict;

my $top_str = `top -n 1`;

print STDERR "top str = \n$top_str\n";

#####
# SAMPLE:
#
# 17:21:13 up 75 days,  6:55,  5 users,  load average: 0.06, 0.03, 0.00
# Tasks:  97 total,   1 running,  96 sleeping,   0 stopped,   0 zombie
# Cpu(s):  0.3%us,  0.0%sy,  0.0%ni, 99.6%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
# Mem:   1536028k total,  1427684k used,   108344k free,    42476k buffers
# Swap:  3145724k total,   260532k used,  2885192k free,   811976k cached

my @lines = split(/\n/, $top_str);

foreach my $line (@lines) {
   print STDERR "line =\n$line\n";
}

# line 0:
# 17:21:13 up 75 days,  6:55,  5 users,  load average: 0.06, 0.03, 0.00
#if ($line[0] !~ /)



print STDERR " ** SCRIPT COMPLETE **\n";

