package HTTP::RESTful::Server::Methods;
use Moose;

use Attribute::Handlers;
use HTTP::RESTful::URI::Template;

has methods => ( is => "ro", isa => "HashRef" );
around add_method => sub {
	my $orig = shift;
	my $self = shift;

	if ( ref $self eq __PACKAGE__ ) {
		return $self->$orig(@_);
	}
	else {
		return __PACKAGE__->get_instance->$orig(@_);
	}
};

sub UNIVERSAL::GET : ATTR(CODE) {
	my ( $package, $symbol, $referent, $attr, $data ) = @_;
	__PACKAGE__->get_instance->add_method( "GET", $package, $referent, $data );
}

sub UNIVERSAL::PUT : ATTR(CODE) {
	my ( $package, $symbol, $referent, $attr, $data ) = @_;
	__PACKAGE__->get_instance->add_method( "PUT", $package, $referent, $data );
}

sub UNIVERSAL::POST : ATTR(CODE) {
	my ( $package, $symbol, $referent, $attr, $data ) = @_;
	__PACKAGE__->get_instance->add_method( "POST", $package, $referent, $data );
}

sub UNIVERSAL::DELETE : ATTR(CODE) {
	my ( $package, $symbol, $referent, $attr, $data ) = @_;
	__PACKAGE__->get_instance->add_method( "DELETE", $package, $referent,
		$data );
}

sub UNIVERSAL::METHOD : ATTR(CODE) {
	my ( $package, $symbol, $referent, $attr, $data ) = @_;
	my @data = ref $data eq "ARRAY" ? @$data : ($data);
	__PACKAGE__->get_instance->add_method( shift @data, $package, $referent,
		\@data );
}

sub add_method {
	my $self    = shift;
	my $method  = shift;
	my $package = shift;
	my $ref     = shift;
	my $data    = shift;

	my @data = ref $data eq "ARRAY" ? @$data : ($data);

	print
qq|adding method "$method" for package "$package" with code "$ref" and URI::Template "@data"$/|;

    my $path = shift @data;
    
	push @{ $self->{methods}->{$method}->{$package} },
	  {
		meth => $ref,
		$path ? ( template => HTTP::RESTful::URI::Template->new( $path ) ) : ()
	  };
}

sub get_method {
	my $self    = shift;
	my $package = shift;
	my $req     = shift;

	for ( @{ $self->methods->{ $req->method }->{$package} || [] } ) {
		print "Trying method $_$/";
		if ( not exists $_->{template} or $_->{template}->match( $req->uri->path ) )
		{
			return $_;
		}
	}
	return;
}

sub run_method {
	my $self = shift;
	my $obj = shift;
	my $req = shift;
	
	my $method = $self->get_method(ref $obj, $req);
	my $meth = $method->{meth};
	$obj->$meth($method->{template}->get_values_list($req->uri->path));
}

sub get_instance {
	$__PACKAGE__::instance ||= __PACKAGE__->new;
}

sub BUILD {
	$__PACKAGE__::instance = shift;
}

42
