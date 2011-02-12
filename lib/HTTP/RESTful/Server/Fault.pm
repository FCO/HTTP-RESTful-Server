package HTTP::RESTful::Server::Fault;
use Moose;
use Carp;

use Attribute::Handlers;

*Fault:: = *HTTP::RESTful::Server::Fault::;

sub BUILD {
	my $self = shift;
	$HTTP::RESTful::Server::Fault::instance ||= $self;
}

sub get_instance {
	$HTTP::RESTful::Server::Fault::instance ||= __PACKAGE__->new
}

has fault => (is => "ro", isa => "HashRef");

has fault_list => (is => "ro", isa => "HashRef");

around qw/fault fault_list add_fault get_fault_msg choose_falut_return_code get_fault_list/ => sub {
	my $orig = shift;
	my $self = shift;
	
	#print $orig, " eq ", \&get_instance, $/;
	if(not ref $self){
		$self->get_instance->$orig(@_);
	} else {
		$self->$orig(@_);
	}
};

sub UNIVERSAL::Fault :ATTR(CODE) {
   my ($package, $symbol, $referent, $attr, $data) = @_;
   unless(ref $data eq "ARRAY" and (@$data == 2 or @$data == 3)) {
   	 croak "Attribute :Fault() MUST receive 2 or 3 arguments";
   }
   HTTP::RESTful::Server::Fault->get_instance->add_fault($package, *{$symbol}{NAME}, $data->[0], $data->[1], $data->[2]);
}

sub add_fault {
	my $self        = shift;
	my $package     = shift;
	my $method      = shift;
	my $code        = shift;
	my $msg         = shift;
	my $return_code = shift;
	
	
	$self->{fault_list}->{$package}->{$method}->{$code}->{msg} = $msg;
	$self->{fault_list}->{$package}->{$method}->{$msg}->{msg}  = $msg;
	if($return_code) {
		$self->{fault_list}->{$package}->{$method}->{$code}->{code} = $return_code;
	    $self->{fault_list}->{$package}->{$method}->{$msg}->{code}  = $return_code;
	}
}

sub get_fault_msg {
	my $self = shift;
	my $package = shift;
	my $method  = shift;
	my $codemsg = shift;
	
	if(
		exists $self->fault_list->{$package}
		and exists $self->fault_list->{$package}->{$method}
		and exists $self->fault_list->{$package}->{$method}->{$codemsg}
		and exists $self->fault_list->{$package}->{$method}->{$codemsg}->{msg}
	) {
		return $self->fault_list->{$package}->{$method}->{$codemsg}->{msg}
	} else {
		return $codemsg
	}
}

sub choose_falut_return_code {
	my $self    = shift;
	my $package = shift;
	my $method  = shift;
	my $codemsg = shift;
	my $default = shift;
	
	if(
		exists $self->fault_list->{$package}
		and exists $self->fault_list->{$package}->{$method}
		and exists $self->fault_list->{$package}->{$method}->{$codemsg}
		and exists $self->fault_list->{$package}->{$method}->{$codemsg}->{code}
	) {
		return $self->fault_list->{$package}->{$method}->{$codemsg}->{code}
	}
}

sub get_fault_list {
	my $self    = shift;
	my $package = shift;
	my $method  = shift;
	
	if(defined $package){
		if(defined $method){
			return $self->fault_list->{$package}->{$method}
		} else {
			return $self->fault_list->{$package}
		}
	} else {
		return $self->fault_list
	}
}
42