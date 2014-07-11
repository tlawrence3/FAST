use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Test::Script::Run;

run_not_ok('fasconvert', [], 'No input test');

# Need way to put file onto stdin for fasconvert to work properly
#run_ok('fasconvert', [qw|-i genbank t/data/AF194338.1.gb|], 'Correct input test');
