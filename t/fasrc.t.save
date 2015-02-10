use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 4;
use Test::Script::Run;

my $test_file = 't/data/fasrc_test.fas';

open( my $test1, "<", $test_file ) || die "Can't open $test_file"; 
my @output = <$test1>;
chomp(@output);
close($test1);

my @nobrand_test = @output;
$nobrand_test[1] = 'CCCCGGGGAAAATTTT';
$nobrand_test[3] = 'ATATCGCGTATAGCGC';

my @brand_test = @nobrand_test;
$brand_test[0] = '>gi|00000000|dbj|00000000.0|-rc fasrc';
$brand_test[2] = '>gi|00000000|dbj|00000000.0|-rc fasrc2';

my @multiple_file_test = @brand_test;
push @multiple_file_test, @brand_test;

run_not_ok('fasrc', [], 'No input test');

run_output_matches('fasrc', ['-n', $test_file],
		   \@nobrand_test, [], 'Checking no brand option');

run_output_matches('fasrc', [$test_file],
		   \@brand_test, [], 'Checking brand option');

run_output_matches('fasrc', [$test_file, $test_file],
		   \@multiple_file_test, [], 'Checking multiple file input option');

