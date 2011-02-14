package HTTP::RESTful::URI::Template;
use Moose;

has template => ( is => "ro", isa => "Str", required => 1 );
has variables => ( is => "ro", isa => "ArrayRef" );
has regex => (is => "ro");

sub BUILD {
	my $self = shift;
	my $regex = "^" if index($self->template, 0, 1) eq "/";
	
}
