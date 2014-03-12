#line 1 "inc/Bio/GapSeq.pm - /home/dave/lib//Bio/GapSeq.pm"
#
# BioPerl module for FAST::Bio::Seq::GapSeq
#
# Cared for by 
#
# Copyright 
#
# You may distribute this module under the same terms as perl itself

# POD documentation - main docs before the code

#line 56


# Let the code begin...

package FAST::Bio::GapSeq;
use vars qw($AUTOLOAD @ISA);
use strict;

# Object preamble - inherits from FAST::Bio::Root::Object

use FAST::Bio::Seq;
use FAST::Bio::GapSeqI;

@ISA = qw(FAST::Bio::Seq FAST::Bio::GapSeqI);


#line 83

sub new {
    # standard new call..
    my($caller,@args) = @_;
    my $self = $caller->SUPER::new(@args);

    return $self;
}

#line 102

sub copy {
  ## not the standard constructor  
  my($caller,$seq_obj) = @_;
  my $self = $caller->SUPER::new();
  unless (UNIVERSAL::isa($seq_obj,"FAST::Bio::Seq")) {
    $self->throw("Argument to copy constructor must be a FAST::Bio::Seq.\n");
  }
  
  $self->alphabet($seq_obj->alphabet);
  $self->seq($seq_obj->seq);
  $self->display_id($seq_obj->display_id);
  $self->accession_number($seq_obj->accession_number);
  $self->primary_id($seq_obj->primary_id);
  $self->desc($seq_obj->desc);
  return $self;
}


#line 135


sub translate {
  my($self) = shift;
  my($stop, $unknown, $frame, $tableid, $fullCDS, $throw) = @_;
  my($i, $len, $output) = (0,0,'');
  my $aa;
  #DHA: IN THIS VERSION WE WILL ASSUME THAT GAP IS '-' 
  my $ingap = '-';
  my $outgap = $ingap;

  ## User can pass in symbol for stop and unknown codons
  unless(defined($stop) and $stop ne '')    { $stop = "*"; }
  unless(defined($unknown) and $unknown ne '') { $unknown = "X"; }
  unless(defined($frame) and $frame ne '') { $frame = 0; }

  ## the codon table ID
  unless(defined($tableid) and $tableid ne '')    { $tableid = 1; }

  ##Error if monomer is "Amino"
  $self->throw("Can't translate an amino acid sequence.") if
      ($self->alphabet eq 'protein');

  ##Error if frame is not 0, 1 or 2
  $self->throw("Valid values for frame are 0, 1, 2, not [$frame].") unless
      ($frame == 0 or $frame == 1 or $frame == 2);

  #thows a warning if ID is invalid
  my $codonTable = FAST::Bio::Tools::CodonTable->new( -id => $tableid);
  my ($seq) = $self->seq();


  #DHA: 
  #     FRAME IS DETERMINED BY THE FIRST NON-GAP CHARACTERS INSTEAD OF THE
  #     HEAD OF THE SEQUENCE.

  ##DHA: why was this here?  $seq .= 'n';
  my $length = length $seq;
  my $codon = '';
  my $frame_copy = $frame;
  my $frame_not_dealt_with = 1;
  if ($frame == 0) {
    $frame_not_dealt_with = 0;
  }

 CHAR:  for ($i = 0 ; $i < $length ; $i++)  {
    my $char = substr($seq, $i, 1);
    if ($char eq $ingap) {
      $output .= $outgap;
    }
    elsif ($frame_not_dealt_with == 1) {
      $output .= $outgap;
      $frame_copy--;
      if ($frame_copy != 0) {
	next CHAR;
      }
      else { 
	$frame_not_dealt_with = 0;
      }
    }
    else {
      $codon .= $char;
      if (length $codon != 3){
	$output .= $outgap;
	next CHAR;
      }
      else { ## COMPLETE CODON, TRANSLATE
	my $aa = $codonTable->translate($codon);
	if ($aa eq '*') {
	  $output .= $stop;
	}
	elsif ($aa eq 'X') {
	  $output .= $unknown;
	}
	else {
	  $output .= $aa ;
	}
	$codon = '';
      }
    }
  }
  ## DHA: FOR THE FOLLOWING TESTS, USE UNGAPPED SEQUENCE
  my $ungapped_output = $output;
  $ungapped_output =~ s/$outgap//g;
  # only if we are expecting to translate a complete coding region
  if ($fullCDS) {
      my $id = $self->display_id;
      #remove the stop character
      if( substr($ungapped_output,-1,1) eq $stop ) {
	  chop $ungapped_output;
      } else {
	  $throw && $self->throw("Seq [$id]: Not using a valid terminator codon!");
	  $self->warn("Seq [$id]: Not using a valid terminator codon!");
      }
      # test if there are terminator characters inside the protein sequence!
      if ($ungapped_output =~ /\*/) {
	  $throw && $self->throw("Seq [$id]: Terminator codon inside CDS!");
	  $self->warn("Seq [$id]: Terminator codon inside CDS!");
      }
      # if the initiator codon is not ATG, the amino acid needs to changed into M
      if ( substr($ungapped_output,0,1) ne 'M' ) {
	  if ($codonTable->is_start_codon(substr($seq, 0, 3)) ) {
	      $ungapped_output = 'M'. substr($ungapped_output,1);
	  }
	  elsif ($throw) {
	      $self->warn("Seq [$id]: Not using a valid initiator codon!");
	  } else {
	      $self->throw("Seq [$id]: Not using a valid initiator codon!");
	  }
      }
  }

  my $seqclass;
  if($self->can_call_new()) {
      $seqclass = ref($self);
  } else {
      $seqclass = 'FAST::Bio::PrimarySeq';
      $self->_attempt_to_load_Seq();
  }
  my $out = $seqclass->new( '-seq' => $output,
			    '-display_id'  => $self->display_id,
			    '-accession_number' => $self->accession_number,
			    # is there anything wrong with retaining the
			    # description?
			    '-desc' => $self->desc(),
			    '-alphabet' => 'protein'
			    );
  return $out;

}

1;
