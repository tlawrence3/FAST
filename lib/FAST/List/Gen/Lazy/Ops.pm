package FAST::List::Gen::Lazy::Ops;
    use strict;
    use warnings;
    use lib '../../';
    use FAST::List::Gen::Lazy 'fn';

=head1 NAME

FAST::List::Gen::Lazy::Ops - perl ops with partial + lazy application

=head1 SYNOPSIS

this module implements some of the perl operators with C< fn() > from
L<FAST::List::Gen::Lazy>

the implemented infix operators are:

        + - / * % . & | ^ < >

the implemented prefix operators are:

        ! ~

each is a subroutine and must be prefixed by C< & >:

    my $plus_1 = &+(1);

    say 5->$plus_1;  # 6

this module mainly exists to ease writing expressions like:

    use FAST::List::Gen::Haskell;

    my $sum = foldl \&+;

    $_ = L 0, 1, zipWith \&+, $_, tail $_ for my $fibs;

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


no strict 'refs';

*$_ = eval "fn {\$_[0] $_ \$_[1]} 2" || die $@ for qw (+ - / * % . & | ^ < >);
*$_ = eval "fn {$_ \$_[0]} 1"        || die $@ for qw (! ~);

*: = fn {unshift @{$_[1]}, $_[0]; $_[1]} 2;

1;
