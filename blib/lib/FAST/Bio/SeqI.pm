#
# BioPerl module for FAST::Bio::SeqI
#
# Please direct questions and support issues to <bioperl-l@bioperl.org>
#
# Cared for by Ewan Birney <birney@ebi.ac.uk>
#
# Copyright Ewan Birney
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

=head1 NAME

FAST::Bio::SeqI - [Developers] Abstract Interface of Sequence (with features)

=head1 SYNOPSIS

    # FAST::Bio::SeqI is the interface class for sequences.

    # If you are a newcomer to bioperl, you should
    # start with FAST::Bio::Seq documentation. This
    # documentation is mainly for developers using
    # Bioperl.

    # FAST::Bio::SeqI implements FAST::Bio::PrimarySeqI
    $seq      = $seqobj->seq(); # actual sequence as a string
    $seqstr   = $seqobj->subseq(10,50);

    # FAST::Bio::SeqI has annotationcollections

    $ann      = $seqobj->annotation(); # annotation object

    # FAST::Bio::SeqI has sequence features
    # features must implement FAST::Bio::SeqFeatureI

    @features = $seqobj->get_SeqFeatures(); # just top level
    @features = $seqobj->get_all_SeqFeatures(); # descend into sub features



=head1 DESCRIPTION

FAST::Bio::SeqI is the abstract interface of annotated Sequences. These
methods are those which you can be guarenteed to get for any FAST::Bio::SeqI
- for most users of the package the documentation (and methods) in
this class are not at useful - this is a developers only class which
defines what methods have to be implmented by other Perl objects to
comply to the FAST::Bio::SeqI interface. Go "perldoc FAST::Bio::Seq" or "man
FAST::Bio::Seq" for more information.


There aren't many here, because too many complicated functions here
prevent implementations which are just wrappers around a database or
similar delayed mechanisms.

Most of the clever stuff happens inside the SeqFeatureI system.

A good reference implementation is FAST::Bio::Seq which is a pure perl
implementation of this class with a lot of extra pieces for extra
manipulation.  However, if you want to be able to use any sequence
object in your analysis, if you can do it just using these methods,
then you know you will be future proof and compatible with other
implementations of Seq.

=head1 FEEDBACK

=head2 Mailing Lists

User feedback is an integral part of the evolution of this and other
Bioperl modules. Send your comments and suggestions preferably to one
of the Bioperl mailing lists.  Your participation is much appreciated.

  bioperl-l@bioperl.org                  - General discussion
  http://bioperl.org/wiki/Mailing_lists  - About the mailing lists

=head2 Support

Please direct usage questions or support issues to the mailing list:

I<bioperl-l@bioperl.org>

rather than to the module maintainer directly. Many experienced and
reponsive experts will be able look at the problem and quickly
address it. Please include a thorough description of the problem
with code and data examples if at all possible.

=head2 Reporting Bugs

Report bugs to the Bioperl bug tracking system to help us keep track
the bugs and their resolution.  Bug reports can be submitted via the
web:

  https://redmine.open-bio.org/projects/bioperl/

=head1 AUTHOR - Ewan Birney

Email birney@ebi.ac.uk


=head1 APPENDIX

The rest of the documentation details each of the object
methods. Internal methods are usually preceded with a _

=cut

#'
# Let the code begin...


package FAST::Bio::SeqI;
use strict;


# Object preamble - inheriets from FAST::Bio::PrimarySeqI

use base qw(FAST::Bio::PrimarySeqI FAST::Bio::AnnotatableI FAST::Bio::FeatureHolderI);

=head2 get_SeqFeatures

 Title   : get_SeqFeatures
 Usage   : my @feats = $seq->get_SeqFeatures();
 Function: retrieve just the toplevel sequence features attached to this seq
 Returns : array of FAST::Bio::SeqFeatureI objects
 Args    : none

This method comes through extension of FAST::Bio::FeatureHolderI. See
L<FAST::Bio::FeatureHolderI> and L<FAST::Bio::SeqFeatureI> for more information.

=cut

=head2 get_all_SeqFeatures

 Title   : get_all_SeqFeatures
 Usage   : @features = $annseq->get_all_SeqFeatures()
 Function: returns all SeqFeatures, included sub SeqFeatures
 Returns : an array of FAST::Bio::SeqFeatureI objects
 Args    : none

This method comes through extension of FAST::Bio::FeatureHolderI. See
L<FAST::Bio::FeatureHolderI> and L<FAST::Bio::SeqFeatureI> for more information.

=cut

=head2 feature_count

 Title   : feature_count
 Usage   : $seq->feature_count()
 Function: Return the number of SeqFeatures attached to a sequence
 Returns : integer representing the number of SeqFeatures
 Args    : none

This method comes through extension of FAST::Bio::FeatureHolderI. See
L<FAST::Bio::FeatureHolderI> for more information.

=cut

=head2 seq

 Title   : seq
 Usage   : my $string = $seq->seq();
 Function: Retrieves the sequence string for the sequence object
 Returns : string
 Args    : none


=cut

sub seq{
   my ($self) = @_;
   $self->throw_not_implemented();
}

=head2 write_GFF

 Title   : write_GFF
 Usage   : $seq->write_GFF(\*FILEHANDLE);
 Function: Convience method to write out all the sequence features
           in GFF format to the provided filehandle (STDOUT by default)
 Returns : none
 Args    : [optional] filehandle to write to (default is STDOUT)


=cut

sub write_GFF{
   my ($self,$fh) = @_;

   $fh || do { $fh = \*STDOUT; };

   foreach my $sf ( $self->get_all_SeqFeatures() ) {
       print $fh $sf->gff_string, "\n";
   }

}

=head2 annotation

 Title   : annotation
 Usage   : $obj->annotation($seq_obj)
 Function: retrieve the attached annotation object
 Returns : FAST::Bio::AnnotationCollectionI or none;

See L<FAST::Bio::AnnotationCollectionI> and L<FAST::Bio::Annotation::Collection>
for more information. This method comes through extension from
L<FAST::Bio::AnnotatableI>.

=cut

=head2 species

 Title   : species
 Usage   :
 Function: Gets or sets the species
 Example : $species = $self->species();
 Returns : FAST::Bio::Species object
 Args    : FAST::Bio::Species object or none;

See L<FAST::Bio::Species> for more information

=cut

sub species {
    my ($self) = @_;
    $self->throw_not_implemented();
}

=head2 primary_seq

 Title   : primary_seq
 Usage   : $obj->primary_seq($newval)
 Function: Retrieve the underlying FAST::Bio::PrimarySeqI object if available.
           This is in the event one has a sequence with lots of features
           but want to be able to narrow the object to just one with
           the basics of a sequence (no features or annotations).
 Returns : FAST::Bio::PrimarySeqI
 Args    : FAST::Bio::PrimarySeqI or none;

See L<FAST::Bio::PrimarySeqI> for more information

=cut

sub primary_seq {
    my ($self) = @_;
    $self->throw_not_implemented;
}

1;
