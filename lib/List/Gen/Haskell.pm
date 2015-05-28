package FAST::List::Gen::Haskell;
    use strict;
    use warnings;
    use lib '../../';
    use FAST::List::Gen::Lazy '*';
    use Scalar::Util 'weaken';
    sub DEBUG () {0}
    our @EXPORT = qw (lazy L lazyx Lx fn now seq map_ unzip unzipn x_xs);
    our @EXPORT_OK;
    my $setup_export = sub {
        @EXPORT_OK = keys %{{map {$_ => 1} @EXPORT, @FAST::List::Gen::EXPORT_OK}}
    };
    our %EXPORT_TAGS = (base => \@EXPORT, all => \@EXPORT_OK);
    BEGIN {
        no strict 'refs';
        *import  = *FAST::List::Gen::import;
        *{uc $_} = *{'FAST::List::Gen::'.uc} for 'version'
    }
    our ($a, $b);
    no if ($] > 5.012), warnings => 'illegalproto';


=head1 NAME

FAST::List::Gen::Haskell - the haskell prelude in perl5

=head1 SYNOPSIS

this module provides most of the functions in the haskell prelude that pertain
to working with lists.

    # haskell:  fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

    use FAST::List::Gen::Haskell;

    $fibs = lazy 0, 1, zipWith {&sum} $fibs, tail $fibs;

    print "@$fibs[0 .. 10]\n"; # prints '0 1 1 2 3 5 8 13 21 34 55'

C< lazy > provides the generic behavior of haskell's lazy list concatenation
(the C< : > and C< ++ > operators). none of its elements are touched until they
are needed. in general, all the functions in this package defer their execution
until something is required of them.  they also only touch their arguments at
the latest possible time, which is how the co-recursion above works.

the functions in this module are a bit more flexible (perlish) than those in
haskell.  in most cases where a function expects a single generator, a list of
values and/or generators can be provided, which will be preprocessed by
C< lazy > into a single generator.

when loaded, most of the functions in this package become methods for all
generators. if a method of the same name already exists, the method from this
package will be prefixed with C< hs_ >. so C< filter > is a method named
C<< ->hs_filter(...) >>

this library currently does not have the best performance due to over-caching
of many internal generators.  a future update will address this by replacing
those generators with cache-less generator streams.

=cut

    sub let {
        my ($name, $code) = splice @_, 0, 2;

        $_ = &fn (ref eq 'ARRAY' ? @$_ : $_, @_) for $code;

        if (DEBUG) {
            my $next = $code;
            $code = sub {Carp::cluck "$name @_"; goto &$next}
        }
        no strict 'refs';
        *$name = *{ucfirst $name} = $code;

        *{'FAST::List::Gen::erator::'
          .('hs_' x defined &{'FAST::List::Gen::erator::'.$name})
          .$name} = sub {
             push @_, shift; goto &$code
        };
        push @EXPORT, $name, ucfirst $name;
    }

    my $pred = sub {
        local *_ = (@_ > 1 ? \$_[1] : \undef);
        $_[0]->($_)
    };

    sub map_ (&) {&map(@_, $_)}


=head1 FUNCTIONS

all of these functions are available with a ucfirst name, since many clash with
perl builtin names.

=head2 Utility Operations

=over 4

=item x_xs C< [GENERATOR] >

C< x_xs > is a convenience function that returns the head and tail of a passed
in generator.  C< x_xs > uses C< $_ > without an argument.

=cut

    sub x_xs (;$) {(@_, $_)[0]->x_xs}


=item seq C< LIST >

forces immediate evaluation of the elements in C< LIST > and returns the list

=cut

    BEGIN {*seq = \&now}


=item flip C< {CODE} >

C< flip > converts C< CODE > into a function that takes it's arguments reversed

    my $idx = \&head . flip \&drop;

    $idx->($gen, 5)  ==  $gen->$idx(5)  ==  $gen->get(5)

=cut

    let flip => sub (&) {goto &FAST::List::Gen::Function::flip};


=back

=head2 List operations

=over 4

=item Map C< {CODE} LIST >

Map f xs is the list obtained by applying f to each element of xs, i.e.,

    map f [x1, x2, ..., xn] == [f x1, f x2, ..., f xn]
    map f [x1, x2, ...] == [f x1, f x2, ...]

    $x = &map(sub {$_**2}, $gen);
    $x = Map {$_**2} $gen;

that usage is the same as C< FAST::List::Gen::gen >, but this is something that
C< gen > can't do:

    my $pow_2 = Map {$_**2};  # partial application, needs at least 1 more
                              # argument to evaluate, but can be passed a list
    my $ints = <0..>;

    my $squares = $ints->$pow_2;

    say "@$squares[0 .. 10]"; # 0 1 4 9 16 25 36 49 64 81 100

and this:

    my $src;
    my $square_of_src = Map {$_ ** 2} $src;

    $src = <1.. by 2>;

    say "@$square_of_src[0 .. 4]"; # 1 9 25 49 81

=cut

    let map => sub (&@) {&gen(shift, &lazy)};


=item filter C< {CODE} LIST >

filter, applied to a predicate and a list, returns the list of those elements
that satisfy the predicate; i.e.,

    filter p xs = [ x | x <- xs, p x]

=cut

    let filter => sub (&@) {&FAST::List::Gen::filter(shift, &lazy)};


=item head C< GENERATOR >

Extract the first element of a list, which must be non-empty.

=cut

    let head => sub {$_[0]->head};


=item Last C< GENERATOR >

Extract the last element of a list, which must be finite and non-empty.

=cut

    let last => sub {$_[0]->last};


=item tail C< GENERATOR >

Extract the elements after the head of a list, which must be non-empty.

=cut

    let tail => sub {$_[0]->tail};


=item init C< GENERATOR >

Return all the elements of a list except the last one. The list must be
non-empty.

=cut

    let init => sub {
        my $xs = shift;
        take($xs->apply->size - 1, $xs)
    };


=item null C< GENERATOR >

Test whether a list is empty.

=cut

    let null => sub {$_[0]->apply->size == 0};


=item Length C< GENERATOR >

=cut

    let length => sub {$_[0]->apply->size};


=item Reverse C< LIST >

reverse xs returns the elements of xs in reverse order. xs must be finite.

=cut

    let reverse => sub {&list->reverse};


=back

=head2 Reducing lists (folds)

=over 4

=item foldl C< {CODE} ITEM LIST >

foldl, applied to a binary operator, a starting value (typically the
left-identity of the operator), and a list, reduces the list using the binary
operator, from left to right:

    foldl f z [x1, x2, ..., xn] == (...((z `f` x1) `f` x2) `f`...) `f` xn

The list must be finite.

=item foldl1 C< {CODE} LIST >

C< foldl1 > is a variant of C< foldl > that has no starting value argument, and
thus must be applied to non-empty lists.

=cut

    let foldl => sub (&@@) {
        my ($code, $z) = splice @_, 0, 2;
        &lazy->do(sub {
            $z = $code->(now $z, $_)
        });
        $z
    };

    let foldl1 => sub (&@) {
        my $code = shift;
        my $xs = &lazy;
        my $init = 1;
        my $x;
        $xs->do(sub {
            if ($init) {
                undef $init;
                $x = now $_;
            } else {
                $x = $code->(now $x, $_)
            }
        });
        $x
    };


=item foldr C< {CODE} ITEM LIST >

foldr, applied to a binary operator, a starting value (typically the
right-identity of the operator), and a list, reduces the list using the binary
operator, from right to left:

    foldr f z [x1, x2, ..., xn] == x1 `f` (x2 `f` ... (xn `f` z)...)

=item foldr1 C< {CODE} LIST >

C< foldr1 > is a variant of C< foldr > that has no starting value argument, and
thus must be applied to non-empty lists.

=cut

    let foldr => sub (&@@) {
        my ($code, $z) = splice @_, 0, 2;
        &lazy->reverse->do(sub {
            $z = $code->(now $_, $z)
        });
        $z
    };

    let foldr1 => sub (&@) {
        my $code = shift;
        my $xs = &lazy;
        $xs->apply;
        my $i = $xs->size - 1;
        my $x = $xs->get($i--);
        while ($i >= 0) {
            $x = $code->(now $xs->get($i--), $x)
        }
        $x
    };


=back

=head3 Special folds

=over 4

=item And C< LIST >

and returns the conjunction of a Boolean list. For the result to be True, the
list must be finite; False, however, results from a False value at a finite
index of a finite or infinite list.

=cut

    let and => sub {
        not &lazy->do(sub {$_ or done 1})
    };


=item Or C< LIST >

or returns the disjunction of a Boolean list. For the result to be False, the
list must be finite; True, however, results from a True value at a finite index
of a finite or infinite list.

=cut

    let or => sub {
        &lazy->do(sub {$_ and done 1});
    };


=item any C< {CODE} LIST >

Applied to a predicate and a list, any determines if any element of the list
satisfies the predicate.

=cut

    let any => sub (&@) {
        my $p = shift;
        &lazy->do(sub {$p->($_) and done 1})
    };


=item all C< {CODE} LIST >

Applied to a predicate and a list, all determines if all elements of the list
satisfy the predicate.

=cut

    let all => sub (&@) {
        my $p = shift;
        not &lazy->do(sub {$p->($_) or done 1})
    };


=item sum C< LIST >

The sum function computes the sum of a finite list of numbers.

=cut

    let sum => sub {&lazy->sum};


=item product C< LIST >

The product function computes the product of a finite list of numbers.

=cut

    let product => sub {&lazy->product};


=item concat C< GENERATOR >

Concatenate a list of lists.

=cut

    let concat => sub {
        my $xs = shift;
        my $xp = 0;
        my $self;
        my $at;
        my $sequence;
        my $ret = mutable gen {$at = $_; $sequence->size > $_ or done; $sequence->get($_)};
        $sequence = sequence mutable gen {
            $xp < @$xs or done;
            my $seq = $self->sequence;
            splice @$seq, $#$seq, 0, map {FAST::List::Gen::isagen or &makegen(\@$_)} $$xs[$xp++];
            $self->rebuild;
            $sequence->get($at)
        } 1;
        $self = tied @$sequence;
        $ret
    };


=item concatMap C< {CODE} LIST >

Map a function over a list and concatenate the results.

=cut

    let concatMap => sub (&@) {concat(&gen(shift, &lazy))};


=item maximum C< LIST >

maximum returns the maximum value from a list, which must be non-empty, finite,
and of an ordered type. It is a special case of maximumBy, which allows the
programmer to supply their own comparison function.

=cut

    let maximum => sub {&lazy->max};


=item minimum C< LIST >

minimum returns the minimum value from a list, which must be non-empty, finite,
and of an ordered type. It is a special case of minimumBy, which allows the
programmer to supply their own comparison function.

=cut

    let minimum => sub {&lazy->min};


=back

=head2 Building lists

=head3 Scans

=over 4

=item scanl C< {CODE} LIST >

scanl is similar to foldl, but returns a list of successive reduced values from
the left:

    scanl f z [x1, x2, ...] == [z, z `f` x1, (z `f` x1) `f` x2, ...]

Note that

    last (scanl f z xs) == foldl f z xs.

=cut

    let scanl => sub (&@) {
        my $code = shift;
        my $gen  = &lazy;
        iterate_multi {
            my $ret = $_ == 0 ? $gen->get(0) : $code->(self($_ - 1), $gen->get($_));
            done $ret if $_ + 1 >= $gen->size;
            $ret
        }->recursive
    };


=item scanr C< {CODE} LIST >

scanr is the right-to-left dual of scanl. Note that

    head (scanr f z xs) == foldr f z xs.

=cut

    let scanr => sub (&@) {
        my $code = shift;
        my $gen  = &lazy;
        iterate_multi {
            my $ret = $_ == 0 ? $gen->get($gen->size - 1) : $code->($gen->get($gen->size - ($_+1)), self($_ - 1));
            done $ret if $_ + 1 >= $gen->size;
            $ret
        }->recursive
    };


=back

=head3 Infinite lists

=over 4

=item iterate C< {CODE} ITEM >

iterate f x returns an infinite list of repeated applications of f to x:

    iterate f x == [x, f x, f (f x), ...]

=cut

    let iterate  => sub (&@) {
        my ($code, $x) = @_;
        &FAST::List::Gen::iterate(sub {$code->($_)})->from($x)->scalar;
    };


=item repeat C< ITEM >

repeat x is an infinite list, with x the value of every element.

=cut

    let repeat => sub {
        my $x = $_[0];
        gen {$x}
    };


=item hs_repeat C< ITEM >

    my $repeat; $repeat = lazy $x, $repeat;

=cut

    let hs_repeat => sub {
        my ($x, $xs) = shift;
        $xs = lazy $x, $xs
    };


=item replicate C< NUM ITEM >

replicate n x is a list of length n with x the value of every element.

=cut

    let hs_replicate => sub ($@) {
        take(shift, &hs_repeat)
    };

    let replicate => sub ($@) {
        my ($n, $x) = @_;
        gen {$x} $n
    };


=item cycle C< LIST >

cycle ties a finite list into a circular one, or equivalently, the infinite
repetition of the original list. It is the identity on infinite lists.

=cut

    let cycle => sub {&lazy->cycle};


=item hs_cycle C< LIST >

hs_cycle ties a finite list into a circular one, or equivalently, the infinite
repetition of the original list. It is the identity on infinite lists.

it is defined in perl as:

   my $cycle; $cycle = lazy $xs, $cycle;

=cut

    let hs_cycle => sub {
        my ($xs, $cycle) = &lazy;
        $cycle = lazy $xs, $cycle
    };


=back

=head3 Sublists

=over 4

=item take C< NUM LIST >

take n, applied to a list xs, returns the prefix of xs of length n, or xs itself
if n > length xs:

    take 3 [1,2,3,4,5] == [1,2,3]
    take 3 [1,2] == [1,2]
    take 3 [] == []
    take (-1) [1,2] == []
    take 0 [1,2] == []

=cut

    let take => sub (@@) {
        my $n = shift;
        &lazy->take($n)
    };


=item drop C< NUM LIST >

drop n xs returns the suffix of xs after the first n elements, or [] if n >
length xs:

    drop 3 [1,2,3,4,5] == [4,5]
    drop 3 [1,2] == []
    drop 3 [] == []
    drop (-1) [1,2] == [1,2]
    drop 0 [1,2] == [1,2]


=cut

    let drop => sub (@@) {
        my $n = shift;
        &lazy->drop($n)
    };


=item splitAt C< NUM LIST >

splitAt n xs returns a tuple where first element is xs prefix of length n and
second element is the remainder of the list:

    splitAt 3 [1,2,3,4,5] == ([1,2,3],[4,5])
    splitAt 1 [1,2,3] == ([1],[2,3])
    splitAt 3 [1,2,3] == ([1,2,3],[])
    splitAt 4 [1,2,3] == ([1,2,3],[])
    splitAt 0 [1,2,3] == ([],[1,2,3])
    splitAt (-1) [1,2,3] == ([],[1,2,3])

It is equivalent to (take n xs, drop n xs).

=cut

   let splitAt => sub {take(@_), drop(@_)}, 2, 2;


=item takeWhile C< {CODE} LIST >

takeWhile, applied to a predicate p and a list xs, returns the longest prefix
(possibly empty) of xs of elements that satisfy p:

    take_while (< 3) [1,2,3,4,1,2,3,4] == [1,2]
    take_while (< 9) [1,2,3] == [1,2,3]
    take_while (< 0) [1,2,3] == []

=cut

    let takeWhile => sub (&@) {
        my ($p, $xs) = (shift, &lazy);
        $xs->take_while(sub {$p->($_)})
    };


=item dropWhile C< {CODE} LIST >

dropWhile p xs returns the suffix remaining after take_while p xs:

    dropWhile (< 3) [1,2,3,4,5,1,2,3] == [3,4,5,1,2,3]
    dropWhile (< 9) [1,2,3] == []
    dropWhile (< 0) [1,2,3] == [1,2,3]

=cut

    let dropWhile => sub (&@) {
        my ($p, $xs) = (shift, &lazy);
        $xs->drop_while(sub {$p->($_)})
    };


=item span C< {CODE} LIST >

span, applied to a predicate p and a list xs, returns a tuple where first
element is longest prefix (possibly empty) of xs of elements that satisfy p and
second element is the remainder of the list:

    span (< 3) [1,2,3,4,1,2,3,4] == ([1,2],[3,4,1,2,3,4])
    span (< 9) [1,2,3] == ([1,2,3],[])
    span (< 0) [1,2,3] == ([],[1,2,3])

span p xs is equivalent to (takeWhile p xs, dropWhile p xs)

=cut

    let span => sub (&@) {
        my $p = shift;
        &lazy->span(sub {$p->($_)})
    }, 2, 2;


=item break C< {CODE} LIST >

break, applied to a predicate p and a list xs, returns a tuple where first
element is longest prefix (possibly empty) of xs of elements that do not satisfy
p and second element is the remainder of the list:

    break (> 3) [1,2,3,4,1,2,3,4] == ([1,2,3],[4,1,2,3,4])
    break (< 9) [1,2,3] == ([],[1,2,3])
    break (> 9) [1,2,3] == ([1,2,3],[])

break p is equivalent to span (not . p)

=cut

    let break => sub (&@) {
        my $p = shift;
        &lazy->span(sub {not $p->($_)})
    }, 2, 2;


=back

=head3 Searching lists

=over 4

=item elem C< ITEM LIST >

elem is the list membership predicate, usually written in infix form, e.g.,
x `elem` xs.

=cut

    let elem => sub (@@) {
        my $x = shift;
        $x eq $_ and return 1 for @{&lazy};
        return ()
    };


=item notElem C< ITEM LIST >

notElem is the negation of elem.

=cut

    let notElem => sub (@@) {
        my $x  = shift;
        my $xs = &lazy;
        $x eq $_ and return () for @$xs;
        return 1
    };


=back

=head3 Zipping and unzipping lists

=over 4

=item zip C< LIST >

zip takes 2+ lists and returns a single interleaved list. If one input list is
short, excess elements of the longer lists are discarded. unlike the haskell
version, the zip returns a flat generator.

C<zip> is the same as C<zipWith {\@_}>

=cut

    let zip => sub (@@) {
        FAST::List::Gen::zipwith {\@_} @_
    };


=item zipWith C< {CODE} LIST >

zipWith generalizes zip by zipping with the function given as the first
argument, instead of a tupling function. For example, zipWith (+) is applied to
two lists to produce the list of corresponding sums.

=cut

    let zipWith => \&FAST::List::Gen::zipwith, 3;


=item zipWithAB C< {$a * $b} $gen1, $gen2 >

The zipWithAB function takes a function which uses C< $a > and C< $b >, as well
as two lists and returns a list analogous to zipWith.

=cut

    let zipWithAB => \&FAST::List::Gen::zipWithAB, 3;


=item unzip C< GENERATOR >

unzip transforms a list into two lists of the even and odd elements.

    zs = zip xs, ys
    (xs, ys) == unzip zs

=cut

    BEGIN {undef $_ for *unzip, *unzipn}
    {no warnings 'once';
        *unzip = &unzipn(2);
    }


=item unzipn C< NUM GENERATOR >

The unzipn function is the n-dimentional precursor to C< unzip >

   unzip xs = unzipn 2, xs

=cut

    sub unzipn {
        return \&unzipn unless @_;
        my $n  = shift;
        return bless sub {&unzipn($n, @_)} => 'FAST::List::Gen::Bare::Function' unless @_;
        my $xs = shift;
        map {
            my $x = $_;
            gen {$$_[$x]} $xs
        } 0 .. $n - 1;
    }
    bless \&unzipn => 'FAST::List::Gen::Bare::Function';


=back

=head3 Functions on strings

=over 4

=item lines C< STRING >

lines breaks a string up into a list of strings at newline characters. The
resulting strings do not contain newlines.  the newline sequence is taken from
the value of the input record separator C< $/ >

=cut

    let lines => sub {
        my $str = &lazy->join($/);
        my $nl  = quotemeta $/;
        iterate_multi {
            if ($str =~ s{\A(.*?)(?:$nl|\Z)}{}o) {
                length $str ? $1 : done $1
            } else {done}
        }
    };


=item words C< STRING >

words breaks a string up into a list of words, which were delimited by white
space.

=cut

    let words => sub {
        my $str = &lazy->str;
        iterate_multi {
            if ($str =~ s/\A\s*(\S*)(?:\s+|\Z)//) {
                length $str ? $1 : done $1
            } else {done}
        }
    };


=item unlines C< LIST >

unlines is an inverse operation to lines. It joins lines, after appending a
terminating newline to each. the newline sequence is taken from the value of the
input record separator C< $/ >

=cut

    let unlines => sub {&foldl1(sub {join $/ => @_}, &lazy)};


=item unwords C< LIST >

unwords is an inverse operation to words. It joins words with separating spaces.

=cut

    let unwords => sub {&foldl1(sub {join ' ' => @_}, &lazy)};


=back

=head1 ACKNOWLEGEMENTS

most of the documentation here started out at
L<http://www.haskell.org/ghc/docs/6.12.2/html/libraries/base-4.2.0.1/Prelude.html>
and was subsequently edited to account for implementation differences.

=head1 AUTHOR

Eric Strom, C<< <asg at cpan.org> >>

=head1 BUGS

there are certainly bugs in code this complex. send in reports, tests, patches.

report any bugs / feature requests to C<bug-list-gen at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=List-Gen>.

=head1 COPYRIGHT & LICENSE

copyright 2009-2011 Eric Strom.

this program is free software; you can redistribute it and/or modify it under
the terms of either: the GNU General Public License as published by the Free
Software Foundation; or the Artistic License.

see http://dev.perl.org/licenses/ for more information.

=cut

$setup_export->();
delete $FAST::List::Gen::Haskell::{let};

__PACKAGE__ if 'first require';
