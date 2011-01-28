package HTTP::RESTful::Server;

use HTTP::Daemon;
use HTTP::Status;
use HTTP::Response;
use HTTP::Headers;
use Moose;
use Carp;
use YAML ();

$| = 1;


has "verb_return_code" => (is => "ro", isa => "HashRef", default => sub {
             {
             	GET      => 200,    POST      => 200,
                PUT      => 201,    DELETE    => 204,
                HEAD     => 204,    TRACE     => 200,
                PROPFIND => 200,    PROPPATCH => 200,
                MKCOL    => 200,    COPY      => 200,
                MOVE     => 200,    LOCK      => 204,
                UNLOCK   => 204,    get_verbs => 200,
             }
});

has server => (is => "ro", isa => "HTTP::Daemon", default => sub{HTTP::Daemon->new(LocalPort => 8080) || croak "Could not create socket"});
has nouns  => (is => "ro", isa => "HashRef", default => sub{{}});

=head1 NAME

HTTP::RESTful::Server - Write RESTful servers eazy!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use HTTP::RESTful::Server;
         
    package Teste;
    sub new {
       bless {}, shift
    }
    sub GET {
       shift();
       return "Teste 123: " . shift();
    }

    sub POST {
       shift();
       "Teste por POST: " . shift()
    }

    package Lalala;
    sub new {
       bless {}, shift
    }
    sub GET {
       shift();
       {"Lalala"  => "lelele"}
    }

    sub POST {
       shift();
       "Lalala por POST: " . shift()
    }

    package ERROR;
    sub new {
       bless {}, shift
    }
    sub GET {
       shift();
       die "Errando Propositalmente: " . shift()
    }

    package main;
    $a = HTTP::RESTful::Server->new;
    $a->add_noun(teste => Teste->new);
    $a->add_noun(Lalala->new);
    $a->add_noun(error => ERROR->new);
    $a->run


=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS

=head2 run

Parameters: no parameters
Return: the self object
   
It runs the server

=cut

sub run {
   my $self = shift;
   print "Please contact me at: <URL:", $self->server->url, ">\n";
   while (my $client = $self->server->accept) {
       while (my $r = $client->get_request) {
           my $content = YAML::Load($r->content);
           my $try_noun = "NOUNS";
           $try_noun = $1 if $r->uri->path =~ m{/(.+)(?:/|$)};
           print "Try noun: $try_noun$/" if defined $try_noun;
           my $exec_obj;
           if(defined $try_noun and exists $self->nouns->{$try_noun}) {
              $exec_obj = $self->nouns->{$try_noun}->{obj}
           } else {
              $exec_obj = $self;
           }
           if(defined $exec_obj) {
               my $verb = "get_verbs";
               $verb = $r->method unless $exec_obj eq $self;
               print "Executing noun $try_noun$/";
               if(grep {$_ eq $verb} keys %{$self->verb_return_code} and $exec_obj->can($verb)) {
                  print "Defining Content-Type$/";
                  my $header = HTTP::Headers->new;
                  $header->header("Content-Type" => "text/plain");
                  print "Executing method $verb$/";
                  my $return = YAML::Dump(eval { [ $exec_obj->$verb(@$content) ] });
                  if(not $@) {
                     my $response = HTTP::Response->new($self->verb_return_code->{$verb}, undef, $header, $return);
                     $client->send_response($response);
                  } else {
                     $client->send_error(500, $@);
                  }
               } else {
                  $client->send_error(405);
               }
           } else {
               $client->send_error(404);
           }
       }
       $client->close;
       undef($client);
   }
   $self
}

=head2 add_noun

Parameters: name and object or just a object
Return: the self object

=cut

sub add_noun {
   my $self = shift;
   my $noun;
   if(defined $_[1]) {
      $noun = shift;
   } else {
      $noun = ref $_[0];
   }
   my $nouns = $self->nouns;
   my $obj = $nouns->{$noun}->{obj} = shift;
   for my $verb (keys %{$self->verb_return_code}) {
      push @{$nouns->{$noun}->{verbs}}, $verb if $obj->can($verb)
   }
   $self
}

=head2 get_nouns

Parameters: no parameters
Return: a list of all nouns names

=cut

sub get_nouns {
   my $self = shift;
   my $nouns = $self->nouns;
   keys %$nouns if ref $nouns eq "HASH"
}

=head2 get_verbs

Parameters: none or a noun name
Return: a hash_ref with all nouns verbs

=cut

sub get_verbs {
   my $self = shift;
   my $noun = shift;
   my $nouns = $self->nouns;
   $nouns = {$noun => $nouns->{$noun}} if defined $noun;
   if(ref $nouns eq "HASH") {
      return {map {($_ => $nouns->{$_}->{verbs})} keys %$nouns}
   }
}

42

__END__

=head1 AUTHOR

"Fernando Correa de Oliveira", C<< <"fco at cpan.org"> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-http-restful-server at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=HTTP-RESTful-Server>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc HTTP::RESTful::Server


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=HTTP-RESTful-Server>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/HTTP-RESTful-Server>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/HTTP-RESTful-Server>

=item * Search CPAN

L<http://search.cpan.org/dist/HTTP-RESTful-Server/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2011 "Fernando Correa de Oliveira".

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut
