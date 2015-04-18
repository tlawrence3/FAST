FAST --- Fast Analysis of Sequences Toolbox
==============

#### Version 1.5. February, 2015 ####

The FAST Analysis of Sequences Toolbox (FAST) is a set of Unix tools
(for example fasgrep, fascut, fashead and fastr) for sequence
bioinformatics modeled after the Unix textutils (such as grep, cut,
head, tr, etc). FAST workflows are designed for "inline" (serial)
processing of flatfile biological sequence record databases
per-sequence, rather than per-line, through Unix command
pipelines. The default data exchange format is multifasta
(specifically, a restriction of BioPerl FastA format). FAST tools
expose the power of Perl and BioPerl for sequence analysis to
non-programmers in an easy-to-learn command-line paradigm.

You do not need to know Perl or BioPerl to use FAST.

UTILITIES
----------

FAST 1.5 contains the following utilities. Each has its own man
page. FAST utilities may be classifed as for annotation, selection,
transformation, and analysis.

#### Annotation ####
| Program | Description |
| ----------- | ----------- |
| faslen     | annotate sequence lengths |
| fascodon   | tally/annotate codon usage |
| fascomp    | tally/annotate monomer frequencies |
| fasxl      | translate gapped and ungapped sequences and alignments |
| fasrc      | reverse complement nucleotide sequences and alignments |

#### Selection ####
| Program | Description |
| ----------- | ----------- |
| fasgrep    | select sequence records by perl regular expressions |
| fasfilter  | select sequence records by numerical values |
| fastax     | select sequence records by NCBI Taxonomy IDs or names |
| fascut     | select/reorder sequence record data by sequential ranges |
| fasuniq    | remove duplicate sequence records from sorted data |
| fashead    | select leading sequence records |
| fastail    | select trailing sequence records |
| alncut     | select sites based on variation and gap-content content |
| gbfcut     | select sequences by regex match on features in a GenBank features |
| gbfalncut  | select sites by regex match on features in a GenBank features |

#### Transformation ####
| Program | Description |
| ----------- | ----------- |
| fasconvert | convert sequences to or from from fasta format |
| fassort    | sort sequence records |
| fastaxsort | sort sequence records by NCBI Taxonomy IDs or names |
| faspaste   | concatenate sequence record data |
| fastr      | transform sequence records by characters and alphabets |
| fassub     | transform sequence records by regex-based substitutions |

#### Analysis ####
| Program | Description |
| ----------- | ----------- |
| faswc      | tally sequences and characters |
| alnpi      | tally molecular population genetic statistics|

PREREQUISITES
--------------

FAST has some Perl dependencies. Once posted to CPAN, the easiest way
to install FAST with its dependencies will be by executing this
command:

```bash
perl -MCPAN -e 'install FAST'
```
You can also follow INSTALLATION instructions below, but you may need to
first run these commands to install FAST dependencies:

```bash 
perl -MPCAN -e 'install Sort::Key'
perl -MCPAN -e 'install Sort::MergeSort'
perl -MCPAN -e 'install Bit::Vector'
perl -MCPAN -e 'install Test::More'
perl -MCPAN -e 'install Test::Script::Run'
```

INSTALLATION
--------------
To install this module, run the following:

```bash
perl Makefile.PL
make
make test
(sudo) make install
```

If you haven't installed perl-based software on your system before, or
you are having problems, please see more detailed notes in INSTALL.

GETTING STARTED
--------------

```bash
perldoc fasgrep
man fasgrep
perldoc FAST
```

Some usage examples in the man pages refer to data that ships with
FAST, in the installation package under t/data. Run these examples
with these data to get started right away using FAST.

DOCUMENTATION
--------------
Installation generates a man page for each utility. From the installation
directory, additional resources are in ./doc, particularly the FAST_Cookbook

SUPPORT
--------------
You can also look for information at:

RT, CPAN's request tracker (**report bugs here**):

http://rt.cpan.org/NoAuth/Bugs.html?Dist=FAST

AnnoCPAN, Annotated CPAN documentation:

http://annocpan.org/dist/FAST

CPAN Ratings:

http://cpanratings.perl.org/d/FAST

Search CPAN:

http://search.cpan.org/dist/FAST/

CITING
--------------
If you use FAST please, cite the FAST project (Lawrence et al. 2015)
and Bioperl (Stajich et al. 2005). 

If you publish work that cites data
provided in this FAST installer, please cite the authors of this data
accordingly. For example, if you use the tRNAdb-CE data provided in
this installer, please cite: Abe T, Inokuchi H, Yamada Y, Muto A,
Iwasaki Y and Ikemura T (2014) tRNADB-CE: tRNA gene database
well-timed in the era of big sequence data. Front. Genet. 5:114. doi:
10.3389/fgene.2014.00114

VERSION AND CHANGES
--------------
1.0 -- First public release

LICENSE AND COPYRIGHT
--------------
Copyright (C) 2015 David H. Ardell

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:
http://www.perlfoundation.org/artistic_license_2_0

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
