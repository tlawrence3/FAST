use 5.006;
use strict;
use warnings FATAL => 'all';
use Test::More tests => 6;
use Test::Script::Run;

run_ok('fasuniq',[qw|/data/P450.fas|]);
run_ok('fasuniq',[qw|-D /data/P450.fas|]);
run_ok('fasuniq',[qw|-I /data/P450.fas|]);
run_ok('fasuniq',[qw|-cd":" /data/P450.fas|]);
run_not_ok('fassort', [qw|-cd"" t/data/P450.fas|],"fail if delimter is empty");
run_not_ok('fassort', [qw|-c t/data/P450.fas|],"fail if delimter is empty");