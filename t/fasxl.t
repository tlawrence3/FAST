use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Test::Script::Run;

run_not_ok('fasxl', [], 'No input test');

run_ok('fasxl', [qw|t/data/Dros.fas|], 'Correct input test');
