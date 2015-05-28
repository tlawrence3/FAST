package FAST::List::Gen;
    use warnings;
    use strict;
    use Carp;
    use Symbol       qw/delete_package/;
    use Scalar::Util qw/reftype weaken openhandle blessed/;
    our @list_util;
    use List::Util
        @list_util   = qw/first max maxstr min minstr reduce shuffle sum/;
    our @EXPORT      = qw/mapn by every range gen cap filter cache apply
                        zip min max reduce glob iterate list/;
    our %EXPORT_TAGS = (
        base         => \@EXPORT,
        'List::Util' => \@list_util,
        map {s/==//g; s/#.*//g;
            /:(\w+)\s+(.+)/s ? ($1 => [split /\s+/ => $2]) : ()
        } split /\n{2,}/ => q(

        :utility    mapn by every apply min max reduce mapab
                    mapkey d deref slide curse remove

        :source     range glob makegen list array vecgen repeat file

        :modify     gen cache expand contract collect slice flip overlay
                    test recursive sequence scan scan_stream == scanS
                    cartesian transpose stream strict

        :zip        zip zipgen tuples zipwith zipwithab unzip unzipn
                    zipmax zipgenmax zipwithmax

        :iterate    iterate
                    iterate_multi        == iterateM
                    iterate_stream       == iterateS
                    iterate_multi_stream == iterateMS

        :gather     gather
                    gather_stream        == gatherS
                    gather_multi         == gatherM
                    gather_multi_stream  == gatherMS

        :mutable    mutable done done_if done_unless

        :filter     filter
                    filter_stream == filterS
                    filter_ # non-lookahead version

        :while      take_while == While
                    take_until == Until
                    while_ until_ # non-lookahead versions
                    drop_while drop_until

        :numeric    primes

        :deprecated genzip
    ));

    our @EXPORT_OK = keys %{{map {$_ => 1} map @$_, values %EXPORT_TAGS}};
    $EXPORT_TAGS{all} = \@EXPORT_OK;
    BEGIN {
        require Exporter;
        require overload;
        require B;
        *FAST::List::Generator:: = *FAST::List::Gen::;
    }
    sub import {
        if (@_ == 2 and !$_[1] || $_[1] eq '*') {
            splice @_, 1, 1, ':all', '\\'
        }
        push @_, '\\' if @_ == 1;
        @_ = grep {/^&?\\$/ ? do {*\ = \&cap; 0} : 1} @_;
        @_ = map  {/^<.*>$/ ? 'glob' : $_} @_;
        goto &{Exporter->can('import')}
    }
    sub VERSION {
         goto &{@_ > 1 && $_[1] == 0 ? *import : *UNIVERSAL::VERSION}
    }

    sub DEBUG () {}
    DEBUG or $Carp::Internal{(__PACKAGE__)}++;

    our $LIST              = 0; # deprecated
    our $LOOKAHEAD         = 1;
    our $DWIM_CODE_STRINGS = 0;
    our $SAY_EVAL          = 0;
    our $STREAM            = 0;
    our $STRICT            = 0;

    my $MAX_IDX = eval {require POSIX; POSIX::DBL_MAX()} || 2**53 - 1;

    our $VERSION = '0.974';

=head1 NAME

FAST::List::Gen - provides functions for generating lists

=head1 VERSION

version 0.974

=head1 SYNOPSIS

this module provides higher order functions, list comprehensions, generators,
iterators, and other utility functions for working with lists. walk lists
with any step size you want, create lazy ranges and arrays with a map like
syntax that generate values on demand. there are several other hopefully useful
functions, and all functions from List::Util are available.

    use FAST::List::Gen;

    print "@$_\n" for every 5 => 1 .. 15;
    # 1 2 3 4 5
    # 6 7 8 9 10
    # 11 12 13 14 15

    print mapn {"$_[0]: $_[1]\n"} 2 => %myhash;

    my $ints    = <0..>;
    my $squares = gen {$_**2} $ints;

    say "@$squares[2 .. 6]"; # 4 9 16 25 36

    $ints->zip('.', -$squares)->say(6); # 0-0 1-1 2-4 3-9 4-16 5-25

    list(1, 2, 3)->gen('**2')->say; # 1 4 9

    my $fib = ([0, 1] + iterate {fib($_, $_ + 1)->sum})->rec('fib');
    my $fac = iterate {$_ < 2 or $_ * self($_ - 1)}->rec;

    say "@$fib[0 .. 15]";  #  0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610
    say "@$fac[0 .. 10]";  #  1 1 2 6 24 120 720 5040 40320 362880 3628800

    say <0, 1, * + * ...>->take(10)->str;   # 0 1 1 2 3 5 8 13 21 34
    say <[..*] 1, 1..>->str(8);             # 1 1 2 6 24 120 720 5040

    <**2 for 1..10 if even>->say;           # 4 16 36 64 100

    <1..>->map('**2')->grep(qr/1/)->say(5); # 1 16 81 100 121

=head1 EXPORT

    use FAST::List::Gen; # is the same as
    use FAST::List::Gen qw/mapn by every range gen cap \ filter cache apply zip
                     min max reduce glob iterate list/;

    the following export tags are available:

        :utility    mapn by every apply min max reduce mapab
                    mapkey d deref slide curse remove

        :source     range glob makegen list array vecgen repeat file

        :modify     gen cache expand contract collect slice flip overlay
                    test recursive sequence scan scan_stream == scanS
                    cartesian transpose stream strict

        :zip        zip zipgen tuples zipwith zipwithab unzip unzipn
                    zipmax zipgenmax zipwithmax

        :iterate    iterate
                    iterate_multi        == iterateM
                    iterate_stream       == iterateS
                    iterate_multi_stream == iterateMS

        :gather     gather
                    gather_stream        == gatherS
                    gather_multi         == gatherM
                    gather_multi_stream  == gatherMS

        :mutable    mutable done done_if done_unless

        :filter     filter
                    filter_stream == filterS
                    filter_ # non-lookahead version

        :while      take_while == While
                    take_until == Until
                    while_ until_ # non-lookahead versions
                    drop_while drop_until

        :numeric    primes

        :deprecated genzip

        :List::Util first max maxstr min minstr reduce shuffle sum

    use FAST::List::Gen '*';     # everything
    use FAST::List::Gen 0;       # everything
    use FAST::List::Gen ':all';  # everything
    use FAST::List::Gen ':base'; # same as 'use FAST::List::Gen;'
    use FAST::List::Gen ();      # no exports

=cut

    sub mapn (&$@);
    #my @packages; END {print "package $_;\n" for sort @packages}
    sub packager {
        unshift @_, split /\s+/ => shift;
        my $pkg = shift;
        my @isa = deref(shift);

        for ($pkg, @isa) {/:/ or s/^/FAST::List::Gen::/}
        #push @packages, $pkg;
        no strict 'refs';
        *{$pkg.'::ISA'} = \@isa;
        mapn {*{$pkg.'::'.$_} = pop} 2 => @_;
        1
    }
    sub generator {
        splice @_, 1, 0, 'Base',    @_ > 1 ? 'TIEARRAY' : ();
        goto &packager
    }
    sub mutable_gen {
        splice @_, 1, 0, 'Mutable', @_ > 1 ? 'TIEARRAY' : ();
        goto &packager
    }

    require Sub::Name if DEBUG;
    {my %id;
    sub curse {
        my ($obj,  $class) = @_;
        my $pkg  = $class || caller;
           $pkg .= '::_'.++$id{$pkg};

        no strict 'refs';
        croak "package $pkg not empty" if %{$pkg.'::'};

        my $destroy = delete $$obj{DESTROY};
        *{$pkg.'::DESTROY'} = sub {
            {&{ $destroy or next}}
            {&{($class   or next)->can('DESTROY') or next}}
            delete_package $pkg
        };
        @{$pkg.'::ISA'} = $class if $class;

        for my $name (grep {not /^-/ and ref $$obj{$_} eq 'CODE'} keys %$obj) {
            DEBUG and B::svref_2object($$obj{$name})->GV->NAME =~ /__ANON__/
                  and Sub::Name::subname("$class\::$name", $$obj{$name});
            *{$pkg.'::'.$name} = $$obj{$name}
        }
        if ($$obj{-overload}) {
            eval 'package '.$pkg.'; use overload @{$$obj{-overload}}'
        }
        bless $$obj{-bless} || $obj => $pkg
    }}

    sub looks_like_number ($) {
        Scalar::Util::looks_like_number($_[0])
            or do {no warnings 'numeric'; $_[0] >= 9**9**9}
            or do {
                ref $_[0]
                and blessed $_[0]
                and $_[0]->isa('Math::BigInt')
                ||  $_[0]->isa('Math::BigRat')
                ||  $_[0]->isa('Math::BigFloat')
            }
    }

    our $sv2cv;

    my $cv_caller = sub {
        reftype($_[0]) eq 'CODE' or croak "not code: $_[0]";
        B::svref_2object($_[0])->STASH->NAME
    };

    my $cv_local = sub {
        my $caller = shift->$cv_caller;
        no strict 'refs';
        my @ret = map \*{$caller.'::'.$_} => @_;
        wantarray ? @ret : pop @ret
    };

    my $cv_ab_ref = sub {
        $_[0]->$cv_local(qw(a b))
    };

    my $cv_wants_2_args = sub {
        (prototype $_[0] or '') eq '$$'
    };

    my $any_mutable = sub {
        for (@_) {return 1 if ref and isagen($_) and $_->is_mutable}
        ''
    };

    my $external_package = sub {
        my $up = @_ ? $_[0] : 1;
        $up++ while (substr caller $up, 0 => 9) eq 'FAST::List::Gen';
        scalar caller $up
    };

    my $isagen = \&isagen;

    my $is_array_or_gen = sub {ref $_[0] eq 'ARRAY' or &isagen};

    my $say_eval = sub {Carp::cluck "eval ($_[0]): '$_[1]'"};

    my $eval = sub {
        my $pkg = $external_package->(2);
        my ($msg, $code) = @_;
        &$say_eval if $SAY_EVAL or DEBUG;

        my $say = $code =~ /(?:\b|^)say(?:\b|$)/
                ? "use feature 'say';"
                : '';
        $code = "[do {$code}]" if wantarray;
        local @$;
        my $ret = eval "package $pkg; $say \\do {$code}"
            or croak "$msg code error: $@\n$say $code\n";
        wantarray ? @$$ret : $$ret
    };


=head1 FUNCTIONS

=over 4

=item mapn C< {CODE} NUM LIST >

this function works like the builtin C< map > but takes C< NUM > sized steps
over the list, rather than one element at a time. inside the C< CODE > block,
the current slice is in C< @_ > and C< $_ > is set to C< $_[0] >. slice elements
are aliases to the original list. if C< mapn > is called in void context, the
C< CODE > block will be executed in void context for efficiency.

    print mapn {$_ % 2 ? "@_" : " [@_] "} 3 => 1..20;
    #  1 2 3 [4 5 6] 7 8 9 [10 11 12] 13 14 15 [16 17 18] 19 20

    print "student grades: \n";
    mapn {
        print shift, ": ", &sum / @_, "\n";
    } 5 => qw {
        bob   90 80 65 85
        alice 75 95 70 100
        eve   80 90 80 75
    };

=cut

    sub mapn (&$@) {
        my ($sub, $n, @ret) = splice @_, 0, 2;
        croak '$_[1] must be >= 1' unless $n >= 1;

        return map $sub->($_) => @_ if $n == 1;

        my $want = defined wantarray;
        while (@_) {
            local *_ = \$_[0];
            if ($want) {push @ret =>
                  $sub->(splice @_, 0, $n)}
            else {$sub->(splice @_, 0, $n)}
        }
        @ret
    }


=item by C< NUM LIST >

=item every C< NUM LIST >

C< by > and C< every > are exactly the same, and allow you to add variable step
size to any other list control structure with whichever reads better to you.

    for (every 2 => @_) {do something with pairs in @$_}

    grep {do something with triples in @$_} by 3 => @list;

the functions generate an array of array references to C< NUM > sized slices of
C< LIST >. the elements in each slice are aliases to the original list.

in list context, returns a real array.
in scalar context, returns a generator.

    my @slices = every 2 => 1 .. 10;     # real array
    my $slices = every 2 => 1 .. 10;     # generator
    for (every 2 => 1 .. 10) { ... }     # real array
    for (@{every 2 => 1 .. 10}) { ... }  # generator

if you plan to use all the slices, the real array is probably better. if you
only need a few, the generator won't need to compute all of the other slices.

    print "@$_\n" for every 3 => 1..9;
    # 1 2 3
    # 4 5 6
    # 7 8 9

    my @a = 1 .. 10;
    for (every 2 => @a) {
        @$_[0, 1] = @$_[1, 0]  # flip each pair
    }
    print "@a";
    # 2 1 4 3 6 5 8 7 10 9

    print "@$_\n" for grep {$$_[0] % 2} by 3 => 1 .. 9;
    # 1 2 3
    # 7 8 9

=cut

    sub by ($@) {
        croak '$_[0] must be >= 1' unless $_[0] >= 1;
        if (wantarray) {
            if (@_ == 2 and ref $_[1] and isagen($_[1])) {
                return &mapn(\&cap, $_[0], $_[1]->all)
            } else {
                unshift @_, \&cap;
                goto &mapn
            }
        }
        tie my @ret => 'FAST::List::Gen::By', shift, \@_;
        FAST::List::Gen::erator->new(\@ret)
    }
    BEGIN {*every = \&by}
    generator By => sub {
        my ($class, $n, $source) = @_;
        if (@$source == 1 and ref $$source[0] and isagen($$source[0])) {
            $source = $$source[0];
        }
        my $size = @$source / $n;
        my $last = $#$source;

        $size ++ if $size > int $size;
        $size = int $size;
        my %cache;
        curse {
            FETCH => isagen($source)
                ? do {
                    my $fetch    = tied(@$source)->can('FETCH');
                    my $src_size = $source->size;
                    $source->tail_size($src_size) if $source->is_mutable;
                    sub {
                        my $i = $n * $_[1];
                        $cache{$i} ||= $i < $src_size
                            ? cap (map $fetch->(undef, $_) => $i .. min($last, $i + $n - 1))
                            : croak "index $_[1] out of bounds [0 .. @{[int( $#$source / $n )]}]"
                   }
                } : sub {
                    my $i = $n * $_[1];
                    $cache{$i} ||= $i < @$source
                       ? cap (@$source[$i .. min($last, $i + $n - 1)])
                       : croak "index $_[1] out of bounds [0 .. @{[int( $#$source / $n )]}]"
                },
            fsize => sub {$size}
        } => $class
    };


=item apply C< {CODE} LIST >

apply a function that modifies C< $_ > to a shallow copy of C< LIST > and
returns the copy

    print join ", " => apply {s/$/ one/} "this", "and that";
    > this one, and that one

=cut

    sub apply (&@) {
        my ($sub, @ret) = splice @_;
        &$sub for @ret;
        wantarray ? @ret : pop @ret
    }


=item zip C< LIST >

C< zip > takes a list of array references and generators. it interleaves the
elements of the passed in sequences to create a new list. C< zip > continues
until the end of the shortest sequence. C< LIST > can be any combination of
array references and generators.

    %hash = zip [qw/a b c/], [1..3]; # same as
    %hash = (a => 1, b => 2, c => 3);

in scalar context, C< zip > returns a generator, produced by C< zipgen >

if the first argument to C< zip > is not an array or generator, it is assumed
to be code or a code like string.  that code will be used to join the elements
from the remaining arguments.

    my $gen = zip sub {$_[0] . $_[1]}, [1..5], <a..>;
    # or    = zip '.' => [1..5], <a..>;
    # or    = zipwith {$_[0] . $_[1]} [1..5], <a..>;

    $gen->str;  # '1a 2b 3c 4d 5e'

=cut

    sub zip {
        my $code;
        unless ($_[0]->$is_array_or_gen) {
            $code = shift;
            $code->$sv2cv;
            unshift @_, $code;
        }
        local  *zipgen = *zipwith if $code;
        goto   &zipgen unless wantarray;
        return &zipgen->all if &$any_mutable;
        if ($code) {
            shift @_;
            map {my $i = $_;
                $code->(map $$_[$i] => @_)
            } 0 .. min map $#$_ => @_
        }
        else {
            map {my $i = $_;
                map $$_[$i] => @_
            } 0 .. min map $#$_ => @_
        }
    }


=item zipmax C< LIST >

interleaves the passed in lists to create a new list. C< zipmax > continues
until the end of the longest list, C< undef > is returned for missing elements
of shorter lists. C< LIST > can be any combination of array references and
generators.

    %hash = zipmax [qw/a b c d/], [1..3]; # same as
    %hash = (a => 1, b => 2, c => 3, d => undef);

in scalar context, C< zipmax > returns a generator, produced by C< zipgenmax >

C< zipmax > provides the same functionality as C< zip > did in versions before
0.90

=cut

    sub zipmax {
        my $code;
        unless ($_[0]->$is_array_or_gen) {
            $code = shift;
            $code->$sv2cv;
            unshift @_, $code;
        }
        local  *zipgenmax = *zipwithmax if $code;
        goto   &zipgenmax unless wantarray;
        return &zipgenmax->all if &$any_mutable;
        if ($code) {
            shift @_;
            map {my $i = $_;
                $code->(map {$i < @$_ ? $$_[$i] : undef} @_)
            } 0 .. max map $#$_ => @_
        }
        else {
            map {my $i = $_;
                map {$i < @$_ ? $$_[$i] : undef} @_
            } 0 .. max map $#$_ => @_
        }
    }


=item tuples C< LIST >

interleaves the passed in lists to create a new list of arrays. C< tuples >
continues until the end of the shortest list. C< LIST > can be any combination
of array references and generators.

    @list = tuples [qw/a b c/], [1..3]; # same as
    @list = ([a => 1], [b => 2], [c => 3]);

in scalar context, C< tuples > returns a generator:

    tuples(...)  ~~  zipwith {\@_} ...

=cut

    sub tuples {
        unless (wantarray) {
            unshift @_, \&cap;
            goto &zipwith
        }
        if (&$any_mutable) {
            unshift @_, \&cap;
            return &zipwith->all
        }
        map {my $i = $_;
            cap (map $$_[$i] => @_)
        } 0 .. min map $#$_ => @_
    }


=item cap C< LIST >

C< cap > captures a list, it is exactly the same as C<< sub{\@_}->(LIST) >>

note that this method of constructing an array ref from a list is roughly 40%
faster than C< [ LIST ]>, but with the caveat and feature that elements are
aliases to the original list

=item C< &\(LIST) >

a synonym for C< cap >, the symbols C< &\(...) > will perform the same action.
it could be read as taking the subroutine style reference of a list.  like all
symbol variables, once imported, C< &\ > is global across all packages.

    my $capture = & \(my $x, my $y);  # a space between & and \ is fine
                                      # and it looks a bit more syntactic
    ($x, $y) = (1, 2);
    say "@$capture"; # 1 2

=cut

    sub cap {\@_}


=back

=head2 generators

=over 4

in this document, a generator is an object similar to an array that generates
its elements on demand. generators can be used as iterators in perl's list
control structures such as C< for/foreach > and C< while >.  generators, like
programmers, are lazy.  unless they have to, they will not calculate or store
anything.  this laziness allows infinite generators to be created. you can
choose to explicitly cache a generator, and several generators have implicit
caches for efficiency.

there are source generators, which can be numeric ranges, arrays, or iterative
subroutines.  these can then be modified by wrapping each element with a
subroutine, filtering elements, or combining generators with other generators.
all of this behavior is lazy, only resolving generator elements at the latest
possible time.

all generator functions return a blessed and overloaded reference to a tied
array.  this may sound a bit magical, but it just means that you can access
the generator in a variety of ways, all which remain lazy.

given the generator:

    my $gen = gen {$_**2} range 0, 100;
          or  gen {$_**2} 0, 100;
          or  range(0, 100)->map(sub {$_**2});
          or  <0..100>->map('**2');
          or  <**2 for 0..100>;

which describes the sequence of C< n**2 for n from 0 to 100 by 1 >:

     0 1 4 9 16 25 ... 9604 9801 10000

the following lines are equivalent (each prints C<'25'>):

    say $gen->get(5);
    say $gen->(5);
    say $gen->[5];
    say $gen->drop(5)->head;
    say $gen->('5..')->head;

as are these (each printing C<'25 36 49 64 81 100'>):

    say "@$gen[5 .. 10]";
    say join ' ' => $gen->slice(5 .. 10);
    say join ' ' => $gen->(5 .. 10);
    say join ' ' => @$gen[5 .. 10];
    say $gen->slice(range 5 => 10)->str;
    say $gen->drop(5)->take(6)->str;
    say $gen->(<5..10>)->str;
    say $gen->('5..10')->str;

=back

=head3 generators as arrays

=over 4

you can access generators as if they were array references. only the requested
indicies will be generated.

    my $range = range 0, 1_000_000, 0.2;
              # will produce 0, 0.2, 0.4, ... 1000000

    say "@$range[10 .. 15]";       # calculates 6 values: 2 2.2 2.4 2.6 2.8 3

    my $gen = gen {$_**2} $range;  # attaches a generator function to a range

    say "@$gen[10 .. 15]";         # '4 4.84 5.76 6.76 7.84 9'

    for (@$gen) {
        last if $_ > some_condition;
            # the iteration of this loop is lazy, so when exited
            # with `last`, no extra values are generated
        ...
    }

=back

=head3 generators in loops

=over 4

evaluation in each of these looping examples remains lazy.  using C< last > to
escape from the loop early will result in some values never being generated.

    ... for @$gen;
    for my $x (@$gen) {...}
    ... while <$gen>;
    while (my ($next) = $gen->()) {...}

there are also looping methods, which take a subroutine. calling C< last > from
the subroutine works the same as in the examples above.

    $gen->do(sub {...}); or ->each

    For {$gen} sub {
        ... # indirect object syntax
    };

there is also a user space subroutine named C< &last > that is installed into
the calling namespace during the execution of the loop.  calling it without
arguments has the same function as the builtin C< last >.  calling it with an
argument will still end the looping construct, but will also cause the loop to
return the argument.  the C< done ... > exception also works the same way as
C< &last(...) >

    my $first = $gen->do(sub {&last($_) if /something/});
    # same as:  $gen->first(qr/something/);

you can use generators as file handle iterators:

    local $_;
    while (<$gen>) {  # calls $gen->next internally
        # do something with $_
    }

=back

=head3 generators as objects

all generators have the following methods by default

=over 4

=item * B<iteration>:

    $gen->next       # iterates over generator ~~ $gen->get($gen->index++)
    $gen->()         # same.  iterators return () when past the end

    $gen->more       # test if $gen->index not past end
    $gen->reset      # reset iterator to start
    $gen->reset(4)   # $gen->next returns $$gen[4]
    $gen->index      # fetches the current position
    $gen->index = 4  # same as $gen->reset(4)
    $gen->nxt        # next until defined
    $gen->iterator   # returns the $gen->next coderef iterator

=item * B<indexing>:

    $gen->get(index)     # returns $$gen[index]
    $gen->(index)        # same

    $gen->slice(4 .. 12) # returns @$gen[4 .. 12]
    $gen->(4 .. 12)      # same

    $gen->size           # returns 'scalar @$gen'
    $gen->all            # same as list context '@$gen' but faster
    $gen->list           # same as $gen->all

=item * B<printing>:

    $gen->join(' ')      # join ' ', $gen->all
    $gen->str            # join $", $gen->all (recursive with nested generators)
    $gen->str(10)        # limits generators to 10 elements
    $gen->perl           # serializes the generator in array syntax (recursive)
    $gen->perl(9)        # limits generators to 9 elements
    $gen->perl(9, '...') # prints ... at the end of each truncated generator
    $gen->print(...);    # print $gen->str(...)
    $gen->say(...);      # print $gen->str(...), $/
    $gen->say(*FH, ...)  # print FH $gen->str(...), $/
    $gen->dump(...)      # print $gen->perl(...), $/
    $gen->debug          # carps debugging information
    $gen->watch(...)     # prints ..., value, $/ each time a value is requested

=item * B<eager looping>:

    $gen->do(sub {...})  # for (@$gen) {...} # but faster
    $gen->each(sub{...}) # same

=item * B<slicing>:

    $gen->head     # $gen->get(0)
    $gen->tail     # $gen->slice(<1..>)  # lazy slices
    $gen->drop(2)  # $gen->slice(<2..>)
    $gen->take(4)  # $gen->slice(<0..3>)
    $gen->x_xs     # ($gen->head, $gen->tail)

=item * B<accessors>:

    $gen->range   # range(0, $gen->size - 1)
    $gen->keys    # same as $gen->range, but a list in list context
    $gen->values  # same as $gen, but a list in list context
    $gen->kv      # zip($gen->range, $gen)
    $gen->pairs   # same as ->kv, but each pair is a tuple (array ref)

=item * B<randomization>:

    $gen->pick     # return a random element from $gen
    $gen->pick(n)  # return n random elements from $gen
    $gen->roll     # same as pick
    $gen->roll(n)  # pick and replace
    $gen->shuffle  # a lazy shuffled generator
    $gen->random   # an infinite generator that returns random elements

=item * B<searching>:

    $gen->first(sub {$_ > 5})  # first {$_ > 5} $gen->all # but faster
    $gen->first('>5')          # same
    $gen->last(...)            # $gen->reverse->first(...)
    $gen->first_idx(...)       # same as first, but returns the index
    $gen->last_idx(...)

=item * B<sorting>:

    $gen->sort                   # sort $gen->all
    $gen->sort(sub {$a <=> $b})  # sort {$a <=> $b} $gen->all
    $gen->sort('<=>')            # same
    $gen->sort('uc', 'cmp')      # does:  map  {$$_[0]}
                                 #        sort {$$a[1] cmp $$b[1]}
                                 #        map  {[$_ => uc]} $gen->all

=item * B<reductions>:

    $gen->reduce(sub {$a + $b})  # reduce {$a + $b} $gen->all
    $gen->reduce('+')            # same
    $gen->sum         # $gen->reduce('+')
    $gen->product     # $gen->reduce('*')
    $gen->scan('+')   # [$$gen[0], sum(@$gen[0..1]), sum(@$gen[0..2]), ...]
    $gen->min         # min $gen->all
    $gen->max         # max $gen->all

=item * B<transforms>:

    $gen->cycle       # infinite repetition of a generator
    $gen->rotate(1)   # [$gen[1], $gen[2] ... $gen[-1], $gen[0]]
    $gen->rotate(-1)  # [$gen[-1], $gen[0], $gen[1] ... $gen[-2]]
    $gen->uniq        # $gen->filter(do {my %seen; sub {not $seen{$_}++}})
    $gen->deref       # tuples($a, $b)->deref  ~~  zip($a, $b)

=item * B<combinations>:

    $gen->zip($gen2, ...)  # takes any number of generators or array refs
    $gen->cross($gen2)     # cross product
    $gen->cross2d($gen2)   # returns a 2D generator containing the same
                           # elements as the flat ->cross generator
    $gen->tuples($gen2)    # tuples($gen, $gen2)

the C< zip > and the C< cross > methods all use the comma operator (C< ',' >)
by default to join their arguments.  if the first argument to any of these
methods is code or a code like string, that will be used to join the arguments.
more detail in the overloaded operators section below

    $gen->zip(',' => $gen2)  # same as $gen->zip($gen2)
    $gen->zip('.' => $gen2)  # $gen[0].$gen2[0], $gen[1].$gen2[1], ...

=item * B<introspection>:

    $gen->type        # returns the package name of the generator
    $gen->is_mutable  # can the generator change size?

=item * B<utility>:

    $gen->apply  # causes a mutable generator to determine its true size
    $gen->clone  # copy a generator, resets the index
    $gen->copy   # copy a generator, preserves the index
    $gen->purge  # purge any caches in the source chain

=item * B<traversal>:

    $gen->leaves  # returns a coderef iterator that will perform a depth first
                  # traversal of the edge nodes in a tree of nested generators.
                  # a full run of the iterator will ->reset all of the internal
                  # generators

=item * B<while>:

    $gen->while(...)       # While {...} $gen
    $gen->take_while(...)  # same
    $gen->drop_while(...)  # $gen->drop( $gen->first_idx(sub {...}) )

    $gen->span           # collects $gen->next calls until one
                         # returns undef, then returns the collection.
                         # ->span starts from and moves the ->index
    $gen->span(sub{...}) # span with an argument splits the list when the code
                         # returns false, it is equivalent to but more efficient
                         # than ($gen->take_while(...), $gen->drop_while(...))
    $gen->break(...)     # $gen->span(sub {not ...})

=item * B<tied vs methods>:

the methods duplicate and extend the tied functionality and are necessary when
working with indices outside of perl's array limit C< (0 .. 2**31 - 1) > or when
fetching a list return value (perl clamps the return to a scalar with the array
syntax). in all cases, they are also faster than the tied interface.

=item * B<functions as methods>:

most of the functions in this package are also methods of generators, including
by, every, mapn, gen, map (alias of gen), filter, grep (alias of filter), test,
cache, flip, reverse (alias of flip), expand, collect, overlay, mutable, while,
until, recursive, rec (alias of recursive).

    my $gen = (range 0, 1_000_000)->gen(sub{$_**2})->filter(sub{$_ % 2});
    #same as: filter {$_ % 2} gen {$_**2} 0, 1_000_000;

=item * B<dwim code>:

when a method takes a code ref, that code ref can be specified as a string
containing an operator and an optional curried argument (on either side)

    my $gen = <0 .. 1_000_000>->map('**2')->grep('%2'); # same as above

you can prefix C< ! > or C< not > to negate the operator:

    my $even = <1..>->grep('!%2');  # sub {not $_ % 2}

you can even use a typeglob to specify an operator when the method expects a
binary subroutine:

    say <1 .. 10>->reduce(*+);  # 55  # and saves a character over '+'

or a regex ref:

    <1..30>->grep(qr/3/)->say; # 3 13 23 30

you can flip the arguments to a binary operator by prefixing it with C< R > or
by applying the C< ~ > operator to it:

    say <a..d>->reduce('R.'); # 'dcba'  # lowercase r works too
    say <a..d>->reduce(~'.'); # 'dcba'
    say <a..d>->reduce(~*.);  # 'dcba'

=item * B<methods without return values>:

the methods that do not have a useful return value, such as C<< ->say >>,
return the same generator they were called with.  this lets you easily insert
these methods at any point in a method chain for debugging.

=back

=head3 predicates

=over 4

several predicates are available to use with the filtering methods:

    <1..>->grep('even' )->say(5); # 2 4 6 8 10
    <1..>->grep('odd'  )->say(5); # 1 3 5 7 9
    <1..>->grep('prime')->say(5); # 2 3 5 7 11
    <1.. if prime>->say(5);       # 2 3 5 7 11

    others are: defined, true, false

=back

=head3 lazy slices

=over 4

if you call the C< slice > method with a C< range > or other numeric generator
as its argument, the method will return a generator that will perform the slice

   my $gen = gen {$_ ** 2};
   my $slice = $gen->slice(range 100 => 1000); # nothing calculated

   say "@$slice[5 .. 10]"; # 6 values calculated

or using the glob syntax:

   my $slice = $gen->slice(<100 .. 1000>);

infinite slices are fine:

   my $tail = $gen->slice(<1..>);

lazy slices also work with the dwim code-deref syntax:

   my $tail = $gen->(<1..>);

stacked continuous lazy slices collapse into a single composite slice for
efficiency

    my $slice = $gen->(<1..>)->(<1..>)->(<1..>);

    $slice == $gen->(<3..>);

if you choose not to import the C< glob > function, you can still write ranges
succinctly as strings, when used as arguments to slice:

    my $tail = $gen->('1..');
    my $tail = $gen->slice('1..');

=back

=head3 dwim code dereference

=over 4

when dereferenced as code, a generator decides what do do based on the
arguments it is passed.

    $gen->()          ~~  $gen->next
    $gen->(1)         ~~  $gen->get(1) or $$gen[1]
    $gen->(1, 2, ...) ~~  $gen->slice(1, 2, ...) or @$gen[1, 2, ...]
    $gen->(<1..>)     ~~  $gen->slice(<1..>) or $gen->tail

if passed a code ref or regex ref, C<< ->map >> will be called with the argument,
if passed a reference to a code ref or regex ref, C<< ->grep >> will be called.

    my $pow2 = <0..>->(sub {$_**2});  # calls ->map(sub{...})
    my $uc   = $gen->(\qr/[A-Z]/);    # calls ->grep(qr/.../)

you can lexically enable code coercion from strings (experimental):

    local $FAST::List::Gen::DWIM_CODE_STRINGS = 1;

    my $gen = <0 .. 1_000_000>->('**2')(\'%2');
                                 ^map   ^grep

due to some scoping issues, if you want to install this dwim coderef into
a subroutine, the reliable way is to call the C<< ->code >> method:

    *fib = <0, 1, *+*...>->code;  # rather than *fib = \&{<0, 1, *+*...>}

=back

=head3 overloaded operators

=over 4

to make the usage of generators a bit more syntactic the following operators
are overridden:

    $gen1 x $gen2      ~~  $gen1->cross($gen2)
    $gen1 x'.'x $gen2  ~~  $gen1->cross('.', $gen2)
                       or  $gen1->cross(sub {$_[0].$_[1]}, $gen2)
    $gen1 x sub{$_[0].$_[1]} x $gen2  # same as above

    $gen1 + $gen2      ~~  sequence $gen1, $gen2
    $g1 + $g2 + $g3    ~~  sequence $g1, $g2, $g3 # or more

    $gen1 | $gen2      ~~  $gen1->zip($gen2)
    $gen1 |'+'| $gen2  ~~  $gen1->zip('+', $gen2)
                       or  $gen1->zip(sub {$_[0] + $_[1]}, $gen2)
    $gen1 |sub{$_[0]+$_[1]}| $gen2  # same as above

    $x | $y | $z       ~~  $x->zip($y, $z)
    $w | $x | $y | $z  ~~  $w->zip($x, $y, $z) # or more

if the first argument to a C<< ->zip >> or C<< ->cross >> method is not an
array or generator, it is assumed to be a subroutine and the corresponding
C<< ->(zip|cross)with >> method is called:

    $gen1->zipwith('+', $gen2)  ~~  $gen1->zip('+', $gen2);

B<hyper operators>:

not quite as elegant as perl6's hyper operators, but the same idea.  these are
similar to C< zipwith > but with more control over the length of the returned
generator.  all of perl's non-mutating binary operators are available to use as
strings, or you can use a subroutine.

    $gen1 <<'.'>> $gen2  # longest list
    $gen1 >>'+'<< $gen2  # equal length lists or error
    $gen1 >>'-'>> $gen2  # length of $gen2
    $gen1 <<'=='<< $gen2 # length of $gen1

    $gen1 <<sub{...}>> $gen2
    $gen1 <<\&some_sub>> $gen2

    my $x = <1..> <<'.'>> 'x';

    $x->say(5); # '1x 2x 3x 4x 5x'

in the last example, a bare string is the final element, and precedence rules
keep everything working.  however, if you want to use a non generator as the
first element, a few parens are needed to force the evaluation properly:

    my $y = 'y' <<('.'>> <1..>);

    $y->say(5); # 'y1 y2 y3 y4 y5'

otherwise C<<< 'y' << '.' >>> will run first without overloading, which will be
an error. since that is a bit awkward, where you can specify an operator string,
you can prefix C< R > or C< r > to indicate that the arguments to the operator
should be reversed.

    my $y = <1..> <<'R.'>> 'y';

    $y->say(5); # 'y1 y2 y3 y4 y5'

just like in perl6, hyper operators are recursively defined for multi
dimensional generators.

    say +(list(<1..>, <2..>, <3..>) >>'*'>> -1)->perl(4, '...')

    # [[-1, -2, -3, -4, ...], [-2, -3, -4, -5, ...], [-3, -4, -5, -6, ...]]

hyper operators currently do not work with mutable generators.  this will be
addressed in a future update.

you can also specify the operator in a hyper-operator as a typeglob:

    my $xs = <1..> >>*.>> 'x';  #  *. is equivalent to '.'

    $xs->say(5); # 1x 2x 3x 4x 5x

    my $negs = <0..> >>*-;  # same as: <0..> >>'-'

    $negs->say(5); # 0 -1 -2 -3 -4

hyper also works as a method:

    <1..>->hyper('<<.>>', 'x')->say(5); # '1x 2x 3x 4x 5x'
    # defaults to '<<...>>'
    <1..>->hyper('.', 'x')->say(5);     # '1x 2x 3x 4x 5x'

hyper negation can be done directly with the prefix minus operator:

    -$gen  ~~  $gen >>'-'  ~~  $gen->hyper('-')

=back

=head3 mutable generators

=over 4

mutable generators (those returned from mutable, filter, While, Until, and
iterate_multi) are generators with variable length.  in addition to all normal
methods, mutable generators have the following methods:

    $gen->when_done(sub {...})  # schedule a method to be called when the
                                # generator is exhausted
                                # when_done can be called multiple times to
                                # schedule multiple end actions

    $gen->apply;  # causes the generator to evaluate all of its elements in
                  # order to find out its true size.  it is a bad idea to call
                  # ->apply on an infinite generator

due to the way perl processes list operations, when perl sees an expression
like:

    print "@$gen\n"; # or
    print join ' ' => @$gen;

it calls the internal C< FETCHSIZE > method only once, before it starts getting
elements from the array.  this is fine for immutable generators.  however, since
mutable generators do not know their true size, perl will think the array is
bigger than it really is, and will most likely run off the end of the list,
returning many undefined elements, or throwing an exception.

the solution to this is to call C<< $gen->apply >> first, or to use the
C<< $gen->all >> method with mutable generators instead of C< @$gen >, since
the C<< ->all >> method understands how to deal with arrays that can change size
while being read.

perl's C< for/foreach > loop is a bit smarter, so just like immutable
generators, the mutable ones can be dereferenced as the loop argument with no
problem:

    ... foreach @$mutable_generator;  # works fine

=back

=head3 stream generators

=over 4

the generators C<filter>, C<scan>, and C<iterate> (all of its flavors) have
internal caches that allow random access within the generator.  some algorithms
only need monotonically increasing access to the generator (all access via
repeated calls to C<< $gen->next >> for example), and the cache could become a
performance/memory problem.

the C< *_stream > family of generators do not maintain an internal cache, and
are subsequently unable to fulfill requests for indicies lower than or equal to
the last accessed index.  they will however be faster and use less memory than
their non-stream counterparts when monotonically increasing access is all that
an algorithm needs.

stream generators can be thought of as traditional subroutine iterators that
also have generator methods.  it is up to you to ensure that all operations and
methods follow the monotonically increasing index rule.  you can determine the
current position of the stream iterator with the C<< $gen->index >> method.

    my $nums = iterate_stream{2*$_}->from(1);

    say $nums->();    # 1
    say $nums->();    # 2
    say $nums->();    # 4
    say $nums->index; # 3
    say $nums->drop( $nums->index )->str(5);  # '8 16 32 64 128'
    say $nums->index; # 8

the C<< $gen->drop( $gen->index )->method >> pattern can be shortened to
C<< $gen->idx->method >>

    say $nums->idx->str(5); # '256 512 1024 2048 4096'

the C<< $gen->index >> method of stream generators is read only.  calling
C<< $gen->reset >> on a stream generator will throw an error.

stream generators are experimental and may change in future versions.

=back

=head3 threads

=over 4

generators have the following multithreaded methods:

    $gen->threads_blocksize(3) # sets size to divide work into
    $gen->threads_cached;      # implements a threads::shared cache
    $gen->threads_cached(10)   # as normal, then calls threads_start with arg

    $gen->threads_start;    # creates 4 worker threads
    $gen->threads_start(2); # or however many you want
                            # if you don't call it, threads_slice will

    my @list = $gen->threads_slice(0 .. 1000);  # sends work to the threads
    my @list = $gen->threads_all;

    $gen->threads_stop;     # or let the generator fall out of scope

all threads are local to a particular generator, they are not shared.
if the passed in generator was cached (at the top level) that cache is shared
and used automatically.  this includes most generators with implicit caches.
threads_slice and threads_all can be called without starting the threads
explicitly.  in that case, they will start with default values.

the threaded methods only work in perl versions 5.10.1 to 5.12.x, patches to
support other versions are welcome.

=back

=cut

{package
    FAST::List::Gen::Base;
    for my $sub (qw(TIEARRAY FETCH STORE STORESIZE CLEAR PUSH
                    POP SHIFT UNSHIFT SPLICE UNTIE EXTEND)) {
        no strict 'refs';
        *$sub = sub {Carp::confess "$sub(".(join ', ' => @_).") not supported"}
    }
    sub DESTROY {}
    sub source  {}
    sub FETCHSIZE {
        my $self      = shift;
        my $install   = (ref $self).'::FETCHSIZE';
        my $fsize     = $self->can('fsize');
        my $fetchsize = sub {
            my $size  = $fsize->();
            $size > 2**31-1
                  ? 2**31-1
                  : $size
        };
        no strict 'refs';
        my $size  = $fetchsize->();
        *$install = $self->mutable
                  ? $fetchsize
                  : sub {$size};
        $size
    }
    sub mutable {
       my @src = shift;
       my %seen;
       while (my $src = shift @src) {
            next if $seen{$src}++;
            return 1 if $src->isa('FAST::List::Gen::Mutable');
            if (my $source = $src->source) {
                push @src, ref $source eq 'ARRAY' ? @$source : $source
            }
       }
       ''
    }
    sub sources {
        my $self = shift;
        my $src = $self->source or return;
        if (ref $src eq 'ARRAY')
             {@$src, map $_->sources, @$src}
        else {$src, $src->sources}
    }

    sub tail_size {
        $_[1] = FAST::List::Gen::TailSize->new($_[0]->can('fsize'))
    }
    {package
        FAST::List::Gen::TailSize;
        sub new {bless [pop]}
        use overload fallback => 1, '0+' => sub {&{$_[0][0]}}
    }

    sub closures {
        map {
            Scalar::Util::reftype($_[0]) eq 'HASH' && $_[0]{$_}
            or $_[0]->can($_)
            or Carp::confess("no $_ on $_[0]")
        } qw (FETCH fsize)
    }
}

    my $op2cv = do {
        my %unary_only = map {$_ => 1} qw (! \ ~);
        my %unary_ok   = map {$_ => 1} qw (+ - not);
        sub {
            my $op  = shift;
            my $src = $unary_only{$op} ? "sub {\@_ ? $op \$_[0] : $op \$_}"
                : 'sub ($$) {'.
                    ($unary_ok{$op} ? "
                        if (\@_ == 0) {return ($op \$_)}
                        if (\@_ == 1) {return ($op \$_[0])}
                    " : "
                        if (\@_ == 0) {return (\$a $op \$b)}
                        if (\@_ == 1) {Carp::croak(q(too few arguments for '$op'))}
                    ") ."
                        if (\@_ == 2) {return (\$_[0] $op \$_[1])}
                        reduce {\$a $op \$b} \@_
                }";
            eval $src or die "$@\n$src"
        }
    };
    my %ops = map {$_ => $_->$op2cv} qw (
        + - / * ** x % . & | ^ < >  << >> <=> cmp lt gt eq ne le ge == != <= >=
        and or xor && || =~ !~
        ! \ ~
    );
    my $ops = join '|' =>
              map  {('\b' x /^\w/).(quotemeta).('\b' x /\w$/)}
              sort {length $b <=> length $a}
              grep {$_ ne '\\'}
              keys %ops, ',';

    $ops{','}     = my $comma  = sub ($$) {$_[0], $_[1]};
    $ops{'R,'}    =
    $ops{'r,'}    = my $rcomma = sub ($$) {$_[1], $_[0]};
    $ops{even}    = sub ($) {  not + (@_ ? $_[0] : $_) % 2};
    $ops{odd}     = sub ($) {        (@_ ? $_[0] : $_) % 2};
    $ops{defined} = sub ($) {defined (@_ ? $_[0] : $_)};
    $ops{true}    = sub ($) {not not  @_ ? $_[0] : $_};
    $ops{false}   = sub ($) {    not  @_ ? $_[0] : $_};
    $ops{reverse} = sub ($) {scalar reverse (@_ ? $_[0] : $_)};
    $ops{say}     = sub ($) {print @_ ? @_ : $_, $/; @_ ? @_[0..$#_] : $_};

    $sv2cv = sub {
        defined $_[0] or croak 'an undefined value can not be coerced into code';
        local $_ = $_[0];
        return $_ if ref and reftype($_) eq 'CODE';
        $_[0] = ($ops{$_} or do {
            $ops{$_} = do {
                if (ref eq ref qr//) {
                    my $re = $_;
                    sub {/$re/}
                }
                elsif (ref \$_ eq 'GLOB') {
                    my $op = B::svref_2object(\$_)->NAME;
                    $ops{$op} or $op->$sv2cv
                }
                elsif (ref and overload::Method($_, '&{}')) {
                    \&{$_}
                }
                elsif ($ops{~$_}
                   or /^[Rr]\s*($ops)\s*$/
                   or ~$_ =~ /^\*main::($ops)$/
                ) {
                    my $op = $ops{$1 ? $1 : ~$_};
                    sub ($$) {$op->(reverse @_)}
                }
                elsif (/[\$\@]\s*_\b/) {
                    '$_/@_'->$eval("sub (\$) {$_}")
                }
                elsif (/\$a(?:\b|$)/ and /\$b(?:\b|$)/) {
                    # $a $b:
                        s{\$a(?:\b(?!\s*[\[\}])|$)} '$_[0]'gx;
                        s{\$b(?:\b(?!\s*[\[\}])|$)} '$_[1]'gx;
                    # $a[1] $b[1]:
                        s{(?<!\$)\$a(?:\b|$)} '${$_[0]}'gx;
                        s{(?<!\$)\$b(?:\b|$)} '${$_[1]}'gx;
                    # $$a[1] $$b[1]:
                        s{\$a(?:\b|$)} '${\$_[0]}'gx;
                        s{\$b(?:\b|$)} '${\$_[1]}'gx;

                    '$a $b'->$eval('sub ($$) '."{$_}")
                }
                elsif (not m[/.+/]
                  and /^ \s* ( ! | not\b | ) \s*
                      (?: (.+?) \s* ($ops) | ($ops) \s* (.+?) )
                      \s* $/x
                ) {
                    my $arg =      $2 ? $2 : $5;
                    my $op  = $ops{$2 ? $3 : $4};
                    if ($1) {
                        my $normal = $op;
                        $op = sub {not &$normal}
                    }
                    $arg = 'curry'->$eval($arg) unless looks_like_number $arg;
                    $2 ? sub ($) {$op->($arg, @_ ? $_[0] : $_)}
                       : sub ($) {$op->(@_ ? $_[0] : $_, $arg)}
                }
                elsif (/^[a-zA-Z_][\w\s]*$/) {
                    'bareword'->$eval("sub (\$) {$_(\$_)}")
                }
                elsif (/^ \s*(?:not|!|)\s* (?: ( [sy] | tr ) | m | (?=\s*\/) ) \s*
                       ( [^\w\s] | (?<= \s )\w ) .* (?: \2 | [\}\)\]] )
                       [a-z]* \s* $/x
                ) {
                    $_ = '(my $x = $_) =~ '.$_.'; $x' if $1;
                    'regex'->$eval("sub (\$) {$_}")
                }
            }
        } or Carp::croak "error, no dwim code type found for: '$_[0]'")
    };

{package
    FAST::List::Gen::Hyper;
    use overload fallback => 1,
        '&{}' => sub {\&{$_[0]->self}},
        map {
           my $op = $_;
           $op => sub {
               my ($x, $y, $flip) = @_;
               hyper ($flip ? ($y, $op, @$x) : (@$x, $op, $y))
           }
        } qw (<< >>);
    sub DESTROY {}
    sub AUTOLOAD {
        my ($method) = our $AUTOLOAD =~ /([^:']+)$/;
        my ($op, $gen) = @{$_[0]}[FAST::List::Gen::isagen($_[0][0]) ? (2,0) : (0,2)];
        $gen->hyper($op)->$method(@_[1..$#_])
    }
    my %cache;
    sub hyper {
        my ($left, $lh, $code, $rh, $right) = @_;
        $code->$sv2cv unless ref $code eq 'CODE';
        for ($left, $right) {
            next if &FAST::List::Gen::isagen($_);
            my $src = $_;
            if (ref $src eq 'ARRAY') {
                $_ = &FAST::List::Gen::makegen($src);
            } else {
                $_ = &FAST::List::Gen::gen(sub {$src}, 1);
            }
        }
        if ($left->is_mutable or $right->is_mutable) {
            Carp::croak('hyper operators not yet supported with mutable generators')
        } else {
            my ($lsize, $rsize) = map tied(@$_)->fsize => $left, $right;
            my $size =
                ($lh eq '<<' and $rh eq '>>') ? List::Util::max($lsize, $rsize)
               : $lh eq '<<'                  ? $rsize
               : $rh eq '>>'                  ? $lsize
               : do {
                    Carp::croak("unequal size lists passed to non-dwimmy hyper")
                        if $lsize != $rsize;
                    $lsize
               };
            for my $src (($lh eq '<<' and $lsize < $size) ? $left  : (),
                         ($rh eq '>>' and $rsize < $size) ? $right : ()) {
                my $fetch    = tied(@$src)->can('FETCH');
                my $src_size = tied(@$src)->fsize;
                $src = &FAST::List::Gen::gen(sub {$fetch->(undef, $_ % $src_size)}, $size)
            }
            my ($lfetch, $rfetch) = map tied(@$_)->can('FETCH') => $left, $right;
            $code == $comma
                ? &FAST::List::Gen::gen(sub {
                    my $got = $_ % 2 ? $rfetch->(undef, int($_/2))
                                     : $lfetch->(undef, int($_/2));
                    if (ref $got) {
                        if (ref $got eq 'ARRAY' or FAST::List::Gen::isagen($got)) {
                            Carp::croak("hyper comma not yet supported with multi-dimentional generators");
                            #my $other   = ($_ % 2 ? $lfetch : $rfetch)->(undef, int($_/2));
                            #my ($l, $r) =  $_ % 2 ? ($other, $got) : ($got, $other);
                            #return $cache{join $; => $l, $lh, $code, $rh, $r}
                            #               ||= hyper($l, $lh, $code, $rh, $r);
                        }
                    }
                    $got
                }, $size * 2)
                : &FAST::List::Gen::gen(sub {
                    my $l = $lfetch->(undef, $_);
                    my $r = $rfetch->(undef, $_);
                    for (grep ref, $l, $r) {
                        if (ref $_ eq 'ARRAY' or &FAST::List::Gen::isagen($_)) {
                            return $cache{join $; => $l, $lh, $code, $rh, $r}
                                           ||= hyper($l, $lh, $code, $rh, $r)
                        }
                    }
                    $code->($l, $r)
                }, $size)
        }
    }
}
{
    my $build; BEGIN {$build = sub {
        my $method = shift;
        sub {
            my ($self, $ys, $flip) = @_;
            my ($code, $xs) = @$self{qw(code xs)};
            $code->$sv2cv;
            ($xs, $ys) = ($ys, $xs) if $flip;
            for ($xs, $ys) {
                next if isagen(my $x = $_);
                $_ = ref && reftype($_) eq 'ARRAY'
                    ? &makegen($_)
                    : $method eq 'zip'
                        ? &repeat($x)
                        : &list($x)
            }
            $xs->$method($code, $ys)
        }
    }}
    package
        FAST::List::Gen::xWith;
        my $end = qr/([^:]+)$/;
        sub AUTOLOAD {
            my ($self)    = $_[0];
            my ($xWith)   = map lc, ref($self) =~ $end;
            my ($method)  = our $AUTOLOAD      =~ $end;
            my ($xs, $ys) = @$self{qw(xs ys)};
            unless ($ys->$isagen) {
                my $y = $ys;
                $ys = $xWith eq 'zip' ? &FAST::List::Gen::repeat($y)
                                      : &FAST::List::Gen::list($y)
            }
            ($xs, $ys) = ($ys, $xs) if $$self{flip};

            $_[0] = $xs->$xWith($ys);

            goto &{$_[0]->can($method)
                or Carp::croak "no method '$method' on $_[0]"}
        }
        sub DESTROY {}
    package
        FAST::List::Gen::xWith::Cross;
        our @ISA = 'FAST::List::Gen::xWith';
        use overload fallback => 1, 'x' => $build->('cross');
    package
        FAST::List::Gen::xWith::Zip;
        our @ISA = 'FAST::List::Gen::xWith';
        use overload fallback => 1, '|' => $build->('zip');
}
{package
    FAST::List::Gen::erator;
    FAST::List::Gen::DEBUG or $Carp::Internal{ (__PACKAGE__) }++;
    use overload fallback => 1,
        '&{}' => sub {$_[0]->_overloader},
        '<>'  => sub {$_[0]->_overloader; $_[0]->next},
        'cross:<x> zip:<|>'->${\sub {map {
            my ($method, $op) = /(.+):<(.)>/;
            my $package       = 'FAST::List::Gen::xWith::'.ucfirst $method;
            my $method_with   = $method.'with';
            $op => sub {
                my ($xs, $ys, $flip) = @_;
                my $ys_save = $ys;
                if (ref \$ys eq 'GLOB') {
                    $ys = B::svref_2object(\$ys)->NAME
                }
                $ys = $ops{$ys} if $ops{$ys};
                if (not ref $ys or ref $ys eq 'CODE') {
                    return bless {
                        flip => $flip,
                        code => $ys,
                        ys   => $ys_save,
                        xs   => $xs,
                    } => $package
                }
                if (ref $ys eq $package) {
                    (my $code, $ys) = @$ys{qw(code xs)};
                    $code->$sv2cv;
                    ($xs, $ys) = ($ys, $xs) if $flip;
                    return $code == $comma
                           ? $xs->$method($ys)
                           : $xs->$method_with($code, $ys)
                }

                if (ref $ys eq 'ARRAY') {
                    $ys = &FAST::List::Gen::makegen($ys)
                }

                for ([xs => $xs], [ys => $ys]) {
                    my ($n, $s) = @$_;
                    if ($s->type =~ /FAST::List::Gen::(Zip)/) {
                        my $type = lc $1;
                        if ($type eq $method) {
                            my $src   = tied(@$s)->source;
                            my $other = $n eq 'xs' ? $ys : $xs;
                            my @other = $other->type =~ /FAST::List::Gen::$type/i
                                            ? @{tied(@$other)->source}
                                            : tied @$other;
                            return FAST::List::Gen::tiegen(
                                ucfirst $type =>
                                    $n eq 'ys' ? (@other, @$src)
                                               : (@$src, @other)
                            )
                        }
                    }
                }
                ($xs, $ys) = ($ys, $xs) if $flip;
                $xs->$method($ys)
            }
        } split /\s+/, shift}},
        '+' => sub {
            my ($x, $y, $flip) = @_;
            ($x, $y) = ($y, $x) if $flip;
            FAST::List::Gen::sequence($x, $y);
        },
        (map {
            (my $op = $_) =~ s/neg/-/;
            $_ => sub {$_[0]->hyper($op)}
        } qw (neg ! ~)),
        do {
            my %unary = map {
                (my $op = $_) =~ s/^u//i;
                $_ => (eval (m/(..)(.)/?"sub {$1\$_[0]$2}":"sub {$op \$_[0]}") or die $@)
            } qw (! ~ \ @{} ${} %{} &{} *{} U- U+ u- u+);
            map {
                my $op = $_;
                $op => sub {
                    my ($x, $y, $flip) = @_;
                    if (my $code = $unary{$y}) {
                        return $x->hyper($code);
                    }
                    ($x, $y) = ($y, $x) if $flip;
                    bless [$x, $op, $y] => 'FAST::List::Gen::Hyper';
                }
            } qw (<< >>)
        };

    #END {defined &$_ and print "$_\n"
    #       for sort {lc $a cmp lc $b} keys %FAST::List::Gen::erator::}
    my $l2g = \&FAST::List::Gen::list;

    sub new {
        goto &_new if $STRICT;
        bless $_[1] => 'FAST::List::Gen::era::tor'}
    {package
        FAST::List::Gen::era::tor;
        our @ISA = 'FAST::List::Gen::erator';
        my $force = sub {FAST::List::Gen::erator->_new($_[0])};

        tie my @by, 'FAST::List::Gen::By', 2, [1..10];
        my $by = FAST::List::Gen::erator->_new(\@by);
        no strict 'refs';
        for my $proxy (grep /[a-z]/, keys %{ref($by).'::'}) {
            *$proxy = $proxy eq 'index'
                    ? sub :lvalue {&$force->index}
                    : sub {goto & {&$force->can($proxy)}}
        }
        sub DESTROY {}
    }
    {
        my %code_ok = map {ref, 1} sub {}, qr {};
        my $croak_msg = 'not supported in dwim generator code dereference';
        sub _new {
            package FAST::List::Gen;
            my ($class, $gen) = @_;
            my $src = tied @$gen;
            weaken $gen;
            my ($fetch, $fsize) = $src->closures;
            my $index   = ($src->can('index') or sub {0})->();
            my $size    = $fsize->();
            my $mutable = $src->mutable;
            if($mutable) {
                $src->tail_size($size)
            }
            my $dwim_code_strings = $DWIM_CODE_STRINGS;
            my $overload = sub {
                if (@_ == 0) {
                    ref $index
                     ? $$index < $size ? $fetch->(undef, $$index  ) : ()
                     :  $index < $size ? $fetch->(undef,  $index++) : ()
                }
                elsif (@_ == 1) {
                    if    (looks_like_number($_[0])) {$fetch->(undef, $_[0])}
                    elsif (ref $_[0]) {
                        if (isagen($_[0])) {slice($gen, $_[0])}
                        elsif ($code_ok{ref $_[0]}) {
                            $gen->map($_[0])
                        }
                        elsif (ref $_[0] eq 'REF' && $code_ok{ref ${$_[0]}}
                           or  $dwim_code_strings && ref $_[0] eq 'SCALAR'
                        ) {
                            $gen->grep(${$_[0]})
                        }
                        else {croak "reference '$_[0]' $croak_msg"}
                    }
                    elsif (canglob($_[0]))     {slice($gen, $_[0])}
                    elsif ($dwim_code_strings) { $gen->map ($_[0])}
                    else  {croak "value '$_[0]' $croak_msg"}
                }
                else {unshift @_, $gen; goto &{$gen->can('slice')}}
            };
            curse {
                -bless      => $gen,
                _overloader => sub {
                    eval qq {
                        package @{[ref $_[0]]};
                        use overload fallback => 1, '&{}' => sub {\$overload},
                                                     '<>' => \\&next;
                        local *DESTROY;
                        bless []; 1
                    } or croak "overloading failed: $@";
                    $overload
                },
                size  => $fsize,
                get   => $fetch,
                slice => sub {shift;
                    @_ == 1 and (isagen($_[0]) or canglob($_[0]))
                        and return slice($gen, $_[0]);
                    if ($mutable) {
                        my @ret;
                        for my $i (@_) {
                            $i < $size or next;
                            my @x = \($fetch->(undef, $i));
                            $i < $size or next;
                            push @ret, @x;
                        }
                        wantarray ? map $$_ => @ret
                           : $l2g->(map $$_ => @ret)
                    }
                    else {
                        wantarray ? map $fetch->(undef, $_) => @_
                           : $l2g->(map $fetch->(undef, $_) => @_)
                    }
                },
                index => ref $index ? sub {$$index} : sub :lvalue {$index},
                more  => ref $index ? sub {$$index < $size} : sub {$index < $size},
                next  => ref $index
                     ? sub {$$index < $size ? $fetch->(undef, $$index  ) : ()}
                     : sub { $index < $size ? $fetch->(undef,  $index++) : ()},
            } => $class
        }
    }
    sub reset {
        tied(@{$_[0]})->can('index')
            and Carp::croak "can not call ->reset on stream generator";

        $_[0]->index = $_[1] || 0; $_[0]
    }

    sub all {
        my $gen     = shift;
        my $src     = tied @$gen;
        my $size    = $src->fsize;
        my $mutable = $src->mutable;

        $mutable or $size < 2**31
            or Carp::confess "can't call ->all on ",
                $size < 9**9**9
                    ? 'generator larger than 2**31, use iteration instead'
                    : 'infinite generator';

        if (my $cap = $src->can('capture')) {
            @{ $cap->() }
        }
        elsif (my $range = $src->can('range')) {
            my ($low, $step, $size) = $range->();
            map $low + $step * $_ => 0 .. $size - 1
        }
        else {
            my $fetch = $src->can('FETCH');
            if ($mutable) {
                my ($i, @ret) = 0;
                $src->tail_size($size);
                while ($i < $size) {
                    my @got = \($fetch->(undef, $i));
                    last unless $i++ < $size;
                    push @ret, @got
                }
                map $$_ => @ret
            }
            else {
                map $fetch->(undef, $_) => 0 .. $size - 1
            }
        }
    }
    BEGIN {*list = *all}

    {my $inf;
    sub hyper {
        if (@_ == 2) {
            $inf ||= &FAST::List::Gen::range(0, 9**9**9);
            my $code = $_[1];
            unless ((ref($code)||'') eq 'CODE') {
                if (ref \$code eq 'GLOB') {
                    ($code) = $code =~ /([^:]+)$/
                } else {
                    $code =~ s/^\s*(?:<<|>>)\s*(.+?)\s*$/$1/
                }
                $code =~ /[~!-\\]/ or Carp::croak 'arg 1 to ->hyper(str) must match /(<<|>>)?[~!-\]/';
                $code = 'hyper'->$eval("sub {$code \$_[0]}")
            }
            return $_[0]->hyper('>>', $code, '>>', $inf)
        }
        if (@_ == 3) {
            if (ref \$_[1] eq 'GLOB' or $_[1] =~ /^(?:<<?|>>?|>=|<=|[^<>]+)$/) {
                return FAST::List::Gen::Hyper::hyper (
                    $_[0], '<<', $_[1], '>>', $_[2]
                )
            }
            if ($_[1] =~ /^\s*(<<?|>>?)?\s*(\S+?)\s*(<<?|>>?)?\s*$/) {

                return FAST::List::Gen::Hyper::hyper (
                    $_[0],
                        $1 ? (length $1 == 1 ? $1.$1 : $1) : '<<',
                        $2,
                        $3 ? (length $3 == 1 ? $3.$3 : $3) : '>>',
                    $_[2]
                )
            }
            Carp::croak "arg 1 to ->hyper(str, val) must match (<<|>>)op(<<|>>)";
        }
        goto &FAST::List::Gen::Hyper::hyper if @_ == 5;
        Carp::croak q{takes 1 `->hyper('-')` or 2 `->hyper('<<+>>', 1)` }.
                    q{or 4 `->hyper(qw(<< + >>), 1)` args, not }.$#_
    }}

    for my $proxy (qw(apply purge rewind)) {
        no strict 'refs';
        *$proxy = sub {
            my @src;
            my @todo = tied @{$_[0]};
            while (my $next = shift @todo) {
                unshift @src, $next;
                next if ref($next) =~ /^FAST::List::Gen::While/;
                if (my $source = $next->source) {
                    unshift @todo, ref $source eq 'ARRAY'
                                    ? @$source
                                    :  $source
                }
            }
            ($_->can($proxy) or next)->($_) for @src;
            $_[0]
        }
    }

    sub is_inf {$_[0]->size >= 9**9**9}
    sub x_xs   {$_[0]->head, $_[0]->tail}
    sub idx    {$_[0]->drop( $_[0]->index + 0 )}

    sub tee {
        my @ret;
        for (shift) {
            for my $code (@_)
                {push @ret, $code->()}}
        wantarray
            ? @ret
            : @ret > 1
                ? &FAST::List::Gen::makegen(\@ret)
                : pop @ret
    }

    BEGIN {
        *from_index = *idx;
        *s = *self = *scalar = sub {$_[0]}
    }

    sub type {(my $t = ref tied @{$_[0]}) =~ s/::_\d+$//; $t}

    sub elems {$_[0]->size}
    sub end   {$_[0]->apply->size - 1}

    {package
        FAST::List::Gen::DwimCode;
        my %save;
        sub new {
            my ($class, $gen) = @_;
            my $code = \&$gen;
            bless $code => $class;
            $save{$code} = $gen;
            $code
        }
        sub DESTROY {
            delete $save{$_[0]}
        }
    }
    sub code {FAST::List::Gen::DwimCode->new($_[0])}

    sub size_from {
        FAST::List::Gen::tiegen(Size_From => map tied @$_ => @_)
    }
    FAST::List::Gen::generator Size_From => sub {
        my ($class, $self, $from) = @_;
        FAST::List::Gen::curse {
            fsize  => $from->can('fsize'),
            FETCH  => $self->can('FETCH'),
            source => sub {[$self, $from]},
            $from->mutable ? (mutable => sub {1}) : ()
        } => $class
    };

    sub defined {$_[0]->grep('defined')}

    sub iterator {$_[0]->index; $_[0]->can('next')}
    BEGIN {*iter = *iterator}

    sub range  {&FAST::List::Gen::range(0, $_[0]->size - 1)}
    {no warnings 'once';
        *keys   = sub {wantarray ? $_[0]->range->all : $_[0]->range};
        *values = sub {wantarray ? $_[0]->all        : $_[0]};
    }
    sub kv     {&FAST::List::Gen::zip($_[0]->range, $_[0])}
    sub tuples {&FAST::List::Gen::tuples}
    sub pairs  {$_[0]->range->tuples($_[0])}

    sub sort {
        my $self = shift;
        @_ == 2 and return $self->wrapsort(@_);
        @_ == 0
            ? wantarray ? sort $self->all
                 : $l2g->(sort $self->all)
            : do {
                my $code = pop;
                $code->$sv2cv;
                my ($ca, $cb) = $code->$cv_ab_ref;
                local (*$ca, *$cb) = (*a, *b);
                wantarray ? sort $code $self->all
                   : $l2g->(sort $code $self->all)
            }
    }
    {package
        FAST::List::Gen::Wrap;
        use overload fallback => 1, '""' => sub {$_[0][1]};
    }
    sub wrap {
        my ($gen, $code) = splice @_;
        $code->$sv2cv;
        $l2g->(map {bless [$_ => &$code] => 'FAST::List::Gen::Wrap'} $gen->all)
    }
    sub unwrap {
        wantarray ? map $$_[0], $_[0]->all
           : $l2g->(map $$_[0], $_[0]->all)
    }
    sub wrapsort {
        my ($gen, $code, @by) = @_;
        $gen->wrap($code)->sort(@by)->unwrap
    }
    BEGIN {*wsort = *wrapsort}

    sub perl {
        my $src = shift;
        '[' .(join ', ' => map {
            ref $_
                ? &FAST::List::Gen::isagen($_)
                    ? $_->perl(@_)
                    : ref eq 'ARRAY'
                        ? &FAST::List::Gen::makegen($_)->perl(@_)
                        : "'$_'"
                : /^-?\d+(?:\.\d+)?$/
                    ? $_
                    : "'$_'"
            } (@_ and $_[0] < 9**9**9)
                ? $src->size <= $_[0]
                    ? $src->all
                    : $src->slice(0 .. $_[0] - 1)
                : $src->all
        ).((@_ == 2 and $_[0] < $src->size) ? ", $_[1]" : ''). ']'
    }
    sub str {
        my $src = shift;
        join defined $" ? $" : '' => $src->flat(@_)
    }
    {no warnings 'once';
    *join = sub {
        join @_ > 1 ? $_[1] : '',
             @_ > 2 ? $_[0]->take($_[2])->all : $_[0]->all,
             @_[3 .. $#_]
    }}
    sub flat {
        my $src = shift;
        map {
            ref $_
                ? &FAST::List::Gen::isagen($_)
                    ? $_->flat(@_)
                    : ref eq 'ARRAY'
                        ? &FAST::List::Gen::makegen($_)->flat(@_)
                        : $_
                : $_
        } (@_ and $_[0] < 9**9**9)
            ? $src->size <= $_[0]
                ? $src->all
                : ($src->slice(0 .. $_[0] - 1), @_ == 2 ? $_[1] : ())
            : $src->all
    }
    sub say {
        local $\ = "\n";
        &print
    }

    sub print {
        my $src = shift;
        if (@_ and Scalar::Util::openhandle($_[0])) {
            my $fh = shift;
            print $fh $src->str(@_)
        }
        else {print $src->str(@_)}
        $src
    }
    sub dump {
        local *flat = *perl;
        &say
    }
    {my $bool = sub {$_[0] ? 'yes' : 'no'};
    sub debug {
        my ($gen, $num) = (@_, 10);
        my ($max)       = map {$_ >= 9**9**9 ? 'inf' : $_} $gen->size - 1;
        my $stream      = tied(@$gen)->can('index');
        my $perl        = !$num ? ''
                        : ($stream ? 'from '.$gen->index.': ' : '')
                        . ($stream ? $gen->idx : $gen)->perl($num, '...');

        Carp::carp join '' => map {
            sprintf "%-8s %s\n", "$$_[0]:",
                $#$_ > 0 ? join ', ' => @$_[1 .. $#$_] : 'none'
        }   [debug   => $gen],
            [type    => $gen->type],
            [source  => map {ref =~ /(.+)::/} tied(@$gen)->sources],
            [mutable => $bool->($gen->is_mutable)],
            [stream  => $bool->($stream)],
            [range   => "[0 .. $max]"],
            [index   => $gen->index],
            $perl ? [perl    => $perl] :();
        $gen
    }}

    sub watch {
        my ($gen, $fh) = shift;
        my $msg = join ' ', grep {
            not (Scalar::Util::openhandle $_ and $fh = $_)
        } @_;
        $msg .= ': ' if $msg =~ /^\w+$/;
        &FAST::List::Gen::gen(sub {
            defined $\ or local $\ = $/;
            $fh ? print $fh $msg, $_
                : print     $msg, $_;
            $_
        }, $gen)
    }

    sub pick {
        my ($self, $n) = (@_, 1);
        if ($n == 1 and not $self->is_mutable) {
            my $size = $self->size;
            $self->get(int rand ($size >= 9**9**9 ? $MAX_IDX : $size))
        } else {
            my $pick = $self->shuffle->take($n);
            wantarray ? $pick->all : $pick
        }
    }
    my $wantgen = sub {wantarray ? @_ : &FAST::List::Gen::makegen(\@_)};
    sub roll {
        my ($self, $n) = (@_, 1);
        $n > 1 ? $wantgen->(map $self->pick, 1 .. $n) : $self->pick
    }

    sub random {
        my $self  = shift;
        my $size  = $self->size;
        my $fetch = tied(@$self)->can('FETCH');
        my %map;
        $self->tail_size($size) if $self->is_mutable;
        &FAST::List::Gen::gen(sub {{
            return $fetch->(undef, $map{$_}) if exists $map{$_};
            my $i = int rand ($size >= 9**9**9 ? $MAX_IDX : $size);
            my $x = $fetch->(undef, $i);
            redo unless $i < $size;
            $map{$_} = $i;
            $x
        }})
    }
    sub shuffle {
        my $src   = shift;
        my $size  = $src->size;
        my $fetch = tied(@$src)->can('FETCH');
        my (%seen, %map);
        $src->tail_size($size) if $src->is_mutable;
        &FAST::List::Gen::gen(sub {
            return $fetch->(undef, $map{$_}) if exists $map{$_};
            while (keys %seen < $size) {
                my $i = int rand ($size >= 9**9**9 ? $MAX_IDX : $size);
                my $start = $i;
                $i++ while $i < $size-1 and $seen{$i};
                $i = $start              if $seen{$i};
                $i-- while $i > 0       and $seen{$i};
                $seen{$i}++ or return $fetch->(undef, $map{$_} = $i)
            }
        })->size_from($src)
    }

    sub uniq {
        my %seen;
        &FAST::List::Gen::filter(sub {not $seen{$_}++}, $_[0])
    }

    our $first_idx;
    sub first {
        return $_[0]->get(0) if @_ == 1;
        my ($self, $code) = @_;
        $code->$sv2cv;
        my $fetch = tied(@$self)->can('FETCH');
        my $i = 0;
        local @_;
        local *_ = \undef;
        my $size = $self->size;
        if ($self->is_mutable) {
            $self->tail_size($size);
            while ($i < $size) {
                *_ = \$fetch->(undef, $i);
                return if $i >= $size;
                return $first_idx ? $i : $_ if &$code;
                $i++;
            }
        } else {
            while ($i < $size) {
                *_ = \$fetch->(undef, $i);
                return $first_idx ? $i : $_ if &$code;
                $i++;
            }
        }
        return
    }
    sub last {
        @_ == 1 ? $_[0]->get( $_[0]->apply->size-1 )
                : $_[0]->reverse->first($_[1])
    }

    sub first_idx {
        local $first_idx = 1;
        &first
    }
    sub last_idx {
        local $first_idx = 1;
        &last
    }
    BEGIN {
        *firstidx = *first_idx;
        *lastidx  = *last_idx;
    }

    sub deref {
       FAST::List::Gen::tiegen(Deref => @_)
    }
    FAST::List::Gen::generator Deref => sub {
        my ($class, $gen, $mod) = @_;
        my ($src, $pos)         = (tied @$gen, -1);
        my ($fetch, $fsize)     = $src->closures;
        my ($ref, $i);
        $mod ||= @{$ref = $fetch->(undef, $pos = 0)};
        my $size = $fsize->();
        FAST::List::Gen::curse {
            FETCH => sub {
                $i = int ($_[1] / $mod);
                $ref = $fetch->(undef, $pos = $i) if $i != $pos;
                $$ref[ $_[1] % $mod ]
            },
            fsize => $src->mutable ? do {
                $src->tail_size($size);
                sub {$size * $mod}
            }
            : do {$size *= $mod; sub {$size}},
            source => sub {$src},
        } => $class
    };

    sub drop_while {
        my ($gen, $code) = @_;
        $code->$sv2cv;
        $gen->drop_until(sub {not &$code})

    }
    sub drop_until {
        my ($gen, $code) = @_;
        my $n = $gen->first_idx($code);
        defined $n ? $gen->drop($n) : FAST::List::Gen::empty()
    }

    sub cross2d {
        if ($_[1]->$is_array_or_gen) {
            $_[0]->crosswith2d($comma, @_[1..$#_])
        } else {
            goto &crosswith2d
        }
    }
    sub crosswith2d {
        my ($xs, $code, $ys) = splice @_, 0, 3;
        $code->$sv2cv;
        if (grep {$_->is_mutable} $xs, $ys) {
            Carp::croak "mutable generators not yet supported"
        }
        &FAST::List::Gen::iterate(sub {
            my $x = $xs->get($_);
            &FAST::List::Gen::gen(sub {$code->($x, $_)}, $ys)
        }, $xs->size);
    }

    sub cross {
        if ($_[1]->$is_array_or_gen) {
            $_[0]->crosswith($comma, @_[1..$#_])
        } else {
            goto &crosswith
        }
    }
    sub crosswith {
        my ($xs, $code, $ys) = splice @_, 0, 3;
        $code->$sv2cv;
        if (@_) {
            $xs = $xs->crosswith($code, $_) for $ys, @_;
            return $xs
        }
        my $mutable;
        FAST::List::Gen::mapn {
            $_[1] = $_->size;
            if ($_->is_mutable) {
                $mutable = $_[2] = 1;
                $_->tail_size($_[1])
            }
        } 3 => $xs => my ($xsize, $xs_mutable),
               $ys => my ($ysize, $ys_mutable);

        if ($ysize >= 9**9**9 and not $ys_mutable) {
            return &FAST::List::Gen::gen(sub {
                $code->($xs->get(0), $ys->get($_))
            })
        }
        if ($xsize >= 9**9**9 and not $xs_mutable) {
            return &FAST::List::Gen::gen(sub {
                $code->($xs->get(int($_ / $ysize)), $ys->get($_ % $ysize))
            })
        }
        my ($xi, $yi, $gen);
        if ($code == $comma) {
            my $i;
            my $got;
            $gen = &FAST::List::Gen::gen(
                $mutable
                ? do {
                    my $set_size = sub {
                        $gen->set_size($xs->size * $ys->size * 2)
                    };
                    $xs->when_done($set_size) if $xs_mutable;
                    $ys->when_done($set_size) if $ys_mutable;
                    sub {
                        if ($got and int($_ / 2) == $i) {
                            return $$got[$_ % 2]
                        }
                        $i   = int ($_ / 2);
                        $xi  = int ($i / $ysize);
                        $yi  = $i - $xi * $ysize;
                        $got = sub {\@_}->($xs->get($xi), $ys->get($yi));
                        $$got[$_ % 2]
                    }
                }
                : sub {
                    $i  = int ($_ / 2);
                    $xi = int ($i / $ysize);
                    $_ % 2 ? $ys->get($i - $xi * $ysize)
                           : $xs->get($xi)
                },
                $xsize * $ysize * 2
            )
        } else {
            $gen = &FAST::List::Gen::gen(
                $mutable
                ? do {
                    my $set_size = sub {
                        $gen->set_size($xs->size * $ys->size)
                    };
                    $xs->when_done($set_size) if $xs_mutable;
                    $ys->when_done($set_size) if $ys_mutable;
                    sub {
                        $xi = int ($_ / $ysize);
                        $yi = $_ - $xi * $ysize;
                        $code->($xs->get($xi), $ys->get($yi))
                    }
                }
                : sub {
                    $xi = int ($_ / $ysize);
                    $yi = $_ - $xi * $ysize;
                    $code->($xs->get($xi), $ys->get($yi))
                },
                $xsize * $ysize
            )
        }
        $gen = &FAST::List::Gen::mutable($gen) if $mutable;
        $gen
    }

    sub cycle {
        my $src = shift;
        my ($fetch, $fsize) = tied(@$src)->closures;
        my $size = $fsize->();
        $src->is_mutable
            ? do {
                $src->tail_size($size);
                &FAST::List::Gen::gen(sub {
                    my $ret = \$fetch->(undef, $size >= 9**9**9 ? $_ : $_ % $size);
                    $_ < $size ? $$ret : $fetch->(undef, $_ % $size)
                })
            }
            : do {
                $size >= 9**9**9
                    ? $src
                    : &FAST::List::Gen::gen(sub {$fetch->(undef, $_ % $size)})
            }
    }

    sub reduce {
        my ($self, $code) = @_;
        $code->$sv2cv;
        return $self       if $code == $comma;
        return $self->flip if $code == $rcomma;

        my ($ca, $cb)  = $code->$cv_ab_ref;
        local (*a, *b) = local (*$ca, *$cb);

        my $fetch = tied(@$self)->can('FETCH');
        $a = $fetch->(undef, 0) if @$self;
        return unless @$self;

        my $args = $code->$cv_wants_2_args;
        if ($self->is_mutable) {
            my $i;
            my $size = $self->size;
            $self->tail_size($size);
            while (++$i < $size) {
                $b = $fetch->(undef, $i);
                last if $i >= $size;
                $a = $code->($args ? ($a, $b) : ())
            }
        } else {
            $self->size < 9**9**9 or Carp::croak "can not reduce infinite generator";
            for (1 .. $#$self) {
                $b = $fetch->(undef, $_);
                $a = $code->($args ? ($a, $b) : ())
            }
        }
        $a
    }
    sub sum     {$_[0]->reduce(sub {$a + $b}) or 0}
    sub product {$_[0]->reduce(sub {$a * $b}) or 0}
    sub min     {$_[0]->reduce(sub {$a > $b ? $b : $a})}
    sub max     {$_[0]->reduce(sub {$a > $b ? $a : $b})}

    sub rotate {
        my ($self, $n) = (@_, 1);
        $self->apply if $self->is_mutable;
        my $size = $self->size;
        if ($n < 0) {
            $n = $size - (abs($n) % $size);
        }
        return $self->drop($n) if $size >= 9**9**9;
        if ($n >= $size) {
            $n %= $size
        }
        FAST::List::Gen::tiegen( Rotate => tied @$self, $n )
    }

    FAST::List::Gen::generator Rotate => sub {
        my ($class, $src, $n) = @_;
        my $size = $src->fsize;
        while ($src->can('rotate')) {
            $n  += $src->rotate;
            $src = $src->source;
        }
        my $fetch = $src->can('FETCH');
        &FAST::List::Gen::curse({
            FETCH  => sub {$fetch->(undef, ($_[1] + $n) % $size)},
            fsize  => sub {$size},
            source => sub {$src},
            rotate => sub {$n},
        } => $class)
    }, mutable => sub {0};

    sub nxt {
        my ($self, $n) = @_;
        my @ret;
        while ($self->more) {
            my @x = $self->next or next;
            if ($n) {
                push @ret, @x;
                next if @ret < $n;
                last
            }
            return wantarray ? @x : pop @x
        }
        wantarray ? @ret : &FAST::List::Gen::makegen(\@ret)
    }

    sub span {
        my $self = shift;
        if (@_) {
            my $code = shift;
            $code->$sv2cv;
            my $size = $self->size;
            $self->tail_size($size) if $self->is_mutable;
            my $done;
            my $take = $self->take_while($code);
            $take->when_done(sub {$done = $take->size});
            my $drop = &FAST::List::Gen::gen(sub {
                $take->apply unless defined $done;
                my $i = $_ + $done;
                FAST::List::Gen::done()   if $i >= $size;
                my $x = $self->get($_ + $done);
                FAST::List::Gen::done()   if $i >= $size;
                FAST::List::Gen::done($x) if $i == $size - 1;
                $x
            })->mutable;
            $take, $drop
        }
        else {
            my (@i, @ret);
            while ($self->more) {
                @ret ? last : next unless @i = $self->next;
                push @ret, @i;
            }
            wantarray ? @ret : \@ret
        }
    }
    sub break {
        my ($self, $code) = @_;
        $code->$sv2cv;
        $self->span(sub {not &$code})
    }

    sub zip {
        if ($_[1]->$is_array_or_gen) {
            goto &FAST::List::Gen::zipgen
        }
        goto &zipwith
    }
    sub zipwith {
        my ($self, $code) = splice @_, 0, 2;
        $code->$sv2cv;
        &FAST::List::Gen::zipwith($code, $self, @_);
    }

    sub zipwithab {
        my ($xs, $code, $ys) = @_;
        if ($code =~ /(?=.* \$a \b) (?=.* \$b \b)/sx) {
            $code = 'zipwithab'->$eval("sub {$code}");
        }
        ref $code eq 'CODE' or Carp::croak "not \$a / \$b code: $code";
        &FAST::List::Gen::zipwithab($code, $xs, $ys)
    }
    BEGIN {*zipab = *zipwithab}

    sub mapn {
        my $self = shift;
        my ($n, $code) = $_[0] =~ /^\d+$/ ? @_ : @_[1, 0];
        $code->$sv2cv;
        $self->by($n)->map(sub {
            local *_ = $_;
            local *_ = \$_[0];
            &$code
        })
    }

    *clone = \&FAST::List::Gen::clone;
    sub copy {
        my $src     = shift;
        my $new     = clone($src);
        $new->index = $src->index;
        $new
    }
    {
        no warnings 'once';
        *For = *each = *do = sub {
            use warnings;
            @_ == 2 or Carp::croak 'call as $gen->do/each(CODE or STRING)';
            my ($gen, $code) = @_;
            my $src = tied @$gen;
            my ($fetch, $fsize) = $src->closures;
            my $i = 0;

            $code->$sv2cv;
            my $last = $code->$cv_local('last');
            no warnings 'redefine';
            local *$last = sub {die bless [@_] => 'FAST::List::Gen::Last'};
            use warnings;

            my $warn = $SIG{__WARN__};
            local $SIG{__WARN__} = sub {
                return if $_[0] =~ /^Exiting subroutine via last/i;
                $warn ? &$warn : print STDERR @_
            };
            local ($@, @_);
            local *_ = \0;
            eval {
                my $size = $fsize->();
                if ($src->mutable) {
                    $src->tail_size($size);
                    while ($i < $size) {
                        *_ = \$fetch->(undef, $i);
                        last unless $i++ < $size;
                        &$code
                    }
                } else {
                     while ($i < $size) {
                        *_ = \$fetch->(undef, $i++);
                        &$code
                    }
                }
            1} or ref $@
                ? ref($@) =~ /^FAST::List::Gen::(Last|Done)$/
                    ? return wantarray ? @{$@} : pop @{$@}
                    : die $@
                : Carp::croak $@;
            return
        }
    }

    sub head {tied(@{$_[0]})->FETCH(0)}
    {
        my ($slice, $range) = \(&FAST::List::Gen::slice, &FAST::List::Gen::range);
        {my $span; sub tail {$_[0]->$slice($span        ||= $range->(    1 => 9**9**9  ))}}
        {my %span; sub drop {$_[0]->$slice($span{$_[1]} ||= $range->($_[1] => 9**9**9  ))}}
        {my %span; sub take {$_[0]->$slice($span{$_[1]} ||= $range->(    0 => $_[1] - 1))}}
    }
    {no strict 'refs';
        for my $sub (qw(
            gen test cache expand contract collect flip While Until recursive
            mutable by every filter filter_stream scan scan_stream
            iterate iterate_multi iterate_stream iterate_multi_stream
             gather  gather_multi  gather_stream  gather_multi_stream
        )) {
            my $code = \&{"FAST::List::Gen::$sub"};
            if ((prototype $code or '') =~ /^&/) {
                *$sub = sub {
                    push @_, shift;
                    $sv2cv->(my $sub = shift);
                    unshift @_, $sub;
                    goto &$code;
                }
            } else {
                *$sub = sub {push @_, shift; goto &$code}
            }
            if ($sub =~ /_/) {
                (my $joined = $sub) =~ s/_//g;
                (my $short  = $sub) =~ s/_([a-z])[a-z]+/\U$1/g;
                *$short = *$joined = *$sub;
            }
        }
        {no warnings 'once';
            *map     = *gen;
            *grep    = *filter;
            *x       = *X           = *cross;
            *z       = *Z           = *zip;
            *while   = *take_while  = *While;
            *until   = *take_until  = *Until;
            *rec     = *with_self   = *withself    = *recursive;
            *cached  = *memoized    = *memoize     = *cache;
            *filterS = *grepS       = *grep_stream = *filter_stream;
        }
        for my $internal (qw(set_size when_done clear_done is_mutable set from
                            PUSH POP SHIFT UNSHIFT SPLICE tail_size load)) {
            my $method = $internal eq 'is_mutable' ? 'mutable' : $internal;
            my $search = $internal =~ /^(?:set_size|when_done|clear_done)$/;
            *{lc $internal} = sub {
                my $gen  = shift;
                my $self = tied @$gen;
                if (my $code = $self->can($method) || $search && do {
                    my @src  = $self->sources;
                    while (@src) {
                        last if $src[0]->can($method);
                        shift @src;
                    }
                    @src ? ($self = $src[0])->can($method) : ()
                }) {
                    unshift @_, $self;
                    if ($internal =~ /^(PUSH|UNSHIFT|from|load)$/) {
                        &$code;
                        $gen
                    } else {&$code}
                }
                else {Carp::croak "no method '$method' on '".ref($self)."'"}
            }
        }
    }
    sub reverse {goto &FAST::List::Gen::flip}
    sub overlay {goto &FAST::List::Gen::overlay}
    sub zipmax  {goto &FAST::List::Gen::zipgenmax}
    sub zipwithmax {
        my $code = splice @_, 1, 1;
        $code->$sv2cv;
        unshift @_, $code;
        goto &FAST::List::Gen::zipwithmax
    }

    sub leaves {
        my @stack = @_;
        for (@stack) {
            $_->reset if ref and FAST::List::Gen::isagen($_)
        }
        sub {
            while (@stack and ref $stack[-1]
            and FAST::List::Gen::isagen($stack[-1])) {
                if (my @next = $stack[-1]->next) {
                    for (@next) {
                        $_->reset if ref and FAST::List::Gen::isagen($_)
                    }
                    push @stack, CORE::reverse @next;
                } else {
                    (pop @stack)->reset;
                }
            }
            @stack ? pop @stack : ()
        }
    }
    {
        my %threaded;
        sub DESTROY {$_[0]->threads_stop if delete $threaded{$_[0]}}

        sub threads_start {
            $] < 5.013 or Carp::croak "threads not yet supported in perl 5.13+";
            $threaded{$_[0]} = 1;
            my $self = tied @{$_[0]};
            return if $$self{thread_queue};
            my $threads = $_[1] || 4;
            require threads;
            require Thread::Queue;
            $$self{$_} = Thread::Queue->new for qw(thread_queue thread_done);
            my $fetch  = $self->can('FETCH');
            my $cached = $self->can('cached');
            if ($cached or $$self{thread_cached}) {
                if ($cached) {
                    $cached = $cached->();
                    unless (&threads::shared::is_shared($cached)) {
                        my $type  = Scalar::Util::reftype $cached;
                        my @cache = $type eq 'HASH' ? %$cached : @$cached;
                        &threads::shared::share($cached);
                        ($type eq 'HASH' ? %$cached : @$cached) = @cache;
                    }
                } else {
                    my $real_fetch = $fetch;
                    my %cache;
                    &threads::shared::share(\%cache);
                    $fetch = sub {
                        exists $cache{$_[1]}
                             ? $cache{$_[1]}
                             :($cache{$_[1]} = $real_fetch->(undef, $_[1]))
                    }
                }
            }
            @{$$self{thread_workers}} = map {
                threads->create(sub {
                    while (my $job = $$self{thread_queue}->dequeue) {
                        last if $job eq 'stop';
                        $$self{thread_done}->enqueue(
                            [$$job[0], sub {\@_}->(map $fetch->(undef, $_) => @{$$job[1]})]
                        )
                    }
                })
            } 1 .. $threads;
            $_[0];
        }
        sub threads_stop {
            my $self = tied @{$_[0]};
            if ($$self{thread_queue}) {
                $$self{thread_queue}->enqueue('stop') for @{$$self{thread_workers}};
                for (@{$$self{thread_workers}}) {
                    $_->join;
                }
                delete $$self{"thread_$_"} for qw(queue done workers cache cached);
            }
            delete $threaded{$_[0]};
            $_[0]
        }
    }
    sub threads_slice {
        my $gen  = shift;
        my $self = tied @$gen;
        $gen->threads_start unless $$self{thread_queue};
        my $threads = @{$$self{thread_workers}};
        my $step = $$self{thread_blocksize} || int(@_/$threads + 1);
        my $part = 0;
        FAST::List::Gen::mapn {
             $$self{thread_queue}->enqueue([$part++, \@_]);
        } $step => @_;
        my @result;
        for (1 .. $part) {
            my $got = $$self{thread_done}->dequeue;
            $result[$$got[0]] = $$got[1];
        }
        wantarray ? map @$_ => @result
           : $l2g->(map @$_ => @result)
    }
    sub threads_all {
        my $gen = shift;
        $gen->threads_slice(0 .. $gen->size - 1)
    }
    sub threads_cached {
        my $gen  = shift;
        my $self = tied @$gen;
        Carp::carp "can not cache started threads" if $$self{thread_workers};
        $$self{thread_cached} = 1;
        $gen->threads_start(@_) if @_;
        $gen;
    }
    sub threads_blocksize {
        my $gen  = shift;
        my $self = tied @$gen;
        my $size = int shift;
        Carp::croak "minimum block size is 1" if $size < 1;
        $$self{thread_blocksize} = $size;
        $gen;
    }
}

    sub isagen (;$) {
        @_ ? (ref $_[0] and substr(ref $_[0], 0, 14) eq 'FAST::List::Gen::era' and $_[0])
           : (ref $_    and substr(ref $_,    0, 14) eq 'FAST::List::Gen::era' and $_)
    }
    sub tiegen {
        my @ret;
        my $class = shift;
        eval {tie @ret => 'FAST::List::Gen::'.$class, @_}
            or croak "error compiling $class, ",
               $@ =~ /^(.+) at .+?List-Gen.*$/s ? $1 : $@;

        if (DEBUG) {
            my $src   = tied @ret;
            (my $type = ref $src) =~ s/::_\d+$//;
            my @needs = do {
                my %exempt = (
                    source  => [qw(Range Capture Iterate Iterate_Multi Empty)],
                    mutable => [qw(Gen Sequence Zip Flip Recursive Slice Mutable)],
                );
                $exempt{$_} = {map {;"FAST::List::Gen::$_" => 1} @{$exempt{$_}}} for keys %exempt;
                grep {$$src{$_} ? 0 : B::svref_2object($src->can($_) or sub {})->STASH->NAME ne $type}
                    qw (FETCH fsize), ('source') x! $exempt{source}{$type},
                    !$exempt{mutable}{$type} && $src->mutable ? qw(apply set_size _when_done tail_size) : ()
            };
            if (@needs) {
                $FAST::List::Gen::report{"$type needs @needs"}++;
            }
        }
        croak '$FAST::List::Gen::LIST is no longer supported' if $LIST;
        FAST::List::Gen::erator->new(\@ret)
    }
    END {if (DEBUG) {warn "$_\n" for keys %FAST::List::Gen::report}}

    sub done;
    sub done_if ($@);
    sub done_unless ($@);
    sub catch_done ();
    sub mutable;

    sub clone {
       tiegen Clone => @_
    }
    generator Clone => sub {
        my $src = tied @{$_[1]};
        bless {%$src, self => [$_[1]]} => ref $src
    };

    sub empty () {tiegen 'Empty'}
    generator Empty => sub {
        curse {
            FETCH => sub () { },
            fsize => sub () {0},
        } => shift
    };


=head2 source generators

=over 4

=item range C< SIZE >

returns a generator from C< 0 > to C< SIZE - 1 >

    my $range = range 10;

    say $range->str;  # 0 1 2 3 4 5 6 7 8 9
    say $range->size; # 10

=item range C< START STOP [STEP] >

returns a generator for values from C< START > to C< STOP > by C< STEP >,
inclusive.

C< STEP > defaults to 1 but can be fractional and negative. depending on your
choice of C< STEP >, the last value returned may not always be C< STOP >.

    range(0, 3, 0.4) will return (0, 0.4, 0.8, 1.2, 1.6, 2, 2.4, 2.8)

    print "$_ " for @{range 0, 1, 0.1};
    # 0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1

    print "$_ " for @{range 5, 0, -1};
    # 5 4 3 2 1 0

    my $nums = range 0, 1_000_000, 2;
    print "@$nums[10, 100, 1000]";
    # gets the tenth, hundredth, and thousandth numbers in the range
    # without calculating any other values

C<range> also accepts character strings instead of numbers.  it will behave
the same way as perl's internal C< .. > operator, except it will be lazy.

    say range('a', 'z')->str;   # 'a b c d e f g ... x y z'

    range('a', 'zzz', 2)->say;  # 'a c e g i k m ... zzu zzw zzy'

    say <A .. ZZ>->str;         # 'A B C D E ... ZX ZY ZZ'

    <1..>->zip(<a..>)->say(10); # '1 a 2 b 3 c 4 d 5 e'

to specify an infinite range, you can pass C< range > an infinite value
(C< 9**9**9 > works well), or the glob C< ** >, or the string C< '*' >

    range(1, 9**9**9) ~~ range(1, **) ~~ range(1, '*') ~~ <1..*> ~~ <1..>

ranges only store their endpoints, and ranges of all sizes take up the same
amount of memory.

=cut

    sub range ($;$$) {
        splice @_, 1, 1, 9**9**9
            if @_ > 1 and $_[1] eq '*'
                      || \$_[1] == \**;
        for (@_) {
            defined
            and /^[a-z]+$/i
            and not looks_like_number $_
            and goto &arange
        }
        tiegen Range => @_ == 1 ? (0, $_[0] - 1) : @_
    }
    generator Range => sub {
        my ($class, $low, $high, $step, $size) = (@_, 1);
        $size = $high < 9**9**9
            ? do {
                $size = $step > 0 ? $high - $low : $low - $high;
                $size = 1 + $size / abs $step;
                $size > 0 ? int $size : 0
            } : $high;

        $size = 0 unless $low < 9**9**9;
        curse {
            FETCH => sub {
                $_[1] < $size
                      ? $low + $step * $_[1]
                      : croak "range index $_[1] out of bounds [0 .. @{[$size - 1]}]"
            },
            fsize => sub {$size},
            range => sub {$low, $step, $size},
        } => $class
    };

    {my %map; @map{0..25} = 'a'..'z';
     my @cache = 'a'..'zz';
    sub num2alpha {
        my $num = @_ ? $_[0] : $_;
        return '-'.num2alpha(-$num) if $num < 0;
        return $cache[$num]         if $num < 702;
        my @str;
        while ($num > -1) {
            unshift @str, $map{$num % 26};
            $num = int($num / 26) - 1;
        }
        join '' => @str
    }}

    {my %map; @map{'a'..'z'} = 0..25;
    sub alpha2num {
        my $str = shift;
        return -alpha2num($1) if $str =~ /^-(.+)/;
        my ($num, $scale);
        for (split //, reverse $str) {
            $num += ($map{$_} + !!$scale) * 26**$scale++
        }
        $num
    }}

    sub arange {
        my ($low, $high, $step) = (@_ == 1 ? 'a' : (), @_, 1);
        my $uc = $low =~ /^[A-Z]+$/;
        for ($low, $high) {
            $_ = alpha2num lc if /^[a-z]+$/i and not looks_like_number $_
        }
        if ($step =~ /^[a-z]+$/i) {
            $step = 1 + alpha2num lc $step;
        }
        &gen($uc ? sub {uc &num2alpha} : \&num2alpha, $low, $high, $step)
    }


=item gen C< {CODE} GENERATOR >

=item gen C< {CODE} ARRAYREF >

=item gen C< {CODE} SIZE >

=item gen C< {CODE} [START STOP [STEP]] >

=item gen C< {CODE} GLOBSTRING >

C< gen > is the equivalent of C< map > for generators. it returns a generator
that will apply the C< CODE > block to its source when accessed. C< gen > takes
a generator, array ref, glob-string, or suitable arguments for C< range > as its
source. with no arguments, C< gen > uses the range C< 0 .. infinity >.

    my @result = map {slow($_)} @source;  # slow() called @source times
    my $result = gen {slow($_)} \@source; # slow() not called

    my ($x, $y) = @$result[4, 7]; # slow()  called twice

    my $lazy = gen {slow($_)} range 1, 1_000_000_000;
      same:    gen {slow($_)} 1, 1_000_000_000;

    print $$lazy[1_000_000]; # slow() only called once

C< gen {...} list LIST > is a replacement for C< [ map {...} LIST ] >.

C< gen > provides the functionality of the identical C<< ->gen(...) >> and
C<< ->map(...) >> methods.

note that while effort has gone into making generators as fast as possible there
is overhead involved with lazy generation. simply replacing all calls to
C< map > with C< gen > will almost certainly slow down your code. use these
functions in situations where the time / memory required to completely generate
the list is unacceptable.

C< gen > and other similarly argumented functions in this package can also
accept a string suitable for the C<< <glob> >> syntax:

    my $square_of_nats = gen {$_**2} '1..';
    my $square_of_fibs = gen {$_**2} '0, 1, *+*'; # no need for '...' with '*'

which is the same as the following if C< glob > is imported:

    my $square_of_nats = gen {$_**2} <1..>;
    my $square_of_fibs = gen {$_**2} <0, 1, *+* ...>; # still need dots here

=cut

    sub gen (&;$$$) {
        tiegen Gen => shift, tied @{&dwim}
    }

    my $canglob = qr/\.{2,3}|,.*\*/;
    sub canglob (;$) {(@_ ? $_[0] : $_) =~ $canglob}

    sub dwim {
        @_ or @_ = (0 => 9**9**9);
        $#_ and &range
            or ref $_[0] and do {
                $_[0] = ${$_[0]}->() if ref $_[0] eq 'FAST::List::Gen::Thunk';
                isagen $_[0]
                or ref $_[0] eq 'ARRAY' and &makegen
            }
            or $_[0] and $_[0] =~ $canglob
                     and isagen &glob($_[0] =~ /\.{2,3}/ ? $_[0] : "$_[0]...")
            or looks_like_number $_[0]
                and range int $_[0]
            or croak "invalid argument for generator: '$_[0]'"
    }
    generator Gen => sub {
        my ($class, $code, $source) = @_;
        my ($fetch, $fsize) = $source->closures;
        curse {
            FETCH => do {
                if ($source->can('range')) {
                    my ($low, $step, $size) = $source->range;
                    sub {
                        local *_ = $_[1] < $size
                                 ? \($low + $step * $_[1])
                                 : &$fetch;
                        $code->()
                    }
                }
                elsif ($source->can('capture')) {
                    my $cap = $source->capture;
                    sub {local *_ = \$$cap[$_[1]]; $code->()}
                }
                else {
                    sub {local *_ = \$fetch->(undef, $_[1]); $code->()}
                }
            },
            fsize  => $fsize,
            source => sub {$source},
        } => $class
    };


=item makegen C< ARRAY >

C< makegen > converts an array to a generator. this is normally not needed as
most generator functions will call it automatically if passed an array reference

C< makegen > considers the length of C< ARRAY > to be immutable. changing the
length of an array after passing it to C< makegen > (or to C< gen > and like
argumented subroutines) will result in undefined behavior.  this is done for
performance reasons.  if you need a length mutable array, use the C< array >
function.  changing the value of a cell in the array is fine, and will be
picked up by a generator (of course if the generator uses a cache, the value
won't change after being cached).

you can assign to the generator returned by C< makegen >, provided the
assignment does not lengthen the array.

    my $gen = makegen @array;

    $$gen[3] = 'some value';  #  now $array[3] is 'some value'

=cut

    sub makegen (\@) {
       tiegen Capture => @_
    }
    generator Capture => sub {
        my ($class, $source) = @_;
        my $size = @$source;
        curse {
            FETCH   => sub {$$source[ $_[1] ]},
            fsize   => sub {$size},
            capture => sub {$source}
        } => $class
    },
        STORE => sub {
            $_[1] < $_[0]->fsize
                  ? $_[0]->capture->[$_[1]] = $_[2]
                  : croak "index $_[1] out of range 0 .. ".($_[0]->size - 1)
        };


=item list C< LIST >

C< list > converts a list to a generator.  it is a thin wrapper around
C< makegen > that simply passes its C< @_ > to C< makegen >.  that means the
values in the returned generator are aliases to C<list>'s arguments.

    list(2, 5, 8, 11)->map('*2')->say;  #  '4 10 16 22'

is the same as writing:

    (gen {$_*2} cap 2, 5, 8, 11)->say;

in the above example, C< list > can be used in place of C< cap > and has exactly
the same functionality:

    (gen {$_*2} list 2, 5, 8, 11)->say;

=cut

    sub list {makegen @_}


=item array C< [ARRAY] >

C< array > is similar to C< makegen > except the array is considered a mutable
data source.  because of this, certain optimizations are not possible, and the
generator returned will be a bit slower than the one created by C< makegen > in
most conditions (increasing as generator functions are stacked).

it is ok to modify C< ARRAY > after creating the generator.  it is also possible
to use normal array modification functions such as C< push >, C< pop >,
C< shift >, C< unshift >, and C< splice > on the generator.  all changes will
translate back to the source array.

you can think of C< array > as converting an array to an array reference that
is also a generator.

    my @src = 1..5;
    my $gen = array @src;

    push @$gen, 6;

    $$gen[6] = 7;  # assignment is ok too

    say $gen->size;  # 7
    say shift @$gen; # 1
    say $gen->size;  # 6
    say $gen->str;   # 2 3 4 5 6 7
    say "@src";      # 2 3 4 5 6 7

    my $array = array;  # no args creates an empty array

=cut

    sub array (;\@) {tiegen Array => @_ ? @_ : []}
    mutable_gen Array => sub {
        my ($class, $src) = @_;
        curse {
            FETCH   => sub {$$src[$_[1]]},
            STORE   => sub {$$src[$_[1]] = $_[2]},
            fsize   => sub {scalar @$src},
            capture => sub {$src},
        } => $class
    },
        PUSH    => sub {push    @{$_[0]->capture}, @_[1..$#_]},
        UNSHIFT => sub {unshift @{$_[0]->capture}, @_[1..$#_]},
        POP     => sub {pop     @{$_[0]->capture}},
        SHIFT   => sub {shift   @{$_[0]->capture}},
        SPLICE  => sub {
            my $cap = shift->capture;
            @_ == 0 ? splice @$cap :
            @_ == 1 ? splice @$cap, $_[0] :
            @_ == 2 ? splice @$cap, $_[0], $_[1] :
                      splice @$cap, $_[0], $_[1], @_[2..$#_]
        },
        DELETE    => sub {delete $_[0]->capture->[$_[1]]},
        STORESIZE => sub {$#{$_[0]->capture} = $_[1] - 1},
        CLEAR     => sub { @{$_[0]->capture} = ()};


=item file C<< FILE [OPTIONS] >>

C< file > creates an C< array > generator from a file name or file handle
using C< Tie::File >.  C< OPTIONS > are passed to C< Tie::File >

    my $gen = file 'some_file.txt';

    my $uc_file = $gen->map('uc');

    my $with_line_numbers = <1..>->zip('"$a: $b"', $gen);

=cut

    sub file {
        my $file = shift;
        my %args = (recsep => $/, @_);
        require Tie::File;
        tie my @array, 'Tie::File', $file, %args or die $!;
        array @array
    }


=item repeat C<< SCALAR [SIZE] >>

an infinite generator that returns C<SCALAR> for every position. it is
equivalent to C< gen {SCALAR} > but a little faster.

=cut

    sub repeat {
       tiegen Repeat => @_
    }
    generator Repeat => sub {
        my ($class, $x, $size) = (@_, 9**9**9);
        curse {
            FETCH => sub () {$x},
            fsize => sub () {$size},
        } => $class
    };


=item iterate C< {CODE} [LIMIT|GENERATOR] >

C< iterate > returns a generator that is created iteratively. C< iterate >
implicitly caches its values, this allows random access normally not
possible with an iterative algorithm.  LIMIT is an optional number of times to
iterate.  normally, inside the CODE block, C<$_> is set to the current iteration
number.  if passed a generator instead of a limit, C<$_> will be set to
sequential values from that generator.

    my $fib = do {
        my ($x, $y) = (0, 1);
        iterate {
            my $return = $x;
            ($x, $y) = ($y, $x + $y);
            $return
        }
    };

generators produced by C< iterate > have an extra method, C<< ->from(LIST) >>.
the method must be called before values are accessed from the generator. the
passed C< LIST > will be the first values returned by the generator.  the method
also changes the behavior of C< $_ > inside the block. C< $_ > will contain the
previous value generated by the iterator. this allows C< iterate > to behave the
same way as the like named haskell function.

    haskell: take 10 (iterate (2*) 1)
    perl:    iterate{2*$_}->from(1)->take(10)
             <1, 2 * * ... 10>
             <1,2**...10>

which all return C< [1, 2, 4, 8, 16, 32, 64, 128, 256, 512] >

=cut

    sub iterate (&;$) {
        goto &iterate_stream if $STREAM;
        my ($code, $size) = (@_, 9**9**9);
        if (isagen($size) and $size->is_mutable) {
            goto &iterate_multi
        }
       tiegen Iterate => $code, $size
    }
    generator Iterate => sub {
        my ($class, $code, $size) = @_;
        my (@list, $from, $source);
        if (isagen($size)) {
            $source = tied(@$size)->can('FETCH');
            $size   = $size->size;
        }
        curse {
            FETCH => sub {
                (my $i = $_[1]) >= $size
                    and croak "index $_[1] out of bounds [0 .. @{[$size - 1]}]";
                if ($i > $#list) {
                    for (@list .. $i) {
                        $list[$_] = do {
                            $from   ? local *_ = $list[$_ - 1]         :
                            $source ? local *_ = \$source->(undef, $_) : ();
                            \$code->()
                        }
                    }
                }
                ${$list[$i]}
            },
            fsize  => sub { $size},
            cached => sub {\@list},
            from   => sub {
                return $from if @_ == 2 and ref $_[1] eq 'FAST::List::Gen::From_Check';

                croak "can not call ->from on started iterator"
                    if @list or $from++;
                push @list, @_ > 1 ? \@_[1..$#_] : \FAST::List::Gen::Iterate::Default->new;
            },
        } => $class
    },
        load  => sub {push @{$_[0]->cached}, \@_[1..$#_]},
        purge => sub {croak 'can not purge iterative generator'};

    {package
        FAST::List::Gen::Iterate::Default;
        sub new {bless []}
        use overload fallback => 1,
            '""' => sub :lvalue {@{$_[0]} ? $_[0][0] : ($_[0][0] = '')},
            '0+' => sub :lvalue {@{$_[0]} ? $_[0][0] : ($_[0][0] = 0)};
    }


=item iterate_stream C< {CODE} [LIMIT] >

C< iterate_stream > is a version of C< iterate > that does not cache the
generated values.  because of this, access to the returned generator must be
monotonically increasing (such as repeated calls to C<< $gen->next >>).

=cut

    sub iterate_stream (&;$) {
        my ($code, $size) = (@_, 9**9**9);
        if (isagen($size) and $size->is_mutable) {
            goto &iterate_multi_stream
        }
        tiegen Iterate_Stream => $code, $size
    }
    BEGIN {*iterateS = *iterate_stream}
    generator Iterate_Stream => sub {
        my ($class, $code, $size) = @_;
        my ($last,  $from, $source);
        my $pos = 0;
        if (isagen($size)) {
            $source = tied(@$size)->can('FETCH');
            $size   = $size->size;
        }
        curse {
            FETCH => sub {
                (my $i = $_[1]) >= $size
                    and croak "index $_[1] out of bounds [0 .. @{[$size - 1]}]";
                $i < $pos and croak "non-monotone access of stream iterator, idx($i) < pos($pos)";

                $pos++, return $$last if $i == 0 and $from;
                local *_;
                while ($i >= $pos and $pos < $size) {
                    *_ = $from ? $last
                               : $source ? \$source->(undef, $pos)
                                         : \(0+$pos);
                    $last = \$code->();
                    $pos++;
                }
                $pos < $size ? $$last : ()
            },
            fsize => sub {$size},
            index => sub {\$pos},
            from  => sub {
                croak "can not call ->from on started iterator"
                    if $pos or $from++;
                $last = @_ > 1 ? \$_[1] : \FAST::List::Gen::Iterate::Default->new;
            },
        } => $class
    },
        purge => sub {croak 'can not purge iterative generator'};


=item iterate_multi C< {CODE} [LIMIT] >

the same as C<iterate>, except CODE can return a list of any size.  inside CODE,
C<$_> is set to the position in the returned generator where the block's
returned list will be placed.

the returned generator from C< iterate_multi > can be modified with C<push>,
C<pop>, C<shift>, C<unshift>, and C<splice> like a normal array.  it is up to
you to ensure that the iterative algorithm will still work after modifying the
array.

the C<< ->from(...) >> method can be called on the returned generator.  see
C< iterate > for the rules and effects of this.

=cut

    sub iterate_multi (&;$) {
        goto &iterate_multi_stream if $STREAM;
        tiegen Iterate_Multi => @_, 9**9**9
    } BEGIN {*iterateM = *iterate_multi}
    mutable_gen Iterate_Multi => sub {
        my ($class, $code, $size) = @_;
        my ($iter, $when_done   ) = (0, sub {});
        my ($from, @list, @tails, $source, $mutable);
        if (isagen $size) {
            my $src  = tied @$size;
            $source  = $src->can('FETCH');
            $size    = $src->fsize;
            $mutable = $src->mutable;
            $src->tail_size($size) if $mutable;
        }
        curse {
            FETCH => sub {
                my $i = $_[1];
                while ($i > $#list) {
                    $iter++ >= $size
                        and croak "too many iterations requested: ".
                                  "$iter. index $i out of bounds [0 .. @{[$size - 1]}]";
                    local *_ = $from   ? $list[-1] :
                               $source ? \$source->(undef, scalar @list) :
                               \scalar @list;
                    eval {push @list, map {ref eq 'FAST::List::Gen::Thunk' ? \$$_->() : \$_} $code->(); 1}
                      or catch_done and do {
                        if (ref $@) {
                          push @list, map {ref eq 'FAST::List::Gen::Thunk' ? \$$_->() : \$_} @{$@};
                          $size = @list;
                          $$_ = $size for @tails;
                          $when_done->();
                          return ${$list[$i < $#list ? $i : $#list]};
                        } else {
                          $iter--;
                          $size = @list;
                          $$_ = $size for @tails;
                          $when_done->();
                          return
                        }
                      }
                }
                if ($size < @list) {
                    $size = @list;
                    $$_ = $size for @tails;
                }
                elsif ($mutable) {
                    $$_ = $size for @tails;
                }
                ${$list[$i]}
            },
            fsize    => sub {$size},
            cached   => sub {\@list},
            set_size => sub {
                $size = int $_[1];
                $$_ = $size for @tails;
                $when_done->() if $size == @list
            },
            _resize => sub {
                $size += $_[1] if $size < 9**9**9;
                $$_ = $size for @tails;
                $iter += $_[1];
            },
            _when_done => sub :lvalue {$when_done},
            from       => sub {
                croak "can not call ->from on started iterator"
                    if @list or $from++;
                push @list, @_ > 1 ? \@_[1..$#_] : \FAST::List::Gen::Iterate::Default->new;
            },
            tail_size => sub {
                push @tails, \$_[1]; weaken $tails[-1];
            },
        } => $class
    },
        purge => sub {Carp::croak 'can not purge iterative generator'},
        load  => sub {push @{$_[0]->cached}, \@_[1..$#_]},
        PUSH  => sub {
            my $self = shift;
            $self->_resize(0+@_);
            push @{$self->cached}, \(@_)
        },
        UNSHIFT => sub {
            my $self = shift;
            $self->_resize(0+@_);
            unshift @{$self->cached}, \(@_)
        },
        POP => sub {
            my $self = shift;
            return unless $self->fsize > 0;
            $self->_resize(-1);
            ${pop @{$self->cached}}
        },
        SHIFT => sub {
            my $self = shift;
            return unless $self->fsize > 0;
            $self->_resize(-1);
            ${shift @{$self->cached}}
        },
        SPLICE => sub {
            my $self = shift;
            my $list = $self->cached;
            my $size = $self->fsize;
            my @ret  =
                @_ == 0 ? splice @$list                      :
                @_ == 1 ? splice @$list, shift               :
                @_ == 2 ? splice @$list, shift, shift        :
                          splice @$list, shift, shift, \(@_) ;
            $self->_resize(@$list - $size);
            map {$$_} @ret
        };


=item iterate_multi_stream C< {CODE} [LIMIT] >

C< iterate_multi_stream > is a version of C< iterate_multi > that does not cache
the generated values.  because of this, access to the returned generator must be
monotonically increasing (such as repeated calls to C<< $gen->next >>).

keyword modification of a stream iterator (with C<push>, C<shift>, ...) is not
supported.

=cut

    sub iterate_multi_stream (&;$) {
       tiegen Iterate_Multi_Stream => @_, 9**9**9
    }
    BEGIN {*iterateMS = *iterate_multi_stream}
    mutable_gen Iterate_Multi_Stream => sub {
        my ($class, $code, $size) = @_;
        my ($pos, $when_done    ) = (0, sub {});
        my ($from, @last, @tails, $source, $mutable);
        if (isagen $size) {
            $source  = tied(@$size)->can('FETCH');
            $mutable = $size->is_mutable;
            $size    = $size->size;
        }
        curse {
            FETCH => sub {
                my $i = $_[1];
                $i < $pos and croak "non-monotone access of iterate multi stream, idx($i) < pos($pos)";
                while ($i >= $pos) {
                     $pos >= $size and croak "too many iterations requested: ".
                                            "$pos. index $i out of bounds [0 .. @{[$size - 1]}]";
                    if ($i == $pos and @last) {
                        $pos++;
                        last
                    }
                    if (@last) {
                        shift @last;
                        $pos++;
                        next;
                    }
                    local *_ = $from ? $from :
                               $source ? \$source->(undef, $pos) :
                               \$pos;
                    eval {push @last, map {ref eq 'FAST::List::Gen::Thunk' ? \$$_->() : \$_} $code->(); 1}
                        or catch_done and do {
                            if (ref $@) {
                                push @last, map {ref eq 'FAST::List::Gen::Thunk' ? \$$_->() : \$_} @{$@};
                                $size = $pos;
                                $$_ = $size for @tails;
                                $when_done->();
                                return ${shift @last};
                            } else {
                                $size = $pos;
                                $$_ = $size for @tails;
                                $when_done->();
                                return
                            }
                        };
                    $from = $last[-1] if $from;
                    $pos++
                }
                if ($mutable) {
                    $$_ = $size for @tails
                }
                ${shift @last};
            },
            fsize    => sub {$size},
            index    => sub {\$pos},
            set_size => sub {
                $size = int $_[1];
                $$_ = $size for @tails;
                $when_done->();
            },
            _when_done => sub :lvalue {$when_done},
            from       => sub {
                croak "can not call ->from on started iterator"
                    if @last or $from;
                push @last, @_ > 1 ? \@_[1..$#_] : \FAST::List::Gen::Iterate::Default->new;
                $from = $last[-1];
            },
            tail_size => sub {
                push @tails, \$_[1]; weaken $tails[-1];
            },
        } => $class
    },
        purge => sub {Carp::croak 'can not purge iterative generator'};


=item gather C< {CODE} [LIMIT] >

C< gather > returns a generator that is created iteratively.  rather than
returning a value, you call C< take($return_value) > within the C< CODE >
block. note that since perl5 does not have continuations, C< take(...) > does
not pause execution of the block.  rather, it stores the return value, the
block finishes, and then the generator returns the stored value.

you can not import the C< take(...) > function from this module.
C< take(...) > will be installed automatically into your namespace during
the execution of the C< CODE > block. because of this, you must always call
C< take(...) > with parenthesis. C< take > returns its argument unchanged.

gather implicitly caches its values, this allows random access normally not
possible with an iterative algorithm.  the algorithm in C< iterate > is a
bit cleaner here, but C< gather > is slower than C< iterate >, so benchmark
if speed is a concern

    my $fib = do {
        my ($x, $y) = (0, 1);
        gather {
            ($x, $y) = ($y, take($x) + $y)
        }
    };

a non-cached version C< gather_stream > is also available, see C< iterate_stream >

=cut

    sub gather (&;$) {
        my $code = shift;
        my $take = $code->$cv_local('take');
        unshift @_, sub {
            my $ret;
            no warnings 'redefine';
            local *$take = sub {$ret = $_[0]};
            $code->();
            $ret
        };
        goto &iterate
    }
    sub gather_stream (&;$) {
        local *iterate = *iterate_stream;
        &gather
    }
    BEGIN {*gatherS = *gather_stream}


=item gather_multi C< {CODE} [LIMIT] >

the same as C< gather > except you can C< take(...) > multiple times, and each
can take a list.  C< gather_multi_stream > is also available.

=cut

    sub gather_multi (&;$) {
        my $code = shift;
        my $take = $code->$cv_local('take');
        unshift @_, sub {
            my @ret;
            no warnings 'redefine';
            local *$take = sub {push @ret, @_; wantarray ? @_ : pop};
            eval {$code->(); 1}
                or catch_done and ref $@ and push @ret, @{$@};
            @ret
        };
        goto &iterate_multi
    }
    sub gather_multi_stream (&;$) {
        local *iterate_multi = *iterate_multi_stream;
        &gather_multi
    }
    BEGIN {
        *gatherM  = *gather_multi;
        *gatherMS = *gather_multi_stream
    }


=item stream C< {CODE} >

in the C< CODE > block, calls to functions or methods with stream versions will
be replaced by those versions.  this applies also to functions that are called
internally by C< FAST::List::Gen > (such as in the glob syntax).  C< stream > returns
what C< CODE > returns.

    say iterate{}->type;             # FAST::List::Gen::Iterate
    say iterate_stream{}->type;      # FAST::List::Gen::Iterate_Stream
    stream {
        say iterate{}->type;         # FAST::List::Gen::Iterate_Stream
    };
    say stream{iterate{}}->type;     # FAST::List::Gen::Iterate_Stream
    say stream{<1.. if even>}->type; # FAST::List::Gen::Filter_Stream

placing code inside a C< stream > block is exactly the same as placing
C< local $FAST::List::Gen::STREAM = 1; > at the top of a block.

=cut

    sub stream (&) {
        local $STREAM = 1;
        $_[0]->()
    }


=item glob C< STRING >

=item <list comprehension>

by default, this module overrides perl's default C< glob > function.  this is
because the C< glob > function provides the behavior of the angle bracket
delimited C<< <*.ext> >> operator, which is a nice place for inserting list
comprehensions into perl's syntax.  the override causes C< glob() > and the
C<< <*.ext> >> operator to have a few special cases overridden, but any case
that is not overridden will be passed to perl's internal C< glob > function
(C<< my @files = <*.txt>; >> works as normal).

=over 4

=item * there are several types of overridden operations:

    range:              < [prefix,] low .. [high] [by step] >

    iterate:            < [prefix,] code ... [size] >

    list comprehension: < [code for] (range|iterate) [if code] [while code] >

    reduction:          < \[op|name\] (range|iterate|list comprehension) >

=item * range strings match the following pattern:

    (prefix,)? number .. number? ((by | += | -= | [-+]) number)?

here are a few examples of valid ranges:

    <1 .. 10>       ~~  range 1, 10
    <0 .. >         ~~  range 0, 9**9**9
    <0 .. *>        ~~  range 0, 9**9**9
    <1 .. 10 by 2>  ~~  range 1, 10, 2
    <10 .. 1 -= 2>  ~~  range 10, 1, -2
    <a .. z>        ~~  range 'a', 'z'
    <A .. ZZ>       ~~  range 'A', 'ZZ'
    <a..>           ~~  range 'a', 9**9**9
    <a.. += b>      ~~  range 'a', 9**9**9, 2
    <0, 0..>        ~~  [0] + range 0, 9**9**9
    <'a','ab', 0..> ~~  ['a','ab'] + range 0, 9**9**9
    <qw(a ab), 0..> ~~  [qw(a ab)] + range 0, 9**9**9

=item * iterate strings match the following pattern:

    (.+? ,)+ (.*[*].* | \{ .+ }) ... number?

such as:

    my $fib = <0, 1, * + * ... *>;

which means something like:

    my $fib = do {
        my @pre = (0, 1);
        my $self;
        $self = iterate {
            @pre ? shift @pre : $self->get($_ - 2) + $self->get($_ - 1)
        } 9**9**9
    };

a few more examples:

    my $fib = <0, 1, {$^a + $^b} ... *>;

    my $fac = <1, * * _ ... *>;

    my $int = <0, * + 1 ... *>;

    my $fib = <0,1,*+*...>; # ending star is optional

=item * list comprehension strings match:

    ( .+ (for | [:|]) )? (range | iterate) ( (if | unless | [?,]) .+ )?
                                           ( (while | until ) .+ )?

examples:

    <**2: 1 .. 10>                 ~~  gen {$_**2} range 1, 10
    <**2: 1 .. 10 ? %2>            ~~  gen {$_**2} filter {$_ % 2} range 1, 10
    <sin: 0 .. 3.14 += 0.01>       ~~  gen {sin} range 0, 3.14, 0.01
    <1 .. 10 if % 2>               ~~  filter {$_ % 2} range 1, 10
    <sin for 0 .. 10 by 3 if /5/>  ~~  gen {sin} filter {/5/} range 0, 10, 3
    <*3 for 0 .. 10 unless %3>     ~~  gen {$_ * 3} filter {not $_ % 3} 0, 10
    <0 .. 100 while \< 10>         ~~  While {$_ < 10} range 0, 100
    <*2 for 0.. if %2 while \<10>  ~~  <0..>->grep('%2')->while('<10')->map('*2')

there are three delimiter types available for basic list comprehensions:

    terse:   <*2: 1.. ?%3>
    haskell: <*2| 1.., %3>
    verbose: <*2 for 1.. if %3>

you can mix and match C<< <*2 for 1.., %3> >>, C<< <*2| 1.. ?%3> >>

in the above examples, most of the code areas are using abbreviated syntax.
here are a few equivalencies:

    <*2:1..?%3> ~~ <*2 for 1.. if %3> ~~ <\$_ * 2 for 1 .. * if \$_ % 3>

    <1.. if even> ~~ <1.. if not %2> ~~ <1..?!%2> ~~ <1.. if not _ % 2>
                  ~~ <1.. unless %2> ~~ <1..* if not \$_ % 2>

    <1.. if %2> ~~ <1.. if _%2> ~~ <1..* ?odd> ~~ <1.. ? \$_ % 2>

=item * reduction strings match:

    \[operator | function_name\] (range | iterate | list comp)

examples:

    say <[+] 1..10>; # prints 55

pre/post fixing the operator with '..' uses the C< scan > function instead of
C< reduce >

    my $fac = <[..*] 1..>;  # read as "a running product of one to infinity"

    my $sum = <[+]>;        # no argument returns the reduction function

    say $sum->(1 .. 10);    # 55
    say $sum->(<1..10>);    # 55

    my $rev_cat = <[R.]>;   # prefix the operator with `R` to reverse it

    say $rev_cat->(1 .. 9); # 987654321

=item * all of these features can be used together:

    <[+..] *2 for 0 .. 100 by 2 unless %3 >

which is the same as:

    range(0, 100, 2)->grep('not %3')->map('*2')->scan('+')

when multiple features are used together, the following construction order is
used:

    1. prefix
    2. range or iterate
    3. if / unless   (grep)
    4. while / until (while)
    5. for           (map)
    6. reduce / scan

    ([prefix] + (range|iterate))->grep(...)->while(...)->map(...)->reduce(...)

=item * bignums

when run in perl 5.9.4+, glob strings will honor the lexical pragmas C< bignum >,
C< bigint >, and C< bigrat >.

    *factorial = do {use bigint; <[..*] 1, 1..>->code};

    say factorial(25); # 15511210043330985984000000

=item * special characters

since the angle brackets (C<< < >> and C<< > >>) are used as delimiters of the
glob string, they both must be escaped with C< \ > if used in the C<< <...> >>
construct.

    <1..10 if \< 5>->say; # 1 2 3 4

due to C<< <...> >> being a C< qq{} > string, in the code areas if you need to
write C< $_ > write it without the sigil as C< _ >

    <1 .. 10 if _**2 \> 40>->say; # 7 8 9 10

it can be escaped C< \$_ > as well.

neither of these issues apply to calling glob directly with a single quoted
string:

    glob('1..10 if $_ < 5')->say; # 1 2 3 4

=back

=cut

    my $get_pragma = do {
        my @pragmas;
        my $init = 1;
        sub {
            if ($init) {
                $init = 0;
                @pragmas = grep {$INC{"$_.pm"}} qw (bignum bigint bigrat);
            }
            return '' if @pragmas == 0 or $] < 5.009004;
            my $caller = 1;
            $caller++ while (substr caller $caller, 0 => 9) eq 'FAST::List::Gen';
            join '' => map {
                (($_->can('in_effect') or sub{})->($caller + 1)) ? "use $_; " : ''
            } @pragmas
        }
    };

    {
    my $number = qr{
        (?: - \s* )?
        (?:
            (?: \d[\d_]* | (?: \d*\.\d+ ) ) (?: e -? \d+ )?
        |   [a-zA-Z]+?
        )
    }x;
    my $prefix = qr{
        (?:
            (?: $number | "[^"]+" | '[^']+' | [^,]+ )     \s*
            ,                                             \s*
        )+
    }x;
    my $build_iterate;
    my $glob = sub {glob $_[0]};
    use subs 'glob';
    sub glob {
        local *_ = @_ ? \"$_[0]" : \"$_";
        s/^\s+|\s+$//g;
        my $reduce;
        my $pkg = $external_package->(1);
        if (s{^
          \[
            ( (?: \\ | \.\.? | , )  (?! \] ) )?
            (?:
                (?: ( [Rr]{0,1} ) \s* ( $ops ) )
            |   ( (?=[^Rr0-9_])\w | [a-zA-Z_]\w+ )
            )
            ( (?: \.\.? | , ) )?
          \]
        }{}x) {
            my ($rev, $op, $word, $scan) = ($2, $3, $4, $1 || $5);
            if ($op) {
                $op = 'R'.$op if $rev
            } else {
                if (my $sub = $pkg->can($word)) {
                    $op = $rev ? sub {$sub->($b, $a)}
                               : sub {$sub->($a, $b)}
                } else {
                    croak "subroutine '&${pkg}::$word' not found"
                }
            }
            $reduce = $scan ? sub {$_[0]->scan  ($op)}
                            : sub {$_[0]->reduce($op)}
        }
        my $pragma = $get_pragma->();
        if (my ($gen, $pre, $low, $high, $step, $iterate, $filter, $while) = m{^
            (?: \s* ( .+? )                                     \s*
                (?: [|:] | \b for \b)
            ){0,1}                                              \s*
            (?: ( $prefix ) ){0,1}                              \s*
            (?:
               ( $number )                                      \s*
                   \.\. (?!\.)                                  \s*
               ( $number | -?(?:\*|) )                          \s*
               (?:
                   (?: \b by \b | [+]= | \+ | (?=-) )           \s*
                   ( (?: -= \s* )? $number )
               )?                                               \s*
            |
                (.*? \s* \.\.\. \s* (?:$number|\*)?)            \s*
            )
            (?:
                (?: \b if \b | (?=\b unless \b) | [?,] )        \s*
                ( .+? )                                         \s*
            )?
            (
                \b (?: while | until ) \b                       \s*
                .+?
            )?                                                  \s*
        $}sxo) {
            $filter =~ s/^unless\b/not / if $filter;
            $while  =~ s/^while\s*/not / or
            $while  =~ s/^until\s*//     if $while;
            $pre ||= '';
            my $ret;
            if ($iterate) {
                $ret = $build_iterate->($pre.$iterate, $pragma, $pkg);
                $pre = '';
            } else {
                $high = 9**9**9 if $high =~ /^\*?$/;
                if ($high eq '-*') {
                    $high = -9**9**9;
                    $step ||= -1;
                }
                $high = -9**9**9 if $high eq '-*';
                $_ and s/_//g, s/^-\s+/-/ for $low, $high, $step;
                $step =~ s/^-=\s*/-/ if $step;
                $ret = &range($low, $high, $step || 1);
            }
            if ($pre) {
                $pre =~ s/,\s*$//g;
                $pre = 'prefix'->$eval($pragma."do {[$pre]}");
                $ret = $pre + $ret if @$pre;
            }
            for ([filter => $filter], [until => $while], [gen => $gen]) {
                $$_[1] or next;
                my ($method, $code) = @$_;
                $code =~ s'\b(?:(?<!\$)_)\b'$_'g;
                $ret = $ret->$method($code);
            }
            $reduce ? $reduce->($ret) : $ret
        }
        else {
            $reduce && !$_ ? sub {
                $reduce->(@_ == 1 && isagen $_[0] or &makegen(\@_))
            } : $glob->($_[0])
        }
    }
    $build_iterate = sub {
        (local $_, my ($pragma, $pkg)) = @_;
        if (my ($x, $n) = /^
            ( \w+ | '[^']*' | "[^"]*" )
            \s* \.{3} \s*
            (\*|\d*)
        $/x) {
            $n = '' if $n eq '*';
            $x =~ s/^('|")(.*)\1$/$2/s;
            return repeat($x, length $n ? $n : ())
        }
        s/$^/\$^/g;
        my ($pre, $block, $star, $end) = /^
            ($prefix)?                         \s*
            (?: \{  (.*\$\^\w.*) \}
              | (
                    .*(?: \* | \b_\b ).*
                    | $number
                    | '(?:[^']|\\')*'
                    | "(?:[^"]|\\")*"
                )
            )                                  \s*
            \.{3}                              \s*
            ([\d\*]+ | )
        $/xs
            or croak "parse error: $_";

        $end = '9**9**9' if $end eq '' or $end eq '*';
        $pre ||= '';
        my $self;
        if ($pre) {
            $pre =~ s/,\s*$//g;
            $pre = 'prefix '->$eval($pragma."[do {$pre}]");
        }
        my $i = 1;
        my $from;
        if ($block) {
            $block =~ s'\b(?:\$\^_|(?<!\$)_)\b'$_'g;
            for (sort keys %{{$block =~ /((\$\^\w+))/g}}) {
                $block =~ s/\Q$_/\$fetch->(undef, \$_ - $i)/g;
                $i++;
            }
            $self = $block;
        }
        else {
            $star =~ s'\b(?<!\$)_\b'$_'g;

            $star =~ s/(?<=[\*\w\]\}\)])\s*\*\*(?=\s*\S)/{#exp#}/g;

            $i = $star =~ s{
                \* (?= \s* ( \*{1,2} \s* \S
                           | [-+%.\/\)\]\};,]
                           | $
                           | \{\#.+?\#\}
                           )
            )} '{*}'gx;
            $star =~ s/\{#exp#\}/**/g;
            if ($i == 1 and $star !~ /\$_(?:\b|$)/) {
                $star =~ s/\Q{*}\E(?=\W|$)/\$_/g;
                $star =~ s/\Q{*}/\$_ /g;
                $from = 1;
            } else {
                $star =~ s/\Q{*}/'$fetch->(undef, $_ - '.$i--.')'/ge
            }
            $self = $star
        }
        $self = "FAST::List::Gen::iterate {package $pkg; $pragma$self} $end";

        'iterate'->$say_eval($self) if $SAY_EVAL or DEBUG;

        my $say = $self =~ /(?:\b|^)say(?:\b|$)/
                ? "use feature 'say';"
                : '';
        my $fetch;
        $self = (eval $say.$self
                   or Carp::croak "iterate error: $@\n$say$self\n");

        return $self->from(@$pre) if $from and $pre;
        $self->load(@$pre) if $pre and @$pre;
        $fetch = tied(@$self)->can('FETCH');
        weaken $fetch;
        $self
    }}


=item FAST::List::Gen C< ... >

the subroutine C< Gen > in the package C< List:: > is a dwimmy function that
produces a generator from a variety of sources.  since C< FAST::List::Gen > is a fully
qualified name, it is available from all packages without the need to import it.

if given only one argument, the following table describes what is done:

    array ref:    FAST::List::Gen \@array      ~~  makegen @array
    code ref:     FAST::List::Gen sub {$_**2}  ~~  <0..>->map(sub {$_**2})
    scalar ref:   FAST::List::Gen \'*2'        ~~  <0..>->map('*2')
    glob string:  FAST::List::Gen '1.. by 2'   ~~  <1.. by 2>
    glob string:  FAST::List::Gen '0, 1, *+*'  ~~  <0, 1, *+*...>
    file handle:  FAST::List::Gen $fh          ~~  file $fh

if the argument does not match the table, or the method is given more than one
argument, the list is converted to a generator with C< list(...) >

    FAST::List::Gen(1, 2, 3)->map('2**')->say;  # 2 4 8

since it results in longer code than any of the equivalent constructs, it is
mostly for if you have not imported anything: C< use FAST::List::Gen (); >

=cut

    sub FAST::List::Gen {
        do {
            if    (@_ == 0) {'FAST::List::Gen'}
            elsif (@_ == 1) {
                if (ref $_[0]) {
                    if    (ref $_[0] eq 'ARRAY' ) {&makegen}
                    elsif (ref $_[0] eq 'CODE'  ) {&range(0, 9**9**9)->map($_[0])}
                    elsif (ref $_[0] eq 'SCALAR') {&range(0, 9**9**9)->map(${$_[0]})}
                    elsif (isagen $_[0]         ) {$_[0]->copy}
                    elsif (openhandle $_[0]     ) {&file}
                }
                elsif ($_[0] =~ /.[.]{2,3}/) {&glob}
                elsif ($_[0] =~ /\*/) {&glob($_[0].'...')}
            }
        } or &list
    }
    BEGIN {*FAST::List::Generator = *FAST::List::Gen}


=item vecgen C< [BITS] [SIZE] [DATA] >

C< vecgen > wraps a bit vector in a generator.  BITS defaults to 8.  SIZE
defaults to infinite.  DATA defaults to an empty string.

cells of the generator can be assigned to using array dereferencing:

    my $vec = vecgen;
    $$vec[3] = 5;

or with the C<< ->set(...) >> method:

    $vec->set(3, 5);

=cut

    sub vecgen {
       tiegen Vec => @_
    }
    generator Vec => sub {
        my ($class, $bits, $size, $str) = @_;
        $str  ||= '';
        $bits ||= 8;
        $size ||= 9**9**9;
        FAST::List::Gen::curse {
            FETCH => sub {vec $str, $_[1], $bits},
            fsize => sub {$size},
          map {$_ => sub {vec($str, $_[1], $bits) = $_[2]}} qw (STORE set)
        } => $class
    };


=item primes

utilizing the same mechanism as the C<< <1..>->grep('prime') >> construct, the
C< primes > function returns an equivalent, but more efficiently constructed
generator.

prime numbers below 1e7 are tested with a sieve of eratosthenes and should be
reasonably efficient. beyond that, simple trial division is used.

C< primes > always returns the same generator.

=cut

    {
        our $DEBUG_PRIME;
        BEGIN {
            *FAST::List::Gen::DEBUG_PRIME = sub () {0}
                unless defined &FAST::List::Gen::DEBUG_PRIME;
        }
        my ($max, $prime, $primes_gen) = -1;
        sub _reset_prime {$max = -1; $primes_gen = $prime = ''}
        my $build = sub {
            return if $_[0] < $max;
            $max  = $_[0] > 1000
                  ? $_[0] : 1000;
            $max = min $max, 1e7;
            $prime = '001' . '10' x ($max/2);
            my ($n, $i) = 1;
            while (($n += 2) < $max) {
                if (substr $prime, $n, 1) { init:  $i  = $n;
                    substr $prime, $i, 1, 0 while ($i += $n) < $max}}
        };
        sub primes () {
           $primes_gen ||= do {
                $build->(1000);
                my ($n, $lim, $i) = 2;
                &iterate(sub {
                    if (FAST::List::Gen::DEBUG_PRIME and $DEBUG_PRIME) {
                        return $n++ if $n == 2;
                        no warnings;
                        goto trial_division
                    }
                    if ($n < 1e7) {
                        $n > $max and $build->($n * 10)
                           until substr $prime, $n++, 1;
                        $n - 1
                    }
                    else {trial_division:
                        while (1) {
                            $n++, next unless $n & 1;
                            ($i, $lim) = (3, 1 + int sqrt $n);
                            while ($i < $lim) {
                                $n % $i or $n++, next trial_division;
                                $i += 2;
                            }
                            return $n++
                        }
                    }
                })
            }
        }
        $ops{prime} = sub ($) {
            my $n = @_ ? $_[0] : $_;
            return $n == 2 if not $n & 1 or $n < 2;
            if (FAST::List::Gen::DEBUG_PRIME and $DEBUG_PRIME) {
                no warnings;
                goto trial_division
            }
            if ($n < 1e7) {
                $build->($n * 10) if $n > $max;
                substr $prime, $n, 1
            }
            else {trial_division:
                my ($i, $lim) = (1, 1 + int sqrt $n);
                $n % $i or return 0 while ($i += 2) < $lim;
                1
            }
        }
    }


=back

=head2 modifying generators

=over 4

=item slice C< SOURCE_GEN RANGE_GEN >

C< slice > uses C< RANGE_GEN > to generate the indices used to take a lazy
slice of C< SOURCE_GEN >.

    my $gen = gen {$_ ** 2};

    my $s1 = slice $gen, range 1, 9**9**9;
    my $s2 = slice $gen, <1..>;
    my $s3 = $gen->slice(<1..>);
    my $s4 = $gen->(<1..>);

    $s1 ~~ $s2 ~~ $s3 ~~ $s4 ~~ $gen->tail

C< slice > will perform some optimizations if it detects that C< RANGE_GEN > is
sufficiently simple (something like C< range $x, $y, 1 >). also, stacked simple
slices will collapse into a single slice, which turns repeated tailing of a
generator into a relatively efficient operation.

   $gen->(<1..>)->(<1..>)->(<1..>) ~~ $gen->(<3..>) ~~ $gen->tail->tail->tail

=cut

    sub slice {
       tiegen Slice => @_
    }
    generator Slice => sub {
        my $class  = $_[0];
        my $source = tied @{$_[1]};
        my $range  = tied @{dwim(@_[2..$#_])};
        my $fetch  = $source->can('FETCH');
        if (my $ranger = $range->can('range')) {
            my ($drop, $step, $take) = $ranger->();
            if ($step == 1) {
                while (my $slicer = $source->can('slice')) {
                    my ($pdrop, $ptake) = $slicer->();

                    $take = min $take, $ptake - $drop;
                    $drop += $pdrop;

                    $source = $source->source;
                    $fetch  = $source->can('FETCH');
                }
                $take = min $take, $source->fsize - $drop;
                $take > 0 or $take = 0;
                return curse {
                    FETCH  => ($drop == 0
                              ? $fetch
                              : sub {$fetch->(undef, $_[1] + $drop)}),
                    $source->mutable ? do {
                        my $size = $source->fsize;
                        $source->tail_size($size);
                        fsize   => sub {min $take, $size - $drop},
                        mutable => sub {1}
                    } : (
                        fsize => sub {$take}
                    ),
                    source => sub {$source},
                    slice  => sub {$drop, $take},
                } => $class
            }
        }
        my $index = $range->can('FETCH');
        curse {
            FETCH  => sub {$fetch->(undef, $index->(undef, $_[1]))},
            source => sub {$source},
            $range->mutable ? (
                fsize   => $range->can('fsize'),
                mutable => sub {1}
            ) : do {
                my $size = min $range->fsize, $source->fsize - $index->(undef, 0) - 1;
                fsize => sub {$size}
            },
        } => $class
    },
        mutable => sub {0};


=item test C< {CODE} [ARGS_FOR_GEN] >

C< test > attaches a code block to a generator.  it takes arguments suitable for
the C< gen > function. accessing an element of the returned generator will call
the code block first with the element in C< $_ >, and if it returns true, the
element is returned, otherwise an empty list (undef in scalar context) is
returned.

when accessing a slice of a tested generator, if you use the C<< ->(x .. y) >>
syntax, the the empty lists will collapse and you may receive a shorter slice.
an array dereference slice will always be the size you ask for, and will have
undef in each failed slot

the C<< $gen->nxt >> method is a version of C<< $gen->next >> that continues
to call C<< ->next >> until a call returns a value, or the generator
is exhausted.  this makes the C<< ->nxt >> method the easiest way to iterate
over only the passing values of a tested generator.

=cut

    sub test (&;$$$) {
        my $code = shift;
        unshift @_, sub {$code->() ? $_ : ()};
        goto &gen
    }


=item cache C< {CODE} >

=item cache C< GENERATOR >

=item cache C<< list => ... >>

C< cache > will return a cached version of the generators returned by functions
in this package. when passed a code reference, cache returns a memoized code ref
(arguments joined with C< $; >). when in 'list' mode, the source is in list
context, otherwise scalar context is used.

    my $gen = cache gen {slow($_)} \@source; # calls = 0

    print $gen->[123];    # calls += 1
    ...
    print @$gen[123, 456] # calls += 1

=cut

    sub cache ($;$) {
        my $gen = pop;
        my $list = "@_" =~ /list/i;
        if (isagen $gen) {
            tiegen Cache => tied @$gen, $list
        } elsif (ref $gen eq 'CODE') {
            my %cache;
            my $sep = $;;
            $list
                ? sub {@{$cache{join $sep => @_} ||= cap &$gen}}
                : sub {
                    my $arg = join $sep => @_;
                    exists $cache{$arg}
                         ? $cache{$arg}
                         :($cache{$arg} = &$gen)
                }
        } else {croak 'cache takes generator or coderef'}
    }
    generator Cache => sub {
        my ($class, $source, $list) = @_;
        my ($fetch, $fsize, %cache) = $source->closures;
        curse {
            FETCH  => (
                $list ? sub {
                    @{$cache{$_[1]} ||= cap $fetch->(undef, $_[1])}
                } : sub {
                    exists $cache{$_[1]}
                         ? $cache{$_[1]}
                         :($cache{$_[1]} = $fetch->(undef, $_[1]))
                }
            ),
            fsize  => $fsize,
            source => sub {$source},
            cached => sub {\%cache},
        } => $class
    },
    purge => sub {%{$_[0]->cached} = ()};


=item flip C< GENERATOR >

C< flip > is C< reverse > for generators. the C<< ->apply >> method is called on
C< GENERATOR >.  C<< $gen->flip >> and C<< $gen->reverse >> do the same thing.

    flip gen {$_**2} 0, 10   ~~   gen {$_**2} 10, 0, -1

=cut

    sub flip ($) {
        croak 'not generator' unless isagen $_[0];
        my $gen = tied @{$_[0]};
        $_[0]->apply if $gen->mutable;
        tiegen Flip => $gen
    }
    generator Flip => sub {
        my ($class, $source) = @_;
        my $size  = $source->fsize;
        my $end   = $size - 1;
        my $fetch = $source->can('FETCH');
        curse {
            FETCH  => sub {$fetch->(undef, $end - $_[1])},
            fsize  => $source->can('fsize'),
            source => sub {$source}
        } => $class
    };


=item expand C< GENERATOR >

=item expand C< SCALE GENERATOR >

C< expand > scales a generator with elements that return equal sized lists. it
can be passed a list length, or will automatically determine it from the length
of the list returned by the first element of the generator. C< expand >
implicitly caches its returned generator.

    my $multigen = gen {$_, $_/2, $_/4} 1, 10;   # each element returns a list

    say join ' '=> $$multigen[0];  # 0.25        # only last element
    say join ' '=> &$multigen(0);  # 1 0.5 0.25  # works
    say scalar @$multigen;         # 10
    say $multigen->size;           # 10

    my $expanded = expand $multigen;

    say join ' '=> @$expanded[0 .. 2];  # 1 0.5 0.25
    say join ' '=> &$expanded(0 .. 2);  # 1 0.5 0.25
    say scalar @$expanded;              # 30
    say $expanded->size;                # 30

    my $expanded = expand gen {$_, $_/2, $_/4} 1, 10; # in one line

C< expand > can also scale a generator that returns array references:

    my $refs = gen {[$_, $_.$_]} 3;

    say $refs->join(', '); # ARRAY(0x272514), ARRAY(0x272524), ARRAY(0x272544)
    say $refs->expand->join(', '); # 0, 00, 1, 11, 2, 22

C< expand > in array ref mode is the same as calling the C<< ->deref >> method.

=cut

    sub expand ($;$) {
        my $gen = pop;
        my ($scale, @first);
        croak "not generator" unless isagen $gen;
        if (@_) {
            $scale = shift;
        }
        else {
            $scale = @first = $gen->head;
            if (@first == 1 and ref $first[0] eq 'ARRAY') {
                return $gen->deref
            }
        }
        tiegen Expand => tied @$gen, $scale, @first
    }
    generator Expand => sub {
        my ($class, $source, $scale) = splice @_, 0, 3;
        my ($fetch, $fsize,  %cache) = $source->closures;
        @cache{0 .. $#_} = @_ if @_;
        my ($src_i, $ret_i);
        curse {
            FETCH => sub {
                unless (exists $cache{$_[1]}) {
                    $src_i = int ($_[1] / $scale);
                    $ret_i = $src_i * $scale;
                    @cache{$ret_i .. $ret_i + $scale - 1} = $fetch->(undef, $src_i);
                }
                $cache{$_[1]}
            },
            fsize => (
                $source->mutable
                    ? sub {$scale * $fsize->()}
                    : do {
                        my $size = $scale * $fsize->();
                        sub {$size}
                    }
            ),
            source => sub {$source},
            cached => sub {\%cache},
            purge  => sub {%cache = ()},
        } => $class
    };


=item contract C< SCALE GENERATOR >

C< contract > is the inverse of C< expand >

also called C< collect >

=cut

    sub contract ($$) {
        my ($scale, $gen) = @_;
        croak '$_[0] >= 1' if $scale < 1;
        croak 'not generator' unless isagen $gen;
        $scale == 1
            ? $gen
            :  gen {&$gen($_ .. $_ + $scale - 1)} 0 => $gen->size - 1, $scale
    }
    BEGIN {*collect = \&contract}


=item scan C< {CODE} GENERATOR >

=item scan C< {CODE} LIST >

C< scan > is a C< reduce > that builds a list of all the intermediate values.
C< scan > returns a generator, and is the function behind the C<< <[..+]> >>
globstring reduction operator.

    (scan {$a * $b} <1, 1..>)->say(8); # 1 1 2 6 24 120 720 5040 40320

    say <[..*] 1, 1..>->str(8);        # 1 1 2 6 24 120 720 5040 40320

    say <1, 1..>->scan('*')->str(8);   # 1 1 2 6 24 120 720 5040 40320

    say <[..*]>->(1, 1 .. 7)->str;     # 1 1 2 6 24 120 720 5040 40320

you can even use the C<< ->code >> method to tersely define a factorial
function:

    *factorial = <[..*] 1, 1..>->code;

    say factorial(5);  # 120

a stream version C< scan_stream > is also available.

=cut

    sub scan (&@) {
        local *iterate = *iterate_stream if $STREAM;
        my $binop = shift;
        my $gen  = (@_ == 1 && FAST::List::Gen::isagen($_[0]) or &makegen(\@_));
        my $last;
        if ($binop->$cv_wants_2_args) {
            iterate {$last = defined $last ? $binop->($last, $_) : $_} $gen
        } else {
            my ($a, $b) = $binop->$cv_ab_ref;
            iterate {$last = defined $last ? do {
                local (*$a, *$b) = \($last, $_);
                $binop->()
            } : $_} $gen
        }
    }
    sub scan_stream (&@) {
        local *iterate = *iterate_stream;
        &scan
    }
    BEGIN {*scanS = *scan_stream}


=item overlay C< GENERATOR PAIRS >

overlay allows you to replace the values of specific generator cells.  to set
the values, either pass the overlay constructor a list of pairs in the form
C<< index => value, ... >>, or assign values to the returned generator using
normal array ref syntax

    my $fib; $fib = overlay gen {$$fib[$_ - 1] + $$fib[$_ - 2]};
    @$fib[0, 1] = (0, 1);

    # or
    my $fib; $fib = gen {$$fib[$_ - 1] + $$fib[$_ - 2]}
                  ->overlay( 0 => 0, 1 => 1 );

    print "@$fib[0 .. 15]";  # '0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610'

=cut

    sub overlay ($%) {
        isagen (my $source = shift)
            or croak '$_[0] to overlay must be a generator';
        tiegen Overlay => tied @$source, @_
    }
    generator Overlay => sub {
        my ($class, $source, %overlay) = @_;
        my ($fetch, $fsize) = $source->closures;
        curse {
            FETCH  => sub {
                exists $overlay{$_[1]}
                     ? $overlay{$_[1]}
                     : $fetch->(undef, $_[1])
            },
            STORE  => sub {$overlay{$_[1]} = $_[2]},
            fsize  => $fsize,
            source => sub {$source}
        } => $class
    };


=item recursive C< [NAME] GENERATOR  >

C< recursive > defines a subroutine named C< self(...) > or C< NAME(...) >
during generator execution.  when called with no arguments it returns the
generator.  when called with one or more numeric arguments, it fetches those
indices from the generator.  when called with a generator, it returns a lazy
slice from the source generator.  since the subroutine created by C< recursive >
is installed at runtime, you must call the subroutine with parenthesis.

    my $fib = gen {self($_ - 1) + self($_ - 2)}
            ->overlay( 0 => 0, 1 => 1 )
            ->cache
            ->recursive;

    print "@$fib[0 .. 15]";  # '0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610'

when used as a method, C<< $gen->recursive >> can be shortened to C<< $gen->rec >>.

    my $fib = ([0, 1] + iterate {sum fib($_, $_ + 1)})->rec('fib');

    print "@$fib[0 .. 15]";  # '0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610'

of course the fibonacci sequence is better written with the glob syntax as
C<< <0, 1, *+*...> >> which is compiled into something similar to the example
with C< iterate > above.

=cut

    sub recursive {
        isagen (my $source = pop)
            or croak '$_[0] to recursive must be a generator';
        tiegen Recursive => $source, tied @$source, scalar caller, @_;
    }
    generator Recursive => sub {
        my ($class, $gen, $source) = @_;
        my ($fetch, $fsize) = $source->closures;
        my $caller = do {
            no strict 'refs';
            \*{$_[3].'::'.(@_ > 4 ? $_[4] : 'self')}
        };
        my $code = $gen->code;
        my $self = sub {@_ ? &$code : $gen};
        curse {
            FETCH  => sub {
                no warnings 'redefine';
                local *$caller = $self;
                $fetch->(undef, $_[1])
            },
            fsize  => $fsize,
            source => sub {$source}
        } => $class
    };


=back

=head2 mutable generators

=over 4

=item filter C< {CODE} [ARGS_FOR_GEN] >

C< filter > is a lazy version of C< grep > which attaches a code block to a
generator. it returns a generator that will test elements with the code
block on demand.  C< filter > processes its argument list the same way C< gen >
does.

C< filter > provides the functionality of the identical C<< ->filter(...) >> and
C<< ->grep(...) >> methods.

normal generators, such as those produced by C< range > or C< gen >, have a
fixed length, and that is used to allow random access within the range. however,
there is no way to know how many elements will pass a filter. because of this,
random access within the filter is not always C< O(1) >. C< filter > will
attempt to be as lazy as possible, but to access the 10th element of a filter,
the first 9 passing elements must be found first. depending on the coderef and
the source, the filter may need to process significantly more elements from its
source than just 10.

in addition, since filters don't know their true size, entire filter arrays do
not expand to the correct number of elements in list context. to correct this,
call the C<< ->apply >> method which will test the filter on all of its source
elements. after that, the filter will return a properly sized array. calling
C<< ->apply >> on an infinite (or very large) range wouldn't be a good idea. if
you are using C<< ->apply >> frequently, you should probably just be using
C< grep >. you can call C<< ->apply >> on any stack of generator functions, it
will start from the deepest filter and move up.

the method C<< ->all >> will first call C<< ->apply >> on itself and then return
the complete list

filters implicitly cache their values.  accessing any element below the highest
element already accessed is C< O(1) >.

accessing individual elements or slices works as you would expect.

    my $filter = filter {$_ % 2} 0, 100;

    say $#$filter;   # incorrectly reports 100

    say "@$filter[5 .. 10]"; # reads the source range up to element 23
                             # prints 11 13 15 17 19 21

    say $#$filter;   # reports 88, closer but still wrong

    $filter->apply;  # reads remaining elements from the source

    say $#$filter;   # 49 as it should be

note: C< filter > now reads one element past the last element accessed, this
allows filters to behave properly when dereferenced in a foreach loop (without
having to call C<< ->apply >>).  if you prefer the old behavior, set
C< $FAST::List::Gen::LOOKAHEAD = 0 > or use C< filter_ ... >

=cut

    sub filter (&;$$$) {
        goto &filter_stream if $STREAM;
        tiegen Filter => shift, tied @{&dwim}
    }
    mutable_gen Filter => sub {
        my ($class, $check, $source) = @_;
        my ($fetch, $fsize)   = $source->closures;
        my ($size, $src_size) = ($fsize->()) x 2;
        if ($source->mutable) {
            $source->tail_size($src_size)
        }
        my $when_done = sub {};
        my ($pos, @list, @tails) = 0;
        my $lookahead = $LOOKAHEAD || 0;
        curse {
            FETCH => sub {
                my $i = $_[1];
                unless ($i < $size) {
                    croak "filter index '$i' out of range [0 .. ".($size - 1).']';
                }
                local *_;
                while ($#list < $i + $lookahead) {
                    if ($pos < $src_size) {
                        *_ = \$fetch->(undef, $pos);
                        if ($pos < $src_size and $check->()) {
                            push @list, \$_;
                        }
                        $pos++
                    }
                    else {
                        $size = @list;
                        $$_ = $size for @tails;
                        $when_done->();
                        $i <= $#list ? last : return
                    }
                }
                $size = $pos < $src_size
                             ? @list + ($src_size - $pos)
                             : @list;
                $$_ = $size for @tails;

                ${ $list[$i] }
            },
            fsize      => sub {$size},
            tail_size  => sub {push @tails, \$_[1]; weaken $tails[-1]},
            source     => sub {$source},
            _when_done => sub :lvalue {$when_done},
        } => $class
    };

    sub filter_ (&;$$$) {
        local $LOOKAHEAD;
        &filter
    }


=item filter_stream C< {CODE} ... >

as C< filter > runs, it builds up a cache of the elements that pass the filter.
this enables efficient random access in the returned generator. sometimes this
caching behavior causes certain algorithms to use too much memory.
C< filter_stream > is a version of C< filter > that does not maintain a cache.

normally, access to C< *_stream > iterators must be monotonically increasing
since their source can only produce values in one direction.  filtering is a
reversible algorithm, and subsequently filter streams are able to rewind
themselves to any previous index.  however, unlike C< filter >, the
C< filter_stream > generator must test previously tested elements to rewind.
things probably wont end well if the test code is non-deterministic or if the
source values are changing.

when used as a method, it can be spelled C<< $gen->filter_stream(...) >> or
C<< $gen->grep_stream(...) >>

=cut

    sub filter_stream (&;$$$) {
         tiegen Filter_Stream => shift, tied @{&dwim}
    }
    BEGIN {*filterS = *filter_stream}

    mutable_gen Filter_Stream => sub {
        my ($class, $code, $src) = @_;
        my ($when_done, @tails ) = sub {};
        my $rewind   = sub {};
        my $idx      = 0;
        my $fetch    = $src->can('FETCH');
        my $size     =
        my $src_size = $src->fsize;
        $src->tail_size($src_size) if $src->mutable;
        my @window;
        my $pos   = 0;
        my $index = 0;
        my ($next, $prev) = do {
            no warnings 'exiting';
            sub {
                while ($pos < $src_size) {
                    *_ = \$fetch->(undef, $pos);
                    $pos < $src_size or last;
                    $pos++;
                    if (&$code) {
                        $idx++;
                        $pos = $src_size if $pos > $src_size;
                        return $_
                    }
                }
                $pos = $src_size;
                last outer
            },
            sub {
                while ($pos > 0) {
                    *_ = \$fetch->(undef, --$pos);
                    if (&$code) {
                        $idx--;
                        $index = $idx = $pos = 0 if $pos < 0;
                        return $_
                    }
                }
                $index = $idx = $pos = 0;
                last outer
            }
        };
        my $last;
        curse {
            FETCH =>
                ($LOOKAHEAD and ! $src->can('index')
                               || $src->isa($class))
                ? sub {
                    my ($want, $ret) = $_[1];
                    outer: {
                        local *_;
                        if ($idx > $want) {
                            while ($idx > $want) {
                                undef $ret;
                                $ret = $prev->();
                                $index--;
                            }
                        }
                        else {
                            my $end = $want + 1;
                            while ($idx <= $end) {
                                $ret = $last;
                                undef $last;
                                $last = $next->();
                                $index++;
                            }
                        }
                    }
                    for ($src_size - $pos + $idx) {
                        if ($size > $_) {
                            $size = $_;
                            $size = $idx if $pos == $src_size;
                            $$_ = $size for @tails;
                        }
                    }
                    defined $ret ? $ret : ()
                }
                : sub {
                    my ($want, $ret) = $_[1];
                    outer: {
                        local *_;
                        if    ($idx >  $want) {$ret = $prev->() while $idx >  $want}
                        elsif ($idx == $want) {$ret = $next->()                    }
                        elsif ($idx <  $want) {$ret = $next->() while $idx <= $want}
                    }
                    $index = $idx;
                    for ($src_size - $pos + $idx) {
                        if ($size > $_) {
                            $size = $_;
                            $$_ = $size for @tails;
                        }
                    }
                    defined $ret ? $ret : ()
                },
            fsize      => sub {$size},
            tail_size  => sub {push @tails, \$_[1]; &weaken($tails[-1])},
            _when_done => sub :lvalue {$when_done},
            rewind     => $rewind,
            index      => sub {\$index},
        } => $class;
    };


=item While C<< {CODE} GENERATOR >>

=item Until C<< {CODE} GENERATOR >>

C<< While / ->while(...) >> returns a new generator that will end when its
passed in subroutine returns false. the C< until > pair ends when the subroutine
returns true.

if C< $FAST::List::Gen::LOOKAHEAD > is true (the default), each reads one element past
its requested element, and saves this value only until the next call for
efficiency, no other values are saved. each supports random access, but is
optimized for sequential access.

these functions have all of the caveats of C< filter >, should be considered
experimental, and may change in future versions. the generator returned should
only be dereferenced in a C< foreach > loop, otherwise, just like a C< filter >
perl will expand it to the wrong size.

the generator will return undef the first time an access is made and the check
code indicates it is past the end.

the generator will throw an error if accessed beyond its dynamically found limit
subsequent times.

    my $pow = While {$_ < 20} gen {$_**2};
              <0..>->map('**2')->while('< 20')

    say for @$pow;

prints:

    0
    1
    4
    9
    16

in general, it is faster to write it this way:

    my $pow = gen {$_**2};
    $gen->do(sub {
        last if $_ > 20;
        say;
    });

=cut

    sub While (&$) {
        my ($code, $source) = @_;
        isagen $source
            or croak '$_[1] to While must be a generator';
        tiegen While => tied @$source, $code
    }
    sub Until (&$) {
        my ($code, $source) = @_;
        isagen $source
            or croak '$_[1] to Until must be a generator';
        tiegen While => tied @$source, sub {not &$code}
    }
    sub while_ (&$) {local $LOOKAHEAD; &While}
    sub until_ (&$) {local $LOOKAHEAD; &Until}

    BEGIN {
        *take_while = *While;
        *take_until = *Until;
    }

    sub drop_while (&$) {$_[1]->drop_while($_[0])}
    sub drop_until (&$) {$_[1]->drop_until($_[0])}

    mutable_gen While => sub {
        my ($class, $source, $check) = @_;
        my ($fetch, $fsize)   = $source->closures;
        my ($size, $src_size) = ($fsize->()) x 2;
        if ($source->mutable) {
            $source->tail_size($src_size)
        }
        my $lookahead = $LOOKAHEAD;
        my (@next, @tails) = -1;
        my $when_done = sub {};
        my $done = sub {
            $size = $_[0];
            $$_ = $size for @tails;
            $when_done->();
            @next = -1;
            return
        };
        curse {
            FETCH => sub {
                my $i = $_[1];
                unless ($i < $size) {
                    croak "while/until: index '$i' past end '".($size - 1)."'"
                }
                if ($i < $src_size) {
                    local *_ = $i == $next[0] ? $next[1] : \$fetch->(undef, $i);
                    return $done->($i) unless $i < $src_size and $check->();

                    if ($lookahead and $i + 1 < $src_size) {
                        local *_ = \$fetch->(undef, $i + 1);
                        if ($i + 1 < $src_size and $check->()) {
                            @next = ($i + 1, \$_)
                        }
                        else {
                            $done->($i + 1)
                        }
                    }
                    return $_
                }
                else {
                    $done->($src_size)
                }
            },
            fsize      => sub {$size},
            tail_size  => sub {push @tails, \$_[1]; weaken $tails[-1]},
            source     => sub {$source},
            _when_done => sub :lvalue {$when_done},
        } => $class
    };


=item mutable C< GENERATOR >

=item C<< $gen->mutable >>

C< mutable > takes a single fixed size (immutable) generator, such as those
produced by C< gen > and converts it into a variable size (mutable) generator,
such as those returned by C< filter >.

as with filter, it is important to not use full array dereferencing (C< @$gen >)
with mutable generators, since perl will expand the generator to the wrong size.
to access all of the elements, use the C<< $gen->all >> method, or call
C<< $gen->apply >> before C< @$gen >.  using a slice C< @$gen[5 .. 10] > is
always ok, and does not require calling C<< ->apply >>.

mutable generators respond to the C< FAST::List::Gen::Done > exception, which can be
produced with either C< done >, C< done_if >, or C< done_unless >.  when the
exception is caught, it causes the generator to set its size, and it also
triggers any C<< ->when_done >> actions.

    my $gen = mutable gen {done if $_ > 5; $_**2};

    say $gen->size; # inf
    say $gen->str;  # 0 1 4 9 16 25
    say $gen->size; # 6

generators returned from C< mutable > have a C<< ->set_size(int) >> method
that will set the generator's size and then trigger any
C<< ->when_done(sub{...}) >> methods.

=cut

    sub mutable {
       tiegen Mutable => tied @{isagen $_[0] or croak "var takes a generator"}
    }
    generator Mutable => sub {
        my ($class, $source  ) = @_;
        my ($fetch, $fsize   ) = $source->closures;
        my ($when_done, $size) = sub {};
        curse {
            FETCH => sub {
                defined $size and $_[1] >= $size
                    and croak "index $_[1] out of bounds [0 .. ${\($size - 1)}";

                my $ret = eval {cap($fetch->(undef, $_[1]))}
                  or catch_done and ref $@ ? do {
                      my $val = $@;
                      $size   = $_[1] + 1;
                      $when_done->();
                      return wantarray ? @$val : pop @$val
                  } : do {
                      $size = $_[1];
                      $when_done->();
                      return
                  };
                wantarray ? @$ret : pop @$ret
            },
            fsize => $source->mutable
                ? sub {defined $size ? $size : $fsize->()}
                : sub {defined $size ? $size : ($size = $fsize->())},
            set_size   => sub {$size = int $_[1]; $when_done->()},
            _when_done => sub :lvalue {$when_done},
            source     => sub {$source},
        } => $class
    },
        when_done => sub {
            my ($self, @next) = @_;
            my $when_done = $self->_when_done;
            if (@next) {
                $self->_when_done = sub {
                    $_->($self) for $when_done, @next;
                }
            } else {$when_done}
        },
        clear_done => sub {
            $_[0]->_when_done = sub {};
            $_[0]
        },
        mutable => sub () {1},
        apply => sub {
            my $self = shift;
            my $code = $self->can('FETCH');
            my ($i, $ok) = (0, 1);
            $self->when_done(sub{undef $ok});
            my $size = $self->fsize;
            $code->(undef, $i++) while $ok and $i < $size;
            $self->when_done->() if $ok;
            $self->clear_done
        };


=item done C< [LAST_RETURN_VALUE] >

throws an exception that will be caught by a mutable generator indicating that
the generator should set its size. if a value is passed to done, that will be
the final value returned by the generator, otherwise, the final value will be
the value returned on the previous call.

=cut

    sub done {die bless [@_] => 'FAST::List::Gen::Done'}
    sub catch_done () {
        ref $@
            ? ref $@ eq 'FAST::List::Gen::Done'
                ? @{$@} ? [@{$@}] : eval {1}
                : die $@
            : croak $@
    }


=item done_if C< COND VALUE >

=item done_unless C< COND VALUE >

these are convenience functions for throwing C< done > exceptions.  if the
condition does not indicate C< done > then the function returns C< VALUE >

=cut

    sub done_if     ($@) { shift @_ ? &done : wantarray ? @_ : pop}
    sub done_unless ($@) {!shift @_ ? &done : wantarray ? @_ : pop}


=item strict C< {CODE} >

in the C< CODE > block, calls to functions or methods are subject to the
following localizations:

=over 4

=item * C< local $FAST::List::Gen::LOOKAHEAD = 0; >

the functions C< filter >, C< While > and their various forms normally stay an
element ahead of the last requested element so that an array dereference in a
C< foreach > loop ends properly. this localization disables this behavior, which
might be needed for certain algorithms.  it is therefore important to never
write code like: C< for(@$strict_filtered){...} >, instead write
C<< $strict_filtered->do(sub{...}) >> which is faster as well. the following
code illustrates the difference in behavior:

    my $test = sub {
        my $loud = filter {print "$_, "; $_ % 2};
        print "($_:", $loud->next, '), ' for 0 .. 2;
        print $/;
    };
    print 'normal: '; $test->();
    print 'strict: '; strict {$test->()};

    normal: 0, 1, 2, 3, (0:1), 4, 5, (1:3), 6, 7, (2:5),
    strict: 0, 1, (0:1), 2, 3, (1:3), 4, 5, (2:5),

=item * C< local $FAST::List::Gen::DWIM_CODE_STRINGS = 0; >

in the dwim C<< $gen->(...) >> code deref syntax, if C< $DWIM_CODE_STRINGS > has
been set to a true value, bare strings that look like code will be interpreted
as code and passed to C< gen > (string refs to C< filter >).  since this
behavior is fun for golf, but potentially error prone, it is off by default.
C< strict > turns it back off if it had been turned on.

=back

C< strict > returns what C< CODE > returns. C< strict > may have additional
restrictions added to it in the future.

=cut

    sub strict (&) {
        local $STRICT            = 1;
        local $LOOKAHEAD         = 0;
        local $DWIM_CODE_STRINGS = 0;
        $_[0]->()
    }


=back

=head2 combining generators

=over 4

=item sequence C< LIST >

string generators, arrays, and scalars together.

C< sequence > provides the functionality of the overloaded C< + > operator on
generators:

    my $seq = <1 .. 10> + <20 .. 30> + <40 .. 50>;

is exactly the same as:

    my $seq = sequence <1 .. 10>, <20 .. 30>, <40 .. 50>;

you can even write things like:

    my $fib; $fib = [0, 1] + iterate {sum $fib->($_, $_ + 1)};

    say "@$fib[0 .. 10]"; # 0 1 1 2 3 5 8 13 21 34 55

=cut

{
    sub sequence {
       tiegen Sequence => @_
    }
    my %seq_const;
    BEGIN {
        %seq_const = (
            FETCH   => 0,
            SIZE    => 1,   LOW  => 1,
            MUTABLE => 2,   HIGH => 2,
        );
        eval "sub $_ () {$seq_const{$_}} 1" or die $@ for keys %seq_const
    }
    generator Sequence => sub {
        my $class  = shift;
        my $size   = 0;
        my @sequence = map {
            (isagen) ? @{(tied(@$_)->can('sequence') or sub {[$_]})->()}
                     : ref eq 'ARRAY' ? makegen @$_ : &makegen([$_])
        } @_;
        my $mutable;
        my @source;
        my $build = sub {
            $mutable = first {$_->is_mutable} @sequence;
            @source  = map {
                $mutable ? [tied(@$_)->closures, $_->is_mutable]
                         : [tied(@$_)->{FETCH}, $size+0, $size += $_->size]
            } @sequence;
            $size = 9**9**9 if $mutable;
        };
        $build->();
        curse {
            FETCH => $mutable ? sub {
                my $i = $_[1];
                croak "sequence index $i out of bounds [0 .. @{[$size - 1]}]"
                    if $i >= $size;
                my $depth = 0;
                for (@source) {
                    my $cur_size = $$_[SIZE]->();
                    if (($depth + $cur_size) > $i) {
                        if ($$_[MUTABLE]) {
                            my $got = \$$_[FETCH]->(undef, $i - $depth);
                            $cur_size = $$_[SIZE]->();
                            return $$got if ($depth + $cur_size) > $i;
                        } else {
                            return $$_[FETCH]->(undef, $i - $depth)
                        }
                    }
                    $depth += $cur_size;
                }
                $size = $depth;
                return;
            } : do {
                my $pos = $#source >> 1;
                my $src = $source[$pos];
                my $i;
                my ($min, $max);
                sub {
                    $i = $_[1];
                    croak "sequence index $i out of bounds [0 .. @{[$size - 1]}]"
                        if $i >= $size;
                    $min = 0;
                    $max = $#source;
                    while ($min <= $max) {
                        if    ($$src[HIGH] <= $i) {$min = $pos + 1}
                        elsif ($$src[LOW]  >  $i) {$max = $pos - 1}
                        else {
                            return $$src[FETCH]->(undef, $i - $$src[LOW])
                        }
                        $pos = ($min + $max) >> 1;
                        $src = $source[$pos];
                    }
                    croak "sequence error at index: $i"
                }
            },
            fsize    => sub {$size},
            sequence => sub {\@sequence},
            $mutable ? (mutable => sub {1}) : (),
            rebuild  => $build,
            source   => do {
                my @src = map tied @$_, @sequence;
                sub {\@src}
            },
        } => $class
    }, mutable => sub {0};
    BEGIN {delete $FAST::List::Gen::{$_} for keys %seq_const}
}


=item zipgen C< LIST >

C< zipgen > is a lazy version of C< zip >. it takes any combination of
generators and array refs and returns a generator.  it is called automatically
when C< zip > is used in scalar context.

C< zipgen > can be spelled C< genzip >

=cut

    sub zipgen {
       tiegen Zip => map tied @{isagen or makegen @$_} => @_
    }
    BEGIN {*genzip = *zipgen}
    generator Zip => sub {
        my ($class, @src) = @_;
        my @fetch   = map $_->can('FETCH') => @src;
        my @size    = map $_->can('fsize') => @src;
        my @mutable = map $_->mutable || 0 => @src;
        if (grep {$_} @mutable) {
            my ($size, @cache, $cached);
            my $set_size = sub {
                @cache   = ();
                $cached  = -1;
                $size    = @src * min(map $_->() => @size);
            };
            $set_size->();
            curse {
                FETCH   => sub {
                    croak "zipgen index $_[1] out of range [0 .. ".($size-1)."]"
                        if $_[1] >= $size;

                    my ($src, $i) = (($_[1] % @src), int ($_[1] / @src));

                    unless ($cached == $i) {
                        @cache  = ();
                        $cached = $i;
                        for my $sid (0 .. $#src) {
                            if ($mutable[$sid]) {
                                if ($i < $size[$sid]()) {
                                    $cache[$sid] = \$fetch[$sid](undef, $i);
                                    if ($i >= $size[$sid]()) {
                                        $set_size->();
                                        return
                                    }
                                } else {
                                    $set_size->();
                                    return
                                }
                            } else {
                                $cache[$sid] = \$fetch[$sid](undef, $i);
                            }
                        }
                    }
                    ${$cache[$src]}
                },
                fsize   => sub {$size},
                source  => sub {\@src},
                mutable => sub {1},
                apply   => $set_size,
            } => $class;
        } else {
            my $size = @src * min(map $_->() => @size);
            curse {
                FETCH  => sub {
                    $fetch[$_[1] % @src](undef, int ($_[1] / @src))
                },
                fsize  => sub {$size},
                source => sub {\@src}
            } => $class
        }
    };


=item unzip C< LIST >

C< unzip > is the opposite of C< zip src1, src2 >.  unzip returns 2 generators,
the first returning src1, the second, src2. if C< LIST > is a single element,
and is a generator, that generator will be unzipped.

=cut

    sub unzip;
    *unzip = &unzipn(2);


=item unzipn C< NUMBER LIST >

C<unzipn> is the n-dimentional precursor of C< unzip >.  assuming a zipped list
produced by C< zip > with C< n > elements, C< unzip n list> returns C< n > lists
corresponding to the lists originally passed to C< zip >.  if C< LIST > is a
single element, and is a generator, that generator will be unzipped.  if only
passed 1 argument, C< unzipn > will return a curried version of itself:

   *unzip3 = unzipn 3;

   my $zip3 = zip <1..>, <2..>, <3..>;

   my ($x, $y, $z) = unzip3($zip3);

   # $x == <1..>, $y == <2..>, $z == <3..>;

=cut

    sub unzipn ($@) {
        return \&unzipn unless @_;
        my $n  = shift;
        return sub {&unzipn($n, @_)} unless @_;
        if (@_ == 1 and ref $_[0] and isagen $_[0]) {
            my $gen = $_[0];
            if ($gen->is_mutable) {
                my @lists;
                $gen->when_done(sub {
                    my $size = int ($gen->size / $n);
                    $_->set_size($size) for @lists;
                    @lists = ()
                });
                @lists = map {
                    my $i = $_;
                    mutable gen {
                        my $idx = $_ * $n + $i;
                        my $ret;
                        done if $gen->size <= $idx;
                        done if not eval {$ret = \$gen->get($idx); 1};
                        done if $gen->size <= $idx;
                        $$ret
                    }
                } 0 .. $n - 1
            }
            else {
                my $size  = int($gen->size/$n);
                my $extra = $gen->size - $size*$n;
                map {
                    my $i = $_;
                    gen {$gen->get($i + $n * $_)} $size + ($extra --> 0)
                } 0 .. $n - 1
            }
        } else {
            my $cap   = \@_;
            my $size  = int(@_/$n);
            my $extra = @_ - $size*$n;
            map {
                my $i = $_;
                gen {$$cap[$i + $n * $_]} $size + ($extra --> 0)
            } 0 .. $n - 1;
        }
    }


=item zipgenmax C< LIST >

C< zipgenmax > is a lazy version of C< zipmax >. it takes any combination of
generators and array refs and returns a generator.

=cut

    sub zipgenmax {
        my @src   = map tied @{isagen or makegen @$_} => @_;
        my @fetch = map $_->can('FETCH') => @src;
        my @size  = map $_->can('fsize') => @src;
        if (first {$_->mutable} @src) {
            mutable gen {
                my ($src, $i) = (($_ % @src), int ($_ / @src));
                my $ret = $i < $size[$src]() ? $fetch[$src](undef, $i) : undef;
                done if $i >= max(map $_->() => @size);
                $ret
            } 0 => @src * max(map $_->() => @size) - 1
        } else {
            @size = map $_->() => @size;
            gen {
                my ($src, $i) = (($_ % @src), int ($_ / @src));
                $i < $size[$src] ? $fetch[$src](undef, $i) : undef
            } 0 => @src * max(@size) - 1
        }
    }


=item zipwith C< {CODE} LIST>

C<zipwith> takes a code block and a list.  the C<LIST> is zipped together and
each sub-list is passed to C<CODE> when requested.  C<zipwith> produces a
generator with the same length as its shortest source list.

    my $triples = zipwith {\@_} <1..>, <20..>, <300..>;

    say "@$_" for @$triples[0 .. 3];

    1 20 300   # the first element of each list
    2 21 301   # the second
    3 22 302   # the third
    4 23 303   # the fourth

=cut

    sub zipwith (&@) {
        my $code = shift;
        my $src  = \@_;
        my $mutable;
        isagen or $_ = makegen @$_ for @$src;
        $mutable ||= (not defined or $_->is_mutable) for @$src;
        if ($mutable) {
            my @size;
            mutable gen {
                my $i = $_;
                my $last;
                unless (@size) {
                    for (map {tied @$_} @$src) {
                        push @size, $_->fsize;
                        $_->tail_size($size[-1]) if $_->mutable;
                    }
                }
                $_ <= $i and done for @size;
                my $arg = cap map $$src[$_]->get($i) => 0 .. $#$src;

                for (@size) {
                    done    if $_ <= $i;
                    $last++ if $_ == $i + 1;
                }
                my $ret = cap $code->(@$arg);
                done @$ret if $last;
                wantarray ? @$ret : pop @$ret
            }
        } else {
            my @fetch = map tied(@$_)->can('FETCH'), @$src;
            gen {
                my $i = $_;
                $code->(map $_->(undef, $i), @fetch)
            } min map $_->size, @$src;
        }
    }


=item zipwithab C<<< {AB_CODE} $gen1, $gen2 >>>

The zipwithab function takes a function which uses C< $a > and C< $b >, as well
as two lists and returns a list analogous to zipwith.

=cut

    sub zipwithab (&@) {
        my $code = shift;
        my $src  = \@_;
        my ($a, $b) = $code->$cv_ab_ref;
        my  $mutable;
            $mutable ||= (not defined or $_->is_mutable) for @$src;
        if ($mutable) {
            my @size;
            mutable gen {
                unless (@size) {
                    for (map {tied @$_} @$src) {
                        push @size, $_->fsize;
                        $_->tail_size($size[-1]) if $_->mutable
                    }
                }
                my $i = $_;
                done if first {$_ <= $i} @size;
                local *$a = \$$src[0]->get($i);
                local *$b = \$$src[1]->get($i);
                done if first {$_ <= $i} @size;
                $code->()
            }
        } else {
            my ($fetch_a, $fetch_b) = map tied(@$_)->can('FETCH'), @$src;
            gen {
                local *$a = \$fetch_a->(undef, $_);
                local *$b = \$fetch_b->(undef, $_);
                $code->()
            } min map $_->size, @$src
        }
    }


=item zipwithmax C< {CODE} LIST >

C< zipwithmax > is a version of C< zipwith > that has the ending conditions of
C< zipgenmax >.

=cut

    sub zipwithmax (&@) {
        my $code  = shift;
        $code->$sv2cv;
        my @src   = map tied @{isagen or makegen @$_} => @_;
        my @fetch = map $_->can('FETCH') => @src;
        my @size  = map $_->can('fsize') => @src;
        if (first {$_->mutable} @src) {
            mutable gen {
                my $i = int ($_ / @src);
                my @ret = map {$i < $size[$_]() ? $fetch[$_](undef, $i) : undef} 0 .. $#src;
                done if $i >= max(map $_->() => @size);
                $code->(@ret)
            } 0 => max(map $_->() => @size) - 1
        } else {
            @size = map $_->() => @size;
            gen {
                my $i = int ($_ / @src);
                $code->(map {$i < $size[$_] ? $fetch[$_](undef, $i) : undef} 0 .. $#src)
            } 0 => max(@size) - 1
        }
    }


=item transpose C< MULTI_DIMENSIONAL_ARRAY >

=item transpose C< LIST >

C< transpose > computes the 90 degree rotation of its arguments, which must be
a single multidimensional array or generator, or a list of 1+ dimensional
structures.

    say transpose([[1, 2, 3]])->perl; # [[1], [2], [3]]

    say transpose([[1, 1], [2, 2], [3, 3]])->perl; # [[1, 2, 3], [1, 2, 3]]

    say transpose(<1..>, <2..>, <3..>)->take(5)->perl;
    # [[1, 2, 3], [2, 3, 4], [3, 4, 5], [4, 5, 6], [5, 6, 7]]

=cut

    sub transpose {
        my $src = @_ == 1 ? shift : \@_;
        return empty unless @$src;
        if (isagen $$src[0] and $$src[0]->is_mutable) {
            iterate_multi {
                my $i = $_;
                $i < $_->size or done for @$src;
                $_->get($i) for @$src;
                $i < $_->size or done for @$src;
                $i + 1 < $_->size or do {
                    done mutable gen {$i < @$_ ? $$_[$i] : done} $src
                } for @$src;
                mutable gen {$i < @$_ ? $$_[$i] : done} $src
            }
        } else {
            iterate {
                my $i = $_;
                gen {$$_[$i]} $src
            } 0+@{$$src[0]}
        }
    }


=item cartesian C< {CODE} LIST >

C< cartesian > computes the cartesian product of any number of array refs or
generators, each which can be any size. returns a generator

    my $product = cartesian {$_[0] . $_[1]} [qw/a b/], [1, 2];

    @$product == qw( a1 a2 b1 b2 );

=cut

    sub cartesian (&@) {
        my $code  = shift;
        my @src   = @_;
        my @size  = map {0+@$_} @src;
        my $size  = 1;
        my @cycle = map {$size / $_}
                    map {$size *= $size[$_] || 1} 0 .. $#src;
        gen {
            my $i = $_;
            $code->(map {
              $size[$_] ? $src[$_][ $i / $cycle[$_] % $size[$_] ] : ()
            } 0 .. $#src)
        } 0 => $size - 1
    }


=back

=head2 misc functions

=over 4

=item mapkey C< {CODE} KEY LIST >

this function is syntactic sugar for the following idiom

    my @cartesian_product =
        map {
            my $first = $_;
            map {
                my $second = $_;
                map {
                    $first . $second . $_
                } 1 .. 3
            } qw/x y z/
        } qw/a b c/;

    my @cartesian_product =
        mapkey {
            mapkey {
                mapkey {
                    $_{first} . $_{second} . $_{third}
                } third => 1 .. 3
            } second => qw/x y z/
        } first => qw/a b c/;

=cut

    sub mapkey (&$@) {
        my ($code, $key) = splice @_, 0, 2;
        local $_{$key};
        map {
            $_{$key} = $_;
            $code->()
        } @_
    }


=item mapab C< {CODE} PAIRS >

this function works like the builtin C< map > but consumes a list in pairs,
rather than one element at a time. inside the C< CODE > block, the variables
C< $a > and C< $b > are aliased to the elements of the list. if C< mapab > is
called in void context, the C< CODE > block will be executed in void context
for efficiency.  if C< mapab > is passed an uneven length list, in the final
iteration, C< $b > will be C< undef >

    my %hash = (a => 1, b => 2, c => 3);

    my %reverse = mapab {$b, $a} %hash;

=cut

    sub mapab (&%) {
        my ($code, @ret) = shift;
        my $want = defined wantarray;
        my ($a, $b) = $code->$cv_ab_ref;
        local (*$a, *$b);
        while (@_) {
            if (@_ == 1) {
                *$a = \shift;
                *$b = \undef;
            } else {
                (*$a, *$b) = \splice @_, 0, 2
            }
            if ($want) {push @ret => $code->()}
            else {$code->()}
        }
        @ret
    }


=item slide C< {CODE} WINDOW LIST >

slides a C< WINDOW > sized slice over C< LIST >, calling C< CODE > for each
slice and collecting the result

as the window reaches the end, the passed in slice will shrink

    print slide {"@_\n"} 2 => 1 .. 4
    # 1 2
    # 2 3
    # 3 4
    # 4         # only one element here

=cut

    sub slide (&$@) {
        my ($code, $window) = splice @_, 0, 2;
        $window--;
        map $code->(@_[$_ .. min $_+$window, $#_]) => 0 .. $#_
    }


=item remove C< {CODE} ARRAY|HASH >

C< remove > removes and returns elements from its source when C< CODE >
returns true. in the code block, if the source is an array, C< $_ > is aliased
to its elements.  if the source is a hash, C< $_ > is aliased to its keys (and
a list of the removed C<< key => value >> pairs are returned).

    my @array   = (1, 7, 6, 3, 8, 4);
    my @removed = remove {$_ > 5} @array;

    say "@array";   # 1 3 4
    say "@removed"; # 7 6 8

in list context, C< remove > returns the list of removed elements/pairs.
in scalar context, it returns the number of removals.  C< remove > will not
build a return list in void context for efficiency.

=cut

    sub remove (&\[@%]) {
        my ($code, $src) = @_;
        my ($want, @ret) = defined wantarray;
        local *_;
        if (reftype $src eq 'ARRAY') {
            my $i = 0;
            while ($i < @$src) {
                *_ = \$$src[$i];
                &$code ? $want ? push @ret, splice @$src, $i, 1
                               :            splice @$src, $i, 1
                       : $i++
            }
        }
        else {
            for (keys %$src) {
                if (&$code) {
                    $want ? push @ret, $_ => delete $$src{$_}
                          :                  delete $$src{$_}
                }
            }
        }
        wantarray
            ? @ret
            : reftype $src eq 'HASH'
                ? @ret / 2
                : @ret
    }


=item d C< [SCALAR] >

=item deref C< [SCALAR] >

dereference a C< SCALAR >, C< ARRAY >, or C< HASH > reference. any other value
is returned unchanged

    print join " " => map deref, 1, [2, 3, 4], \5, {6 => 7}, 8, 9, 10;
    # prints 1 2 3 4 5 6 7 8 9 10

=cut

    sub d (;$) {
        local *_ = \$_[0] if @_;
        my $type = reftype $_;
        $type ?
            $type eq 'ARRAY'  ? @$_ :
            $type eq 'HASH'   ? %$_ :
            $type eq 'SCALAR' ? $$_ : $_
        : $_
    }
    BEGIN {*deref = \&d}


=item curse C< HASHREF PACKAGE >

many of the functions in this package utilize closure objects to avoid the speed
penalty of dereferencing fields in their object during each access. C< curse >
is similar to C< bless > for these objects and while a blessing makes a
reference into a member of an existing package, a curse conjures a new package
to do the reference's bidding

    package Closure::Object;
        sub new {
            my ($class, $name, $value) = @_;
            curse {
                get  => sub {$value},
                set  => sub {$value = $_[1]},
                name => sub {$name},
            } => $class
        }

C<< Closure::Object >> is functionally equivalent to the following normal perl
object, but with faster method calls since there are no hash lookups or other
dereferences (around 40-50% faster for short getter/setter type methods)

    package Normal::Object;
        sub new {
            my ($class, $name, $value) = @_;
            bless {
                name  => $name,
                value => $value,
            } => $class
        }
        sub get  {$_[0]{value}}
        sub set  {$_[0]{value} = $_[1]}
        sub name {$_[0]{name}}

the trade off is in creation time / memory, since any good curse requires
drawing at least a few pentagrams in the blood of an innocent package.

the returned object is blessed into the conjured package, which inherits from
the provided C< PACKAGE >. always use C<< $obj->isa(...) >> rather than
C< ref $obj eq ... > due to this. the conjured package name matches
C<< /${PACKAGE}::_\d+/ >>

special keys:

    -bless    => $reference  # returned instead of HASHREF
    -overload => [fallback => 1, '""' => sub {...}]

when fast just isn't fast enough, since most cursed methods don't need to be
passed their object, the fastest way to call the method is:

    my $obj = Closure::Object->new('tim', 3);
    my $set = $obj->{set};                  # fetch the closure
         # or $obj->can('set')

    $set->(undef, $_) for 1 .. 1_000_000;   # call without first arg

which is around 70% faster than pre-caching a method from a normal object for
short getter/setter methods, and is the method used internally in this module.

=back

=head1 SEE ALSO

=over 4

=item * see L<FAST::List::Gen::Cookbook> for usage tips.

=item * see L<FAST::List::Gen::Benchmark> for performance tips.

=item * see L<FAST::List::Gen::Haskell> for an experimental implementation of
haskell's lazy list behavior.

=item * see L<FAST::List::Gen::Lazy> for the tools used to create
L<FAST::List::Gen::Haskell>.

=item * see L<FAST::List::Gen::Lazy::Ops> for some of perl's operators implemented
as lazy haskell like functions.

=item * see L<FAST::List::Gen::Lazy::Builtins> for most of perl's builtin functions
implemented as lazy haskell like functions.

=item * see L<FAST::List::Gen::Perl6> for a source filter that adds perl6's meta
operators to use with generators, rather than the default overloaded operators

=back

=head1 CAVEATS

version 0.90 added C< glob > to the default export list (which gives you
syntactic ranges C<< <1 .. 10> >> and list comprehensions.).  version 0.90 also
adds many new features and bug-fixes, as usual, if anything is broken, please
send in a bug report. the ending conditions of C< zip > and C< zipgen > have
changed, see the documentation above. C< test > has been removed from the
default export list. setting C< $FAST::List::Gen::LIST > true to enable list context
generators is no longer supported and will now throw an error. C< list > has
been added to the default export list.  C< genzip > has been renamed C< zipgen >

version 0.70 comes with a bunch of new features, if anything is broken, please
let me know.  see C< filter > for a minor behavior change

versions 0.50 and 0.60 break some of the syntax from previous versions,
for the better.

=over 4

=item code generation

a number of the syntactic shortcuts that FAST::List::Gen provides will construct and
then evaluate code behind the scenes.  Normally this is transparent, but if you
are trying to debug a problem, hidden code is never a good thing.  You can
lexically enable the printing of evaled code with:

    local $FAST::List::Gen::SAY_EVAL = 1;

    my $fib = <0, 1, *+*...>;

    #   eval: ' @pre = (0, 1)' at (file.pl) line ##
    #   eval: 'FAST::List::Gen::iterate { if (@pre) {shift @pre}
    #            else { $fetch->(undef, $_ - 2) + $fetch->(undef, $_ - 1) }
    #        } 9**9**9' at (file.pl) line ##

    my $gen = <1..10>->map('$_*2 + 1')->grep('some_predicate');

    #   eval: 'sub ($) {$_*2 + 1}' at (file.pl) line ##
    #   eval: 'sub ($) {some_predicate($_)}' at (file.pl) line ##

a given code string is only evaluated once and is then cached, so you will not
see any additional output when using the same code strings in multiple places.
in some cases (like the iterate example above) the code is closing over external
variables (C< @pre > and C< $fetch >) so you will not be able to see everything,
but C< $SAY_EVAL > should be a helpful debugging aid.

any time that code evaluation fails, an immediate fatal error is thrown.  the
value of C< $SAY_EVAL > does not matter in that case.

=item captures of compile time constructed lists

the C< cap > function and its twin operator C< &\ > are faster than the
C< [...] > construct because they do not copy their arguments.  this is why the
elements of the captures remain aliased to their arguments.  this is normally
fine, but it has an interesting effect with compile time constructed constant
lists:

    my $max = 1000;
    my $range = & \(1 .. $max); #  57% faster than [1 .. $max]
    my $nums  = & \(1 .. 1000); # 366% faster than [1 .. 1000], but cheating

the first example shows the expected speed increase due to not copying the
values into a new empty array reference. the second example is much faster at
runtime than the C< [...] > syntax, but this speed is deceptive.  the reason is
that the list being passed in as an argument is generated by the compiler before
runtime begins.  so all perl has to do is place the values on the stack, and
call the function.

normally this is fine, but there is one catch to be aware of, and that is that
a capture of a compile time constant list in a loop or subroutine (or any
structure that can execute the same segment of code repeatedly) will always
return a reference to an array of the same elements.

    # two instances give two separate arrays
    my ($a, $b) = (&\(1 .. 3), &\(1 .. 3));
    $_ += 10 for @$a;
    say "@$a : @$b"; # 11 12 13 : 1 2 3

    # here the one instance returns the same elements twice
    my ($x, $y) = map &\(1 .. 3), 1 .. 2;
    $_ += 10 for @$x;
    say "@$x : @$y"; # 11 12 13 : 11 12 13

this only applies to compile time constructed constant lists, anything
containing a variable or non constant function call will give you separate
array elements, as shown below:

    my ($low, $high) = (1, 3);
    my ($x, $y) = map &\($low .. $high), 1 .. 2;  # non constant list
    $_ += 10 for @$x;
    say "@$x : @$y"; # 11 12 13 : 1 2 3

=back

=head1 AUTHOR

Eric Strom, C<< <asg at cpan.org> >>

=head1 BUGS

overloading has gotten fairly complicated and is probably in need of a rewrite.
if any edge cases do not work, please send in a bug report.

both threaded methods (C<< $gen->threads_slice(...) >>) and function composition
with overloaded operators (made with C<FAST::List::Gen::Lazy::fn {...}>) do not work
properly in versions of perl before 5.10.  patches welcome

report any bugs / feature requests to C<bug-list-gen at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=List-Gen>.

comments / feedback / patches are also welcome.

=head1 COPYRIGHT & LICENSE

copyright 2009-2011 Eric Strom.

this program is free software; you can redistribute it and/or modify it under
the terms of either: the GNU General Public License as published by the Free
Software Foundation; or the Artistic License.

see http://dev.perl.org/licenses/ for more information.

=cut

__PACKAGE__ if 'first require';
