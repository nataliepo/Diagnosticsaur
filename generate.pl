#!/usr/bin/perl

use strict;

use constant SERVER => 'AIdev';
use constant DEBUG => 1;
use constant DEBUG_SAVE => 0;

use constant USER => 'xxxx';
use constant PASS => 'xxxx';

# libraries
use Data::Dumper;
use File::Glob qw(:globally :nocase);
use JSON;
use MongoDB;

# globals or reused
my ($key, $value);
my $now = time;
my (%setid, $setid);
my ($ii, $tt);
my %datakey;
my @datavar;

my $connection = MongoDB::Connection->new( host => 'dbh00.mongolab.com', port => 27007 );
$connection->authenticate( 'smddj1', USER, PASS );
my $database = $connection->smddj1;
my $collection = $database->aidev2;


sub debug {
   DEBUG and print "DEBUG: @_\n";
   DEBUG_SAVE and print STDERR @_,"\n";
}

# more info is available here: http://search.cpan.org/dist/MongoDB/lib/MongoDB/Collection.pm
# or here http://www.mongodb.org/display/DOCS/Advanced+Queries
# TODO - it appears that we can't .group with MongoDB.pm. It's OK. 
my $data       = $collection->find( { }, {'setid' => 1 } );

while (my $ii = $data->next) {
   # debug($ii->{'setid'});
   $setid{$ii->{'setid'}} = 1;
}

foreach (keys %setid) {
   my $data = $collection->find( { 'setid' => $_ });
   $setid = $_;
   while ($ii = $data->next) {
      # debug(Dumper($ii));
      # my $hour = (localtime($ii->{'time'}))[2], "\n";
      $datakey{$setid}{'name'} = $setid;
      $datakey{$setid}{'hour'} = ((localtime($ii->{'time'}))[2] - 3) % 24;
      $datakey{$setid}{$ii->{'operation'}} = $ii->{'value'};
   }   
   # push hash into array
   push (@datavar, $datakey{$setid});
}

# TODO: don't hard code this location
my $write_file = '/Users/djacobs/Desktop/protovis/scratch/stats2.js';
open my ($fh), '>', $write_file or die 'could not open stats file for writing';
print $fh 'var stats = '. encode_json(\@datavar) .';';
close $fh;


__END__ 


# look at _grrrr - the keys of a cursor!
#foreach (keys %$data) { print $_, "\n"; }

/* TODO: iowait status? */

# see  



For right now, focus on the individual commands and scripts. We can reorg the github repost later, the important thing for now is to establish what's easy to get. And then the get-the-data logic is this: 
1) what server am I? ($argv{server-name} ? $argv{server-name} : ($ENV{server-name} ? $ENV{server-name} : FALLBACK ) 
 
2. What time is it? (time -d)
 
3. What am I doing (look in the scripts-enabled directory, foreach ( every script in that directory ) ,eval {script } if $@ elsif { results aren't a single integer complain } else {upload the results to PLACE}
