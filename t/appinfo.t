#!perl -w

use strict;
use Test;
plan tests => 2;

use Stackato::AppInfo qw(dot_stackato);

dot_stackato({appname => "tut3", foo => 1});
my $info = dot_stackato();
ok($info->{appname}, "tut3");
ok(unlink($info->{appfile}));
