use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Test::Script::Run;

run_not_ok('fascut', [], 'No input test');
run_not_ok('fascut', [qw|t/data/P450.fas|], 'No index input test');
