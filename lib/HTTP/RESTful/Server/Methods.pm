package HTTP::RESTful::Server::Methods;
use Moose;
use Carp;

use Attribute::Handlers;

sub BUILD {
	my $self = shift;
	$HTTP::RESTful::Server::Methods::instance ||= $self;
}

sub get_instance {
	$HTTP::RESTful::Server::Methods::instance ||= __PACKAGE__->new
}

has fault => (is => "ro", isa => "HashRef");

has fault_list => (is => "ro", isa => "HashRef");

#around qw// => sub {
#	my $orig = shift;
#	my $self = shift;
#	
#	#print $orig, " eq ", \&get_instance, $/;
#	if(not ref $self){
#		$self->get_instance->$orig(@_);
#	} else {
#		$self->$orig(@_);
#	}
#};

sub UNIVERSAL::GET :ATTR(CODE) {
   my ($package, $symbol, $referent, $attr, $data) = @_;
   HTTP::RESTful::Server::Methods->get_instance->add_get_method($package, *{$symbol}{CODE}, $data);
}

sub add_get_method {
	my $self     = shift;
	my $package  = shift;
	my $code_ref = shift;
	my $data     = shift;
	
	my @data = ref $data eq "ARRAY" ? @$data : ($data);
	### TODO: Em $data deve ter 1 único valor, uma string representando um URI::Template
	croak ":GET() must receive only 1 string" if @data != 1;
}


42