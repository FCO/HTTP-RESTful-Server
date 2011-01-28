#!perl -T

use Test::More tests => 15;

package noun;
sub new{bless {}, shift}
package noun::with::verbs;
sub new{bless {}, shift}
sub GET{"GET"}
sub PUT{"PUT"}

package main;

BEGIN {
    use_ok( 'HTTP::RESTful::Server' ) || print "Bail out!
";
}

my $obj = HTTP::RESTful::Server->new;
is(ref $obj, "HTTP::RESTful::Server", "New created a HTTP::RESTful::Server obj");

$obj->add_noun(named_noun => my $noun = noun->new);
is_deeply([sort $obj->get_nouns], [sort qw/named_noun/]);

$obj->add_noun("named noun" => $noun);
is_deeply([sort $obj->get_nouns], [sort "named_noun", "named noun"]);

$obj->add_noun("-- noun --" => $noun);
is_deeply([sort $obj->get_nouns], [sort "named_noun", "named noun", "-- noun --"]);


for my $new_noun(1 .. 10){
	$obj->add_noun("noun $new_noun" => $noun);
	is_deeply([sort $obj->get_nouns], [sort "named_noun", "named noun", "-- noun --", map {"noun $_"} 1 .. $new_noun]);
}

