package FAST;
use 5.10.1;
use strict;
use Carp;
use warnings FATAL => 'all';


our $VERSION = '1.06';

our $DEF_FORMAT  = "fasta";
our $DEF_LOGNAME = "FAST.log.txt";
our $DEF_JOIN_STRING = " ";
our $DEF_SPLIT_REGEX = ' ';

sub log {
  my ($logname, $DATE, $COMMAND, $comment, $fromSTDIN) = @_;
  unless ($logname and $DATE and $COMMAND) {
    carp join "","FAST::log: logname, DATE, or COMMAND undefined; logging not possible.\n";
    return;
  }
  open (LOG, ">>$logname") or carp "FAST::log: cannot open logfile $logname\n";
  if (*LOG) {
    if (!$fromSTDIN) {
      print LOG "\n# FAST $VERSION $DATE ";
      print LOG "$comment" if ($comment);
      print LOG "\n";
      print LOG "$COMMAND"
    }
    else {
      print LOG " | $COMMAND" 
    }
    close LOG;
  }
}


=head1 NAME

FAST - FAST Analysis of Sequences Toolbox

=head1 VERSION

Version 1.03

=head1 SYNOPSIS

The Fast Analysis of Sequences Toolbox (FAST) is a set of UNIX
utilities (for example fasgrep, fascut, fashead and fastr) that
extends the UNIX toolbox paradigm to bioinformatic sequence
records. Modeled after the UNIX textutils (such as grep, cut, head,
tr, etc), FAST workflows are designed for "inline" (serial) processing
of flatfile biological sequence record databases per-sequence, rather
than per-line, through UNIX pipelines. The default data exchange
format is multifasta (specifically, a restriction of BioPerl FastA
format). FASTQ format is supported. FAST is designed for learnability,
interoperability, interface consistency, rapid prototyping, fine-tuned
control, and reproducibility. FAST tools expose the power of Perl and
BioPerl to users in an easy-to-learn command-line paradigm.

=head1 UTILITIES

FAST 1.0x contains the following utilities. Each has its own man page.

=over 4

=item B<alncut>     
select sites based on site variation and gap-content

=item B<alnpi>      
calculate molecular population genetic statistics 

=item B<fascodon>   
tally/annotate codon usage

=item B<fascomp>    
tally/annotate monomer frequencies

=item B<fasconvert> 
convert sequences to or from from fasta format

=item B<fascut>     
select/reorder sequence records based on index lists/ranges

=item B<fasfilter>  
filter sequence records based on numerical values

=item B<fasgrep>    
filter sequence records based on perl regular expressions

=item B<fashead>    
filter leading sequence records

=item B<faslen>     
annotate sequence lengths

=item B<faspaste>   
concatenate sequence records

=item B<fasrc>      
reverse complement nucleotide sequences and alignments

=item B<fassort>    
sort sequence records

=item B<fassub>     
transform sequence records using regex-based substitutions

=item B<fastail>    
filter trailing sequence records

=item B<fastax>     
filter sequence records based on NCBI taxonomy IDs or names

=item B<fastaxsort> 
sort sequence records based on NCBI taxonomy IDs or names

=item B<fastr>      
transform sequence records by character, degap, strict

=item B<fasuniq>    
remove duplicate sequence records from sorted data

=item B<faswc>      
tally sequences and characters

=item B<fasxl>      
translate gapped and ungapped sequences and alignments

=item B<gbfalncut>  
select sites by regex matching of features in a GenBank file

=item B<gbfcut>     
print sequences by regex matching to features in a GenBank file

=back

=head1 AUTHORS

David H. Ardell, C<< <dhard at cpan.org> >>
and members of the Ardell Laboratory 
and other contributors including:
Travis Lawrence
Dana Carper
Katherine Amrine
Kyle Kauffman
Claudia Canales

=head1 BUGS

Please report any bugs or feature requests to C<bug-fast at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=FAST>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2015 David H. Ardell.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of FAST
