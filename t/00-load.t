#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'HTTP::RESTful::Server' ) || print "Bail out!
";
}

diag( "Testing HTTP::RESTful::Server $HTTP::RESTful::Server::VERSION, Perl $], $^X" );
