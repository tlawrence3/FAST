use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 18;
use Test::Script::Run;

my $test_file = 't/data/fashead_tail_test1.fas';

open( my $test1, "<", $test_file ) || die "Can't open $test_file"; 
my @output = <$test1>;
chomp(@output);
close($test1);

my @temp = undef;

my @range_test1 = @output[0, 1, 4, 5, 8, 9];
$range_test1[1] = 'D';
$range_test1[3] = 'D';
$range_test1[5] = 'D';

my @range_test2 = @range_test1;
$range_test2[1] = 'DTFMFE';
$range_test2[3] = 'DTFMFE';
$range_test2[5] = 'DTFMFE';

my @by_test = @range_test1;
$by_test[1] = 'DFF';
$by_test[3] = 'DFF';
$by_test[5] = 'DFF';

my @neg_test = @range_test1;
$neg_test[1] = 'IGQKFA';
$neg_test[3] = 'IGQKFA';
$neg_test[5] = 'IGQKFA';

my @neg_test2 = @range_test1;
$neg_test2[1] = 'IGQ';
$neg_test2[3] = 'IGQ';
$neg_test2[5] = 'IGQ';

my @neg_by_test = @range_test1;
$neg_by_test[1] = 'AKG';
$neg_by_test[3] = 'AKG';
$neg_by_test[5] = 'AKG';

my @id_test = @output;
$id_test[0] = '>gi|294338405| P450 [Ummeliata insecticeps]';
$id_test[4] = '>gi|294338401| P450 [Ummeliata insecticeps]';
$id_test[8] = '>gi|294338403| P450 [Ummeliata insecticeps]';

my @desc_test = @output;
$desc_test[0] = '>gi|294338405|emb|CBL51706.1| Ummeliata insecticeps';
$desc_test[4] = '>gi|294338401|emb|CBL51704.1| Ummeliata insecticeps';
$desc_test[8] = '>gi|294338403|emb|CBL51705.1| Ummeliata insecticeps';

my @field_test = @output;
$field_test[0] = '>gi|294338405|emb|CBL51706.1| P450';
$field_test[4] = '>gi|294338401|emb|CBL51704.1| P450';
$field_test[8] = '>gi|294338403|emb|CBL51705.1| P450';

my @split_test = @output;
$split_test[0] = '>294338405 P450 [Ummeliata insecticeps]';
$split_test[4] = '>294338401 P450 [Ummeliata insecticeps]';
$split_test[8] = '>294338403 P450 [Ummeliata insecticeps]';

my @join_test = @output;
$join_test[0] = '>294338405|CBL51706.1 P450 [Ummeliata insecticeps]';
$join_test[4] = '>294338401|CBL51704.1 P450 [Ummeliata insecticeps]';
$join_test[8] = '>294338403|CBL51705.1 P450 [Ummeliata insecticeps]';

run_not_ok('fascut', [], 'No input test');
run_not_ok('fascut', [qw|t/data/P450.fas|], 'No index input test');

run_output_matches('fascut', ['1', $test_file],
		   \@range_test1, [], 'Checking range index option');

@temp = @range_test2;
run_output_matches('fascut', ['1:6', $test_file],
		   \@temp, [], 'Checking R style range option');

@temp = @range_test2;
run_output_matches('fascut', ['1-6', $test_file],
		   \@temp, [], 'Checking Unix style range option');

@temp = @range_test2;
run_output_matches('fascut', ['1..6', $test_file],
		   \@temp, [], 'Checking perl style range option');

@temp = @range_test2;
run_output_matches('fascut', ['1,2,3,4,5,6', $test_file],
		   \@temp, [], 'Checking range index option');

@temp = @range_test2;
run_output_matches('fascut', ['1-3,4:6', $test_file],
		   \@temp, [], 'Checking range index option');

run_output_matches('fascut', [':6:2', $test_file],
		   \@by_test, [], 'Checking by range option');

run_output_matches('fascut', ['--', '-6:', $test_file],
		   \@neg_test, [], 'Checking by negative range option');

run_output_matches('fascut', ['--', '-6:-4', $test_file],
		   \@neg_test2, [], 'Checking by negative range option');

run_output_matches('fascut', ['--', '-1:-6:-2', $test_file],
		   \@neg_by_test, [], 'Checking by negative range option');

run_output_matches('fascut', ['-i', '1:13', $test_file],
		   \@id_test, [], 'Checking identifier option');

run_output_matches('fascut', ['-d', '7:27', $test_file],
		   \@desc_test, [], 'Checking description option');

run_output_matches('fascut', ['-f', '-d', '1', $test_file],
		   \@field_test, [], 'Checking field option');

run_output_matches('fascut', ['-i', '-S\|', '2', $test_file],
		   \@split_test, [], 'Checking split option');

run_output_matches('fascut', ['-i', '-S\|', '-j|', '2,4', $test_file],
		   \@join_test, [], 'Checking join option');

run_output_matches('fascut', ['--strict', '1:1000', $test_file], [],
		   ['fascut: Skipped sequence gi|294338405|emb|CBL51706.1| with sequence length 151: indices 1 and/or 1000 out-of-bounds.',
		    'fascut: Skipped sequence gi|294338401|emb|CBL51704.1| with sequence length 151: indices 1 and/or 1000 out-of-bounds.',
		    'fascut: Skipped sequence gi|294338403|emb|CBL51705.1| with sequence length 151: indices 1 and/or 1000 out-of-bounds.'], 
		   'Checking by strict option');
