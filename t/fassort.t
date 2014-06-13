#!perl
use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 10;
use Test::Script::Run;


run_ok('fassort',[qw|-t species t/data/Dros.fas|]);
run_not_ok('fassort',[qw|-t species: t/data/Dros.fas|],"fail if -t argument uses a colon");

run_ok('fassort', [qw|-sx "^\w(\w)" t/data/P450.fas|]);
run_not_ok('fassort', [qw|-sx "^\w\w" t/data/P450.fas|],"fail if -x argument contains neither left nor right paren");
run_not_ok('fassort', [qw|-sx "^\w(\w" t/data/P450.fas|],"fail if -x argument contains a left but not a right paren");
run_not_ok('fassort', [qw|-sx "^\w\w)" t/data/P450.fas|],"fail if -x argument contains a right but not a left paren");
run_not_ok('fassort', [qw|-sx "^\w)\w(" t/data/P450.fas|],"fail if -x argument contains a right paren before a left paren");
run_not_ok('fassort', [qw|-sx "^(\w)(\w)" t/data/P450.fas|],"fail if -x argument contains more than one capture buffer");
run_not_ok('fassort', [qw|-sx "^)\w(\w)\w(" t/data/P450.fas|],"fail if -x argument contains unmatched parens");
run_not_ok('fassort', [qw|-sx "^()" t/data/P450.fas|],"fail if -x argument contains an empty capture buffer");
