package FAST::List::Gen::Cookbook;
    use warnings;
    use strict;

=head1 NAME

FAST::List::Gen::Cookbook - how to get the most out of L<FAST::List::Gen>

=head1 COOKBOOK

this document contains tips and tricks for working with and combining generators

=head2 iteration

given the generator C< my $gen = gen {2**$_} 100; > which computes the first
hundred powers of two, here are a few was to iterate over it (that all maintain
lazy evaluation):

    for (@$gen) {...}      # no need to reset generator between calls
    for my $p (@$gen) {...}
    ... for @$gen;

    while (<$gen>) {...}   # iterated generators must be reset with `$gen->reset`
    ... while <$gen>       # before each loop, also be sure to `local $_` before
                           # while loops that modify `$_`
    while (my $p = <$gen>) {...}
    while (defined(my $p = $gen->())) {...}
    while ($gen->more) {do something with $gen->next}

since all of these iteration examples remain lazy (only generating values on
demand), you can C< last > at any time to break out of the loop.

you can also use the C< do > method:

    $gen->do(sub {...}); # which calls sub on every element of $gen

=head2 list creation

you can dereference finite length generators to pass all of their elements to
a function:

    say sum @$gen;

but it is usually faster to write it this way:

    say sum $gen->all;

generators interpolate in strings like normal arrays:

    say "@$gen[0 .. 10]";

do not call C<< ->all >> or use array dereferencing on infinite generators.  in
some places you may get an error, others, it will loop forever (and probably run
out of memory at some point).

=head2 inline generators

the generators without code blocks, C< range > and C< glob >, can be directly
dereferenced with C< @{...} >

    for (@{range 0.345, -21.5, -0.5}) {...}

    for (@{< 1 .. 10 by 2 >}) {...}

for those with code blocks, perl needs a little help to figure out whats going
on:

    for (@{ +gen {$_**2} 1, 10 }) {...}  # a '+' or ';' before it does the trick

=head2 normal generators

the C< range > and C< makegen > functions are the most primitive generators,
C< range > producing a lazy list, and C< makegen > wrapping a perl array.

you build upon these with the other generator functions/methods.  many
generator functions will pass their arguments along to C< range > or
C< makegen > as needed, so you rarely need to use them directly.

    gen {$_**2} 100             ~~  gen {$_**2} range 0, 100

    my @names = qw/bob alice eve/;
    gen {"hello $_!"} \@names   ~~  gen {"hello $_!"} makegen @names

those were two examples of C< gen >, the generator equivalent of C< map > that
attaches a code block to a generator.

=head2 iterative generators

there is one other primitive generator type, the C< iterate > generator, which
is used when your algorithm is iterative in nature.  iterative generators come
in two flavors, single element per iteration, and multi element per iteration.

    my $fib = do {
        my ($an, $bn) = (0, 1);
        iterate {
            my $return = $an;
            ($an, $bn) = ($bn, $an + $bn);
            $return
        }
    };

    my $multi = do {
        my $var;
        iterate_multi {
            my @return = ...;
        }
    }

you can also use the C<< ->from >> method to write an iterator that builds
from an initial value:

    say iterate{$_*2}->from(1)->str(10); # 1 2 4 8 16 32 64 128 256 512

the iterative generators have some syntactic sugar you can use, in the form of
C< gather {...} > and C< take(...) >:

    my $fib = do {
        my ($x, $y) = (0, 1);
        gather {
            ($x, $y) = ($y, take($x) + $y)
        }
    };

don't confuse this implementation of C< gather/take > with the perl6
implementation, or the implementation of C< yield > in python.  since perl5 does
not have continuations, C< take > can't pause the execution of the gather block.
instead, it saves the value passed to it, and the gather block returns it when
the block ends.  you can use C< gather_multi > to C< take > multiple times.

all iterative generators implicitly cache their generated elements in an
internal array.  this allows random access within the generator.  unlike other
caching generators, you can not purge the iterator's cache (except by letting
all references to the generator fall out of scope, like a normal variable).
if you want an iterator that throws its values away, just write a subroutine:

    my $fib = do {
        my ($an, $bn) = (0, 1);
        sub {
            my $return = $an;
            ($an, $bn) = ($bn, $an + $bn);
            $return
        }
    };

    say $fib->() for 1 .. 10;


=head2 composite generators

there are many ways to modify generators.

    my $odd = filter {$_ % 2};
    my $squares_of_odd = gen {$_**2} $odd;

    my $less_than_1000 = While {$_ < 1000} $squares_of_odd;

    say for @$less_than_1000;

    my $this_is_same = While {$_ < 1000} gen {$_**2} filter {$_ % 2};

    say for @$this_is_same;

here is a sub that returns a generator producing the fibonacci sequence to a
given magnitude:

    sub fibonacci {
        my $limit   = 10**shift;
        my ($x, $y) = (0, 1);

        While {$_ < $limit} gather {
            ($x, $y) = ($y, take($x) + $y)
        }
    }

    say for @{fibonacci 15};


=head2 variable length generators

to implement C< grep > (as C< filter >) or C< while > (as C< While >) on a
generator means that the generator no longer knows its exact size at all times.
care has been taken to make sure that this doesn't bite you too much.

    my $pow = While {$_ < 20} gen {$_**2};

    say for @$pow;     # checks size on every iteration, works fine
    say while <$pow>;  # also works
    say $pow->all;     # ok too

each prints:

    0
    1
    4
    9
    16

but, if instead of C< say for @$pow > you had written C< map {say} @$pow >, perl
will try to expand C< @$pow > in list context, and it will not know when to
stop, since it only checks at the beginning.  the solution, in short, is to only
dereference variable length generators in slice C< @$gen[0 .. 10] > or iterator
C< ... for @$gen; > context, and never in list context.

in general, it makes more sense (and is faster) to build your constraint into
the calling code:

    my $pow = gen {$_**2};
    for (@$gen) {
        last if $_ > 20;
        say;
    }


=head2 recursive generators

the fibonacci sequence can be generated from the following definition:

    f[0] = 0;
    f[1] = 1;
    f[n] = f[n-1] + f[n-2];

here are a few ways to write that definition as a generator:

    my $fib; $fib = cache gen {$_ < 2  ? $_ : $$fib[$_ - 1] + $$fib[$_ - 2]};

    my $fib = gen {$_ < 2 ? $_ : self($_ - 1) + self($_ - 2)}
              ->cache
              ->recursive;

    my $fib; $fib = gen {$fib->($_ - 1) + $fib->($_ - 2)}
                  ->overlay( 0 => 0, 1 => 1 )
                  ->cache;

    my $fib; $fib = gen {$$fib[$_ - 1] + $$fib[$_ - 2]}->cache->overlay;
    @$fib[0, 1] = (0, 1);

bringing all those techniques together:

    my $fib = gen {self($_ - 1) + self($_ - 2)}
            ->overlay( 0 => 0, 1 => 1 )
            ->cache
            ->recursive;

the C< cache > function is used in each example because the recursive definition
of the fibonacci sequence would generate an exponentially increasing number of
calls to itself as the list grows longer.  C< cache > prevents any index from
being calculated more than once.

=head3 more ways to write the fibonacci sequence

    my $fib = <0, 1, *+*...>; >>

    my $fib = <0, 1, {$^a + $^b}...>; >>

    my $fib = ([0, 1] + iterate {sum self($_, $_ + 1)})->rec; >>

    my $fib = ([0, 1] + iterate {sum fib($_, $_ + 1)})->rec('fib'); >>

    my $fib = (iterate {$_ < 2 ? $_ : sum self($_ - 1, $_ - 2)})->rec; >>

    my $fib; $fib = cache gen {$_ < 2 ? $_ : sum $fib->($_ - 1, $_ - 2)}; >>

=head3 a few ways to write the factorial sequence

    my $fac = <[*..] 1, 1..>;

    my $fac = <1, 1..>->scan('*');

    my $fac = 1 + repeat(1)->scan('+')->scan('*');

    my $fac = <1, **_...>;

=head2 stream generators

here is an example of a sieve of eratosthenes implemented with generators:

    my $primes = do {
        my $src = <2..>;
        iterate {
            my ($x, $xs) = $src->x_xs;
            $src = $xs->grep_stream(sub {$_ % $x});
            $x
        }
    };

in this example, the list is filtered with C< grep_stream/filter_stream > since
the algorithm only reads the source once, and reads it in order.  a regular
C< filter/grep > call could be used, but it would unnecessarily use up a lot
of memory since each call would have to build up a new random-access cache.

the inefficiency addressed above could also be fixed by modifying the filtering
function itself:

    my $primes = do {
        my @p;
        <2..>->grep(sub {
            my $i = $_;
            $i % $_ or return for @p;
            push @p, $i;
        })
    };

of course if you want prime numbers, just use the C< primes > function:

    my $primes = FAST::List::Gen::primes;

which is implemented as a precomputed sieve of eratosthenes in a string buffer.
initially it is ready to test the primality of numbers below 1000.  if a higher
number is checked, the sieve will grow to 10 times larger than that value.
beyond 1e7 primes are checked with simple trial division.

=head2 printing generators

there are a variety of methods available for printing out the contents of a
generator:

    my $gen = <1..5>;

    say $gen->str;  # 1 2 3 4 5
    $gen->say;      # 1 2 3 4 5
    $gen->print;    # same as: print $gen;

    say $gen->perl; # [1, 2, 3, 4, 5]
    $gen->dump;     # [1, 2, 3, 4, 5]

if your generator is longer than you would like to print, such as an infinite
generator, passing a number to any of the methods above will limit the number
of elements printed.

    <1..>->say(5); # 1 2 3 4 5

which is the same as

    <1..>->take(5)->say;  # 1 2 3 4 5

if passed an additional argument, that string will be included in the output
whenever the printing method needs to truncate a generator.

    say <1..>->perl(5, '...');  # [1, 2, 3, 4, 5, ...]

these methods are recursive and will expand elements that are generators or
array references.

    list(<1..>, <a..>, <A..>)->dump(3, '...');

    # [[1, 2, 3, ...], ['a', 'b', 'c', ...], ['A', 'B', 'C', ...]]

    <1..>->tuples(<a..>)->dump(3); # [[1, 'a'], [2, 'b'], [3, 'c']]

a target file handle can be passed as the first argument:

    <1..>->dump(*STDERR, 5);

the C<say>, C<print>, and C<dump> methods all return the generator they were
called on for easy chaining.

    <1..>->say(5)->map('**2')->say(5);
    # 1 2 3 4 5
    # 1 4 9 16 25

=head2 debugging generators

in addition to the methods to print generators, there are several methods
dedicated to debugging:

    <0..>->debug;
    # debug:   FAST::List::Gen::erator::_20=ARRAY(0x2d07bfc)
    # type:    FAST::List::Gen::Range
    # source:  none
    # mutable: no
    # stream:  no
    # range:   [0 .. inf]
    # index:   0
    # perl:    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, ...]
    #  at file.pl line 12

pass C< debug > a number to control how many elements are printed.

    my $gen = <0..>->watch('range')
                   ->grep('even')->watch('grep')
                   ->map('**2')->watch('map')
                   ->map('"[$_]"');

    local $\ = ', '; # watch ends lines with $\ if defined or with $/

    say $gen->(0); # range: 0, range: 1, range: 2, grep: 0, map: 0, [0]
    say $gen->(1); # range: 3, range: 4, grep: 2, map: 4, [4]
    say $gen->(2); # range: 5, range: 6, grep: 4, map: 16, [16]

C<watch> can also be passed a file handle to print to.

=head1 AUTHOR

Eric Strom, C<< <asg at cpan.org> >>

=head1 COPYRIGHT & LICENSE

copyright 2009-2011 Eric Strom.

this program is free software; you can redistribute it and/or modify it under
the terms of either: the GNU General Public License as published by the Free
Software Foundation; or the Artistic License.

see http://dev.perl.org/licenses/ for more information.

=cut


__PACKAGE__ if 'first require';
