use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;
use Test::Script::Run;

run_not_ok('fashead', [], 'No input test');

open( my $test1, "<", "t/data/fashead_tail_test1.fas" ) || die "Can't open fashead_tail_test1.fas"; 
my @output = <$test1>;
chomp(@output);
close($test1);

my @n_test_output = @output[0 .. 3];

my @verbose_test_output = @output[0 .. 3];
$verbose_test_output[0] .= ' fashead_tail_test1.fas';

my @silent_test_output = @output[0 .. 3];
push @silent_test_output, @silent_test_output;

my @def_verbose_test_output = @output[0 .. 3];
push @def_verbose_test_output, @def_verbose_test_output;
$def_verbose_test_output[0] .= ' fashead_tail_test1.fas';
$def_verbose_test_output[4] .= ' fashead_tail_test1.fas';

run_output_matches('fashead', [qw|t/data/fashead_tail_test1.fas|], \@output, [], "Checking output without 'n' specified");
run_output_matches('fashead', [qw|-n 1 t/data/fashead_tail_test1.fas|], \@n_test_output, [], "Checking output with 'n' specified");
run_output_matches('fashead', [qw|-v -n 1 t/data/fashead_tail_test1.fas|], \@verbose_test_output, [], "Checking verbose option");
run_output_matches('fashead', [qw|-Q -n 1 t/data/fashead_tail_test1.fas t/data/fashead_tail_test1.fas|], \@silent_test_output, [], "Checking silent option");
run_output_matches('fashead', [qw|-n 1 t/data/fashead_tail_test1.fas t/data/fashead_tail_test1.fas|], \@def_verbose_test_output, [], "Checking multi-file default verbose option");