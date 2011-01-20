#!/usr/bin/perl -w

use strict;
use Getopt::Long;

my $filesys;
my $option;

my $result = GetOptions ( "filesys=s"   => \$filesys,
                          "option=s"    => \$option);

die "USAGE: $0 --filesys=\"name\" --option=\"value_option\"\n" if (!$filesys || !$option);

my $error = 0;
my $freespace = `df -h "$filesys"`;
(print "-1\n" and die "Error.\n") if ($?);


#   print STDERR "\n=== INITIAL OUTPUT ===\n$freespace\n\n";

   my @lines = split(/\n/, $freespace);

   my @keys;

   if ($lines[0] =~ m|^(.*)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+(Mounted on)$|) {
      @keys = ($1, $2, $3, $4, $5, $6);         
   }
   else {
      print "-1\n";
      die "Header doesnt match expected pattern.\n";
   }

   my $results = ( );


   for (my $i = 1; $i < @lines; $i++) {

      my $line = $lines[$i];

      if ($line =~ m|^(.*)\s+([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+([\d]+)%\s+([^\s]+)$|) {
   
         my @values = ($1, $2, $3, $4, $5, $6);
         my $breakdown = ();

         for (my $j = 0; $j < 6; $j++) {
         
            # trailing whitespace!
            $values[$j] =~ s/\s+$//;
            $breakdown->{$keys[$j]} = $values[$j];
         }
      
         $results->{$values[0]} = $breakdown;
      }
      else {
         print STDERR "This line doesn't match expected pattern: \n$line\n\n";
         print "-1\n";
         die;
      }
   }

   if (!exists($results->{$filesys})) {
      die "No volume named \"$filesys\"\n";
   }

   if (!exists($results->{$filesys}->{$option})) {
      die "No column (option) named \"$option\"\n";
   }

   print $results->{$filesys}->{$option} . "\n";

#   print STDERR "*** SCRIPT COMPLETE *** \n";

