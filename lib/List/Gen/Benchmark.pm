package FAST::List::Gen::Benchmark;
    use warnings;
    use strict;
    use FAST::List::Gen 0;
    use Benchmark 'cmpthese';
    our ($a, $b);

    print "iteration:\n";
    for my $mag (10, 50, map 10**$_, 2 .. 5) {
        print "\n[+] 0 .. $mag:\n";
        my $gen = range $mag;
        my $sum = $gen->sum;
        cmpthese -2 => {
            do => sub {
                my $i = 0;
                $gen->do(sub {$i += $_});
                $i == $sum or die $i;
            },
            for => sub {
                my $i = 0;
                $i += $_ for @$gen;
                $i == $sum or die $i;
            },
            next => sub {
                my ($i, $n) = 0;
                $gen->reset;
                $i += $n while ($n) = $gen->next;
                $i == $sum or die $i;
            },
            'more/next' => sub {
                my $i = 0;
                $gen->reset;
                $i += $gen->next while $gen->more;
                $i == $sum or die $i;
            },
            iterator => sub {
                my ($i, $n) = 0;
                $gen->reset;
                my $itr = $gen->iterator;
                $i += $n while ($n) = $itr->();
                $i == $sum or die $i;
            },
            '$gen->()' => sub {
                my ($i, $n) = 0;
                $gen->reset;
                $i += $n while ($n) = $gen->();
                $i == $sum or die $i;
            },
            reduce => sub {
                $gen->reduce(sub {$a + $b}) == $sum or die
            },
            handle => sub {
                my $i = 0;
                local $_;
                $gen->reset;
                $i += $_ while <$gen>;
                $i == $sum or die $i;
            },
        }
    }

    exit;

=head1 NAME

FAST::List::Gen::Benchmark - performance tips for using L<FAST::List::Gen>

=head1 SYNOPSIS

this document contains various benchmarks comparing the parallel syntax styles
that L<FAST::List::Gen> provides.

=head1 running the benchmark

    perl -MFAST::List::Gen::Benchmark

=head1 benchmark tests

    iteration:

        reduce:    my $x = $gen->reduce(sub {$a + $b});
                   # same as $gen->sum

        do:        my $x; $gen->do(sub {$x += $_})

        for:       my $x; $x += $_ for @$gen;

        more/next: my $x; $gen->reset;
                   $x += $gen->next while $gen->more;

        $gen->():  my ($x, $n); $gen->reset;
                   $x += $n while ($n) = $gen->();

        iterator:  my $it = $gen->iterator;
                   my ($x, $n); $gen->reset;
                   $x += $n while ($n) = $it->();

        next:      my ($x, $n); $gen->reset;
                   $x += $n while ($n) = $gen->next;

        handle:    my $x; local $_; $gen->reset;
                   $x += $_ while <$gen>;

=head1 benchmark results

    iteration:

    [+] 0 .. 10:
                 Rate reduce     do    for more/next $gen->() iterator   next handle
    reduce    28489/s     --    -8%   -30%      -55%     -55%     -67%   -68%   -71%
    do        31109/s     9%     --   -24%      -51%     -51%     -64%   -65%   -69%
    for       40877/s    43%    31%     --      -35%     -35%     -53%   -55%   -59%
    more/next 62977/s   121%   102%    54%        --      -0%     -27%   -30%   -36%
    $gen->()  63141/s   122%   103%    54%        0%       --     -27%   -30%   -36%
    iterator  86340/s   203%   178%   111%       37%      37%       --    -4%   -13%
    next      90021/s   216%   189%   120%       43%      43%       4%     --    -9%
    handle    98964/s   247%   218%   142%       57%      57%      15%    10%     --

    [+] 0 .. 50:
                 Rate    for $gen->() more/next reduce     do   next iterator handle
    for        8762/s     --     -40%      -40%   -41%   -43%   -59%     -60%   -63%
    $gen->()  14546/s    66%       --       -1%    -2%    -5%   -31%     -34%   -38%
    more/next 14646/s    67%       1%        --    -2%    -4%   -31%     -33%   -38%
    reduce    14892/s    70%       2%        2%     --    -3%   -30%     -32%   -37%
    do        15278/s    74%       5%        4%     3%     --   -28%     -30%   -35%
    next      21222/s   142%      46%       45%    43%    39%     --      -3%   -10%
    iterator  21892/s   150%      51%       49%    47%    43%     3%       --    -7%
    handle    23454/s   168%      61%       60%    57%    54%    11%       7%     --

    [+] 0 .. 100:
                 Rate    for more/next $gen->() reduce     do   next iterator handle
    for        4424/s     --      -40%     -42%   -53%   -53%   -60%     -61%   -64%
    more/next  7385/s    67%        --      -3%   -21%   -21%   -34%     -34%   -39%
    $gen->()   7607/s    72%        3%       --   -19%   -19%   -32%     -32%   -38%
    reduce     9340/s   111%       26%      23%     --    -0%   -16%     -17%   -23%
    do         9341/s   111%       26%      23%     0%     --   -16%     -17%   -23%
    next      11108/s   151%       50%      46%    19%    19%     --      -1%    -9%
    iterator  11253/s   154%       52%      48%    20%    20%     1%       --    -8%
    handle    12190/s   176%       65%      60%    31%    31%    10%       8%     --

    [+] 0 .. 1000:
                Rate     for more/next $gen->()   next iterator     do reduce handle
    for        446/s      --      -39%     -42%   -61%     -62%   -62%   -63%   -64%
    more/next  735/s     65%        --      -4%   -35%     -37%   -37%   -39%   -41%
    $gen->()   763/s     71%        4%       --   -33%     -34%   -34%   -37%   -38%
    next      1131/s    153%       54%      48%     --      -3%    -3%    -7%    -9%
    iterator  1164/s    161%       58%      52%     3%       --    -0%    -4%    -6%
    do        1165/s    161%       58%      53%     3%       0%     --    -4%    -6%
    reduce    1210/s    171%       65%      58%     7%       4%     4%     --    -2%
    handle    1237/s    177%       68%      62%     9%       6%     6%     2%     --

    [+] 0 .. 10000:
                Rate     for more/next $gen->()   next iterator     do handle reduce
    for       44.5/s      --      -40%     -42%   -60%     -62%   -63%   -64%   -64%
    more/next 74.0/s     66%        --      -3%   -34%     -36%   -39%   -41%   -41%
    $gen->()  76.6/s     72%        4%       --   -32%     -34%   -37%   -38%   -39%
    next       113/s    153%       52%      47%     --      -3%    -8%    -9%   -10%
    iterator   116/s    161%       57%      52%     3%       --    -5%    -7%    -7%
    do         122/s    174%       65%      59%     8%       5%     --    -2%    -3%
    handle     124/s    179%       68%      62%    10%       7%     2%     --    -1%
    reduce     125/s    182%       70%      64%    11%       8%     3%     1%     --

    [+] 0 .. 100000:
                Rate     for more/next $gen->()   next iterator reduce     do handle
    for       4.47/s      --      -41%     -42%   -61%     -62%   -63%   -64%   -64%
    more/next 7.55/s     69%        --      -2%   -34%     -36%   -38%   -39%   -40%
    $gen->()  7.71/s     72%        2%       --   -32%     -35%   -36%   -38%   -39%
    next      11.4/s    155%       51%      48%     --      -4%    -6%    -8%    -9%
    iterator  11.9/s    166%       57%      54%     4%       --    -2%    -4%    -5%
    reduce    12.1/s    170%       60%      57%     6%       2%     --    -2%    -4%
    do        12.3/s    176%       64%      60%     8%       4%     2%     --    -2%
    handle    12.5/s    180%       66%      63%    10%       6%     4%     2%     --

=head1 interpretation

once the generator size gets large enough to mask differences in initialization
code, the access methods fall into 4 classes.

=over 4

=item 1: C< for >

while it is one of the most perlish ways to write the loop, the
C< $x += $_ for @$gen > construct uses a tied array, and unfortunately ties are
fairly slow.  all of the other constructs use the exact same underlying
C< FETCH > and C< FETCHSIZE > methods that the tied array uses, yet they are all
much faster.

=item 2: C<< more/next, $gen->() >>

these are almost the same speed, and are the slowest of the non-tied access
methods.  the C< more/next > pair results in unneeded function calls, since
C< next > is checking the C< more > condition already.  the overloaded
dereference has some interpreter overhead.

=item 3: C< next, iterator, reduce, do >

these are the faster ways to access generators, the ranking of which depends on
the size of the generator.  C< next > and C< iterator > are almost the same, and
are fast across the size range.  C< iterator > will always be slightly faster
than C< next > since it is the function used internally by C< next>

C< reduce > and C< do > both have slower start-up time than C< next > or
C< iterator > due to a bit of initialization code.  this initialization code
allows for their loops to be optimized further, which lets C< reduce > and
C< do > achieve higher speeds for larger generators.

=item 4: C< handle >

handle iteration in a while loop is heavily optimized by perl, and is
subsequently one of the fastest techniques for iterating over a generator, and
this speed is independent of generator size.

=back

in summary, stick to C< next, iterator, reduce, do, or handle > iteration styles
if performance is a concern.

=head1 AUTHOR

Eric Strom, C<< <asg at cpan.org> >>

=head1 COPYRIGHT & LICENSE

copyright 2009-2011 Eric Strom.

this program is free software; you can redistribute it and/or modify it under
the terms of either: the GNU General Public License as published by the Free
Software Foundation; or the Artistic License.

see http://dev.perl.org/licenses/ for more information.

=cut
