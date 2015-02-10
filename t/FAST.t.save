use lib "t/lib";
use Test::More tests => 2;
use Test::Cmd;     
    
$test = Test::Cmd->new(prog => 'bin/fasconvert', workdir => '');
ok($test, "creating Test::Cmd object");
	    
$test->run(args => '-i genbank < t/data/AF194338.1.gb');
ok($? == 0, "executing bin/fasconvert -i genbank < t/data/AF194338.1.gb");
