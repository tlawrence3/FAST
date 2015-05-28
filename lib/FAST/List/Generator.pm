package FAST::List::Generator;
BEGIN {require FAST::List::Gen}

=head1 NAME

FAST::List::Generator - provides functions for generating lists

=head1 VERSION

version 0.974

=head1 SYNOPSIS

this module is an alias for L<FAST::List::Gen>.  it is the same as L<FAST::List::Gen> in
every way.

    use FAST::List::Generator;

    my $range = <1 .. 1_000_000_000 by 3>;

    my $squares = gen {$_ ** 2} <1..>;

    my $fib = <0, 1, *+* ...>;

    say "@$fib[0 .. 10]"; # 0 1 1 2 3 5 8 13 21 34 55

    list(1 .. 5)->map('*2')->say; # 2 4 6 8 10

    <1..>->zip('.' => <a..>)->say(5); # 1a 2b 3c 4d 5e

each line below prints C< '1 9 25 49 81' >:

    functions:           (gen {$_**2} filter {$_ % 2} 1, 10)->say;

    list comprehensions: <**2 for 1 .. 10 if odd>->say;

    dwimmy methods:      <1..10>->grep('odd')->map('**2')->say;

    normal methods:      range(1, 10)->grep(sub {$_%2})->map(sub {$_**2})->say;

=head1 LINKS

=over 4

=item * see L<FAST::List::Gen> for core documentation.

=item * see L<FAST::List::Gen::Benchmark> for performance tips.

=item * see L<FAST::List::Gen::Cookbook> for usage tips.

=item * see L<FAST::List::Gen::Haskell> for an experimental implementation of haskell's
lazy list behavior.

=item * see L<FAST::List::Gen::Lazy> for the tools used to create L<FAST::List::Gen::Haskell>.

=item * see L<FAST::List::Gen::Lazy::Ops> for some of perl's operators implemented as lazy
haskell like functions.

=item * see L<FAST::List::Gen::Lazy::Builtins> for most of perl's builtin functions
implemented as lazy haskell like functions.

=item * see L<FAST::List::Gen::Perl6> for a source filter that adds perl6's meta
operators to use with generators, rather than the default overloaded operators

=back

=head1 AUTHOR

Eric Strom, C<< <asg at cpan.org> >>

=head1 COPYRIGHT & LICENSE

copyright 2009-2011 Eric Strom.

this program is free software; you can redistribute it and/or modify it under
the terms of either: the GNU General Public License as published by the Free
Software Foundation; or the Artistic License.

see http://dev.perl.org/licenses/ for more information.

=cut

1;
