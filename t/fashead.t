use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;
use Test::Script::Run;

run_not_ok('fashead', [], 'No input test');

run_ok('fashead', [qw|t/data/P450.fas|], 'File test');
run_ok('fashead', [qw|-n 3 t/data/P450.fas|], 'Sequence number test');
run_ok('fashead', [qw|-v t/data/P450.fas|], 'Verbose test');

run_ok('fashead', [qw| t/data/P450.fas t/data/P450.fas|], 'Multi-file test');
run_ok('fashead', [qw|-q t/data/P450.fas t/data/P450.fas|], 'Silent test');