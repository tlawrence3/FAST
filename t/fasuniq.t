use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 18;
use Test::Script::Run;

open( my $test1, "<", "t/data/fasuniq_test1.fas" ) || die "Can't open fasuniq_test1.fas"; #fasuniq_test1.fas
my @output = <$test1>;
chomp(@output);
run_output_matches('fasuniq', [qw|t/data/P450.fas|], \@output, [], "Failed to remove repetitive sequences");
close($test1);

open( my $test2, "<", "t/data/fasuniq_test2.fas" ) || die "Can't open fasuniq_test2.fas"; #fasuniq_test2.fas
@output = <$test2>;
chomp(@output);
run_output_matches('fasuniq', [qw|-D t/data/P450.fas|], \@output, [], "Failed to remove sequences with repetitive descriptions");
close($test2);

open( my $test3, "<", "t/data/fasuniq_test3.fas" ) || die "Can't open fasuniq_test3.fas"; #fasuniq_test3.fas
@output = <$test3>;
chomp(@output);
run_output_matches('fasuniq', [qw|-I t/data/P450.fas|], \@output, [], "Failed to remove sequences with repetitive IDs");
close($test3);

open( my $test4, "<", "t/data/fasuniq_test4.fas" ) || die "Can't open fasuniq_test4.fas"; #fasuniq_test4.fas
@output = <$test4>;
chomp(@output);
run_output_matches('fasuniq', [qw|-Icd":" t/data/P450.fas|], \@output, [], "Failed to remove (and append IDs) sequences with repetitive IDs");
close($test4);

####For some reason this run_output_matches doesn't process the -d":" correctly and needs to be -d:
open( my $test5, "<", "t/data/fasuniq_test5.fas" ) || die "Can't open fasuniq_test5.fas"; #fasuniq_test5.fas
@output = <$test5>;
chomp(@output);
run_output_matches('fasuniq', [qw|-Dcd: t/data/P450.fas|], \@output, [], "Failed to remove (and append IDs) sequences with repetitive descriptions");
close($test5);

open( my $test6, "<", "t/data/fasuniq_test6.fas" ) || die "Can't open fasuniq_test6.fas"; #fasuniq_test6.fas
@output = <$test6>;
chomp(@output);
run_output_matches('fasuniq', [qw|-cd":" t/data/P450.fas|], \@output, [], "Failed to remove (and append IDs) repetitive sequences");
close($test6);

run_ok('fasuniq',[qw|t/data/P450.fas|]);
run_ok('fasuniq',[qw|-D t/data/P450.fas|]);
run_ok('fasuniq',[qw|-I t/data/P450.fas|]);
run_ok('fasuniq',[qw|-Icd":" t/data/P450.fas|]);
run_ok('fasuniq',[qw|-Dcd":" t/data/P450.fas|]);
run_ok('fasuniq',[qw|-cd":" t/data/P450.fas|]);

run_not_ok('fassort', [qw|-cd"" t/data/P450.fas|],"fail if delimter is empty");
run_not_ok('fassort', [qw|-Dcd"" t/data/P450.fas|],"fail if delimter is empty");
run_not_ok('fassort', [qw|-Icd"" t/data/P450.fas|],"fail if delimter is empty");
run_not_ok('fassort', [qw|-c t/data/P450.fas|],"fail if delimter is not specified");
run_not_ok('fassort', [qw|-Ic t/data/P450.fas|],"fail if delimter is not specified");
run_not_ok('fassort', [qw|-Dc t/data/P450.fas|],"fail if delimter is not specified");
