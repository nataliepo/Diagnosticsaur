#!/usr/bin/perl -w

use strict;
use Getopt::Long;


use constant TYPES => (
   'info',
   'tasks',
   'cpu',
   'mem',
   'swap',
);


my $type;
my $detail;
my $debug;

my $result = GetOptions ( "type=s"   => \$type,
                          "detail=s" => \$detail,
                          "debug"    => \$debug);
                          
my @type_array = TYPES;

die "USAGE: $0 --type=\"name\" --detail=\"value\"\n" . 
    "\ttype values are @type_array.\n\tUse the --debug flag to see all values.\n" 
   if ((!$type || !$detail) && !$debug);


# OUTPUT ONE SNAPSHOT OF READABLE DATA.
my $top_str = `top -n 1 -b`;

#####
# SAMPLE:
#
# 17:21:13 up 75 days,  6:55,  5 users,  load average: 0.06, 0.03, 0.00
# Tasks:  97 total,   1 running,  96 sleeping,   0 stopped,   0 zombie
# Cpu(s):  0.3%us,  0.0%sy,  0.0%ni, 99.6%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
# Mem:   1536028k total,  1427684k used,   108344k free,    42476k buffers
# Swap:  3145724k total,   260532k used,  2885192k free,   811976k cached

my @lines = split(/\n/, $top_str);

for (my $i = 0; $i < @lines; $i++) {

   $lines[$i] =~ s/\s+$//;
   $lines[$i] =~ s/^\s+//;
}



## 
# top - 10:36:52 up 81 days, 11 min,  1 user,  load average: 0.07, 0.03, 0.00
#     'n min' is optional
# double \\ req'd
my $regexp = 
   #"^top - (.*) up ([\\d]+) days?,\\s+([0-9:]+)(min)?," . 
   #          "\\s+([\\d]+) users?,\\s+" . 
             "load average: ([0-9.]+), ([0-9.]+), ([0-9.]+)";

my $breakout;

# line 0 -- info
#------------
# top - 17:21:13 up 75 days,  6:55,  5 users,  load average: 0.06, 0.03, 0.00
if ($lines[0] !~ m/$regexp/) {
   die "Line doesn't match pattern: \n" . $lines[0] . "\n";
   
}
else {   
   
#   $breakout->{'info'}->{'timestamp'} = $1;
#   $breakout->{'info'}->{'days_up'} = $2;  
#   $breakout->{'info'}->{'unknown_timestamp'} = $3; 
#   $breakout->{'info'}->{'users'} = $5;
   $breakout->{'info'}->{'load_1'} = $1;
   $breakout->{'info'}->{'load_5'} = $2;
   $breakout->{'info'}->{'load_10'} = $3;
}


# line 1 -- tasks
#---------
# Tasks:  77 total,   1 running,  76 sleeping,   0 stopped,   0 zombie
$regexp = "^Tasks:\\s+([\\d]+) total,\\s+ ([\\d]+) running,\\s+" . 
          "([\\d]+) sleeping,\\s+([\\d]+) stopped," . 
          "\\s+([\\d]+) zombie";
            #",\\s+([0-9:]+)," . 
            # "\\s+([\\d]+) users?,\\s+" . 
            # "load average: ([0-9.]+), ([0-9.]+), ([0-9.]+)";
if ($lines[1] !~ m/$regexp/) {
   die "Line doesn't match pattern: \n" . $lines[1] . "\n";

}
else {   
   $breakout->{'tasks'}->{'total'} = $1;
   $breakout->{'tasks'}->{'running'} = $2; 
   $breakout->{'tasks'}->{'sleeping'} = $3;
   $breakout->{'tasks'}->{'stopped'} = $4;
   $breakout->{'tasks'}->{'zombie'} = $5;
}



# line 2 
#----------
# Cpu(s):  0.2%us,  0.2%sy,  0.0%ni, 99.7%id,  0.0%wa,  0.0%hi,  0.0%si,  0.0%st
$regexp = ":\\s+([0-9.]+)\%us,\\s+([0-9.]+)\%sy,\\s+([0-9.]+)\%ni," . 
         "\\s+([0-9.]+)\%id,\\s+([0-9.]+)\%wa,\\s+([0-9.]+)\%hi," . 
         "\\s+([0-9.]+)\%si,\\s+([0-9.]+)\%st";
if ($lines[2] !~ m/$regexp/) {
   die "Line doesn't match pattern: \n" . $lines[2] . "\n";
}
else {
   $breakout->{'cpu'}->{'us'} = $1;
   $breakout->{'cpu'}->{'sy'} = $2;
   $breakout->{'cpu'}->{'ni'} = $3;
   $breakout->{'cpu'}->{'id'} = $4;
   $breakout->{'cpu'}->{'wa'} = $5;
   $breakout->{'cpu'}->{'hi'} = $6;
   $breakout->{'cpu'}->{'si'} = $7;
   $breakout->{'cpu'}->{'st'} = $8;
}

# line 3
#-----------
#Mem:   1536028k total,  1157656k used,   378372k free,    52448k buffers
$regexp = "^Mem:\\s+([\\d]+k) total,\\s+([\\d]+k) used," . 
          "\\s+([\\d]+k) free,\\s+([\\d]+k) buffers";

if ($lines[3] !~ m/$regexp/) {
   die "Line doesn't match pattern: \n" . $lines[3] . "\n";
}
else {          
   $breakout->{'mem'}->{'total'} = $1;
   $breakout->{'mem'}->{'used'} = $2;
   $breakout->{'mem'}->{'free'} = $3;
   $breakout->{'mem'}->{'buffers'} = $4;
}          


# line 4
#--------------
#Swap:  3145724k total,   260532k used,  2885192k free,   563116k cached
$regexp = "^Swap:\\s+([\\d]+k) total,\\s+([\\d]+k) used," . 
           "\\s+([\\d]+k) free,\\s+([\\d]+k) cached";
           
if ($lines[4] !~ m/$regexp/) {
   die "Line doesn't match pattern: \n" . $lines[3] . "\n";
}
else {      
   $breakout->{'swap'}->{'total'} = $1;
   $breakout->{'swap'}->{'used'} = $2;
   $breakout->{'swap'}->{'free'} = $3;
   $breakout->{'swap'}->{'buffers'} = $4;
}


print $breakout->{$type}->{$detail} . "\n";


if ($debug) {
   my @types = TYPES;


   #---- DEBUG
   foreach my $k (sort(@types)) {
      print STDERR "$k:\n";
      my $breakout_hash = $breakout->{$k};
   
      foreach my $l (sort(keys(%$breakout_hash))) {
         print STDERR "\t [$l] = " . $breakout->{$k}->{$l} . "\n";
      }
   }
}  