#!/usr/bin/perl -w

use strict;

use Getopt::Long;

my $task;

my $result = GetOptions ( "task=s"   => \$task);


die "USAGE: \n" . 
     "nfs read throughput: \n\t$0 --task=r\n" . 
     "nfs write throughput: \n\t$0 --task=w\n" 
         if (!$task);
   
my $scriptname = $0;

my $result_str = `iostat -kn 1 11 | grep drbd`;

my @results = split(/\n/, $result_str);

my $size = @results;
my $total = 0;

for (my $i = 0; $i < $size; $i++) {

   my $line = $results[$i];
   
   # SKIP THE FIRST RESULT!!!!
   next if ($i == 0);
   
#   my $val = `$line | awk '/mnt/ {print $2}'`;
   die "Misformatted row: \"$line\"\n" if ($results[$i] !~ m|/mnt/|);

   $results[$i] =~ m|^([^\s]+)\s+([^\s]+)\s+([^\s]+)\s+|;
      
   if ($task eq "r") {
      $total += $2;
   }
   elsif ($task eq "w") {
      $total += $3;
   }
}

if (!$total) {
   print "0";
}

# otherwise, calculate the average.
else {
   print ($total / ($size - 1));
}

print "\n";


__END__


# USER , PID, %CPU, %MEM, VSZ, RSS, TTY ,S ,STARTED , TIME, COMMAND
# root      1373  0.0  0.4 300348  6700 ?        Ss    2010   5:26 /usr/sbin/httpd -k start
else {
   my $procs = `ps aux | grep $process`;
   
   my @processes = split(/\n/, $procs);
   
   my $breakdown;
   
                  # 1, 2, 3, 4
   my $regexp = "^([^\\s]+)\\s+([\\d]+)\\s+([0-9.]{3})\\s+([0-9.]{3})" . 
                  # 5, 6, 7, 8
                "\\s+([\\d]+)\\s+([\\d]+)\\s+([^\\s]*)\\s+([^\\s]+)\\s+" . 
                  # 9, 10, 11
                "([^\\s]+)\\s+([:\\d]+)\\s+(.*)\$";    
   
   foreach my $p (@processes) {
      my $row;
      
      if ($p !~ m/$regexp/) {
         die "row misformatted; row = \n$p\n";
      }
      
      my $command = $11;
      $command =~ s/\s+$//;  # snip trailing whitespace
      
      # skip this script from the data.
      if ($command =~ m/$scriptname/) {
         next;
      }
      
      $row->{'user'} = $1;
      $row->{'pid'} = $2;
      $row->{'cpu'} = $3;
      $row->{'mem'} = $4;
      $row->{'vsz'} = $5;
      $row->{'rss'} = $6;
      $row->{'tty'} = $7;
      $row->{'s'}   = $8;
      $row->{'started'} = $9;
      $row->{'time'} = timestamp_to_int($10);
      $row->{'command'} = $command;
      
      push (@$breakdown, $row);
   }
   
   if ($breakdown) {
      
      
      my $sum = 0;
      my $count = 0;
      my $max = 0;
      my $min = 0;

     foreach my $b (@$breakdown) {
        $sum += $b->{$metric};
        $count++;
        if ($b->{$metric} >= $max) {
           $max = $b->{$metric};
        }
        
        if ($b->{$metric} <= $min) {
           $min = $b->{$metric};
        }
     }

     my $avg = ($sum / $count);
     $avg += 0.0;
     
     if ($summary eq "avg") {

        print "$avg\n";
      }
      elsif ($summary eq "max") {
         print "$max\n";
      }
      elsif ($summary eq "min") {
         print "$min\n";
      }
      elsif ($summary eq "all") {
         print "avg = $avg\n";
         print "max = $max\n";
         print "min = $min\n";         
      }
      else {
         print STDERR "unknown summary.\n";
      }
  }
}


print STDERR "** SCRIPT COMPLETE **\n";


sub debug {
   my ($breakdown) = @_;

   foreach my $k (@$breakdown) {
      foreach my $l (sort(keys(%$k))) {
         print STDERR "\t [$l] = " . $k->{$l} . "\n";
      }
   }
}

sub timestamp_to_int {
   my ($timestamp) = @_;
   
   $timestamp =~ m/([\d]+):([\d]+)/;
   
   return (60 * $1) + $2;
}

