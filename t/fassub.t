use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;
use Test::Script::Run;

my $test_file = 't/data/fashead_tail_test1.fas';

run_not_ok('fassub', [], 'No input test');

open( my $test1, "<", $test_file ) || die "Can't open $test_file"; 
my @output = <$test1>;
chomp(@output);
close($test1);

my @desription_test = @output;
my @insen_desription_test = @output;
my @sequence_test = @output;
my @global_test = @output; 
s/Ummeliata/atailemmU/ for @desription_test;
s/Ummeliata/atailemmU/ for @insen_desription_test;
s/KYLE/ELYK/i for @sequence_test;
s/VE/EV/g for @global_test;


run_output_matches('fassub', ['-d', 'Ummeliata', 'atailemmU', $test_file],
		   \@desription_test, [], 'Checking description option');

run_output_matches('fassub', ['-d', 'ummeliata', 'atailemmU', $test_file],
		   \@output, [], 'Checking without case-insensitively option');

run_output_matches('fassub', ['-i', '-d', 'ummeliata', 'atailemmU', $test_file],
		   \@insen_desription_test, [], 'Checking case-insensitively option');

run_output_matches('fassub', ['-s', 'KYLE', 'ELYK', $test_file],
		   \@sequence_test, [], 'Checking sequence option');

run_output_matches('fassub', ['-g', '-s', 'VE', 'EV', $test_file],
		   \@global_test, [], 'Checking global option');
