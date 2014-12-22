use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 3;
use Test::Script::Run;

run_not_ok('fashead', [], 'No input test');

open( my $test1, "<", "t/data/fashead_tail_test1.fas" ) || die "Can't open faslen_tail_test1.fas"; 
my @output = <$test1>;
close($test1);
chomp(@output);

my @n_test_output = @output[-4 .. -1];

my @verbose_test_output = @output[-4 .. -1];
$verbose_test_output[0] .= ' fashead_tail_test1.fas';

my @silent_test_output = @output[-4 .. -1];
push @silent_test_output, @silent_test_output;

run_output_matches('fastail', [qw|t/data/fashead_tail_test1.fas|], \@output, [], "Checking output without 'n' specified");
run_output_matches('fastail', [qw|-n 1 t/data/fashead_tail_test1.fas|], \@n_test_output, [], "Checking output with 'n' specified");
