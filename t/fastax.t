use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 1;
use Test::Script::Run;

run_not_ok('fastax', [], 'No input test');
