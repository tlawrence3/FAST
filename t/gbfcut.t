use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 5;
use Test::Script::Run;

run_not_ok('gbfcut', 'No input test');

open( my $test1, "<", "t/data/gbfcut_test.fas" ) || die "Can't open gbfcut_test.fas"; 
my @output = <$test1>;
chomp(@output);
close($test1);

my @tag_test_output = @output[0..3];

my @case_ins_test_output = @tag_test_output;

my @primary_test_output = @output[5..$#output];

my @location_test_output = @primary_test_output;
$location_test_output[0] .= ' location="21..145"';
$location_test_output[4] .= ' location="4839..4966"';

run_output_matches('gbfcut', [qw|-t note=t[elo]{3}mere t/data/AF194338.1.gb|], \@tag_test_output, [], "Checking tag option");
run_output_matches('gbfcut', [qw|-i -t note=TELOMERE t/data/AF194338.1.gb|], \@case_ins_test_output, [], "Checking case insensitive option");

run_output_matches('gbfcut', [qw|-p UTR t/data/AF194338.1.gb|], \@primary_test_output, [], "Checking primary option");
run_output_matches('gbfcut', [qw|-lp UTR t/data/AF194338.1.gb|], \@location_test_output, [], "Checking location option");
