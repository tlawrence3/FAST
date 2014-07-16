#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 4;
use Test::Script::Run;

my $test_file = 't/data/fasfilter_test.fas';

open( my $test, "<", $test_file ) || die "Can't open $test_file";
my @output = <$test>;
chomp(@output);
close($test);

my @tag_test = @output[-12..-1];
my @negate_test = @output[0..8];

run_not_ok('fasfilter', [], 'No input test');

run_output_matches('fasfilter', ['-t', 'length', '1..200', $test_file],
		   \@tag_test, [], 'Checking tag option');

run_output_matches('fasfilter', ['-vt', 'length', '1..200', $test_file],
		   \@negate_test, [], 'Checking negate option');

run_output_matches('fasfilter', ['-f2', '-S', '|', '294338401..294338406', $test_file],
		   \@negate_test, [], 'Checking split/field option');
