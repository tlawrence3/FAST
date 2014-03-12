#
# BioPerl module for FAST::Bio::Seq::GapSeqI
#
# Cared for by Dave Ardell dave.ardell@ebc.uu.se
#
# Copyright David H. Ardell
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

FAST::Bio::Seq::GapSeqI - GapSeq interface, for gapped sequences

=head1 SYNOPSIS

    $aa   = $gapseq->translate;

=head1 DESCRIPTION

This interface extends the FAST::Bio::SeqI interface to give additional functionality
to gapped sequences.

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this
and other Bioperl modules. Send your comments and suggestions preferably
 to one of the Bioperl mailing lists.
Your participation is much appreciated.

  bioperl-l@bioperl.org                 - General discussion
  http://bio.perl.org/MailList.html             - About the mailing lists

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track
 the bugs and their resolution.
 Bug reports can be submitted via email or the web:

  bioperl-bugs@bio.perl.org
  http://bio.perl.org/bioperl-bugs/

=head1 AUTHOR - Dave Ardell

Email dave.ardell@ebc.uu.se

Describe contact details here

=head1 APPENDIX

The rest of the documentation details each of the object methods. Internal methods are usually preceded with a _

=cut


# Let the code begin...

package FAST::Bio::GapSeqI;
use vars qw(@ISA);
use strict;
use FAST::Bio::MySeqI;

@ISA = ('FAST::Bio::MySeqI');


=head2 translate

 Title   : translate
 Usage   : $protein_seq_obj = $dna_seq_obj->translate
           #if full CDS expected:
           $protein_seq_obj = $cds_seq_obj->translate(undef,undef,undef,undef,1);
 Function: Translate with gaps, so that an amino acid is aligned with the last base of a codon, even if said codon
           is interrupted by gaps. Generally this is only meaningful when input gaps are retained in the output; hence            the sequence is suitable for alignment to a DNA sequence. Otherwise, see pod for FAST::Bio::PrimarySeqI
 Example : "UUUC--CC -> "--F----P"
 Returns : a protein sequence object
 Args    : none


=cut



sub translate{
   my ($self,@args) = @_;

   $self->throw("hit translate in interface definition - error");

}



1;


