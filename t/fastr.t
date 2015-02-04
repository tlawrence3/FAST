use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 7;
use Test::Script::Run;


my $test_file = 't/data/fastr_test.fas';

#>gi|00000000|dbj|00000000.0| fasstr
#AAAWWUUUCCCGGG---RRRNNN-ZZZ
#>gi|00000000|dbj|00000000.0| tesst
#ACDEFGH--XXNN


open( my $test1, "<", $test_file ) || die "Can't open $test_file"; 
my @output = <$test1>;
chomp(@output);
close($test1);

my @delete_test = @output;
tr/|//d for @delete_test;

my @squash_test = @output;
tr/ //s for @squash_test;

my @comple_test = @output;
tr/A-Z/a-z/ for @comple_test[1,3];

my @strict_test = [];
$strict_test[0] = '>gi|00000000|dbj|00000000.0| fasstr';
$strict_test[1] = 'AAAWWXXXCCCGGG---RRRNNN-XXX';
$strict_test[2] = '>gi|00000000|dbj|00000000.0| tesst';
$strict_test[3] = 'ACDEFGH--XXNN';
my @iupac_test = [];
$iupac_test[0] = '>gi|00000000|dbj|00000000.0| fasstr';
$iupac_test[1] = 'AAAWWXXXCCCGGG---RRRNNN-ZZZ';
$iupac_test[2] = '>gi|00000000|dbj|00000000.0| tesst';
$iupac_test[3] = 'ACDEFGH--XXNN';

my @ambig_test = @strict_test;


run_not_ok('fastr', [], 'No input test');

run_output_matches('fastr', ['-nD', '|', $test_file],
		   \@delete_test, [], 'Checking delete option');

run_output_matches('fastr', ['-nS', 's', $test_file],
		   \@squash_test, [], 'Checking squash option');

run_output_matches('fastr', ['-s', 'A-Z', 'a-z', $test_file],
		   \@comple_test, [], 'Checking complement option');

run_output_matches('fastr', ['--strict', $test_file],
		   \@strict_test, [], 'Checking strict option');

run_output_matches('fastr', ['--iupac', $test_file],
		   \@iupac_test, [], 'Checking iupac option');

run_output_matches('fastr', ['--strict', '-X', 'X', $test_file],
		   \@ambig_test, [], 'Checking ambig option');
