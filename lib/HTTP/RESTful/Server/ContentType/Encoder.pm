package HTTP::RESTful::Server::ContentType::Encoder;
use Moose;

has content_type => (is => "ro", isa => "ArrayRef", default => sub{ [ qw|text/plan| ] }, auto_deref => 1);

sub encode {
	print __PACKAGE__, ": encode()$/"
}

sub decode {
	print __PACKAGE__, ": decode()$/"
}

42