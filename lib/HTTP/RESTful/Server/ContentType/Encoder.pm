package HTTP::RESTful::Server::ContentType::Encoder;
use Moose;

has content_type => (is => "ro", isa => "Str", default => "text/plan");

sub encode {
	print __PACKAGE__, ": encode()$/"
}

sub decode {
	print __PACKAGE__, ": decode()$/"
}

42