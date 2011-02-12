package HTTP::RESTful::Server::Exporter;
use Moose;
use Carp;

use HTTP::RESTful::Server::Fault;

use Attribute::Handlers;

sub __PACKAGE__::Fault :ATTR(CODE) {
   my ($package, $symbol, $referent, $attr, $data) = @_;
   unless(ref $data eq "ARRAY" and @$data == 2) {
   	 croak "Attribute :Fault() MUST receive 2 arguments";
   }
   HTTP::RESTful::Server::Fault->get_instance->add_fault($package, *{$symbol}{NAME}, $data->[0], $data->[1]);
}

no Moose;

42