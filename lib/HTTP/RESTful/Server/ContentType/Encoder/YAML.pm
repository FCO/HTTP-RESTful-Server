package HTTP::RESTful::Server::ContentType::Encoder::YAML;
use Moose;
use YAML ();
use HTTP::RESTful::Server::ContentType::Encoder;

extends "HTTP::RESTful::Server::ContentType::Encoder";

has +content_type => ( is => "ro", default => "text/yaml" );

sub encode {
	my $self = shift;
	my $data = shift;
	use Data::Dumper;
	print Dumper($data), "in YAML is$/", YAML::Dump($data);

	return YAML::Dump($data);
}

sub decode {
	my $self = shift;
	my $data = shift;

	return YAML::Load($data);
}

42