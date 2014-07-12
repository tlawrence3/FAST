use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 9;
use Test::Script::Run;

run_not_ok('faspaste', 'No input test');

open( my $test1, "<", "t/data/faspaste_test.fas" ) || die "Can't open faspaste_test.fas"; 
my @output = <$test1>;
chomp(@output);
close($test1);

my @combined_test_output = @output;
$combined_test_output[1] .= 'ATGC';

my @combined_test_output2 = @output;
$combined_test_output2[1] .= $combined_test_output2[1];
$combined_test_output2[3] .= $combined_test_output2[3];
$combined_test_output2[5] .= $combined_test_output2[5];

my @serial_test_output = @output;
$serial_test_output[1] .= $serial_test_output[3] . $serial_test_output[5];
@serial_test_output = @serial_test_output[0..1];

my @serial_test_output2 = @serial_test_output;
push @serial_test_output2, @serial_test_output2;

my @delimiter_test_output = @serial_test_output;
$delimiter_test_output[0] .= ' serial description';

my @delimiter_test_output2 = @serial_test_output;
$delimiter_test_output2[0] .= '-serial_description';

my @join_test_output = @output;
$join_test_output[1] .= 'O' . $join_test_output[3] . 'P' . $join_test_output[5];
@join_test_output = @join_test_output[0..1];


run_output_matches('faspaste', [qw|t/data/faspaste_test.fas|], \@output, [], "Checking single file output");
run_output_matches('faspaste', [qw|t/data/faspaste_test.fas t/data/faspaste_test2.fas|], \@combined_test_output, [], "Checking multi-file output");
run_output_matches('faspaste', [qw|t/data/faspaste_test.fas t/data/faspaste_test.fas|], \@combined_test_output2, [], "Checking multi-file output again");

run_output_matches('faspaste', [qw|-s t/data/faspaste_test.fas|], \@serial_test_output, [], "Checking serial option");
run_output_matches('faspaste', [qw|-s t/data/faspaste_test.fas t/data/faspaste_test.fas|], \@serial_test_output2, [], "Checking multi-file serial option");

run_output_matches('faspaste', [qw|-d -s t/data/faspaste_test.fas|], \@delimiter_test_output, [], "Checking delimiter option");
run_output_matches('faspaste', [qw|--delimiter=-_ -s t/data/faspaste_test.fas|], \@delimiter_test_output2, [], "Checking custom delimiter option");

run_output_matches('faspaste', [qw|--join=OP -s t/data/faspaste_test.fas|], \@join_test_output, [], "Checking join option");
