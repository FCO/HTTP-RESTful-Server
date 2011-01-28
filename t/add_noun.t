#!perl -T

use Test::More tests => 16;

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

$obj->add_noun(my $noun = noun->new);
ok(exists $obj->{nouns}->{noun}, "Obj noun has been added");
ok($obj->{nouns}->{noun}->{obj} eq $noun, "Included the reference");

$obj->add_noun(named_noun => $noun = noun->new);
ok(exists $obj->{nouns}->{named_noun}, "Obj named noun has been added");
ok($obj->{nouns}->{named_noun}->{obj} eq $noun, "Included the reference");

$obj->add_noun($noun = noun::with::verbs->new);
ok(exists $obj->{nouns}->{"noun::with::verbs"}, "Obj noun whith verbs has been added");
ok($obj->{nouns}->{"noun::with::verbs"}->{obj} eq $noun, "Included the reference");
ok(exists $obj->{nouns}->{"noun::with::verbs"}->{verbs}, "Created verbs key");
ok(@{$obj->{nouns}->{"noun::with::verbs"}->{verbs}} == 2, "Created 2 verbs");
is_deeply([sort @{$obj->{nouns}->{"noun::with::verbs"}->{verbs}}], [sort qw/GET PUT/], "2 write verbs");

$obj->add_noun("named noun with verbs" => $noun = noun::with::verbs->new);
ok(exists $obj->{nouns}->{"named noun with verbs"}, "Obj named noun whith verbs has been added");
ok($obj->{nouns}->{"named noun with verbs"}->{obj} eq $noun, "Included the reference");
ok(exists $obj->{nouns}->{"named noun with verbs"}->{verbs}, "Created verbs key");
ok(@{$obj->{nouns}->{"named noun with verbs"}->{verbs}} == 2, "Created 2 verbs");
is_deeply([sort @{$obj->{nouns}->{"named noun with verbs"}->{verbs}}], [sort qw/GET PUT/], "2 write verbs");


