use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 4;
use Test::Script::Run;

run_not_ok('faslen', [], 'No input test');
run_ok('faslen', [qw|t/data/P450.fas|], 'Input test');
run_ok('faslen', [qw|t/data/P450.fas t/data/P450.fas|], 'Multiple input test');

open( my $test1, "<", "t/data/faslen_test1.fas" ) || die "Can't open faslen_test1.fas"; 
my @output = <$test1>;
chomp(@output);
run_output_matches('faslen', [qw|t/data/P450.fas|], \@output, [], "Checking lengths are correct");
close($test1);
