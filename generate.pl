#!/usr/bin/perl

use strict;

use constant DEBUG      => 0;
use constant DEBUG_SAVE => 0;

# libraries
#use Data::Dumper;
#use File::Glob qw(:globally :nocase);
use JSON;
use MongoDB;
use Getopt::Long;



use constant CONFIG_FILE => 'config.json';

#use lib qw( lib );
#use DiagnosticsaurUtil;
my $config_file;

my $result = GetOptions(
   "config=s" => \$config_file,
);

my $config = parse_config_file($config_file);


# globals or reused variables
my ( %setid,      $setid );
my ( $ii,         $tt );
my ( %datakey,    @datavar );
my ( $connection, $database, $collection );


$connection = MongoDB::Connection->new( 
                           host => $config->{'Database_Host'}, 
                           port => $config->{'Database_Port'});
$connection->authenticate( $config->{'Database_Name'}, 
                           $config->{'Database_User'}, 
                           $config->{'Database_Password'} );

my $db_name = $config->{'Database_Name'};
my $coll_name  = $config->{'Collection'};

my $database = $connection->$db_name;
my $collection = $database->$coll_name;

sub debug {
    DEBUG and print "DEBUG: @_\n";
    DEBUG_SAVE and print STDERR @_, "\n";
}

# more info is available here: http://search.cpan.org/dist/MongoDB/lib/MongoDB/Collection.pm
# or here http://www.mongodb.org/display/DOCS/Advanced+Queries
# TODO - it appears that we can't .group with MongoDB.pm. That's OK.
my $data = $collection->find( {}, { 'setid' => 1 } );

while ( my $ii = $data->next ) {

    # debug($ii->{'setid'});
    $setid{ $ii->{'setid'} } = 1;
}

foreach ( keys %setid ) {
    my $data = $collection->find( { 'setid' => $_ } );
    $setid = $_;
    while ( $ii = $data->next ) {

# TODO we only have to do these next 3 things once, it's the op/value thing that we have to loop over.
        $datakey{$setid}{'name'}      = $setid;
        $datakey{$setid}{'server_id'} = $ii->{'server_id'};
        $datakey{$setid}{'hour'} =
          ( localtime( $ii->{'time'} ) )[2] +
          ( ( ( localtime( $ii->{'time'} ) )[1] ) / 60 );
        $datakey{$setid}{ $ii->{'operation'} } = $ii->{'value'};
    }

    # push hash into array
    push( @datavar, $datakey{$setid} );
}

# TODO: don't hard code this location
# HC
my $date = `date +%Y%m%d`;
$date =~ s/\n$//;
my $write_file = $config->{'Output_Path'} . $date . '.js';

open my ($fh), '>', $write_file or 
   die 'could not open stats file \"' . $write_file . '\" for writing';
print $fh 'var stats = ' . encode_json( \@datavar ) . ';';
close $fh;


sub parse_config_file {
   my ($filename) = @_;
   
   $filename = CONFIG_FILE if (!$filename);

   open (INFILE, $filename) or die "Couldn't open config file \"$filename\" for reading.\n";
   
   
   my $line = "";
   my $final_json = "";

   while ($line = <INFILE>) { 
      $final_json .= $line;
   }

   my $obj = decode_json($final_json);

   foreach my $o (keys(%$obj)) {
      # print STDERR "\t obj->{$o} = \"" . $obj->{$o} . "\"\n";
   }

   close (INFILE);
   
   return $obj;
}


__END__ 


# look at _grrrr - the keys of a cursor!
#foreach (keys %$data) { print $_, "\n"; }

/* TODO: iowait status? */

# see  



For right now, focus on the individual commands and scripts. We can reorg the github repost later, the important thing for now is to establish what's easy to get. And then the get-the-data logic is this: 
1) what server am I? ($argv{server-name} ? $argv{server-name} : ($ENV{server-name} ? $ENV{server-name} : FALLBACK ) 
 
2. What time is it? (time -d)
 
3. What am I doing (look in the scripts-enabled directory, foreach ( every script in that directory ) ,eval {script } if $@ elsif { results aren't a single integer complain } else {upload the results to PLACE}
