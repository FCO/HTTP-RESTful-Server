package HTTP::RESTful::Server::ContentType::EncodeChoser;
use Moose;
#use HTTP::RESTful::Server::ContentType::Encoder::YAML;
#use HTTP::RESTful::Server::ContentType::Encoder::JSON;

has encoders => ( is => "ro", isa => "HashRef", auto_deref => 0 );

sub BUILD {
	my $self = shift;
	$self->find_encoders;
	$self;
}

sub find_encoders {
	#print "find_encoders()!$/";
	my $self = shift;
	while ( my ( $key, $value ) =
		each %{*HTTP::RESTful::Server::ContentType::Encoder::} )
	{
		#print "Trying: ($key | $value)$/";
		( my $pack = __PACKAGE__ ) =~ s/::EncodeChoser$//;
		if ( $key =~ /^(\w+)::$/ ) {
			$pack .= "::Encoder::" . $1;
			print $pack, $/;
		}
		my $obj;
		$obj = $pack->new if $pack->can("new");
		next if not $obj or not $obj->can("content_type")
		   or exists $self->{encoders}->{ $obj->content_type };
		$self->{encoders}->{ $obj->content_type } = $obj->new;
	}
	use Data::Dumper;
	print Dumper $self;
}

sub encode {
	use Data::Dumper;
	my $self         = shift;
	my $content_type = shift;
	my $data         = shift;
	print "Asked to encode as \"$content_type\" the data: ", Dumper($data);

	my $encoded = $self->encoders->{$content_type}->encode($data) if keys %{$self->encoders} and exists $self->encoders->{$content_type};
}

sub decode {
	my $self         = shift;
	my $content_type = shift;
	my $data         = shift;

	my $decoded = $self->encoders->{$content_type}->decode($data) if exists $self->encoders->{$content_type};
}

42