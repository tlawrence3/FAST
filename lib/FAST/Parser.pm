package FAST::Parser;
use strict;
use warnings;
 
use Exporter qw(import);
 
our @EXPORT_OK = qw(readfq);

sub readfq {
    	my @aux = undef;
	my $aux = \@aux;
	my $fh = shift(@_);
	@$aux = [undef, 0] if (!(@$aux));
	return if ($aux->[1]);
	if (!($aux->[0])) {
		while (<$fh>) {
			chomp;
			if (substr($_, 0, 1) eq '>' || substr($_, 0, 1) eq '@') {
				$aux->[0] = $_;
				last;
			}
		}
		if (!($aux->[0])) {
			$aux->[1] = 1;
			return;
		}
	}
	my $name = /^.(\S+)/? $1 : '';
	my $seq = '';
	my $c;
	$aux->[0] = undef;
	while (<$fh>) {
		chomp;
		$c = substr($_, 0, 1);
		last if ($c eq '>' || $c eq '@' || $c eq '+');
		$seq .= $_;
	}
	$aux->[0] = $_;
	$aux->[1] = 1 if (!($aux->[0]));
	if ($c ne '+'){
	   my @header = split / /, $name, 2;
	   if (scalar @header == 2){
	     return ($header[0], $header[1], $seq, undef);
           }
           else{
	     return ($name, undef, $seq, undef);
	   }
	}
	my $qual = '';
	while (<$fh>) {
		chomp;
		$qual .= $_;
		if (length($qual) >= length($seq)) {
			$aux->[0] = undef;
			my @header = split / /, $name, 2;
			if (scalar @header == 2){
			    return ($header[0], $header[1], $seq, $qual);
		        }
		        else{
			    return ($name, undef, $seq, $qual);
		        }
		}
	}
	$aux->[1] = 1;
	my @header = split / /, $name, 2;
	if (scalar @header == 2){
	    return ($header[0], $header[1], $seq, $qual);
        }
	else{
	    return ($name, undef, $seq, $qual);
	}
}
 
1;
