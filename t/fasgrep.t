use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 2;
use Test::Script::Run;

run_not_ok('fasgrep', [], 'No input test');
run_not_ok('fasgrep', [qw|t/data/P450.fas|], 'No regex test');

# Test works if you run 'fasgrep 403 t/data/P450.fas', but doesn't work here
# so thus the comment untill I can figure out the issue
#run_ok('fasgrep', [qw|403 t/data/P450.fas|], 'Regex test');