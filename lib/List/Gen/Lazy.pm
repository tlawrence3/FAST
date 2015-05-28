package FAST::List::Gen::Lazy;
    use lib '../../';
    use FAST::List::Gen ();
    for my $method (qw(import VERSION)) {
        *$method = sub {
            splice @_, 0, 1, 'FAST::List::Gen';
            goto &{FAST::List::Gen->can($method)}
        }
    }

package
    FAST::List::Gen;
    use strict;
    use warnings;
    use Scalar::Util 'set_prototype';
    our $LOOKAHEAD = 0;
    push our @lazy_export, qw (lazy L lazyx Lx Lazy Lazyx lazypipe lazyflatten fn now stream);
    push our (@EXPORT_OK), @lazy_export;
    $FAST::List::Gen::EXPORT_TAGS{':lazy'} = \@lazy_export;
    no if $] > 5.012, warnings => 'illegalproto';


=head1 NAME

FAST::List::Gen::Lazy - perl6 / haskell like laziness in perl5

=head1 SYNOPSIS

this module provides tools to implement perl6/haskell style lazy programming
in perl5.

this module is a mixin to L<FAST::List::Gen> that adds functions to C< FAST::List::Gen's >
namespace and exportable function list

=head1 FUNCTIONS

=over 8

=item lazypipe C< LIST >

C< lazypipe > provides a lazy list implementation that will expand generators.

two methods are provided, C<< ->next >> which returns the next item from the
pipe, and C<< ->more >> which returns true if there are more items in the pipe.
the pipe works with aliases to its argument list, and never touches or copies
any items until it has to.

C< lazypipe > provides the behavior of the C< lazy > generator.

=item lazyflatten C< LIST >

C< lazyflatten > is just like C< lazypipe > except it will also expand array
references and subroutines.

C< lazyflatten > provides the behavior of the C< lazyx > generator.

=item lazy C< LIST >

=item L C< LIST >

C< lazy > is a C< lazypipe > wrapped inside of an iterative generator.
if C< LIST > is one item, and is already a generator, that generator is
returned unchanged.

=item lazyx C< LIST >

=item Lx C< LIST >

C< lazyx > is a C< lazyflatten > wrapped inside of an iterative generator.
if C< LIST > is one item, and is already a generator, that generator is
returned unchanged.

=item fn C< CODE [ARITY] [RETURNS] >

C< fn > converts a subroutine into a subroutine with partial application and
lazy evaluation.

    my $add3 = fn {$_[0] + $_[1] + $_[2]} 3;
    my $add2 = $add3->(my $first);
    my $add1 = $add2->(my $second);

    my $sum1 = $add1->(4);
    my $sum2 = $add1->(8);
    $first  = 10;
    $second = 100;
    say $sum1; # prints 114

    $second = 800;
    say $sum1; # still prints 114
    say $sum2; # prints 818

C< fn > supports subroutine prototypes, and can determine C< ARITY > from them.
C< ARITY > defaults to 1, with a prototype of C< (@) >.  C< ARITY > can be given
as a prototype string C< '&@' > or an integer.

the C< RETURNS > defaults to 1, and specifies the number of values that will
be returned by the function (the number of thunk accessors to create).  for
example, the C< splitAt > function in L<FAST::List::Gen::Haskell> is implemented as:

    *splitAt = fn {take(@_), drop(@_)} 2, 2;

    my ($xs, $ys) = splitAt(3, <1..>); # 2 thunk accessors are created but
                                       # take() and drop() have not been called
    say $xs->str;    # 1 2 3
    say $ys->str(5); # 4 5 6 7 8

due to partial application, you can even call subs in a way that looks a bit
like the haskell type signature, should you so desire.

    my ($xs, $ys) = splitAt -> (3) -> (<1..>);

most of the functions in L<FAST::List::Gen::Haskell> are implemented with C< fn >

=item now C< LIST >

sometimes the return values of C< fn {...} > are too lazy.  C< now > will force
the values in C< LIST > to evaluate, and will return the new list.

    now(...)  ~~  grep {!$_ or 1} ...

=item methods of C< fn {...} > functions

return values of C< fn {...} > have the following overloaded behaviors and
methods

    $fn . $code     $fn->compose($code)    sub {$fn->(&$code)}
    $fn << $val     $fn->curry($val)       sub {$fn->($val, @_)}
    $fn >> $val     $fn->rcurry($val)      sub {$fn->(@_, $val)}
    ~$fn            $fn->flip              sub {$fn->(@_[reverse 0 .. $#_])}

some more complex examples, assuming the functions from L<FAST::List::Gen::Haskell>

    my $second = \&head . \&tail;

    my $third  = \&head . \&tail . \&tail;

    my $join = \&foldl << sub {$_[0] . $_[1]};

    my $ucjoin = sub {uc $_[0]} . $join;

    my $cycle = \&cycle << '[' >> ']';

    my $joined_cycle = $ucjoin . take(18) . $cycle;

    say $joined_cycle->(qw(1 a 2 b)); # '[1A2B][1A2B][1A2B]'

the overloaded operators for functions do not seem to work properly in perl's
before 5.10.  the corresponding methods can be used instead.

=cut


    sub lazypipe {
        my ($pipe, $pos, $size) = (\@_, 0, 0);
        my ($fetch, $src, $mutable);
        curse {
            next => sub {
                top: until ($size) {
                    @$pipe or return;
                    $src = shift @$pipe;
                    $src = $$src->() if ref $src eq 'FAST::List::Gen::Thunk';
                    ($size, $fetch) = isagen($src) ? do {
                        $mutable = $src->is_mutable && tied(@$src)->can('fsize');
                        ($src->size, tied(@$src)->can('FETCH'))
                    } : (1, undef)
                }
                if ($fetch) {
                    my $got = cap $fetch->(undef, $pos);
                    $size = $mutable->() if $mutable;
                    if ($size <= $pos) {
                        $size = $pos = 0;
                        goto top;
                    }
                    $size = $pos = 0     if ++$pos >= $size;
                    return wantarray ? @$got : pop @$got;
                } else {
                    $size = 0;
                    return $src
                }
            },
            more => sub {@$pipe or $pos < $size},
        } => 'FAST::List::Gen::Pipe'
    }

    sub lazyflatten {
        my ($pipe, $pos, $size) = (\@_, 0, 0);
        my ($type, $src, $ref, $mutable);
        my $next = sub {
            shift_pipe: until ($size) {
                @$pipe or return;
                $src = shift @$pipe;
                $src = $$src->() if ref $src eq 'FAST::List::Gen::Thunk';
                ($size, $type) = do {
                    if ($ref = ref $src) {
                        if ($ref eq 'ARRAY') {
                            (0 + @$src, 'array')
                        }
                        elsif (FAST::List::Gen::isagen $src) {
                            $mutable = tied(@$src)->mutable;
                            ($src->size, 'gen')
                        }
                        elsif (eval {$src->isa('FAST::List::Gen::Pipe')}) {
                            ($src->more, 'pipe')
                        }
                        else {1}
                    }
                    else {1}
                }
            }
            my $got;
            if ($type) {
                if ($type eq 'array') {
                    $got  = \$$src[$pos]
                }
                elsif ($type eq 'gen') {
                    $got  = \$src->get($pos);
                    $size = $src->size if $mutable;
                    if ($pos >= $size) {
                        goto shift_pipe
                    }
                }
                else {
                    $got  = \$src->next;
                    $size = $src->more
                }
            } else {
                if ($ref eq 'CODE') {
                    defined ${$got = \$src->()}
                        ? $pos--
                        : do {
                            $pos = $size = 0;
                            goto shift_pipe
                        }
                }
                else {$got = \$src}
            }
            if (++$pos >= $size) {
                  $pos  = $size = 0
            }
            $$got
        };
        curse {
            next  => $next,
            more  => sub {@$pipe or $pos < $size},
        } => 'FAST::List::Gen::Pipe'
    }

    my $lazy = sub {
        my $pipe = shift;
        $pipe->more or return empty;
        iterate_multi {
            my $x = cap $pipe->next;
            $pipe->more or @$x ? done @$x : done;
            @$x
        }
    };

    sub lazy {
        if (@_ == 1 and ref $_[0]) {
            return $_[0]           if isagen $_[0];
            return &makegen($_[0]) if ref $_[0] eq 'ARRAY';
        }
        $lazy->(&lazypipe)
    }

    sub lazyx {@_ == 1 && ref $_[0] && isagen($_[0]) or $lazy->(&lazyflatten)}
    BEGIN {
        *L  = *lazy;
        *Lx = *lazyx;
    }
    sub Lazy  {$lazy->(&lazypipe)}
    sub Lazyx {$lazy->(&lazyflatten)}

    my $set_proto = sub {bless set_prototype(\&{$_[1]}, $_[0]), 'FAST::List::Gen::Function'};

    my $fn = \&fn;
    my ($proto_init, $proto_tail, $will_return);
    our $proto_split;
    {
        my %will_return;
        my $proto_chunk = qr/ \\? (?: [\%\@\*\$\&_]| \[ [^\]]+ \] ) /x;

        $proto_tail = sub {(my $proto = $_[0]) =~ s/^$proto_chunk//; $proto};
        $proto_init = sub {
            my ($head, $tail) = $_[0] =~ /^([^;]*)(;.*)?$/;
            $head =~ s/($proto_chunk)$//;

            (($1 eq '@' and substr($head, -1) ne '@') or $1 eq '%')
                ? $_[0]
                : join('', grep defined, $head, $tail)
        };
        $proto_split = sub {$_[0] =~ /$proto_chunk/go};
        $will_return = sub {$will_return{$_[0]} or 1};

        sub fn (&@) {
            my $code  = shift;
            my $proto = prototype($code) || '@';

            my $need;
            if (@_) {
                 if (defined $_[0] and $_[0] =~ /^\d+$/) {
                    $need = shift;
                 } else {
                    $proto = shift || '@';
                 }
            }

            my $returns = @_ ? shift : $will_return{$code} || 1;

            my ($head) = $proto =~ /^([^;]*)(?:;.*)?$/
                or carp "unsupported prototype: $proto";

            unless (defined $need) {
                $need  = (()= $head =~ /$proto_chunk/go);
            }
            if ($need > 1 and $proto eq '@') {
                $proto = ('@' x $need)
            }
            (my $next_proto = $proto) =~ s/^$proto_chunk//o;

            my $self;
            $self = my $ret = $set_proto->($proto, sub {
                return $self unless @_;
                my $args = \@_;

                if (@_ < $need) {
                    &fn ($set_proto->($next_proto,
                        sub {$code->(@$args, @_)}
                    ), $need - @_, $returns)
                }
                elsif (@_ >= $need) {
                    my $thunk = sub {$code->(@$args)};
                    my $data;
                    if ($returns == 1) {
                        bless \sub {
                            unless ($data) {
                                $data = \scalar $thunk->();
                                $data = \$$$data->() if ref $$data eq 'FAST::List::Gen::Thunk';
                                undef $thunk;
                            }
                            $$data
                        } => 'FAST::List::Gen::Thunk'
                    } else {
                        map {
                            my $n = $_ - 1;
                            bless \sub {
                                unless ($data) {
                                    $data = sub {\@_}->(map {
                                        ref eq 'FAST::List::Gen::Thunk' ? $$_->() : $_
                                    } $thunk->());
                                    undef $thunk;
                                }
                                $$data[$n]
                            } => 'FAST::List::Gen::Thunk'
                        } 1 .. $returns
                    }
                }
            });
            Scalar::Util::weaken($self);
            if ($returns > 1) {
                $will_return{$ret} = $returns;
            }
            $ret
        }
    }

{package
    FAST::List::Gen::Function;
    use overload fallback => 1,
        '.' => \&compose,
        '~' => \&flip,
        (map {$_ => \& curry} qw(< <<)),
        (map {$_ => \&rcurry} qw(> >>));

    my $wrap = do {
        sub {
            my $src_fn = shift;
            unless (ref $src_fn eq 'FAST::List::Gen::Bare::Function') {
                push @_, $will_return->($src_fn);
                goto &$fn;
            }
            my ($code, $proto) = @_;
            $proto ||= '@';
            bless Scalar::Util::set_prototype(\&$code, $proto), 'FAST::List::Gen::Bare::Function';
        }
    };

    sub compose {
        my ($x, $y) = @_;
           ($x, $y) = ($y, $x) if $_[2];

        $wrap->($x, sub {$x->(&$y)}, prototype $y)
    }
    sub curry {
        my $x = shift;
        my $y = \$_[0];
        my $proto     = prototype $x;
        my $new_proto = $proto =~ /^\@(?!\@)/ ? $proto : $proto_tail->($proto);

        $wrap->($x, sub {$x->($$y, @_)}, $new_proto);
    }
    sub rcurry {
        my $x = shift;
        my $y = \$_[0];
        $wrap->($x, sub {$x->(@_, $$y)}, $proto_init->(prototype $x));
    }
    sub flip {
        my $x             = shift;
        my ($head, $tail) = (prototype($x) || '@') =~ /^([^;]+)(.*)/;
        my $new_proto     = (join '' => reverse $proto_split->($head)).$tail;

        $wrap->($x, sub {$x->(@_[reverse 0 .. $#_])}, $new_proto);
    }
}

{package
    FAST::List::Gen::Bare::Function;
    our @ISA = 'FAST::List::Gen::Function';
}

{package
    FAST::List::Gen::Thunk;
    use overload fallback => 1,
        '&{}' => sub {
            $_[0] = ${$_[0]}->();
            FAST::List::Gen::isagen($_[0]) ? $_[0]->_overloader : $_[0]
        },
        map {$_ => sub {$_[0] = ${$_[0]}->()}} qw( bool "" 0+ @{} %{} *{} );

    sub DESTROY {}
    sub AUTOLOAD {
        my $method = substr our $AUTOLOAD, 2 + length __PACKAGE__;
        if (defined wantarray and not wantarray) {
            my $args = \@_;
            bless \sub {
                $$args[0] = ${$$args[0]}->() if ref $$args[0] eq 'FAST::List::Gen::Thunk';
                print "lazy call: $$args[0]\->$method(@$args[1..$#$args])\n"
                    if FAST::List::Gen::DEBUG;
                my $code = $$args[0]->can($method) or Carp::croak("no method '$method'");
                $code->(splice @$args);
            }
        } else {
            $_[0] = ${$_[0]}->();
            goto & {$_[0]->can($method) or Carp::croak("no method '$method'")}
        }
    }
}

    sub now {
        for (@_) {
            $_ = $$_->() while ref eq 'FAST::List::Gen::Thunk'
        }
        wantarray ? @_ : pop
    }


=back

=head1 AUTHOR

Eric Strom, C<< <asg at cpan.org> >>

=head1 BUGS

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


'FAST::List::Gen::Lazy' if 'first require';
