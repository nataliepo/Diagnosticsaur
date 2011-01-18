package DiagnosticsaurUtil;

use strict;

use JSON;

use constant CONFIG_FILE => 'config.json';


sub parse_config_file {

   my $filename = CONFIG_FILE;

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


1;