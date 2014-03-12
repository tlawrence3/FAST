#line 1 "inc/Bio/MySeqUtils.pm - /home/dave/lib//Bio/MySeqUtils.pm"

#
# BioPerl module for FAST::Bio::SeqUtils
#
# Cared for by Heikki Lehvaslaiho <heikki@ebi.ac.uk>
#
# Copyright Heikki Lehvaslaiho
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

#line 79


# Let the code begin...


package FAST::Bio::SeqUtils;
use vars qw(@ISA);
use strict;
use Carp;
use FAST::Bio::Tools::CodonTable;

@ISA = qw(FAST::Bio::Root::RootI);
# new inherited from RootI

{

my  %onecode =
    ('Ala' => 'A', 'Asx' => 'B', 'Cys' => 'C', 'Asp' => 'D',
     'Glu' => 'E', 'Phe' => 'F', 'Gly' => 'G', 'His' => 'H',
     'Ile' => 'I', 'Lys' => 'K', 'Leu' => 'L', 'Met' => 'M',
     'Asn' => 'N', 'Pro' => 'P', 'Gln' => 'Q', 'Arg' => 'R',
     'Ser' => 'S', 'Thr' => 'T', 'Val' => 'V', 'Trp' => 'W',
     'Xaa' => 'X', 'Tyr' => 'Y', 'Glx' => 'Z', 'Ter' => '*',
     'Sel' => 'U'
     );

my  %threecode =
    ('A' => 'Ala', 'B' => 'Asx', 'C' => 'Cys', 'D' => 'Asp',
     'E' => 'Glu', 'F' => 'Phe', 'G' => 'Gly', 'H' => 'His',
     'I' => 'Ile', 'K' => 'Lys', 'L' => 'Leu', 'M' => 'Met',
     'N' => 'Asn', 'P' => 'Pro', 'Q' => 'Gln', 'R' => 'Arg',
     'S' => 'Ser', 'T' => 'Thr', 'V' => 'Val', 'W' => 'Trp',
     'Y' => 'Tyr', 'Z' => 'Glx', 'X' => 'Xaa', '*' => 'Ter',
     'U' => 'Sel'
     );

#line 134

{ no warnings 'redefine'; #DHA FAST
sub seq3 {
   my ($self, $seq, $stop, $sep ) = @_;

   $seq->isa('FAST::Bio::PrimarySeqI') ||
       $self->throw('Not a FAST::Bio::PrimarySeqI object but [$self]');
   $seq->alphabet eq 'protein' ||
       $self->throw('Not a protein sequence');

   if (defined $stop) {
       length $stop != 1 and $self->throw('One character stop needed, not [$stop]');
       $threecode{$stop} = "Ter";
   }
   $sep ||= '';

   my $aa3s;
   foreach my $aa  (split //, uc $seq->seq) {
       $threecode{$aa} and $aa3s .= $threecode{$aa}. $sep, next;
       $aa3s .= 'Xaa'. $sep;
   }
   $sep and substr($aa3s, -(length $sep), length $sep) = '' ;
   return $aa3s;
}
}

#line 179

{ no warnings 'redefine'; #DHA FAST
sub seq3in {
   my ($self, $seq, $string, $stop, $unknown) = @_;

   $seq->isa('FAST::Bio::PrimarySeqI') ||
       $self->throw('Not a FAST::Bio::PrimarySeqI object but [$self]');
   $seq->alphabet eq 'protein' ||
       $self->throw('Not a protein sequence');

   if (defined $stop) {
       length $stop != 1 and $self->throw('One character stop needed, not [$stop]');
       $onecode{'Ter'} = $stop;
   }
   if (defined $unknown) {
       length $unknown != 1 and $self->throw('One character stop needed, not [$unknown]');
       $onecode{'Xaa'} = $unknown;
   }

   my ($aas, $aa3);
   my $length = (length $string) - 2;
   for (my $i = 0 ; $i < $length ; $i += 3)  {
       $aa3 = substr($string, $i, 3);
       $onecode{$aa3} and $aas .= $onecode{$aa3}, next;
       warn("Unknown three letter amino acid code [$aa3] ignored");
   }
   $seq->seq($aas);
   return $seq;
}
}

#line 225

sub seq3gap {
   my ($self, $seq, $sep) = @_;

   $seq->isa('FAST::Bio::PrimarySeqI') ||
       $self->throw('Not a FAST::Bio::PrimarySeqI object but [$self]');
   $seq->alphabet eq 'protein' ||
       $self->throw('Not a protein sequence');

   $sep ||= '~';

   my $aa3s;
   foreach my $aa  (split //, uc $seq->seq) {
       $aa3s .= $aa . $sep x 2, next;
   }
   $sep and substr($aa3s, -(length $sep), length $sep) = '' ;
   return $aa3s;

}

}


1;





