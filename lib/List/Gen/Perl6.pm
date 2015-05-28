package FAST::List::Gen::Perl6;
    use strict;
    use warnings;
    use lib '../../';
    use FAST::List::Gen ();
    use Filter::Simple;
    use Carp ();
    BEGIN {
        FILTER_ONLY      all => \&_filter_hyper,
            code_no_comments => \&_filter_rest;
    }
    my ($ops) = map qr/(?:[Rr]?(?:$_))/, join '|', map quotemeta, ',', qw (
        - + / * ** x % . & | ^ < > << >> <=> cmp lt gt eq ne le ge == != <= >=
    );
    sub _filter_hyper {
        s/ ((?:<<|>>)~?) ($ops) (<<|>>) /$1'$2'$3/gx;
    }
    sub _filter_rest {
        s{
            (?<!<)
            \[ (\.\.|\\)? ($ops) \]
            (?= \s* (?! -> | \b(?:$ops)\b(?!>) | [;\)\]\}\>] ) )
        }{
            my $t = $1 || '';
            $t = '..' if $t eq '\\';
            "FAST::List::Gen::Perl6::_reduceWith '$t$2', "
        }egx;
        s{
            (?<!<)
            \[ (\.\.|\\)? ($ops) \]
            (?!>)
        }{
            my $t = $1 || '';
            $t = '..' if $t eq '\\';
            "FAST::List::Gen::Perl6::_reduction('$t$2')"
        }gxe;
        s{
            (?<![\$\@\%\&\*]) \b Z([Rr]?) \b (?:(~?)($ops))?
        }{
            my $rev = $1||$2 ? '~' : '';
            $3 ? "|$rev'$3'|" : '|'
        }gxe;
        s{
            (?<![\$\@\%\&\*]) \b X([Rr]?) \b (?:(~?)($ops))?
        }{
            my $rev = $1||$2 ? '~' : '';
            $3 ? "x$rev'$3'x" : 'x'
        }gxe;
    }

    my %cache;
    sub _reduction {
        my $str = "[@_]";
        {return $cache{$str} || next}
        local $@;
        my $ret = eval {&FAST::List::Gen::glob($str)};
        ref $ret eq 'CODE' or Carp::croak("not a generator glob: $str\n$@\n");
        $cache{$str} = $ret;
    }
    sub _reduceWith {
        goto &{_reduction shift}
    }
    sub filter {
        my $str = shift;
        for ($str) {
            _filter_hyper;
            _filter_rest;
        }
        return $str;
    }

=head1 NAME

FAST::List::Gen::Perl6 - perl6 meta operators in perl5

=head1 SYNOPSIS

many of the features found in L<FAST::List::Gen> borrow ideas from perl6.  however,
since the syntax of perl5 and perl6 differ, some of the constructs in perl5 are
longer/messier than in perl6.  C< FAST::List::Gen::Perl6 > is a source filter that
makes some of C<FAST::List::Gen>'s features more syntactic.

the new syntactic constructs are:

    zip:       generator Z  generator
    zipwith:   generator Z+ generator
    cross:     generator X  generator
    crosswith: generator X+ generator
    hyper:     generator <<+>> generator
    hyper:     generator >>+<< generator
    hyper:     generator >>+>> generator
    hyper:     generator <<+<< generator
    reduce:    [+] list
    triangular reduction: [\+]  list
                       or [..+] list

in the above, C< + > can be any perl binary operator.

here is a table showing the correspondence between the source filter constructs,
the native overloaded ops, and the operation expanded into methods and functions.

    FAST::List::Gen::Perl6      FAST::List::Gen                FAST::List::Gen expanded

    <1..3> Z <4..6>      ~~  <1..3> | <4..6>        ~~  <1..3>->zip(<4..6>)

    <1..3> Z. <4..6>     ~~  <1..3> |'.'| <4..6>    ~~  <1..3>->zip('.' => <4..6>)

    <1..3> X <4..6>      ~~  <1..3> x <4..6>        ~~  <1..3>->cross(<4..6>)

    <1..3> X. <4..6>     ~~  <1..3> x'.'x <4..6>    ~~  <1..3>->cross('.' => <4..6>)

    <1..3> <<+>> <4..6>  ~~  <1..3> <<'+'>> <4..6>  ~~  <1..3>->hyper('<<+>>', <4..6>)

    [+] 1..10            ~~  <[+] 1..10>            ~~  reduce {$_[0] + $_[1]} 1 .. 10
    [+]->(1..10)         ~~  <[+]>->(1..10)         ~~  same as above

    [\+] 1..10           ~~  <[..+] 1..10>          ~~  scan {$_[0] + $_[1]} 1 .. 10
    [\+]->(1..10)        ~~  <[..+]>->(1..10)       ~~  same as above

except for normal reductions C< [+] >, all of the new constructs return a
generator.

you can flip the arguments to an operator with C< R > or C< r > and in some
cases C< ~ >

      ZR.     Zr.     Z~.
      XR.     Xr.     X~.
     <<R.>>  <<r.>>  <<~.>>
      [R.]    [r.]    n/a
     [\R.]   [\r.]    n/a

when used without a following argument, reductions and triangular reductions
will return a code reference that will perform the reduction on its arguments.

    my $sum = [+];
    say $sum->(1..10);  # 55

reductions can take a list of scalars, or a single generator as their argument.

only the left hand side of the zip, cross, and hyper operators needs to be a
generator.  zip and cross will upgrade their rhs to a generator if it is an array.
hyper will upgrade it's rhs to a generator if it is an array or a scalar.

the source filter is limited in scope, and should not harm other parts of the code,
however, source filters are notoriously difficult to fully test, so take that
with a grain of salt.  due to limitations of L<Filter::Simple>, hyper operators
will be filtered in both code and strings.  all other filters should skip strings.

this code is not really intended for serious work, ymmv.

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

1
