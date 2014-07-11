use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Test::Script::Run;

run_ok('fasrc', [qw|t/data/Dros.fas|], 'Input test');
run_ok('fasrc', [qw|t/data/Dros.fas t/data/Dros.fas|], 'Multiple input test');