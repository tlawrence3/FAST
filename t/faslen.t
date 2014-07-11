use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 3;
use Test::Script::Run;

run_not_ok('faslen', [], 'No input test');
run_ok('faslen', [qw|t/data/P450.fas|], 'Input test');
run_ok('faslen', [qw|t/data/P450.fas t/data/P450.fas|], 'Multiple input test');