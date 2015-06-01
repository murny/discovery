#!/usr/bin/perl -w
# Author: 	Neil MacGregor
# Date: 	May 25, 2015
# Purpose: 	A regression testing suite against the Test instance of Discovery
#		At one time, all of these strings caused "500 Internal Server Error"-style crashes
#		Some were due to the Zero Results bug
#		Some were due to a bug in handling punctuation
#		These were inspired by early revisions of mobyTest.pl, which found these class of errors!
# RevisionCntl: 
# Context: 	
# Ideas for improvement:  This should take a parameter that will allow us to run it against either Test or Prod!
use strict;
use WWW::Mechanize;
use Test::More;

my $mech = WWW::Mechanize->new();  				
my $host="search-test.library.ualberta.ca";
$host = $ENV{"TARGETHOSTNAME"}  if defined $ENV{"TARGETHOSTNAME"};
my $url="https://$host";  
my $DEBUG = 0; $DEBUG = $ENV{"DEBUG"} if defined $ENV{"DEBUG"};

$mech->get( $url );    		# Visit the sign_in page
my $searchString;
my @knownBad = ( 	"All the yard-arms",
			"Pusie Hall can",
			"the Guernsey-man to",
			"sports; his slouched",
			"my sire. Leap!",
			"\"Find who?\"",
			"freshets of blood",
			"vibrating his predestinating",
			"domesticated them. Queequeg",
			"sullen paws of",
			"\"Sweet fields beyond",
			"convulsively grasped stout",
			"butts all inquiring",
			"honourable whalemen allowances",
		);
my $count=0;
foreach $searchString (@knownBad) {
	$DEBUG && print "Trying $searchString...\n";
	eval {$mech->submit_form( fields    => { q => $searchString, },);  };
	ok ($mech->status == 200, "$host: Search for $searchString") ;
	$count ++;
}
done_testing $count;