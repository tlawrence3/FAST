use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 18;
use Test::Script::Run;

run_not_ok('faspaste', 'expects at least one input filename or glob');

run_ok('faspaste', [qw|t/data/faspaste_test.fas|], 'test');
run_ok('faspaste', [qw|-s t/data/faspaste_test.fas|], 'test serial description');
run_ok('faspaste', [qw|t/data/faspaste_test.fas t/data/faspaste_test2.fas|], 'ATGCATGC');
run_ok('faspaste', [qw|--delimiter='_' t/data/faspaste_test.fas t/data/faspaste_test2.fas|], 'test_delimiter');
run_ok('faspaste', [qw|t/data/faspaste_test.fas -|], 'Could not find any input on STDIN. Skipping.');
run_ok('faspaste', [qw|--join=T t/data/faspaste_test.fas t/data/faspaste_test2.fas|], 'ATGCTATGC');
