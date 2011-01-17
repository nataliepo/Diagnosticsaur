#!/usr/bin/perl

use strict;

use constant SERVER     => 'AIdev';
use constant SERVER_ID  => '1';
use constant DEBUG      => 0;
use constant DEBUG_SAVE => 0;

use constant USER => 'xxxx';
use constant PASS => 'xxxx';

# libraries
use Data::Dumper;
use File::Glob qw(:globally :nocase);
use JSON;
use MongoDB;

# globals or reused
my ( $key, $value );
my $now = time;
my $setid = join( '.', $now, SERVER, int( rand() * 100000 ) );

debug($setid);

#my @scripts = <SDIR>;
# TODO - script locations should not be hardcoded
# HC
my @scripts = </home/djacobs/diagnosticsaur/run/*>;

# TODO - decide on a consistent naming convention for databases
my $connection =
  MongoDB::Connection->new( host => 'dbh00.mongolab.com', port => 27007 );
$connection->authenticate( 'smddj1', 'USER', 'PASS' );

# TODO - db & collection names should not be hard coded
#Serious Eats Metrics Dev David Jacobs 1 / AI dev 1
# moved to AI dev 2 1/14
my $database   = $connection->smddj1;
my $collection = $database->aidev2;

sub debug {
    DEBUG and print "DEBUG: @_\n";
    DEBUG_SAVE and print STDERR @_, "\n";
}

foreach $key (@scripts) {
    $now   = time;
    $value = `$key`;

    chomp($value);

    debug( join( ':', $key, $value, $now, SERVER ) );

    # TODO make sure the result makes sense (integer, no newline) (\d+)

    my @script = split( '/', $key );

    my $id = $collection->insert(
        {
            'operation' => $script[-1],
            'value'     => $value,
            'time'      => $now,
            'server'    => SERVER,
            'fullpath'  => $key,
            'setid'     => $setid,
            'server_id' => SERVER_ID,
        }
    );
    debug( "id, ", $id );
}

__END__ 

#my $id         = $collection->insert( { httpd => 'six' } );
#my $id         = $collection->insert( @a );

# more info is available here: http://search.cpan.org/dist/MongoDB/lib/MongoDB/Collection.pm#find($query)
my $data       = $collection->find( { 'server' => SERVER } );

# look at _grrrr - the keys of a cursor!
#foreach (keys %$data) { print $_, "\n"; }

while (my $ii = $data->next) {
   #debug(Dumper($ii));
   #print $ii->{'operation'}, "\n";
   debug(join(',', $ii->{'operation'}, $ii->{'value'}, $ii->{'time'}));
}




For right now, focus on the individual commands and scripts. We can reorg the github repost later, the important thing for now is to establish what's easy to get. And then the get-the-data logic is this: 
1) what server am I? ($argv{server-name} ? $argv{server-name} : ($ENV{server-name} ? $ENV{server-name} : FALLBACK ) 
 
2. What time is it? (time -d)
 
3. What am I doing (look in the scripts-enabled directory, foreach ( every script in that directory ) ,eval {script } if $@ elsif { results aren't a single integer complain } else {upload the results to PLACE}
