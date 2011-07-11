package Stackato::Services;

use strict;

sub filter {
    my($services, %where) = @_;

    # accept unparsed JSON as $services
    if (!ref($services)) {
	require JSON;
	$services = JSON::decode_json($services);
    }

    # normalize
    my %tags;
    if ($where{tags}) {
	if (ref($where{tags})) {
	    %tags = map {$_ => 1} @{$where{tags}};
	}
	else {
	    $tags{$where{tags}}++;
	}
    }

    my @res;
    for my $s (@$services) {
	next if $where{name}   && $where{name}   ne $s->{name};
	next if $where{type}   && $where{type}   ne $s->{type};
	next if $where{label}  && $where{label}  ne $s->{label};
	next if $where{vendor} && $where{vendor} ne $s->{vendor};

	if (%tags) {
	    my $foundit;
	    for my $tag (@{$s->{tags}}) {
		if ($tags{$tag}) {
		    $foundit++;
		    last;
		}
	    }
	    next unless $foundit;
	}

	push(@res, $s);
    }
    return @res;
}

sub get_service {
    my($services, $name) = @_;
    my @res = filter($services, name => $name);
    die "Assert" if @res > 1;
    return $res[0];
}

1;
