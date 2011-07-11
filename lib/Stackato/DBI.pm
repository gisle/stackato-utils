package Stackato::DBI;

use strict;
use JSON qw(decode_json);
use Stackato::Services;

sub connect {
    my $class = shift;
    require DBI;
    return DBI->connect($class->credentials, @_);
}

sub credentials {
    my $class = shift;
    my $service = shift;
    if (my $vcap = $ENV{VCAP_SERVICES}) {
	$vcap = decode_json($vcap);

	# Convert to a plain list, instead of hash of lists
	my @services = map @$_, values %$vcap;

	# Find the one to use
	my $selected;
	if ($service) {
	    $selected = Stackato::Services::get_service(\@services, $service)
	        || die "No service named '$service' found"
	}
	else {
	    my @cand = Stackato::Services::filter(\@services, tags => "relational");
	    unless (@cand) {
		die "No DBI supported service found";
	    }
	    $selected = $cand[0];
	}
	die "No service found" unless $selected;

	# Convert to DBI credentials
	my $cred = $selected->{credentials} || die "No credentials given for $selected->{name}";
	my $driver = $selected->{label};
	$driver = "mysql" if $driver =~ /^mysql\b/;
	$driver = "pg" if $driver =~ /^postgresql\b/;

	my $dsn = "dbi:$driver:database=$cred->{name};host=$cred->{hostname};port=$cred->{port}";
	return ($dsn, $cred->{user}, $cred->{password});
    }
    else {
	die "NYI";
    }
}

1;
