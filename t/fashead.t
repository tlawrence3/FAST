use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;
use Test::Script::Run;

run_not_ok('fashead', [], 'No input test');

run_ok('fashead', [qw|t/data/P450.fas|], 'File test');
run_ok('fashead', [qw|-n 3 t/data/P450.fas|], 'Sequence number test');
run_ok('fashead', [qw|-v t/data/P450.fas|], 'Verbose test');

run_ok('fashead', [qw| t/data/P450.fas t/data/P450.fas|], 'Multi-file test');
run_ok('fashead', [qw|-q t/data/P450.fas t/data/P450.fas|], 'Silent test');

open( my $test1, "<", "data/fashead_test1.fas" ) || die "Can't open P450.fas"; 
my @output = <$test1>;
chomp(@output);
run_output_matches('fashead', [qw|data/fashead_test1.fas|], \@output, [], "Checking output without 'n' specified");
close($test1);

open( my $test2, "<", "data/fashead_test1.fas" ) || die "Can't open P450.fas"; 
@output = <$test2>;
chomp(@output);
@output = @output[0 .. 3];
run_output_matches('fashead', [qw|-n 1 data/fashead_test1.fas|], \@output, [], "Checking output with 'n' specified");
close($test2);

open( my $test3, "<", "data/fashead_test1.fas" ) || die "Can't open P450.fas"; 
@output = <$test3>;
chomp(@output);
@output = @output[0 .. 3];
$output[0] .= ' fashead_test1.fas';
run_output_matches('fashead', [qw|-v -n 1 data/fashead_test1.fas|], \@output, [], "Checking verbose option");
close($test3);

open( my $test4, "<", "data/fashead_test1.fas" ) || die "Can't open P450.fas"; 
@output = <$test4>;
chomp(@output);
@output = @output[0 .. 3];
$output[0] .= ' fashead_test1.fas';
push @output, @output;
run_output_matches('fashead', [qw|-n 1 data/fashead_test1.fas data/fashead_test1.fas|], \@output, [], "Checking multi-file default verbose option");
close($test4);

open( my $test5, "<", "data/fashead_test1.fas" ) || die "Can't open P450.fas"; 
@output = <$test5>;
chomp(@output);
@output = @output[0 .. 3];
push @output, @output;
run_output_matches('fashead', [qw|-q -n 1 data/fashead_test1.fas data/fashead_test1.fas|], \@output, [], "Checking multi-file silent option");
close($test5);