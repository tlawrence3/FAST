package FAST::List::Gen::Lazy::Builtins;
    use warnings;
    use strict;
    use Carp;
    use FAST::List::Gen::Lazy 'fn';

    BEGIN {
        no strict 'refs';
        *import  = *FAST::List::Gen::import;
        *{uc $_} = *{'FAST::List::Gen::'.uc} for 'version'
    }

    our (@EXPORT_OK, @EXPORT, %EXPORT_TAGS) = 'wrap';

    our $WARN;
    $WARN = 1 unless defined $WARN;

    my %styles = (
        '$'  => sub {"\$_[@_]"},
        '*'  => sub {"\$_[@_]"},
        '\$' => sub {'${$_['."@_]}"},
        '\@' => sub {'@{$_['."@_]}"},
        '\%' => sub {'%{$_['."@_]}"},
        '\&' => sub {'&{$_['."@_]}"},
        '&'  => sub {'\&{$_['."@_]}"},
        '\*' => sub {'*{$_['."@_]}"},
        '@'  => sub {$_[0] == 0 ? '@_' : "\@_[@_ .. \$#_]"},
        '%'  => sub {"\@_[@_ .. \$#_]"},
        '_'  => sub {"\$#_ >= @_ ? \$_[@_] : \$_"},
    );

    sub wrap {
        my $name = shift;
        my %cfg = (
            arity   => 1,
            returns => 1,
            proto   => eval {prototype($name) or defined prototype("CORE::$name") ? prototype("CORE::$name")||' ' : '@' } || '@',
            styles  => {},
            @_
        );

        unless (keys %{$cfg{styles}}) {
            my ($head, $tail) = $cfg{proto} =~ /^([^;]*);?(.*)/;
            my @head = $FAST::List::Gen::proto_split->($head);
            my @tail = $FAST::List::Gen::proto_split->($tail);

            my $need = @head;

            $cfg{styles}{$need} = \@head;
            for my $i (0 .. $#tail) {
                $cfg{styles}{$need + $i + 1} = [@head, @tail[0 .. $i]]
            }
        }

        my (@pre, @post);
        my $add = sub {push @pre, shift; unshift @post, @_};

        my $wrap_code;
        if (ref $name eq 'CODE') {
            $wrap_code = $name;
            $name = '$wrap_code->';
        } else {
            $name =~ /^\w+$/ or croak "invalid name for wrap: $name";
        }

        $add->("sub ($cfg{proto}) {", '}');
        for my $num ((sort {$a <=> $b} grep {/^\d+$/} keys %{$cfg{styles}}), '@') {
            my $styles = $cfg{styles}{$num} or next;
            my $pred;
            if ($num eq '@') {
                $pred = 'if (1       ) {';
            } elsif (@$styles and $$styles[$#$styles] eq '@') {
                $pred = "if (\@_ >= $num) {";
            } else {
                $pred = "if (\@_ == $num) {";
            }
            my $n = 0;
            $add->("    $pred return $name(".join(', ' => map {($styles{$_} or die "$name: no style: $_")->($n++)} @$styles).'); }');
        }

        unless (keys %{$cfg{styles}}) {
            $add->("return $name(\@_)")
        }
        no warnings;
        eval "fn @pre @post" or die $@;
    }

    my @builtin = qw(
         abs accept alarm atan2 bind binmode bless caller chdir chmod chomp
         chop chown chr chroot close closedir connect cos crypt dbmclose dbmopen
         default defined die do endgrent endhostent endnetent endprotoent
         endpwent endservent eof eval exec exit exp fcntl fileno flock fork
         formline getc getgrent getgrgid getgrnam gethostbyaddr gethostbyname
         gethostent getlogin getnetbyaddr getnetbyname getnetent getpeername
         getpgrp getppid getpriority getprotobyname getprotobynumber getprotoent
         getpwent getpwnam getpwuid getservbyname getservbyport getservent
         getsockname getsockopt glob gmtime goto hex index int ioctl join
         kill lc lcfirst length link listen localtime lock log lstat mkdir
         msgctl msgget msgrcv msgsnd oct open opendir ord pack pipe pop pos
         print printf prototype push quotemeta rand read readdir readline
         readlink readpipe recv ref rename require reset reverse rewinddir
         rindex rmdir say scalar seek seekdir select semctl semget semop send
         setgrent sethostent setnetent setpgrp setpriority setprotoent setpwent
         setservent setsockopt shift shmctl shmget shmread shmwrite shutdown sin
         sleep socket socketpair splice split sprintf sqrt srand stat study
         substr symlink syscall sysopen sysread sysseek system syswrite tell
         telldir tied time times truncate uc ucfirst umask undef unlink unpack
         unshift untie utime vec wait waitpid wantarray warn when write
    );

    for my $fn (@builtin) {
        no strict 'refs';
        my $code = eval {wrap $fn};
        unless ($code) {
            warn "could not wrap '$fn': $@\n" if $WARN;
            next;
        }
        *$_ = $code for $fn, "lazy_$fn", ucfirst $fn, "_$fn";

        push @EXPORT, ucfirst $fn;

        push @EXPORT_OK, "lazy_$fn";
        push @{$EXPORT_TAGS{lazy}}, "lazy_$fn";

        push @EXPORT_OK, "_$fn";
        push @{$EXPORT_TAGS{_}}, "_$fn";

        push @EXPORT_OK, $fn;
        push @{$EXPORT_TAGS{userspace}}, ucfirst $fn;
    }

    @EXPORT_OK = keys %{{map {$_ => 1} @EXPORT_OK, @EXPORT}};
    $EXPORT_TAGS{':all'}  = \@EXPORT_OK;
    $EXPORT_TAGS{':base'} = \@EXPORT;


=head1 NAME

FAST::List::Gen::Builtins - perl builtin functions with partial + lazy application

=head1 SYNOPSIS

this module implements most of the perl functions with C< fn() > from
L<FAST::List::Gen::Lazy>.  you can import functions from this module as follows:

=head1 EXPORT

builtin's with prototypes have the same prototype when exported from this module.

to export the builtins in ucfirst:

    use FAST::List::Gen::Builtins;  # ucfirst is default

    my $int = Int my $float;

    $float = 4.333;

    say $int; # 4

or to export prefixed with C< '_' >:

    use FAST::List::Gen::Builtins ':_';

    my $int = _int my $float;

or to export prefixed with C< 'lazy_' >:

    use FAST::List::Gen::Builtins ':lazy';

    my $int = lazy_int my $float;

to export the builtins as like named userspace functions:

    use FAST::List::Gen::Builtins ':userspace';

    my $int = &int(my $float);

note that as always, when a user function is called with C< & >, prototypes are
disabled, this means that you must call functions like C< &shift > as:

    my $x = &shift(\@array);  # must use parens and manually take the reference

the implemented functions are:

    abs accept alarm atan2 bind binmode bless caller chdir chmod chomp chop
    chown chr chroot close closedir connect cos crypt dbmclose dbmopen default
    defined die do endgrent endhostent endnetent endprotoent endpwent
    endservent eof eval exec exit exp fcntl fileno flock fork formline getc
    getgrent getgrgid getgrnam gethostbyaddr gethostbyname gethostent getlogin
    getnetbyaddr getnetbyname getnetent getpeername getpgrp getppid getpriority
    getprotobyname getprotobynumber getprotoent getpwent getpwnam getpwuid
    getservbyname getservbyport getservent getsockname getsockopt glob gmtime
    goto hex index int ioctl join keys kill lc lcfirst length link listen
    localtime lock log lstat mkdir msgctl msgget msgrcv msgsnd oct open opendir
    ord pack pipe pop pos print printf prototype push quotemeta rand read
    readdir readline readlink readpipe recv ref rename require reset reverse
    rewinddir rindex rmdir say scalar seek seekdir select semctl semget semop
    send setgrent sethostent setnetent setpgrp setpriority setprotoent setpwent
    setservent setsockopt shift shmctl shmget shmread shmwrite shutdown sin
    sleep socket socketpair splice split sprintf sqrt srand stat study substr
    symlink syscall sysopen sysread sysseek system syswrite tell telldir tied
    time times truncate uc ucfirst umask undef unlink unpack unshift untie utime
    values vec wait waitpid wantarray warn when write

just because they have been implemented, that says nothing about their
usefulness as a lazy function.

=head1 FUNCTIONS

=over 4

=item C< wrap NAME OPTIONS >

=item C< wrap CODE OPTIONS >

C< wrap > is used to automatically wrap the builtin functions in a C< fn(...) >
function that calls the builtin with the arguments passed in.

    *lazy_open = wrap 'open',
        styles => {
            1   => ['\@'],
            2   => ['\@', '$',],
            3   => ['\@', '$', '$'],
            '@' => ['\@', '$', '$', '@']
        },
        proto => '\@;$$@';
        arity => 1,
        returns => 1;

all of the options are optional, in fact, with a proper prototype, C< wrap >
will determine everything itself:

    *lazy_open = wrap 'open';  # same as with the options above

C< wrap > does not install anything, it returns the lazy coderef.

=back

=head1 AUTHOR

Eric Strom, C<< <asg at cpan.org> >>

=head1 BUGS

this module has barely been tested, ymmv

several functions are not available in 5.13+ and a warning will be generated.
to silence this:

    BEGIN {$FAST::List::Gen::Lazy::Builtins::WARN = 0}  # before calling 'use'
    use FAST::List::Gen::Lazy::Builtins;

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


1;
