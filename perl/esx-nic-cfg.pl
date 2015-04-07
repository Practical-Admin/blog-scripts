#!/usr/bin/perl -w
#
# esx-nic-cfg.pl - written by Andrew Sullivan, 2009-04-08
#
# Please report bugs and request improvements at 
#  http://practical-admin.com/blog/perl-toolkit-pnic-to-vswitch-information/
#
# Simple perl script to display some basic info about physical nics on an esx host
#
# Examples:
#   Connecting directly to the esx host
#   ./esx-nic-cfg.pl --server your.esx.host
#
#   Connecting via vCenter
#   ./esx-nic-cfg.pl --server your.vCenter.server --vihost your.esx.host
#
 
use strict;
use warnings;
 
use FindBin;
use lib "$FindBin::Bin/../";
 
use VMware::VIRuntime;
 
my %opts = (
	'vihost' => {
		type => "=s",
		help => "The name of the ESX host to interrogate, not required if connecting "
			  . "directly to the ESX host",
		required => 0
	}
);
 
Opts::add_options(%opts);
Opts::parse();
Opts::validate();
 
Util::connect();
 
my $vihost;
my $host;
 
if (Opts::option_is_set('vihost') && Opts::get_option('vihost') ne "") {
	$vihost = Opts::get_option('vihost');
} else {
	$vihost = Opts::get_option('server');
}
 
eval {
	$host = Vim::find_entity_view(
		view_type => 'HostSystem',
		filter => { 'name' => qr/($vihost)/i }
	);
};
 
if ($@) {
	Util::trace(0, "Host not found or host name ambiguous");
	Util::trace(0, $@);
	Util::disconnect;
	exit;
}
 
my $networkSystem = Vim::get_view(mo_ref => $host->configManager->networkSystem);
 
my $vswitches = $networkSystem->networkInfo->vswitch;
my $pnics = $networkSystem->networkInfo->pnic;
 
# get the map of pnics to vswitches, we use this later to display the vswitch a pnic
# is connected to
my %pnic_to_vswitch = ();
foreach my $vswitch (@$vswitches) {
	if (scalar(@{$vswitch->pnic}) > 0) {
		foreach (@{$vswitch->pnic}) {
			$pnic_to_vswitch{$_} = $vswitch->name;
		}
	}
}
 
# a header, to make it more readable
print "Adaptor (Driver)tSpeed (Duplex)ttMACtttvSwitchn";
print "----------------t--------------tt---ttt-------n";
 
foreach (@$pnics) {
	print $_->device . " (" . $_->driver . ")" . "tt"
		. $_->linkSpeed->speedMb . " (" . ($_->linkSpeed->duplex eq "1" ? "Full" : "Half") . ")tt"
		. $_->mac . "t"
		. $pnic_to_vswitch{$_->key} . "n";
}
 
Util::disconnect();