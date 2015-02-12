use 5.10.1;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

my @scripts = qw/alnpi alncut fascodon fascomp fasconvert fascut fasfilter fasgrep fashead fastail faspaste faslen faswc fasrc fassort fassub fastax fastaxsort fastr fasuniq fasxl gbfalncut gbfcut/;

WriteMakefile(
	      NAME             => 'FAST',
	      AUTHOR           => q{David H. Ardell <dhard@cpan.org>},
	      VERSION_FROM     => 'lib/FAST.pm',
	      ABSTRACT_FROM    => 'lib/FAST.pm',
	      LICENSE          => 'Perl',
	      EXE_FILES => [ map { "bin/$_" } @scripts ],
	      INSTALLMAN3DIR   => 'none',	  	  
	      
	      MIN_PERL_VERSION => 5.10.1,
	      CONFIGURE_REQUIRES => {
				     'ExtUtils::MakeMaker' => 0,
				    },
	      BUILD_REQUIRES => {
	      		     	'Test::More' => 0,
				},
	      PREREQ_PM => {
                            'Pod::Usage' => 0, 
			    'Sort::Key' => 0,
			    'Sort::MergeSort' => 0,
			    'Bit::Vector'   => 0
			    
			   },
	      dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
	      clean => { FILES => 'FAST-*' },
	     );
