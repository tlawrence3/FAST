use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 9;
use Test::Script::Run;

my $test_file = 't/data/faspaste_test.fas';
my $test_file2 = 't/data/faspaste_test2.fas';

open( my $test, "<", $test_file2 ) || die "Can't open $test_file2";
my @output = <$test>;
chomp(@output);
close($test);

my @default_test = @output;
$default_test[0] .= ' comp_A:1 comp_C:1 comp_G:1 comp_T:1';

my @norm_test = @output;
$norm_test[0] .= ' comp_A:0.250 comp_C:0.250 comp_G:0.250 comp_T:0.250';

my @prec_test = @output;
$prec_test[0] .= ' comp_A:0.25 comp_C:0.25 comp_G:0.25 comp_T:0.25';

my @join_test = @output;
$join_test[0] .= ';comp_A:0.25;comp_C:0.25;comp_G:0.25;comp_T:0.25';

my @alph_test = @output;
$alph_test[0] .= ';comp_A:1;comp_C:1';

my @table_test = ('A:1    C:1    G:1    T:1    total:4     gi|00000000|dbj|00000000.0|',
		  'A:1    C:1    G:1    T:1    total:4     # ALL DATA');

my @iupac_test = ('   A   G   C   T   R   Y   S   W   K   M   B   H   D   V   X   N   total',
		  '   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0       4  gi|00000000|dbj|00000000.0|',
		  '   1   1   1   1   0   0   0   0   0   0   0   0   0   0   0   0       4  # ALL DATA');

my @strict_test = ('   A   G   C   T   total',
		   '   1   1   1   1       4  gi|00000000|dbj|00000000.0|',
		   '   1   1   1   1       4  gi|00000000|dbj|00000000.0|',
		   '   1   1   1   1       4  gi|00000000|dbj|00000000.0|',
		   '   1   1   1   1       4  gi|00000000|dbj|00000000.0|',
		   '   4   4   4   4      16  # ALL DATA');

run_not_ok('fascomp', [], 'No input test');

run_output_matches('fascomp', [$test_file2],
		   \@default_test, [], 'Checking default options');

run_output_matches('fascomp', ['-n', $test_file2],
		   \@norm_test, [], 'Checking normalize option');

run_output_matches('fascomp', ['-np2', $test_file2],
		   \@prec_test, [], 'Checking precision option');

run_output_matches('fascomp', ['-j', ';', '-np2', $test_file2],
		   \@join_test, [], 'Checking join option');

run_output_matches('fascomp', ['-a', 'AC', '-j', ';', $test_file2],
		   \@alph_test, [], 'Checking alphabet option');

run_output_matches('fascomp', ['-t', $test_file2],
		   \@table_test, [], 'Checking table option');

run_output_matches('fascomp', ['-it', $test_file2],
		   \@iupac_test, [], 'Checking iupac option');

run_output_matches('fascomp', ['-st', $test_file2, $test_file],
		   \@strict_test, [], 'Checking strict option');
