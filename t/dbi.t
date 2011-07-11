#!perl -w

use strict;

BEGIN {
    $ENV{VCAP_SERVICES}='{"mysql-5.1":[{"name":"mysql-ad3d1","label":"mysql-5.1","plan":"free","tags":["mysql","mysql-5.1","relational"],"credentials":{"node_id":"mysql_node_1","hostname":"127.0.0.1","port":3306,"password":"pLciNE6donyPM","name":"da88bc1216972477a84cb653ab164495d","user":"uhCNWldTvLmyL"}},{"name":"xx2","label":"mysql-5.1","plan":"free","tags":["mysql","mysql-5.1","relational"],"credentials":{"node_id":"mysql_node_1","hostname":"127.0.0.1","port":3306,"password":"pftr3azRh0dUg","name":"d4f9291f55f7c4b558fae00e0fcd1bc9e","user":"utODG6N0ryZVL"}}],"redis-2.2":[{"name":"redis-e84dc","label":"redis-2.2","plan":"free","tags":["redis","redis-2.2","key-value","nosql"],"credentials":{"node_id":"redis_node_1","hostname":"127.0.0.1","port":5000,"password":"1eafdf35-4b41-49ce-9ee0-3b3e388c94e4","name":"redis-5d819500-128e-4f83-bef8-47c21ab848ac"}}]}';
}

use Test;
plan tests => 6;

use Stackato::DBI;

my($dsn, $user, $pass) = Stackato::DBI->credentials;
ok($dsn, "dbi:mysql:database=da88bc1216972477a84cb653ab164495d;host=127.0.0.1;port=3306");
ok($user, "uhCNWldTvLmyL");
ok($pass, "pLciNE6donyPM");

($dsn, $user, $pass) = Stackato::DBI->credentials("xx2");
ok($dsn, "dbi:mysql:database=d4f9291f55f7c4b558fae00e0fcd1bc9e;host=127.0.0.1;port=3306");
ok($user, "utODG6N0ryZVL");
ok($pass, "pftr3azRh0dUg");
