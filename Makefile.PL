use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'HTTP::RESTful::Server',
    AUTHOR              => q{"Fernando Correa de Oliveira" <"fco@cpan.org">},
    VERSION_FROM        => 'lib/HTTP/RESTful/Server.pm',
    ABSTRACT_FROM       => 'lib/HTTP/RESTful/Server.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'HTTP-RESTful-Server-*' },
);
