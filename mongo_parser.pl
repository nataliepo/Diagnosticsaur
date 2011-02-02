#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use constant INFILE_NAME => 'live.csv';
use constant OUTFILE_NAME => 'live-modified.csv';

open (INFILE, INFILE_NAME) or die "Can't open \"" . 
   INFILE_NAME . "\" for reading.\n";
   

use constant PEAK_START => 12;
use constant PEAK_STOP  => 20;   
   
use constant MONTH => 
   (
      'Jan', 
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
   );
   
# first line is a dummy
my $line = <INFILE>;   

# ignore second line (header)
my $header = <INFILE>;


my $summary;


my @months = MONTH;
while ($line = <INFILE>) {
   next if ($line =~ m/null/);
   $line =~ s/\n$//;
   my @vars = split(/,/, $line);
   
   my $date = $vars[0];
   my $server_id = $vars[1];
   my $operation = $vars[2];
   my $value = $vars[3];
   
   $value =~ s/\"//g;
   $value = 0 if (!$value);
   
   $server_id =~ s/\"//g;
   $operation =~ s/\"//g;
   
   
   
   my $hour = (localtime($date))[2];
   my $min = (localtime($date))[1];   
         
   my $day = (localtime($date))[3];
   my $month = (localtime($date))[4];
   
   my $date_str = ($month + 1) . "/$day/2011";
   my $time_str = "$hour:$min";

   
   if (
         (!exists($summary->{$date_str})) || 
         (!exists($summary->{$date_str}->{$operation})) ||
         (!exists($summary->{$date_str}->{$operation}->{$server_id}))
         ) {
      $summary->{$date_str}->{$operation}->{$server_id}->{'peak'}->{'count'} = 0;
      $summary->{$date_str}->{$operation}->{$server_id}->{'peak'}->{'total'} = 0;

      $summary->{$date_str}->{$operation}->{$server_id}->{'offpeak'}->{'count'} = 0;
      $summary->{$date_str}->{$operation}->{$server_id}->{'offpeak'}->{'total'} = 0;

   }
   
   # Peak hours
   if (($hour >= PEAK_START) && ($hour <= PEAK_STOP)) {
      $summary->{$date_str}->{$operation}->{$server_id}->{'peak'}->{'count'}++;
      $summary->{$date_str}->{$operation}->{$server_id}->{'peak'}->{'total'} += $value;      
   }
   else {
      $summary->{$date_str}->{$operation}->{$server_id}->{'offpeak'}->{'count'}++;
      $summary->{$date_str}->{$operation}->{$server_id}->{'offpeak'}->{'total'} += $value;      
   }
   
   
   #### Reformat timestamps.
   #print OUTFILE $months[$month] . ",$day,$hour:$min,$rest\n";
}

print_report ($summary);   
   
close(INFILE);




####
sub print_report {
   my ($summary) = @_;

   open (OUTFILE, "> " . OUTFILE_NAME) or die "Can't open \"" . 
      OUTFILE_NAME . "\" for writing.\n";

   # header
   print OUTFILE "DATE,OPERATION," . 
                 "App1-PEAK AVERAGE," . 
                 "App1-OFFPEAK AVG," . 
                 "App2-PEAK AVERAGE," . 
                 "App2-OFFPEAK AVG," .   
                 "App3-PEAK AVERAGE," . 
                 "App3-OFFPEAK AVG," .
                 "App4-PEAK AVERAGE," . 
                 "App4-OFFPEAK AVG," .
                 "Overall-PEAK AVERAGE," . 
                 "Overall-OFFPEAK AVG," .
            "\n";

   foreach my $date (sort(keys(%$summary))) {
      my $date_obj = $summary->{$date};
      foreach my $operation (sort(keys(%$date_obj))) {
         my $op_obj = $summary->{$date}->{$operation};

         my $allserver_offpeak_total = 0;
         my $allserver_offpeak_count = 0;
         
         my $allserver_peak_total = 0;
         my $allserver_peak_count = 0;
         
         print OUTFILE "$date,$operation,";

#          foreach my $server (sort(keys(%$op_obj))) {
         for (my $server = 1; $server <= 4; $server++) {
            
            if (!exists($summary->{$date}->{$operation}->{$server})) {
               print OUTFILE "0,0,";
               next;
            }
            
            my $offpeak_count = $summary->{$date}->{$operation}->{$server}->{'offpeak'}->{'count'};
            my $peak_count    = $summary->{$date}->{$operation}->{$server}->{'peak'}->{'count'};
            my $offpeak_total = $summary->{$date}->{$operation}->{$server}->{'offpeak'}->{'total'};
            my $peak_total    = $summary->{$date}->{$operation}->{$server}->{'peak'}->{'total'};
            
            
            $allserver_offpeak_total += $offpeak_total;
            $allserver_offpeak_count += $offpeak_count;
            
            $allserver_peak_total += $peak_total;
            $allserver_peak_count += $peak_count;
            
            # Peak Average
            print OUTFILE 
                  (($peak_count) ? ($peak_total / $peak_count) : 0) . "," .  # peak average
                  (($offpeak_count) ? ($offpeak_total / $offpeak_count) : 0) . ",";  # offpeak average
         }
         
         # ACROSS ALL SERVERS -- Peak Average
         print OUTFILE
               (($allserver_peak_count) ? ($allserver_peak_total / $allserver_peak_count) : 0) . "," .  # average
               (($allserver_offpeak_count) ? ($allserver_offpeak_total / $allserver_offpeak_count) : 0) . ","   # average
               . "\n";    # offpeak count    
      }
   }

   close (OUTFILE);

}