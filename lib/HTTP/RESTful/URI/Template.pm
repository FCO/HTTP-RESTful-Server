package HTTP::RESTful::URI::Template;
use Moose;

has template => ( is => "ro", isa => "Str", required => 1 );
has variables => ( is => "ro", isa => "ArrayRef", default => sub { [] } );
has regex => ( is => "ro" );

sub BUILDARGS {
	my $class = shift;
	my $par   = shift;
	if ( not @_ ) {
		return { template => $par };
	}
	else {
		return { $par => @_ };
	}
}

sub BUILD {
	my $self = shift;
	my $regex;

	$regex = $self->template;
	for my $var ( $self->template =~ m#\{(\w+?)\}#g ) {
		push @{ $self->{variables} }, $var;
		$regex =~ s#(^|/)\{ $var \}#$1(\\w+?)#x;
	}
	$regex =
	  ( substr( $self->template, 0, 1 ) eq "/" ? "^" : "" ) . $regex . '$';
	$self->{regex} = qr{$regex};
}

sub match {
	my $self = shift;
	my $text = shift;

    print "Trying match ($text) over ", $self->regex, " == ", $text =~ $self->regex, $/;
	return 1 if $text =~ $self->regex;
	return;
}

sub get_values_list {
	my $self = shift;
	my $text = shift;
	return unless $self->match($text);
	$text =~ $self->regex;
}

sub get_values {
	my $self = shift;
	my $text = shift;
	my %value;
	my @values = $self->get_values_list;
	@value{ @{ $self->variables } } = @values;
	return { %value }
}
42
