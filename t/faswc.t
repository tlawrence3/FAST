use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 7;
use Test::Script::Run;

my $test_file = 't/data/fashead_tail_test1.fas';

run_not_ok('faswc', [], 'No input test');

run_output_matches('faswc', [$test_file],
		   ["         3       453 $test_file",
		    '         3       453 total'], [], 'Checking default option');

run_output_matches('faswc', ['-s', $test_file],
		   ["         3 $test_file",
		    '         3 total'], [], 'Checking sequence option');

run_output_matches('faswc', ['-c', $test_file],
		   ["       453 $test_file",
		    '       453 total'], [], 'Checking character option');

run_output_matches('faswc', [$test_file, $test_file],
		   ["         3       453 $test_file",
		    "         3       453 $test_file",
		    '         6       906 total'], [], 'Checking multi-file default option');

run_output_matches('faswc', ['-s', $test_file, $test_file],
		   ["         3 $test_file",
		    "         3 $test_file",
		    '         6 total'], [], 'Checking multi-file sequence option');

run_output_matches('faswc', ['-c', $test_file, $test_file],
		   ["       453 $test_file",
		    "       453 $test_file",
		    '       906 total'], [], 'Checking multi-file character option');
