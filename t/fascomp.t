use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Test::Script::Run;

run_not_ok('fascomp', [], 'No input test');
run_ok('fascomp', [qw|t/data/P450.fas|], 'Input test');