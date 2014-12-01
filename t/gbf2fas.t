use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 4;
use Test::Script::Run;

run_not_ok('gbf2fas', 'No input test');

open( my $test1, "<", "t/data/gbf2fas_test.fas" ) || die "Can't open gbf2fas_test.fas"; 
my @output = <$test1>;
chomp(@output);
close($test1);

my @tag_test_output = @output[0..3];

my @case_ins_test_output = @tag_test_output;

my @primary_test_output = @output[5..$#output];


run_output_matches('gbf2fas', [qw|-t note=t[elo]{3}mere t/data/AF194338.1.gb|], \@tag_test_output, [], "Checking tag option");
run_output_matches('gbf2fas', [qw|-i -t note=TELOMERE t/data/AF194338.1.gb|], \@case_ins_test_output, [], "Checking case insensitive option");

run_output_matches('gbf2fas', [qw|-p UTR t/data/AF194338.1.gb|], \@primary_test_output, [], "Checking primary option");
