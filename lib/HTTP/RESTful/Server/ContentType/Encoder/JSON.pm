package HTTP::RESTful::Server::ContentType::Encoder::JSON;
use Moose;
use JSON ();
use HTTP::RESTful::Server::ContentType::Encoder;

extends "HTTP::RESTful::Server::ContentType::Encoder";

has +content_type => ( is => "ro", default => sub{ [ qw|text/json application/json| ] } );

sub encode {
	my $self = shift;
	my $data = shift;
	use Data::Dumper;
	print Dumper($data), "in JSON is$/", JSON::encode_json($data), $/;

	return JSON::encode_json($data);
}

sub decode {
	my $self = shift;
	my $data = shift;

	return JSON::decode_json($data);
}

42