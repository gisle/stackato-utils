package Stackato::AppInfo;

use strict;
use base qw(Exporter);

our @EXPORT_OK = qw(dot_stackato);

use JSON ();
use Cwd ();
use File::Basename qw(dirname);

my $DOT_STACKATO = ".stackato.json";

sub dot_stackato {
    if (@_) {
	my $data = shift;
	my $json = JSON::encode_json($data);
	my $filename = $DOT_STACKATO;
	$filename = shift . "/" . $filename if @_;
	open(my $fh, ">", $filename) || die "Can't create '$filename': $!";
	print $fh $json, "\n";
	close($fh) || die "Can't write '$filename': $!";
	return;
    }

    my $dir = Cwd::cwd();
    while (1) {
	my $filename = "$dir/$DOT_STACKATO";
	if (open(my $fh, "<", $filename)) {
	    my $data = JSON::decode_json(do { local $/; scalar <$fh> });
	    $data->{approot} = $dir;
	    $data->{appfile} = $filename;
	    return $data;
	}
	my $pdir = dirname($dir);
	last if $pdir eq $dir;
	$dir = $pdir;
    }

    return undef;
}

1;
