use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

#my @scripts = qw/alndegap alnpi alnseg fascodon fascomp fasconvert fascut fasfilter fasgrep faslen fasposcomp fasrc fasstrict fassub fastr fasuniq fasxl gbf2fas gbfcut gbfgrep/;
my @scripts = qw/alndegap alnpi alnseg fascodon fascomp fasconvert fascut
fasfilter fasgrep faslen fasposcomp fasrc fassub fastr fasuniq
fasxl fassort fastaxsort gbfeat2fas gbalncut gbgrep/;

WriteMakefile(
    NAME             => 'FAST',
    AUTHOR           => q{David H. Ardell <dhard@cpan.org>},
    VERSION_FROM     => 'lib/FAST.pm',
    ABSTRACT_FROM    => 'lib/FAST.pm',
    LICENSE          => 'Perl',
    EXE_FILES => [ map { "bin/$_" } @scripts ],
    INSTALLMAN3DIR   => 'none',	  	  

    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'GetOpt::Long'           => 2.32,
        #'Foo::Bar::Module' => 5.0401,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'FAST-*' },
);
