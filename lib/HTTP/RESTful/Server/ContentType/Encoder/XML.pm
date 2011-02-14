package HTTP::RESTful::Server::ContentType::Encoder::XML;
use Moose;
use XML::Simple ();
use HTTP::RESTful::Server::ContentType::Encoder;

extends "HTTP::RESTful::Server::ContentType::Encoder";

has +content_type => ( is => "ro", default => sub{ [ qw|text/xml application/xml| ] } );

sub encode {
	my $self = shift;
	my $data = shift;
	use Data::Dumper;
	print Dumper($data), "in XML is$/", XML::Simple::XMLout($data), $/;

	return XML::Simple::XMLout($data);
}

sub decode {
	my $self = shift;
	my $data = shift;

	return XML::Simple::XMLin($data);
}

42
