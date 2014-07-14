use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Test::Script::Run;

run_not_ok('fastr', [], 'No input test');

run_ok('fastr', [qw|-n 'A' t/data/P450.fas|], 'Correct input test');
