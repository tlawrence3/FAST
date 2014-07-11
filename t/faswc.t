use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Test::Script::Run;

run_not_ok('faswc', [], 'No input test');

run_ok('faswc', [qw|t/data/P450.fas|], 'Correct input test');
