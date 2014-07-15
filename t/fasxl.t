use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 13;
use Test::Script::Run;

my $test_file = 't/data/fasxl_test.fas';
my $test_file2 = 't/data/fasxl_test2.fas';
my $test_file3 = 't/data/fasxl_test3.fas';
my $test_file4 = 't/data/fasxl_test4.fas';
my $test_file5 = 't/data/fasxl_test5.fas';

open( my $test1, "<", $test_file ) || die "Can't open $test_file"; 
my @output = <$test1>;
chomp(@output);
close($test1);

open( my $test2, "<", $test_file2 ) || die "Can't open $test_file2"; 
my @frame_test = <$test2>;
chomp(@frame_test);
close($test2);

open( my $test3, "<", $test_file4 ) || die "Can't open $test_file4"; 
my @gapkeep_test = <$test3>;
chomp(@gapkeep_test);
close($test3);

my @annotate_test = @output;
$annotate_test[0] .= '  xl0:KYLE';
$annotate_test[2] .= '  xl0:XIFG';

my @gap_test = @gapkeep_test[0..3];
my @keep_test = @gapkeep_test[4..11];

my @join_test = @output;
$join_test[0] .= ' _xl0:KYLE';
$join_test[2] .= ' _xl0:XIFG';

my @frame0_test = @frame_test[0..3];
my @frame1_test = @frame_test[4..7];
my @frame2_test = @frame_test[8..11];

my @table_test = ('>gi|00000000|dbj|00000000.0|-xl0',
		  'KYLER*');

my @table_test2 = ('>gi|00000000|dbj|00000000.0|-xl0',
		   'KYLE**');

my @stop_test = ('>gi|00000000|dbj|00000000.0|-xl0',
		  'KYLER-');

my @frame3_test = ();
push @frame3_test, @frame_test[0..1];
push @frame3_test, @frame_test[4..5];
push @frame3_test, @frame_test[8..9];
push @frame3_test, @frame_test[2..3];
push @frame3_test, @frame_test[6..7];
push @frame3_test, @frame_test[10..11];

my @frame6_test = @frame3_test[0..5];

push @frame6_test, ('>gi|00000000|dbj|00000000.0|-rc-xl0', 'LQIF',
		    '>gi|00000000|dbj|00000000.0|-rc-xl1', '-SKY',
		    '>gi|00000000|dbj|00000000.0|-rc-xl2', '--PNI');
push @frame6_test, @frame3_test[6..11];
push @frame6_test, ('>gi|00000000|dbj|00000000.0|-rc-xl0', 'LQIF',
		    '>gi|00000000|dbj|00000000.0|-rc-xl1', '-SKYX',
		    '>gi|00000000|dbj|00000000.0|-rc-xl2', '--PNI');


run_not_ok('fasxl', [], 'No input test');

run_output_matches('fasxl', ['-a', $test_file],
		   \@annotate_test, [], 'Checking annotate option');

run_output_matches('fasxl', ['-a', '-j_', $test_file],
		   \@join_test, [], 'Checking join option');

run_output_matches('fasxl', ['-g', $test_file3],
		   \@gap_test, [], 'Checking gap option');

run_output_matches('fasxl', ['-k', $test_file3],
		   \@keep_test, [], 'Checking keep option');

run_output_matches('fasxl', [$test_file],
		   \@frame0_test, [], 'Checking frame option');

run_output_matches('fasxl', ['-f1', $test_file],
		   \@frame1_test, [], 'Checking frame option');

run_output_matches('fasxl', ['-f2', $test_file],
		   \@frame2_test, [], 'Checking frame option');

run_output_matches('fasxl', ['-t1', $test_file5],
		   \@table_test, [], 'Checking table option');

run_output_matches('fasxl', ['-t2', $test_file5],
		   \@table_test2, [], 'Checking table option again');

run_output_matches('fasxl', ['-s-', $test_file5],
		   \@stop_test, [], 'Checking stop option again');

run_output_matches('fasxl', ['-3', $test_file],
		   \@frame3_test, [], 'Checking 3 frame option');

run_output_matches('fasxl', ['-6', $test_file],
		   \@frame6_test, [], 'Checking 6 frame option');
