# This Makefile is for the FAST extension to perl.
#
# It was generated automatically by MakeMaker version
# 6.96 (Revision: 69600) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT_FROM => q[lib/FAST.pm]
#     AUTHOR => [q[David H. Ardell <dhard@cpan.org>]]
#     BUILD_REQUIRES => { Test::More=>q[0] }
#     CONFIGURE_REQUIRES => { ExtUtils::MakeMaker=>q[0] }
#     EXE_FILES => [q[bin/alndegap], q[bin/alnpi], q[bin/alnseg], q[bin/fascodon], q[bin/fascomp], q[bin/fasconvert], q[bin/fascut], q[bin/fasfilter], q[bin/fasgrep], q[bin/faslen], q[bin/fasposcomp], q[bin/fasrc], q[bin/fassub], q[bin/fastr], q[bin/fasuniq], q[bin/fasxl], q[bin/fassort]]
#     INSTALLMAN3DIR => q[none]
#     LICENSE => q[Perl]
#     MIN_PERL_VERSION => q[5.006]
#     NAME => q[FAST]
#     PREREQ_PM => { Test::More=>q[0], GetOpt::Long=>q[2.32] }
#     TEST_REQUIRES => {  }
#     VERSION_FROM => q[lib/FAST.pm]
#     clean => { FILES=>q[FAST-*] }
#     dist => { COMPRESS=>q[gzip -9f], SUFFIX=>q[gz] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/5.18.2/darwin-2level/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = cc
CCCDLFLAGS =  
CCDLFLAGS =  
DLEXT = bundle
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = env MACOSX_DEPLOYMENT_TARGET=10.3 cc
LDDLFLAGS =  -bundle -undefined dynamic_lookup -L/usr/local/lib -fstack-protector
LDFLAGS =  -fstack-protector -L/usr/local/lib
LIBC = 
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = darwin
OSVERS = 13.1.0
RANLIB = ranlib
SITELIBEXP = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/site_perl/5.18.2
SITEARCHEXP = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/site_perl/5.18.2/darwin-2level
SO = dylib
VENDORARCHEXP = 
VENDORLIBEXP = 


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = FAST
NAME_SYM = FAST
VERSION = 0.04
VERSION_MACRO = VERSION
VERSION_SYM = 0_04
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.04
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1
MAN3EXT = 3
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2
SITEPREFIX = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2
VENDORPREFIX = 
INSTALLPRIVLIB = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/5.18.2
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/site_perl/5.18.2
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = 
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/5.18.2/darwin-2level
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/site_perl/5.18.2/darwin-2level
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = 
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = 
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = 
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = 
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = none
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = 
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/5.18.2
PERL_ARCHLIB = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/5.18.2/darwin-2level
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/5.18.2/darwin-2level/CORE
PERL = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/bin/perl
FULLPERL = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/bin/perl
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/lib/site_perl/5.18.2/ExtUtils/MakeMaker.pm
MM_VERSION  = 6.96
MM_REVISION = 69600

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = FAST
BASEEXT = FAST
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = lib/FAST.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = bin/alndegap \
	bin/alnseg \
	bin/fascomp \
	bin/fasconvert \
	bin/fascut \
	bin/fasgrep \
	bin/faslen \
	bin/fasrc \
	bin/fassort \
	bin/fassub \
	bin/fastr \
	bin/fasuniq \
	bin/fasxl
MAN3PODS = 

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIB)$(DFSEP)Config.pm $(PERL_INC)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/.DS_Store \
	lib/FAST.pm \
	lib/FAST/.DS_Store \
	lib/FAST/Bio/Align/AlignI.pm \
	lib/FAST/Bio/AlignIO.pm \
	lib/FAST/Bio/AlignIO/Handler/GenericAlignHandler.pm \
	lib/FAST/Bio/AlignIO/arp.pm \
	lib/FAST/Bio/AlignIO/bl2seq.pm \
	lib/FAST/Bio/AlignIO/clustalw.pm \
	lib/FAST/Bio/AlignIO/emboss.pm \
	lib/FAST/Bio/AlignIO/fasta.pm \
	lib/FAST/Bio/AlignIO/largemultifasta.pm \
	lib/FAST/Bio/AlignIO/maf.pm \
	lib/FAST/Bio/AlignIO/mase.pm \
	lib/FAST/Bio/AlignIO/mega.pm \
	lib/FAST/Bio/AlignIO/meme.pm \
	lib/FAST/Bio/AlignIO/metafasta.pm \
	lib/FAST/Bio/AlignIO/msf.pm \
	lib/FAST/Bio/AlignIO/nexml.pm \
	lib/FAST/Bio/AlignIO/nexus.pm \
	lib/FAST/Bio/AlignIO/pfam.pm \
	lib/FAST/Bio/AlignIO/phylip.pm \
	lib/FAST/Bio/AlignIO/po.pm \
	lib/FAST/Bio/AlignIO/proda.pm \
	lib/FAST/Bio/AlignIO/prodom.pm \
	lib/FAST/Bio/AlignIO/psi.pm \
	lib/FAST/Bio/AlignIO/selex.pm \
	lib/FAST/Bio/AlignIO/stockholm.pm \
	lib/FAST/Bio/AlignIO/xmfa.pm \
	lib/FAST/Bio/AnalysisParserI.pm \
	lib/FAST/Bio/AnalysisResultI.pm \
	lib/FAST/Bio/AnnotatableI.pm \
	lib/FAST/Bio/Annotation/AnnotationFactory.pm \
	lib/FAST/Bio/Annotation/Collection.pm \
	lib/FAST/Bio/Annotation/Comment.pm \
	lib/FAST/Bio/Annotation/DBLink.pm \
	lib/FAST/Bio/Annotation/OntologyTerm.pm \
	lib/FAST/Bio/Annotation/Reference.pm \
	lib/FAST/Bio/Annotation/SimpleValue.pm \
	lib/FAST/Bio/Annotation/TagTree.pm \
	lib/FAST/Bio/Annotation/Target.pm \
	lib/FAST/Bio/Annotation/TypeManager.pm \
	lib/FAST/Bio/AnnotationCollectionI.pm \
	lib/FAST/Bio/AnnotationI.pm \
	lib/FAST/Bio/Cluster/FamilyI.pm \
	lib/FAST/Bio/Cluster/SequenceFamily.pm \
	lib/FAST/Bio/ClusterI.pm \
	lib/FAST/Bio/DB/InMemoryCache.pm \
	lib/FAST/Bio/DB/RandomAccessI.pm \
	lib/FAST/Bio/DB/SeqI.pm \
	lib/FAST/Bio/DB/Taxonomy.pm \
	lib/FAST/Bio/DB/Taxonomy/entrez.pm \
	lib/FAST/Bio/DB/Taxonomy/flatfile.pm \
	lib/FAST/Bio/DB/Taxonomy/list.pm \
	lib/FAST/Bio/DescribableI.pm \
	lib/FAST/Bio/Event/EventGeneratorI.pm \
	lib/FAST/Bio/Event/EventHandlerI.pm \
	lib/FAST/Bio/Factory/FTLocationFactory.pm \
	lib/FAST/Bio/Factory/LocationFactoryI.pm \
	lib/FAST/Bio/Factory/ObjectBuilderI.pm \
	lib/FAST/Bio/Factory/ObjectFactory.pm \
	lib/FAST/Bio/Factory/ObjectFactoryI.pm \
	lib/FAST/Bio/Factory/SequenceFactoryI.pm \
	lib/FAST/Bio/Factory/SequenceStreamI.pm \
	lib/FAST/Bio/FeatureHolderI.pm \
	lib/FAST/Bio/GapSeq.pm \
	lib/FAST/Bio/GapSeqI.pm \
	lib/FAST/Bio/HandlerBaseI.pm \
	lib/FAST/Bio/IdentifiableI.pm \
	lib/FAST/Bio/LocatableSeq.pm \
	lib/FAST/Bio/Location/Atomic.pm \
	lib/FAST/Bio/Location/CoordinatePolicyI.pm \
	lib/FAST/Bio/Location/Fuzzy.pm \
	lib/FAST/Bio/Location/FuzzyLocationI.pm \
	lib/FAST/Bio/Location/NarrowestCoordPolicy.pm \
	lib/FAST/Bio/Location/Simple.pm \
	lib/FAST/Bio/Location/Split.pm \
	lib/FAST/Bio/Location/SplitLocationI.pm \
	lib/FAST/Bio/Location/WidestCoordPolicy.pm \
	lib/FAST/Bio/LocationI.pm \
	lib/FAST/Bio/MyPrimarySeqI.pm \
	lib/FAST/Bio/MySeqI.pm \
	lib/FAST/Bio/MySeqUtils.pm \
	lib/FAST/Bio/Nexml/Factory.pm \
	lib/FAST/Bio/Ontology/DocumentRegistry.pm \
	lib/FAST/Bio/Ontology/OBOEngine.pm \
	lib/FAST/Bio/Ontology/Ontology.pm \
	lib/FAST/Bio/Ontology/OntologyEngineI.pm \
	lib/FAST/Bio/Ontology/OntologyI.pm \
	lib/FAST/Bio/Ontology/OntologyStore.pm \
	lib/FAST/Bio/Ontology/Relationship.pm \
	lib/FAST/Bio/Ontology/RelationshipFactory.pm \
	lib/FAST/Bio/Ontology/RelationshipI.pm \
	lib/FAST/Bio/Ontology/RelationshipType.pm \
	lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor.pm \
	lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor02.pm \
	lib/FAST/Bio/Ontology/SimpleOntologyEngine.pm \
	lib/FAST/Bio/Ontology/Term.pm \
	lib/FAST/Bio/Ontology/TermFactory.pm \
	lib/FAST/Bio/Ontology/TermI.pm \
	lib/FAST/Bio/OntologyIO.pm \
	lib/FAST/Bio/OntologyIO/Handlers/BaseSAXHandler.pm \
	lib/FAST/Bio/OntologyIO/Handlers/InterProHandler.pm \
	lib/FAST/Bio/OntologyIO/Handlers/InterPro_BioSQL_Handler.pm \
	lib/FAST/Bio/OntologyIO/InterProParser.pm \
	lib/FAST/Bio/OntologyIO/dagflat.pm \
	lib/FAST/Bio/OntologyIO/goflat.pm \
	lib/FAST/Bio/OntologyIO/obo.pm \
	lib/FAST/Bio/OntologyIO/simplehierarchy.pm \
	lib/FAST/Bio/OntologyIO/soflat.pm \
	lib/FAST/Bio/PrimarySeq.pm \
	lib/FAST/Bio/PrimarySeqI.pm \
	lib/FAST/Bio/PullParserI.pm \
	lib/FAST/Bio/Range.pm \
	lib/FAST/Bio/RangeI.pm \
	lib/FAST/Bio/Root/Exception.pm \
	lib/FAST/Bio/Root/HTTPget.pm \
	lib/FAST/Bio/Root/IO.pm \
	lib/FAST/Bio/Root/Root.pm \
	lib/FAST/Bio/Root/RootI.pm \
	lib/FAST/Bio/Root/Version.pm \
	lib/FAST/Bio/Search/BlastUtils.pm \
	lib/FAST/Bio/Search/GenericStatistics.pm \
	lib/FAST/Bio/Search/HSP/BlastPullHSP.pm \
	lib/FAST/Bio/Search/HSP/GenericHSP.pm \
	lib/FAST/Bio/Search/HSP/HSPFactory.pm \
	lib/FAST/Bio/Search/HSP/HSPI.pm \
	lib/FAST/Bio/Search/HSP/HmmpfamHSP.pm \
	lib/FAST/Bio/Search/HSP/PullHSPI.pm \
	lib/FAST/Bio/Search/Hit/BlastPullHit.pm \
	lib/FAST/Bio/Search/Hit/GenericHit.pm \
	lib/FAST/Bio/Search/Hit/HitFactory.pm \
	lib/FAST/Bio/Search/Hit/HitI.pm \
	lib/FAST/Bio/Search/Hit/HmmpfamHit.pm \
	lib/FAST/Bio/Search/Hit/PullHitI.pm \
	lib/FAST/Bio/Search/Result/BlastPullResult.pm \
	lib/FAST/Bio/Search/Result/CrossMatchResult.pm \
	lib/FAST/Bio/Search/Result/GenericResult.pm \
	lib/FAST/Bio/Search/Result/HmmpfamResult.pm \
	lib/FAST/Bio/Search/Result/PullResultI.pm \
	lib/FAST/Bio/Search/Result/ResultFactory.pm \
	lib/FAST/Bio/Search/Result/ResultI.pm \
	lib/FAST/Bio/Search/SearchUtils.pm \
	lib/FAST/Bio/Search/StatisticsI.pm \
	lib/FAST/Bio/SearchIO.pm \
	lib/FAST/Bio/SearchIO/EventHandlerI.pm \
	lib/FAST/Bio/SearchIO/FastHitEventBuilder.pm \
	lib/FAST/Bio/SearchIO/IteratedSearchResultEventBuilder.pm \
	lib/FAST/Bio/SearchIO/SearchResultEventBuilder.pm \
	lib/FAST/Bio/SearchIO/SearchWriterI.pm \
	lib/FAST/Bio/SearchIO/Writer/BSMLResultWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/GbrowseGFF.pm \
	lib/FAST/Bio/SearchIO/Writer/HSPTableWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/HTMLResultWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/HitTableWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/ResultTableWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/TextResultWriter.pm \
	lib/FAST/Bio/SearchIO/XML/BlastHandler.pm \
	lib/FAST/Bio/SearchIO/XML/PsiBlastHandler.pm \
	lib/FAST/Bio/SearchIO/axt.pm \
	lib/FAST/Bio/SearchIO/blast.pm \
	lib/FAST/Bio/SearchIO/blast_pull.pm \
	lib/FAST/Bio/SearchIO/blasttable.pm \
	lib/FAST/Bio/SearchIO/blastxml.pm \
	lib/FAST/Bio/SearchIO/cross_match.pm \
	lib/FAST/Bio/SearchIO/erpin.pm \
	lib/FAST/Bio/SearchIO/exonerate.pm \
	lib/FAST/Bio/SearchIO/fasta.pm \
	lib/FAST/Bio/SearchIO/gmap_f9.pm \
	lib/FAST/Bio/SearchIO/hmmer.pm \
	lib/FAST/Bio/SearchIO/hmmer2.pm \
	lib/FAST/Bio/SearchIO/hmmer3.pm \
	lib/FAST/Bio/SearchIO/hmmer_pull.pm \
	lib/FAST/Bio/SearchIO/infernal.pm \
	lib/FAST/Bio/SearchIO/megablast.pm \
	lib/FAST/Bio/SearchIO/psl.pm \
	lib/FAST/Bio/SearchIO/rnamotif.pm \
	lib/FAST/Bio/SearchIO/sim4.pm \
	lib/FAST/Bio/SearchIO/waba.pm \
	lib/FAST/Bio/SearchIO/wise.pm \
	lib/FAST/Bio/Seq.pm \
	lib/FAST/Bio/Seq/LargeLocatableSeq.pm \
	lib/FAST/Bio/Seq/LargePrimarySeq.pm \
	lib/FAST/Bio/Seq/LargeSeqI.pm \
	lib/FAST/Bio/Seq/Meta.pm \
	lib/FAST/Bio/Seq/Meta/Array.pm \
	lib/FAST/Bio/Seq/MetaI.pm \
	lib/FAST/Bio/Seq/PrimaryQual.pm \
	lib/FAST/Bio/Seq/QualI.pm \
	lib/FAST/Bio/Seq/Quality.pm \
	lib/FAST/Bio/Seq/RichSeq.pm \
	lib/FAST/Bio/Seq/RichSeqI.pm \
	lib/FAST/Bio/Seq/SeqBuilder.pm \
	lib/FAST/Bio/Seq/SeqFactory.pm \
	lib/FAST/Bio/Seq/SeqFastaSpeedFactory.pm \
	lib/FAST/Bio/Seq/SequenceTrace.pm \
	lib/FAST/Bio/Seq/TraceI.pm \
	lib/FAST/Bio/SeqAnalysisParserI.pm \
	lib/FAST/Bio/SeqFeature/FeaturePair.pm \
	lib/FAST/Bio/SeqFeature/Gene/Exon.pm \
	lib/FAST/Bio/SeqFeature/Gene/ExonI.pm \
	lib/FAST/Bio/SeqFeature/Gene/GeneStructure.pm \
	lib/FAST/Bio/SeqFeature/Gene/GeneStructureI.pm \
	lib/FAST/Bio/SeqFeature/Gene/Intron.pm \
	lib/FAST/Bio/SeqFeature/Gene/NC_Feature.pm \
	lib/FAST/Bio/SeqFeature/Gene/Poly_A_site.pm \
	lib/FAST/Bio/SeqFeature/Gene/Promoter.pm \
	lib/FAST/Bio/SeqFeature/Gene/Transcript.pm \
	lib/FAST/Bio/SeqFeature/Gene/TranscriptI.pm \
	lib/FAST/Bio/SeqFeature/Gene/UTR.pm \
	lib/FAST/Bio/SeqFeature/Generic.pm \
	lib/FAST/Bio/SeqFeature/Similarity.pm \
	lib/FAST/Bio/SeqFeature/SimilarityPair.pm \
	lib/FAST/Bio/SeqFeature/Tools/FeatureNamer.pm \
	lib/FAST/Bio/SeqFeature/Tools/IDHandler.pm \
	lib/FAST/Bio/SeqFeature/Tools/TypeMapper.pm \
	lib/FAST/Bio/SeqFeature/Tools/Unflattener.pm \
	lib/FAST/Bio/SeqFeatureI.pm \
	lib/FAST/Bio/SeqI.pm \
	lib/FAST/Bio/SeqIO.pm \
	lib/FAST/Bio/SeqIO/FTHelper.pm \
	lib/FAST/Bio/SeqIO/Handler/GenericRichSeqHandler.pm \
	lib/FAST/Bio/SeqIO/MultiFile.pm \
	lib/FAST/Bio/SeqIO/abi.pm \
	lib/FAST/Bio/SeqIO/ace.pm \
	lib/FAST/Bio/SeqIO/agave.pm \
	lib/FAST/Bio/SeqIO/alf.pm \
	lib/FAST/Bio/SeqIO/asciitree.pm \
	lib/FAST/Bio/SeqIO/bsml.pm \
	lib/FAST/Bio/SeqIO/bsml_sax.pm \
	lib/FAST/Bio/SeqIO/chadoxml.pm \
	lib/FAST/Bio/SeqIO/chaos.pm \
	lib/FAST/Bio/SeqIO/chaosxml.pm \
	lib/FAST/Bio/SeqIO/ctf.pm \
	lib/FAST/Bio/SeqIO/embl.pm \
	lib/FAST/Bio/SeqIO/embldriver.pm \
	lib/FAST/Bio/SeqIO/entrezgene.pm \
	lib/FAST/Bio/SeqIO/excel.pm \
	lib/FAST/Bio/SeqIO/exp.pm \
	lib/FAST/Bio/SeqIO/fasta.pm \
	lib/FAST/Bio/SeqIO/fastq.pm \
	lib/FAST/Bio/SeqIO/flybase_chadoxml.pm \
	lib/FAST/Bio/SeqIO/game.pm \
	lib/FAST/Bio/SeqIO/game/featHandler.pm \
	lib/FAST/Bio/SeqIO/game/gameHandler.pm \
	lib/FAST/Bio/SeqIO/game/gameSubs.pm \
	lib/FAST/Bio/SeqIO/game/gameWriter.pm \
	lib/FAST/Bio/SeqIO/game/seqHandler.pm \
	lib/FAST/Bio/SeqIO/gbdriver.pm \
	lib/FAST/Bio/SeqIO/gbxml.pm \
	lib/FAST/Bio/SeqIO/gcg.pm \
	lib/FAST/Bio/SeqIO/genbank.pm \
	lib/FAST/Bio/SeqIO/interpro.pm \
	lib/FAST/Bio/SeqIO/kegg.pm \
	lib/FAST/Bio/SeqIO/largefasta.pm \
	lib/FAST/Bio/SeqIO/lasergene.pm \
	lib/FAST/Bio/SeqIO/locuslink.pm \
	lib/FAST/Bio/SeqIO/mbsout.pm \
	lib/FAST/Bio/SeqIO/metafasta.pm \
	lib/FAST/Bio/SeqIO/msout.pm \
	lib/FAST/Bio/SeqIO/nexml.pm \
	lib/FAST/Bio/SeqIO/phd.pm \
	lib/FAST/Bio/SeqIO/pir.pm \
	lib/FAST/Bio/SeqIO/pln.pm \
	lib/FAST/Bio/SeqIO/qual.pm \
	lib/FAST/Bio/SeqIO/raw.pm \
	lib/FAST/Bio/SeqIO/scf.pm \
	lib/FAST/Bio/SeqIO/seqxml.pm \
	lib/FAST/Bio/SeqIO/strider.pm \
	lib/FAST/Bio/SeqIO/swiss.pm \
	lib/FAST/Bio/SeqIO/swissdriver.pm \
	lib/FAST/Bio/SeqIO/tab.pm \
	lib/FAST/Bio/SeqIO/table.pm \
	lib/FAST/Bio/SeqIO/tigr.pm \
	lib/FAST/Bio/SeqIO/tigrxml.pm \
	lib/FAST/Bio/SeqIO/tinyseq.pm \
	lib/FAST/Bio/SeqIO/tinyseq/tinyseqHandler.pm \
	lib/FAST/Bio/SeqIO/ztr.pm \
	lib/FAST/Bio/SeqUtils.pm \
	lib/FAST/Bio/SimpleAlign.pm \
	lib/FAST/Bio/Species.pm \
	lib/FAST/Bio/Taxon.pm \
	lib/FAST/Bio/Tools/AnalysisResult.pm \
	lib/FAST/Bio/Tools/CodonTable.pm \
	lib/FAST/Bio/Tools/GFF.pm \
	lib/FAST/Bio/Tools/Genewise.pm \
	lib/FAST/Bio/Tools/Genomewise.pm \
	lib/FAST/Bio/Tools/GuessSeqFormat.pm \
	lib/FAST/Bio/Tools/IUPAC.pm \
	lib/FAST/Bio/Tools/MySeqStats.pm \
	lib/FAST/Bio/Tools/Run/GenericParameters.pm \
	lib/FAST/Bio/Tools/Run/ParametersI.pm \
	lib/FAST/Bio/Tools/SeqPattern.pm \
	lib/FAST/Bio/Tools/SeqPattern/Backtranslate.pm \
	lib/FAST/Bio/Tools/SeqStats.pm \
	lib/FAST/Bio/Tree/Node.pm \
	lib/FAST/Bio/Tree/NodeI.pm \
	lib/FAST/Bio/Tree/Tree.pm \
	lib/FAST/Bio/Tree/TreeFunctionsI.pm \
	lib/FAST/Bio/Tree/TreeI.pm \
	lib/FAST/Bio/UnivAln.pm \
	lib/FAST/Bio/WebAgent.pm \
	lib/Pod/Usage.pm

PM_TO_BLIB = lib/.DS_Store \
	blib/lib/.DS_Store \
	lib/FAST.pm \
	blib/lib/FAST.pm \
	lib/FAST/.DS_Store \
	blib/lib/FAST/.DS_Store \
	lib/FAST/Bio/Align/AlignI.pm \
	blib/lib/FAST/Bio/Align/AlignI.pm \
	lib/FAST/Bio/AlignIO.pm \
	blib/lib/FAST/Bio/AlignIO.pm \
	lib/FAST/Bio/AlignIO/Handler/GenericAlignHandler.pm \
	blib/lib/FAST/Bio/AlignIO/Handler/GenericAlignHandler.pm \
	lib/FAST/Bio/AlignIO/arp.pm \
	blib/lib/FAST/Bio/AlignIO/arp.pm \
	lib/FAST/Bio/AlignIO/bl2seq.pm \
	blib/lib/FAST/Bio/AlignIO/bl2seq.pm \
	lib/FAST/Bio/AlignIO/clustalw.pm \
	blib/lib/FAST/Bio/AlignIO/clustalw.pm \
	lib/FAST/Bio/AlignIO/emboss.pm \
	blib/lib/FAST/Bio/AlignIO/emboss.pm \
	lib/FAST/Bio/AlignIO/fasta.pm \
	blib/lib/FAST/Bio/AlignIO/fasta.pm \
	lib/FAST/Bio/AlignIO/largemultifasta.pm \
	blib/lib/FAST/Bio/AlignIO/largemultifasta.pm \
	lib/FAST/Bio/AlignIO/maf.pm \
	blib/lib/FAST/Bio/AlignIO/maf.pm \
	lib/FAST/Bio/AlignIO/mase.pm \
	blib/lib/FAST/Bio/AlignIO/mase.pm \
	lib/FAST/Bio/AlignIO/mega.pm \
	blib/lib/FAST/Bio/AlignIO/mega.pm \
	lib/FAST/Bio/AlignIO/meme.pm \
	blib/lib/FAST/Bio/AlignIO/meme.pm \
	lib/FAST/Bio/AlignIO/metafasta.pm \
	blib/lib/FAST/Bio/AlignIO/metafasta.pm \
	lib/FAST/Bio/AlignIO/msf.pm \
	blib/lib/FAST/Bio/AlignIO/msf.pm \
	lib/FAST/Bio/AlignIO/nexml.pm \
	blib/lib/FAST/Bio/AlignIO/nexml.pm \
	lib/FAST/Bio/AlignIO/nexus.pm \
	blib/lib/FAST/Bio/AlignIO/nexus.pm \
	lib/FAST/Bio/AlignIO/pfam.pm \
	blib/lib/FAST/Bio/AlignIO/pfam.pm \
	lib/FAST/Bio/AlignIO/phylip.pm \
	blib/lib/FAST/Bio/AlignIO/phylip.pm \
	lib/FAST/Bio/AlignIO/po.pm \
	blib/lib/FAST/Bio/AlignIO/po.pm \
	lib/FAST/Bio/AlignIO/proda.pm \
	blib/lib/FAST/Bio/AlignIO/proda.pm \
	lib/FAST/Bio/AlignIO/prodom.pm \
	blib/lib/FAST/Bio/AlignIO/prodom.pm \
	lib/FAST/Bio/AlignIO/psi.pm \
	blib/lib/FAST/Bio/AlignIO/psi.pm \
	lib/FAST/Bio/AlignIO/selex.pm \
	blib/lib/FAST/Bio/AlignIO/selex.pm \
	lib/FAST/Bio/AlignIO/stockholm.pm \
	blib/lib/FAST/Bio/AlignIO/stockholm.pm \
	lib/FAST/Bio/AlignIO/xmfa.pm \
	blib/lib/FAST/Bio/AlignIO/xmfa.pm \
	lib/FAST/Bio/AnalysisParserI.pm \
	blib/lib/FAST/Bio/AnalysisParserI.pm \
	lib/FAST/Bio/AnalysisResultI.pm \
	blib/lib/FAST/Bio/AnalysisResultI.pm \
	lib/FAST/Bio/AnnotatableI.pm \
	blib/lib/FAST/Bio/AnnotatableI.pm \
	lib/FAST/Bio/Annotation/AnnotationFactory.pm \
	blib/lib/FAST/Bio/Annotation/AnnotationFactory.pm \
	lib/FAST/Bio/Annotation/Collection.pm \
	blib/lib/FAST/Bio/Annotation/Collection.pm \
	lib/FAST/Bio/Annotation/Comment.pm \
	blib/lib/FAST/Bio/Annotation/Comment.pm \
	lib/FAST/Bio/Annotation/DBLink.pm \
	blib/lib/FAST/Bio/Annotation/DBLink.pm \
	lib/FAST/Bio/Annotation/OntologyTerm.pm \
	blib/lib/FAST/Bio/Annotation/OntologyTerm.pm \
	lib/FAST/Bio/Annotation/Reference.pm \
	blib/lib/FAST/Bio/Annotation/Reference.pm \
	lib/FAST/Bio/Annotation/SimpleValue.pm \
	blib/lib/FAST/Bio/Annotation/SimpleValue.pm \
	lib/FAST/Bio/Annotation/TagTree.pm \
	blib/lib/FAST/Bio/Annotation/TagTree.pm \
	lib/FAST/Bio/Annotation/Target.pm \
	blib/lib/FAST/Bio/Annotation/Target.pm \
	lib/FAST/Bio/Annotation/TypeManager.pm \
	blib/lib/FAST/Bio/Annotation/TypeManager.pm \
	lib/FAST/Bio/AnnotationCollectionI.pm \
	blib/lib/FAST/Bio/AnnotationCollectionI.pm \
	lib/FAST/Bio/AnnotationI.pm \
	blib/lib/FAST/Bio/AnnotationI.pm \
	lib/FAST/Bio/Cluster/FamilyI.pm \
	blib/lib/FAST/Bio/Cluster/FamilyI.pm \
	lib/FAST/Bio/Cluster/SequenceFamily.pm \
	blib/lib/FAST/Bio/Cluster/SequenceFamily.pm \
	lib/FAST/Bio/ClusterI.pm \
	blib/lib/FAST/Bio/ClusterI.pm \
	lib/FAST/Bio/DB/InMemoryCache.pm \
	blib/lib/FAST/Bio/DB/InMemoryCache.pm \
	lib/FAST/Bio/DB/RandomAccessI.pm \
	blib/lib/FAST/Bio/DB/RandomAccessI.pm \
	lib/FAST/Bio/DB/SeqI.pm \
	blib/lib/FAST/Bio/DB/SeqI.pm \
	lib/FAST/Bio/DB/Taxonomy.pm \
	blib/lib/FAST/Bio/DB/Taxonomy.pm \
	lib/FAST/Bio/DB/Taxonomy/entrez.pm \
	blib/lib/FAST/Bio/DB/Taxonomy/entrez.pm \
	lib/FAST/Bio/DB/Taxonomy/flatfile.pm \
	blib/lib/FAST/Bio/DB/Taxonomy/flatfile.pm \
	lib/FAST/Bio/DB/Taxonomy/list.pm \
	blib/lib/FAST/Bio/DB/Taxonomy/list.pm \
	lib/FAST/Bio/DescribableI.pm \
	blib/lib/FAST/Bio/DescribableI.pm \
	lib/FAST/Bio/Event/EventGeneratorI.pm \
	blib/lib/FAST/Bio/Event/EventGeneratorI.pm \
	lib/FAST/Bio/Event/EventHandlerI.pm \
	blib/lib/FAST/Bio/Event/EventHandlerI.pm \
	lib/FAST/Bio/Factory/FTLocationFactory.pm \
	blib/lib/FAST/Bio/Factory/FTLocationFactory.pm \
	lib/FAST/Bio/Factory/LocationFactoryI.pm \
	blib/lib/FAST/Bio/Factory/LocationFactoryI.pm \
	lib/FAST/Bio/Factory/ObjectBuilderI.pm \
	blib/lib/FAST/Bio/Factory/ObjectBuilderI.pm \
	lib/FAST/Bio/Factory/ObjectFactory.pm \
	blib/lib/FAST/Bio/Factory/ObjectFactory.pm \
	lib/FAST/Bio/Factory/ObjectFactoryI.pm \
	blib/lib/FAST/Bio/Factory/ObjectFactoryI.pm \
	lib/FAST/Bio/Factory/SequenceFactoryI.pm \
	blib/lib/FAST/Bio/Factory/SequenceFactoryI.pm \
	lib/FAST/Bio/Factory/SequenceStreamI.pm \
	blib/lib/FAST/Bio/Factory/SequenceStreamI.pm \
	lib/FAST/Bio/FeatureHolderI.pm \
	blib/lib/FAST/Bio/FeatureHolderI.pm \
	lib/FAST/Bio/GapSeq.pm \
	blib/lib/FAST/Bio/GapSeq.pm \
	lib/FAST/Bio/GapSeqI.pm \
	blib/lib/FAST/Bio/GapSeqI.pm \
	lib/FAST/Bio/HandlerBaseI.pm \
	blib/lib/FAST/Bio/HandlerBaseI.pm \
	lib/FAST/Bio/IdentifiableI.pm \
	blib/lib/FAST/Bio/IdentifiableI.pm \
	lib/FAST/Bio/LocatableSeq.pm \
	blib/lib/FAST/Bio/LocatableSeq.pm \
	lib/FAST/Bio/Location/Atomic.pm \
	blib/lib/FAST/Bio/Location/Atomic.pm \
	lib/FAST/Bio/Location/CoordinatePolicyI.pm \
	blib/lib/FAST/Bio/Location/CoordinatePolicyI.pm \
	lib/FAST/Bio/Location/Fuzzy.pm \
	blib/lib/FAST/Bio/Location/Fuzzy.pm \
	lib/FAST/Bio/Location/FuzzyLocationI.pm \
	blib/lib/FAST/Bio/Location/FuzzyLocationI.pm \
	lib/FAST/Bio/Location/NarrowestCoordPolicy.pm \
	blib/lib/FAST/Bio/Location/NarrowestCoordPolicy.pm \
	lib/FAST/Bio/Location/Simple.pm \
	blib/lib/FAST/Bio/Location/Simple.pm \
	lib/FAST/Bio/Location/Split.pm \
	blib/lib/FAST/Bio/Location/Split.pm \
	lib/FAST/Bio/Location/SplitLocationI.pm \
	blib/lib/FAST/Bio/Location/SplitLocationI.pm \
	lib/FAST/Bio/Location/WidestCoordPolicy.pm \
	blib/lib/FAST/Bio/Location/WidestCoordPolicy.pm \
	lib/FAST/Bio/LocationI.pm \
	blib/lib/FAST/Bio/LocationI.pm \
	lib/FAST/Bio/MyPrimarySeqI.pm \
	blib/lib/FAST/Bio/MyPrimarySeqI.pm \
	lib/FAST/Bio/MySeqI.pm \
	blib/lib/FAST/Bio/MySeqI.pm \
	lib/FAST/Bio/MySeqUtils.pm \
	blib/lib/FAST/Bio/MySeqUtils.pm \
	lib/FAST/Bio/Nexml/Factory.pm \
	blib/lib/FAST/Bio/Nexml/Factory.pm \
	lib/FAST/Bio/Ontology/DocumentRegistry.pm \
	blib/lib/FAST/Bio/Ontology/DocumentRegistry.pm \
	lib/FAST/Bio/Ontology/OBOEngine.pm \
	blib/lib/FAST/Bio/Ontology/OBOEngine.pm \
	lib/FAST/Bio/Ontology/Ontology.pm \
	blib/lib/FAST/Bio/Ontology/Ontology.pm \
	lib/FAST/Bio/Ontology/OntologyEngineI.pm \
	blib/lib/FAST/Bio/Ontology/OntologyEngineI.pm \
	lib/FAST/Bio/Ontology/OntologyI.pm \
	blib/lib/FAST/Bio/Ontology/OntologyI.pm \
	lib/FAST/Bio/Ontology/OntologyStore.pm \
	blib/lib/FAST/Bio/Ontology/OntologyStore.pm \
	lib/FAST/Bio/Ontology/Relationship.pm \
	blib/lib/FAST/Bio/Ontology/Relationship.pm \
	lib/FAST/Bio/Ontology/RelationshipFactory.pm \
	blib/lib/FAST/Bio/Ontology/RelationshipFactory.pm \
	lib/FAST/Bio/Ontology/RelationshipI.pm \
	blib/lib/FAST/Bio/Ontology/RelationshipI.pm \
	lib/FAST/Bio/Ontology/RelationshipType.pm \
	blib/lib/FAST/Bio/Ontology/RelationshipType.pm \
	lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor.pm \
	blib/lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor.pm \
	lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor02.pm \
	blib/lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor02.pm \
	lib/FAST/Bio/Ontology/SimpleOntologyEngine.pm \
	blib/lib/FAST/Bio/Ontology/SimpleOntologyEngine.pm \
	lib/FAST/Bio/Ontology/Term.pm \
	blib/lib/FAST/Bio/Ontology/Term.pm \
	lib/FAST/Bio/Ontology/TermFactory.pm \
	blib/lib/FAST/Bio/Ontology/TermFactory.pm \
	lib/FAST/Bio/Ontology/TermI.pm \
	blib/lib/FAST/Bio/Ontology/TermI.pm \
	lib/FAST/Bio/OntologyIO.pm \
	blib/lib/FAST/Bio/OntologyIO.pm \
	lib/FAST/Bio/OntologyIO/Handlers/BaseSAXHandler.pm \
	blib/lib/FAST/Bio/OntologyIO/Handlers/BaseSAXHandler.pm \
	lib/FAST/Bio/OntologyIO/Handlers/InterProHandler.pm \
	blib/lib/FAST/Bio/OntologyIO/Handlers/InterProHandler.pm \
	lib/FAST/Bio/OntologyIO/Handlers/InterPro_BioSQL_Handler.pm \
	blib/lib/FAST/Bio/OntologyIO/Handlers/InterPro_BioSQL_Handler.pm \
	lib/FAST/Bio/OntologyIO/InterProParser.pm \
	blib/lib/FAST/Bio/OntologyIO/InterProParser.pm \
	lib/FAST/Bio/OntologyIO/dagflat.pm \
	blib/lib/FAST/Bio/OntologyIO/dagflat.pm \
	lib/FAST/Bio/OntologyIO/goflat.pm \
	blib/lib/FAST/Bio/OntologyIO/goflat.pm \
	lib/FAST/Bio/OntologyIO/obo.pm \
	blib/lib/FAST/Bio/OntologyIO/obo.pm \
	lib/FAST/Bio/OntologyIO/simplehierarchy.pm \
	blib/lib/FAST/Bio/OntologyIO/simplehierarchy.pm \
	lib/FAST/Bio/OntologyIO/soflat.pm \
	blib/lib/FAST/Bio/OntologyIO/soflat.pm \
	lib/FAST/Bio/PrimarySeq.pm \
	blib/lib/FAST/Bio/PrimarySeq.pm \
	lib/FAST/Bio/PrimarySeqI.pm \
	blib/lib/FAST/Bio/PrimarySeqI.pm \
	lib/FAST/Bio/PullParserI.pm \
	blib/lib/FAST/Bio/PullParserI.pm \
	lib/FAST/Bio/Range.pm \
	blib/lib/FAST/Bio/Range.pm \
	lib/FAST/Bio/RangeI.pm \
	blib/lib/FAST/Bio/RangeI.pm \
	lib/FAST/Bio/Root/Exception.pm \
	blib/lib/FAST/Bio/Root/Exception.pm \
	lib/FAST/Bio/Root/HTTPget.pm \
	blib/lib/FAST/Bio/Root/HTTPget.pm \
	lib/FAST/Bio/Root/IO.pm \
	blib/lib/FAST/Bio/Root/IO.pm \
	lib/FAST/Bio/Root/Root.pm \
	blib/lib/FAST/Bio/Root/Root.pm \
	lib/FAST/Bio/Root/RootI.pm \
	blib/lib/FAST/Bio/Root/RootI.pm \
	lib/FAST/Bio/Root/Version.pm \
	blib/lib/FAST/Bio/Root/Version.pm \
	lib/FAST/Bio/Search/BlastUtils.pm \
	blib/lib/FAST/Bio/Search/BlastUtils.pm \
	lib/FAST/Bio/Search/GenericStatistics.pm \
	blib/lib/FAST/Bio/Search/GenericStatistics.pm \
	lib/FAST/Bio/Search/HSP/BlastPullHSP.pm \
	blib/lib/FAST/Bio/Search/HSP/BlastPullHSP.pm \
	lib/FAST/Bio/Search/HSP/GenericHSP.pm \
	blib/lib/FAST/Bio/Search/HSP/GenericHSP.pm \
	lib/FAST/Bio/Search/HSP/HSPFactory.pm \
	blib/lib/FAST/Bio/Search/HSP/HSPFactory.pm \
	lib/FAST/Bio/Search/HSP/HSPI.pm \
	blib/lib/FAST/Bio/Search/HSP/HSPI.pm \
	lib/FAST/Bio/Search/HSP/HmmpfamHSP.pm \
	blib/lib/FAST/Bio/Search/HSP/HmmpfamHSP.pm \
	lib/FAST/Bio/Search/HSP/PullHSPI.pm \
	blib/lib/FAST/Bio/Search/HSP/PullHSPI.pm \
	lib/FAST/Bio/Search/Hit/BlastPullHit.pm \
	blib/lib/FAST/Bio/Search/Hit/BlastPullHit.pm \
	lib/FAST/Bio/Search/Hit/GenericHit.pm \
	blib/lib/FAST/Bio/Search/Hit/GenericHit.pm \
	lib/FAST/Bio/Search/Hit/HitFactory.pm \
	blib/lib/FAST/Bio/Search/Hit/HitFactory.pm \
	lib/FAST/Bio/Search/Hit/HitI.pm \
	blib/lib/FAST/Bio/Search/Hit/HitI.pm \
	lib/FAST/Bio/Search/Hit/HmmpfamHit.pm \
	blib/lib/FAST/Bio/Search/Hit/HmmpfamHit.pm \
	lib/FAST/Bio/Search/Hit/PullHitI.pm \
	blib/lib/FAST/Bio/Search/Hit/PullHitI.pm \
	lib/FAST/Bio/Search/Result/BlastPullResult.pm \
	blib/lib/FAST/Bio/Search/Result/BlastPullResult.pm \
	lib/FAST/Bio/Search/Result/CrossMatchResult.pm \
	blib/lib/FAST/Bio/Search/Result/CrossMatchResult.pm \
	lib/FAST/Bio/Search/Result/GenericResult.pm \
	blib/lib/FAST/Bio/Search/Result/GenericResult.pm \
	lib/FAST/Bio/Search/Result/HmmpfamResult.pm \
	blib/lib/FAST/Bio/Search/Result/HmmpfamResult.pm \
	lib/FAST/Bio/Search/Result/PullResultI.pm \
	blib/lib/FAST/Bio/Search/Result/PullResultI.pm \
	lib/FAST/Bio/Search/Result/ResultFactory.pm \
	blib/lib/FAST/Bio/Search/Result/ResultFactory.pm \
	lib/FAST/Bio/Search/Result/ResultI.pm \
	blib/lib/FAST/Bio/Search/Result/ResultI.pm \
	lib/FAST/Bio/Search/SearchUtils.pm \
	blib/lib/FAST/Bio/Search/SearchUtils.pm \
	lib/FAST/Bio/Search/StatisticsI.pm \
	blib/lib/FAST/Bio/Search/StatisticsI.pm \
	lib/FAST/Bio/SearchIO.pm \
	blib/lib/FAST/Bio/SearchIO.pm \
	lib/FAST/Bio/SearchIO/EventHandlerI.pm \
	blib/lib/FAST/Bio/SearchIO/EventHandlerI.pm \
	lib/FAST/Bio/SearchIO/FastHitEventBuilder.pm \
	blib/lib/FAST/Bio/SearchIO/FastHitEventBuilder.pm \
	lib/FAST/Bio/SearchIO/IteratedSearchResultEventBuilder.pm \
	blib/lib/FAST/Bio/SearchIO/IteratedSearchResultEventBuilder.pm \
	lib/FAST/Bio/SearchIO/SearchResultEventBuilder.pm \
	blib/lib/FAST/Bio/SearchIO/SearchResultEventBuilder.pm \
	lib/FAST/Bio/SearchIO/SearchWriterI.pm \
	blib/lib/FAST/Bio/SearchIO/SearchWriterI.pm \
	lib/FAST/Bio/SearchIO/Writer/BSMLResultWriter.pm \
	blib/lib/FAST/Bio/SearchIO/Writer/BSMLResultWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/GbrowseGFF.pm \
	blib/lib/FAST/Bio/SearchIO/Writer/GbrowseGFF.pm \
	lib/FAST/Bio/SearchIO/Writer/HSPTableWriter.pm \
	blib/lib/FAST/Bio/SearchIO/Writer/HSPTableWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/HTMLResultWriter.pm \
	blib/lib/FAST/Bio/SearchIO/Writer/HTMLResultWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/HitTableWriter.pm \
	blib/lib/FAST/Bio/SearchIO/Writer/HitTableWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/ResultTableWriter.pm \
	blib/lib/FAST/Bio/SearchIO/Writer/ResultTableWriter.pm \
	lib/FAST/Bio/SearchIO/Writer/TextResultWriter.pm \
	blib/lib/FAST/Bio/SearchIO/Writer/TextResultWriter.pm \
	lib/FAST/Bio/SearchIO/XML/BlastHandler.pm \
	blib/lib/FAST/Bio/SearchIO/XML/BlastHandler.pm \
	lib/FAST/Bio/SearchIO/XML/PsiBlastHandler.pm \
	blib/lib/FAST/Bio/SearchIO/XML/PsiBlastHandler.pm \
	lib/FAST/Bio/SearchIO/axt.pm \
	blib/lib/FAST/Bio/SearchIO/axt.pm \
	lib/FAST/Bio/SearchIO/blast.pm \
	blib/lib/FAST/Bio/SearchIO/blast.pm \
	lib/FAST/Bio/SearchIO/blast_pull.pm \
	blib/lib/FAST/Bio/SearchIO/blast_pull.pm \
	lib/FAST/Bio/SearchIO/blasttable.pm \
	blib/lib/FAST/Bio/SearchIO/blasttable.pm \
	lib/FAST/Bio/SearchIO/blastxml.pm \
	blib/lib/FAST/Bio/SearchIO/blastxml.pm \
	lib/FAST/Bio/SearchIO/cross_match.pm \
	blib/lib/FAST/Bio/SearchIO/cross_match.pm \
	lib/FAST/Bio/SearchIO/erpin.pm \
	blib/lib/FAST/Bio/SearchIO/erpin.pm \
	lib/FAST/Bio/SearchIO/exonerate.pm \
	blib/lib/FAST/Bio/SearchIO/exonerate.pm \
	lib/FAST/Bio/SearchIO/fasta.pm \
	blib/lib/FAST/Bio/SearchIO/fasta.pm \
	lib/FAST/Bio/SearchIO/gmap_f9.pm \
	blib/lib/FAST/Bio/SearchIO/gmap_f9.pm \
	lib/FAST/Bio/SearchIO/hmmer.pm \
	blib/lib/FAST/Bio/SearchIO/hmmer.pm \
	lib/FAST/Bio/SearchIO/hmmer2.pm \
	blib/lib/FAST/Bio/SearchIO/hmmer2.pm \
	lib/FAST/Bio/SearchIO/hmmer3.pm \
	blib/lib/FAST/Bio/SearchIO/hmmer3.pm \
	lib/FAST/Bio/SearchIO/hmmer_pull.pm \
	blib/lib/FAST/Bio/SearchIO/hmmer_pull.pm \
	lib/FAST/Bio/SearchIO/infernal.pm \
	blib/lib/FAST/Bio/SearchIO/infernal.pm \
	lib/FAST/Bio/SearchIO/megablast.pm \
	blib/lib/FAST/Bio/SearchIO/megablast.pm \
	lib/FAST/Bio/SearchIO/psl.pm \
	blib/lib/FAST/Bio/SearchIO/psl.pm \
	lib/FAST/Bio/SearchIO/rnamotif.pm \
	blib/lib/FAST/Bio/SearchIO/rnamotif.pm \
	lib/FAST/Bio/SearchIO/sim4.pm \
	blib/lib/FAST/Bio/SearchIO/sim4.pm \
	lib/FAST/Bio/SearchIO/waba.pm \
	blib/lib/FAST/Bio/SearchIO/waba.pm \
	lib/FAST/Bio/SearchIO/wise.pm \
	blib/lib/FAST/Bio/SearchIO/wise.pm \
	lib/FAST/Bio/Seq.pm \
	blib/lib/FAST/Bio/Seq.pm \
	lib/FAST/Bio/Seq/LargeLocatableSeq.pm \
	blib/lib/FAST/Bio/Seq/LargeLocatableSeq.pm \
	lib/FAST/Bio/Seq/LargePrimarySeq.pm \
	blib/lib/FAST/Bio/Seq/LargePrimarySeq.pm \
	lib/FAST/Bio/Seq/LargeSeqI.pm \
	blib/lib/FAST/Bio/Seq/LargeSeqI.pm \
	lib/FAST/Bio/Seq/Meta.pm \
	blib/lib/FAST/Bio/Seq/Meta.pm \
	lib/FAST/Bio/Seq/Meta/Array.pm \
	blib/lib/FAST/Bio/Seq/Meta/Array.pm \
	lib/FAST/Bio/Seq/MetaI.pm \
	blib/lib/FAST/Bio/Seq/MetaI.pm \
	lib/FAST/Bio/Seq/PrimaryQual.pm \
	blib/lib/FAST/Bio/Seq/PrimaryQual.pm \
	lib/FAST/Bio/Seq/QualI.pm \
	blib/lib/FAST/Bio/Seq/QualI.pm \
	lib/FAST/Bio/Seq/Quality.pm \
	blib/lib/FAST/Bio/Seq/Quality.pm \
	lib/FAST/Bio/Seq/RichSeq.pm \
	blib/lib/FAST/Bio/Seq/RichSeq.pm \
	lib/FAST/Bio/Seq/RichSeqI.pm \
	blib/lib/FAST/Bio/Seq/RichSeqI.pm \
	lib/FAST/Bio/Seq/SeqBuilder.pm \
	blib/lib/FAST/Bio/Seq/SeqBuilder.pm \
	lib/FAST/Bio/Seq/SeqFactory.pm \
	blib/lib/FAST/Bio/Seq/SeqFactory.pm \
	lib/FAST/Bio/Seq/SeqFastaSpeedFactory.pm \
	blib/lib/FAST/Bio/Seq/SeqFastaSpeedFactory.pm \
	lib/FAST/Bio/Seq/SequenceTrace.pm \
	blib/lib/FAST/Bio/Seq/SequenceTrace.pm \
	lib/FAST/Bio/Seq/TraceI.pm \
	blib/lib/FAST/Bio/Seq/TraceI.pm \
	lib/FAST/Bio/SeqAnalysisParserI.pm \
	blib/lib/FAST/Bio/SeqAnalysisParserI.pm \
	lib/FAST/Bio/SeqFeature/FeaturePair.pm \
	blib/lib/FAST/Bio/SeqFeature/FeaturePair.pm \
	lib/FAST/Bio/SeqFeature/Gene/Exon.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/Exon.pm \
	lib/FAST/Bio/SeqFeature/Gene/ExonI.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/ExonI.pm \
	lib/FAST/Bio/SeqFeature/Gene/GeneStructure.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/GeneStructure.pm \
	lib/FAST/Bio/SeqFeature/Gene/GeneStructureI.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/GeneStructureI.pm \
	lib/FAST/Bio/SeqFeature/Gene/Intron.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/Intron.pm \
	lib/FAST/Bio/SeqFeature/Gene/NC_Feature.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/NC_Feature.pm \
	lib/FAST/Bio/SeqFeature/Gene/Poly_A_site.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/Poly_A_site.pm \
	lib/FAST/Bio/SeqFeature/Gene/Promoter.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/Promoter.pm \
	lib/FAST/Bio/SeqFeature/Gene/Transcript.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/Transcript.pm \
	lib/FAST/Bio/SeqFeature/Gene/TranscriptI.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/TranscriptI.pm \
	lib/FAST/Bio/SeqFeature/Gene/UTR.pm \
	blib/lib/FAST/Bio/SeqFeature/Gene/UTR.pm \
	lib/FAST/Bio/SeqFeature/Generic.pm \
	blib/lib/FAST/Bio/SeqFeature/Generic.pm \
	lib/FAST/Bio/SeqFeature/Similarity.pm \
	blib/lib/FAST/Bio/SeqFeature/Similarity.pm \
	lib/FAST/Bio/SeqFeature/SimilarityPair.pm \
	blib/lib/FAST/Bio/SeqFeature/SimilarityPair.pm \
	lib/FAST/Bio/SeqFeature/Tools/FeatureNamer.pm \
	blib/lib/FAST/Bio/SeqFeature/Tools/FeatureNamer.pm \
	lib/FAST/Bio/SeqFeature/Tools/IDHandler.pm \
	blib/lib/FAST/Bio/SeqFeature/Tools/IDHandler.pm \
	lib/FAST/Bio/SeqFeature/Tools/TypeMapper.pm \
	blib/lib/FAST/Bio/SeqFeature/Tools/TypeMapper.pm \
	lib/FAST/Bio/SeqFeature/Tools/Unflattener.pm \
	blib/lib/FAST/Bio/SeqFeature/Tools/Unflattener.pm \
	lib/FAST/Bio/SeqFeatureI.pm \
	blib/lib/FAST/Bio/SeqFeatureI.pm \
	lib/FAST/Bio/SeqI.pm \
	blib/lib/FAST/Bio/SeqI.pm \
	lib/FAST/Bio/SeqIO.pm \
	blib/lib/FAST/Bio/SeqIO.pm \
	lib/FAST/Bio/SeqIO/FTHelper.pm \
	blib/lib/FAST/Bio/SeqIO/FTHelper.pm \
	lib/FAST/Bio/SeqIO/Handler/GenericRichSeqHandler.pm \
	blib/lib/FAST/Bio/SeqIO/Handler/GenericRichSeqHandler.pm \
	lib/FAST/Bio/SeqIO/MultiFile.pm \
	blib/lib/FAST/Bio/SeqIO/MultiFile.pm \
	lib/FAST/Bio/SeqIO/abi.pm \
	blib/lib/FAST/Bio/SeqIO/abi.pm \
	lib/FAST/Bio/SeqIO/ace.pm \
	blib/lib/FAST/Bio/SeqIO/ace.pm \
	lib/FAST/Bio/SeqIO/agave.pm \
	blib/lib/FAST/Bio/SeqIO/agave.pm \
	lib/FAST/Bio/SeqIO/alf.pm \
	blib/lib/FAST/Bio/SeqIO/alf.pm \
	lib/FAST/Bio/SeqIO/asciitree.pm \
	blib/lib/FAST/Bio/SeqIO/asciitree.pm \
	lib/FAST/Bio/SeqIO/bsml.pm \
	blib/lib/FAST/Bio/SeqIO/bsml.pm \
	lib/FAST/Bio/SeqIO/bsml_sax.pm \
	blib/lib/FAST/Bio/SeqIO/bsml_sax.pm \
	lib/FAST/Bio/SeqIO/chadoxml.pm \
	blib/lib/FAST/Bio/SeqIO/chadoxml.pm \
	lib/FAST/Bio/SeqIO/chaos.pm \
	blib/lib/FAST/Bio/SeqIO/chaos.pm \
	lib/FAST/Bio/SeqIO/chaosxml.pm \
	blib/lib/FAST/Bio/SeqIO/chaosxml.pm \
	lib/FAST/Bio/SeqIO/ctf.pm \
	blib/lib/FAST/Bio/SeqIO/ctf.pm \
	lib/FAST/Bio/SeqIO/embl.pm \
	blib/lib/FAST/Bio/SeqIO/embl.pm \
	lib/FAST/Bio/SeqIO/embldriver.pm \
	blib/lib/FAST/Bio/SeqIO/embldriver.pm \
	lib/FAST/Bio/SeqIO/entrezgene.pm \
	blib/lib/FAST/Bio/SeqIO/entrezgene.pm \
	lib/FAST/Bio/SeqIO/excel.pm \
	blib/lib/FAST/Bio/SeqIO/excel.pm \
	lib/FAST/Bio/SeqIO/exp.pm \
	blib/lib/FAST/Bio/SeqIO/exp.pm \
	lib/FAST/Bio/SeqIO/fasta.pm \
	blib/lib/FAST/Bio/SeqIO/fasta.pm \
	lib/FAST/Bio/SeqIO/fastq.pm \
	blib/lib/FAST/Bio/SeqIO/fastq.pm \
	lib/FAST/Bio/SeqIO/flybase_chadoxml.pm \
	blib/lib/FAST/Bio/SeqIO/flybase_chadoxml.pm \
	lib/FAST/Bio/SeqIO/game.pm \
	blib/lib/FAST/Bio/SeqIO/game.pm \
	lib/FAST/Bio/SeqIO/game/featHandler.pm \
	blib/lib/FAST/Bio/SeqIO/game/featHandler.pm \
	lib/FAST/Bio/SeqIO/game/gameHandler.pm \
	blib/lib/FAST/Bio/SeqIO/game/gameHandler.pm \
	lib/FAST/Bio/SeqIO/game/gameSubs.pm \
	blib/lib/FAST/Bio/SeqIO/game/gameSubs.pm \
	lib/FAST/Bio/SeqIO/game/gameWriter.pm \
	blib/lib/FAST/Bio/SeqIO/game/gameWriter.pm \
	lib/FAST/Bio/SeqIO/game/seqHandler.pm \
	blib/lib/FAST/Bio/SeqIO/game/seqHandler.pm \
	lib/FAST/Bio/SeqIO/gbdriver.pm \
	blib/lib/FAST/Bio/SeqIO/gbdriver.pm \
	lib/FAST/Bio/SeqIO/gbxml.pm \
	blib/lib/FAST/Bio/SeqIO/gbxml.pm \
	lib/FAST/Bio/SeqIO/gcg.pm \
	blib/lib/FAST/Bio/SeqIO/gcg.pm \
	lib/FAST/Bio/SeqIO/genbank.pm \
	blib/lib/FAST/Bio/SeqIO/genbank.pm \
	lib/FAST/Bio/SeqIO/interpro.pm \
	blib/lib/FAST/Bio/SeqIO/interpro.pm \
	lib/FAST/Bio/SeqIO/kegg.pm \
	blib/lib/FAST/Bio/SeqIO/kegg.pm \
	lib/FAST/Bio/SeqIO/largefasta.pm \
	blib/lib/FAST/Bio/SeqIO/largefasta.pm \
	lib/FAST/Bio/SeqIO/lasergene.pm \
	blib/lib/FAST/Bio/SeqIO/lasergene.pm \
	lib/FAST/Bio/SeqIO/locuslink.pm \
	blib/lib/FAST/Bio/SeqIO/locuslink.pm \
	lib/FAST/Bio/SeqIO/mbsout.pm \
	blib/lib/FAST/Bio/SeqIO/mbsout.pm \
	lib/FAST/Bio/SeqIO/metafasta.pm \
	blib/lib/FAST/Bio/SeqIO/metafasta.pm \
	lib/FAST/Bio/SeqIO/msout.pm \
	blib/lib/FAST/Bio/SeqIO/msout.pm \
	lib/FAST/Bio/SeqIO/nexml.pm \
	blib/lib/FAST/Bio/SeqIO/nexml.pm \
	lib/FAST/Bio/SeqIO/phd.pm \
	blib/lib/FAST/Bio/SeqIO/phd.pm \
	lib/FAST/Bio/SeqIO/pir.pm \
	blib/lib/FAST/Bio/SeqIO/pir.pm \
	lib/FAST/Bio/SeqIO/pln.pm \
	blib/lib/FAST/Bio/SeqIO/pln.pm \
	lib/FAST/Bio/SeqIO/qual.pm \
	blib/lib/FAST/Bio/SeqIO/qual.pm \
	lib/FAST/Bio/SeqIO/raw.pm \
	blib/lib/FAST/Bio/SeqIO/raw.pm \
	lib/FAST/Bio/SeqIO/scf.pm \
	blib/lib/FAST/Bio/SeqIO/scf.pm \
	lib/FAST/Bio/SeqIO/seqxml.pm \
	blib/lib/FAST/Bio/SeqIO/seqxml.pm \
	lib/FAST/Bio/SeqIO/strider.pm \
	blib/lib/FAST/Bio/SeqIO/strider.pm \
	lib/FAST/Bio/SeqIO/swiss.pm \
	blib/lib/FAST/Bio/SeqIO/swiss.pm \
	lib/FAST/Bio/SeqIO/swissdriver.pm \
	blib/lib/FAST/Bio/SeqIO/swissdriver.pm \
	lib/FAST/Bio/SeqIO/tab.pm \
	blib/lib/FAST/Bio/SeqIO/tab.pm \
	lib/FAST/Bio/SeqIO/table.pm \
	blib/lib/FAST/Bio/SeqIO/table.pm \
	lib/FAST/Bio/SeqIO/tigr.pm \
	blib/lib/FAST/Bio/SeqIO/tigr.pm \
	lib/FAST/Bio/SeqIO/tigrxml.pm \
	blib/lib/FAST/Bio/SeqIO/tigrxml.pm \
	lib/FAST/Bio/SeqIO/tinyseq.pm \
	blib/lib/FAST/Bio/SeqIO/tinyseq.pm \
	lib/FAST/Bio/SeqIO/tinyseq/tinyseqHandler.pm \
	blib/lib/FAST/Bio/SeqIO/tinyseq/tinyseqHandler.pm \
	lib/FAST/Bio/SeqIO/ztr.pm \
	blib/lib/FAST/Bio/SeqIO/ztr.pm \
	lib/FAST/Bio/SeqUtils.pm \
	blib/lib/FAST/Bio/SeqUtils.pm \
	lib/FAST/Bio/SimpleAlign.pm \
	blib/lib/FAST/Bio/SimpleAlign.pm \
	lib/FAST/Bio/Species.pm \
	blib/lib/FAST/Bio/Species.pm \
	lib/FAST/Bio/Taxon.pm \
	blib/lib/FAST/Bio/Taxon.pm \
	lib/FAST/Bio/Tools/AnalysisResult.pm \
	blib/lib/FAST/Bio/Tools/AnalysisResult.pm \
	lib/FAST/Bio/Tools/CodonTable.pm \
	blib/lib/FAST/Bio/Tools/CodonTable.pm \
	lib/FAST/Bio/Tools/GFF.pm \
	blib/lib/FAST/Bio/Tools/GFF.pm \
	lib/FAST/Bio/Tools/Genewise.pm \
	blib/lib/FAST/Bio/Tools/Genewise.pm \
	lib/FAST/Bio/Tools/Genomewise.pm \
	blib/lib/FAST/Bio/Tools/Genomewise.pm \
	lib/FAST/Bio/Tools/GuessSeqFormat.pm \
	blib/lib/FAST/Bio/Tools/GuessSeqFormat.pm \
	lib/FAST/Bio/Tools/IUPAC.pm \
	blib/lib/FAST/Bio/Tools/IUPAC.pm \
	lib/FAST/Bio/Tools/MySeqStats.pm \
	blib/lib/FAST/Bio/Tools/MySeqStats.pm \
	lib/FAST/Bio/Tools/Run/GenericParameters.pm \
	blib/lib/FAST/Bio/Tools/Run/GenericParameters.pm \
	lib/FAST/Bio/Tools/Run/ParametersI.pm \
	blib/lib/FAST/Bio/Tools/Run/ParametersI.pm \
	lib/FAST/Bio/Tools/SeqPattern.pm \
	blib/lib/FAST/Bio/Tools/SeqPattern.pm \
	lib/FAST/Bio/Tools/SeqPattern/Backtranslate.pm \
	blib/lib/FAST/Bio/Tools/SeqPattern/Backtranslate.pm \
	lib/FAST/Bio/Tools/SeqStats.pm \
	blib/lib/FAST/Bio/Tools/SeqStats.pm \
	lib/FAST/Bio/Tree/Node.pm \
	blib/lib/FAST/Bio/Tree/Node.pm \
	lib/FAST/Bio/Tree/NodeI.pm \
	blib/lib/FAST/Bio/Tree/NodeI.pm \
	lib/FAST/Bio/Tree/Tree.pm \
	blib/lib/FAST/Bio/Tree/Tree.pm \
	lib/FAST/Bio/Tree/TreeFunctionsI.pm \
	blib/lib/FAST/Bio/Tree/TreeFunctionsI.pm \
	lib/FAST/Bio/Tree/TreeI.pm \
	blib/lib/FAST/Bio/Tree/TreeI.pm \
	lib/FAST/Bio/UnivAln.pm \
	blib/lib/FAST/Bio/UnivAln.pm \
	lib/FAST/Bio/WebAgent.pm \
	blib/lib/FAST/Bio/WebAgent.pm \
	lib/Pod/Usage.pm \
	blib/lib/Pod/Usage.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 6.96
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --
CP_NONEMPTY = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'cp_nonempty' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = COPY_EXTENDED_ATTRIBUTES_DISABLE=1 COPYFILE_DISABLE=1 tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip -9f
SUFFIX = .gz
SHAR = shar
PREOP = $(NOECHO) $(NOOP)
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = FAST
DISTVNAME = FAST-0.04


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(BOOTSTRAP) $(INST_DYNAMIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	bin/alndegap \
	bin/alnseg \
	bin/fascomp \
	bin/fasconvert \
	bin/fascut \
	bin/fasgrep \
	bin/faslen \
	bin/fasrc \
	bin/fassort \
	bin/fassub \
	bin/fastr \
	bin/fasuniq \
	bin/fasxl
	$(NOECHO) $(POD2MAN) --section=1 --perm_rw=$(PERM_RW) \
	  bin/alndegap $(INST_MAN1DIR)/alndegap.$(MAN1EXT) \
	  bin/alnseg $(INST_MAN1DIR)/alnseg.$(MAN1EXT) \
	  bin/fascomp $(INST_MAN1DIR)/fascomp.$(MAN1EXT) \
	  bin/fasconvert $(INST_MAN1DIR)/fasconvert.$(MAN1EXT) \
	  bin/fascut $(INST_MAN1DIR)/fascut.$(MAN1EXT) \
	  bin/fasgrep $(INST_MAN1DIR)/fasgrep.$(MAN1EXT) \
	  bin/faslen $(INST_MAN1DIR)/faslen.$(MAN1EXT) \
	  bin/fasrc $(INST_MAN1DIR)/fasrc.$(MAN1EXT) \
	  bin/fassort $(INST_MAN1DIR)/fassort.$(MAN1EXT) \
	  bin/fassub $(INST_MAN1DIR)/fassub.$(MAN1EXT) \
	  bin/fastr $(INST_MAN1DIR)/fastr.$(MAN1EXT) \
	  bin/fasuniq $(INST_MAN1DIR)/fasuniq.$(MAN1EXT) \
	  bin/fasxl $(INST_MAN1DIR)/fasxl.$(MAN1EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = bin/alndegap bin/alnpi bin/alnseg bin/fascodon bin/fascomp bin/fasconvert bin/fascut bin/fasfilter bin/fasgrep bin/faslen bin/fasposcomp bin/fasrc bin/fassub bin/fastr bin/fasuniq bin/fasxl bin/fassort

pure_all :: $(INST_SCRIPT)/fascomp $(INST_SCRIPT)/fasrc $(INST_SCRIPT)/faslen $(INST_SCRIPT)/fasgrep $(INST_SCRIPT)/fastr $(INST_SCRIPT)/fassub $(INST_SCRIPT)/fassort $(INST_SCRIPT)/alnpi $(INST_SCRIPT)/alnseg $(INST_SCRIPT)/fasconvert $(INST_SCRIPT)/fasposcomp $(INST_SCRIPT)/fasuniq $(INST_SCRIPT)/fascut $(INST_SCRIPT)/fasxl $(INST_SCRIPT)/fascodon $(INST_SCRIPT)/fasfilter $(INST_SCRIPT)/alndegap
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/fascomp $(INST_SCRIPT)/fasrc \
	  $(INST_SCRIPT)/faslen $(INST_SCRIPT)/fasgrep \
	  $(INST_SCRIPT)/fastr $(INST_SCRIPT)/fassub \
	  $(INST_SCRIPT)/fassort $(INST_SCRIPT)/alnpi \
	  $(INST_SCRIPT)/alnseg $(INST_SCRIPT)/fasconvert \
	  $(INST_SCRIPT)/fasposcomp $(INST_SCRIPT)/fasuniq \
	  $(INST_SCRIPT)/fascut $(INST_SCRIPT)/fasxl \
	  $(INST_SCRIPT)/fascodon $(INST_SCRIPT)/fasfilter \
	  $(INST_SCRIPT)/alndegap 

$(INST_SCRIPT)/fascomp : bin/fascomp $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fascomp
	$(CP) bin/fascomp $(INST_SCRIPT)/fascomp
	$(FIXIN) $(INST_SCRIPT)/fascomp
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fascomp

$(INST_SCRIPT)/fasrc : bin/fasrc $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fasrc
	$(CP) bin/fasrc $(INST_SCRIPT)/fasrc
	$(FIXIN) $(INST_SCRIPT)/fasrc
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fasrc

$(INST_SCRIPT)/faslen : bin/faslen $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/faslen
	$(CP) bin/faslen $(INST_SCRIPT)/faslen
	$(FIXIN) $(INST_SCRIPT)/faslen
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/faslen

$(INST_SCRIPT)/fasgrep : bin/fasgrep $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fasgrep
	$(CP) bin/fasgrep $(INST_SCRIPT)/fasgrep
	$(FIXIN) $(INST_SCRIPT)/fasgrep
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fasgrep

$(INST_SCRIPT)/fastr : bin/fastr $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fastr
	$(CP) bin/fastr $(INST_SCRIPT)/fastr
	$(FIXIN) $(INST_SCRIPT)/fastr
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fastr

$(INST_SCRIPT)/fassub : bin/fassub $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fassub
	$(CP) bin/fassub $(INST_SCRIPT)/fassub
	$(FIXIN) $(INST_SCRIPT)/fassub
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fassub

$(INST_SCRIPT)/fassort : bin/fassort $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fassort
	$(CP) bin/fassort $(INST_SCRIPT)/fassort
	$(FIXIN) $(INST_SCRIPT)/fassort
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fassort

$(INST_SCRIPT)/alnpi : bin/alnpi $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/alnpi
	$(CP) bin/alnpi $(INST_SCRIPT)/alnpi
	$(FIXIN) $(INST_SCRIPT)/alnpi
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/alnpi

$(INST_SCRIPT)/alnseg : bin/alnseg $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/alnseg
	$(CP) bin/alnseg $(INST_SCRIPT)/alnseg
	$(FIXIN) $(INST_SCRIPT)/alnseg
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/alnseg

$(INST_SCRIPT)/fasconvert : bin/fasconvert $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fasconvert
	$(CP) bin/fasconvert $(INST_SCRIPT)/fasconvert
	$(FIXIN) $(INST_SCRIPT)/fasconvert
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fasconvert

$(INST_SCRIPT)/fasposcomp : bin/fasposcomp $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fasposcomp
	$(CP) bin/fasposcomp $(INST_SCRIPT)/fasposcomp
	$(FIXIN) $(INST_SCRIPT)/fasposcomp
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fasposcomp

$(INST_SCRIPT)/fasuniq : bin/fasuniq $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fasuniq
	$(CP) bin/fasuniq $(INST_SCRIPT)/fasuniq
	$(FIXIN) $(INST_SCRIPT)/fasuniq
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fasuniq

$(INST_SCRIPT)/fascut : bin/fascut $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fascut
	$(CP) bin/fascut $(INST_SCRIPT)/fascut
	$(FIXIN) $(INST_SCRIPT)/fascut
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fascut

$(INST_SCRIPT)/fasxl : bin/fasxl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fasxl
	$(CP) bin/fasxl $(INST_SCRIPT)/fasxl
	$(FIXIN) $(INST_SCRIPT)/fasxl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fasxl

$(INST_SCRIPT)/fascodon : bin/fascodon $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fascodon
	$(CP) bin/fascodon $(INST_SCRIPT)/fascodon
	$(FIXIN) $(INST_SCRIPT)/fascodon
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fascodon

$(INST_SCRIPT)/fasfilter : bin/fasfilter $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fasfilter
	$(CP) bin/fasfilter $(INST_SCRIPT)/fasfilter
	$(FIXIN) $(INST_SCRIPT)/fasfilter
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fasfilter

$(INST_SCRIPT)/alndegap : bin/alndegap $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/alndegap
	$(CP) bin/alndegap $(INST_SCRIPT)/alndegap
	$(FIXIN) $(INST_SCRIPT)/alndegap
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/alndegap



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).bso $(BASEEXT).def \
	  $(BASEEXT).exp $(BASEEXT).x \
	  $(BOOTSTRAP) $(INST_ARCHAUTODIR)/extralibs.all \
	  $(INST_ARCHAUTODIR)/extralibs.ld $(MAKE_APERL_FILE) \
	  *$(LIB_EXT) *$(OBJ_EXT) \
	  *perl.core MYMETA.json \
	  MYMETA.yml blibdirs.ts \
	  core core.*perl.*.? \
	  core.[0-9] core.[0-9][0-9] \
	  core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
	  core.[0-9][0-9][0-9][0-9][0-9] lib$(BASEEXT).def \
	  mon.out perl \
	  perl$(EXE_EXT) perl.exe \
	  perlmain.c pm_to_blib \
	  pm_to_blib.ts so_locations \
	  tmon.out 
	- $(RM_RF) \
	  FAST-* blib 
	  $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(FIRST_MAKEFILE) $(MAKEFILE_OLD) 
	- $(RM_RF) \
	  $(DISTVNAME) 


# --- MakeMaker metafile section:
metafile : create_distdir
	$(NOECHO) $(ECHO) Generating META.yml
	$(NOECHO) $(ECHO) '---' > META_new.yml
	$(NOECHO) $(ECHO) 'abstract: '\''FAST Analysis of Sequences Toolbox'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'author:' >> META_new.yml
	$(NOECHO) $(ECHO) '  - '\''David H. Ardell <dhard@cpan.org>'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'build_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  Test::More: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'configure_requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  ExtUtils::MakeMaker: '\''0'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'dynamic_config: 1' >> META_new.yml
	$(NOECHO) $(ECHO) 'generated_by: '\''ExtUtils::MakeMaker version 6.96, CPAN::Meta::Converter version 2.140640'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'license: perl' >> META_new.yml
	$(NOECHO) $(ECHO) 'meta-spec:' >> META_new.yml
	$(NOECHO) $(ECHO) '  url: http://module-build.sourceforge.net/META-spec-v1.4.html' >> META_new.yml
	$(NOECHO) $(ECHO) '  version: '\''1.4'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'name: FAST' >> META_new.yml
	$(NOECHO) $(ECHO) 'no_index:' >> META_new.yml
	$(NOECHO) $(ECHO) '  directory:' >> META_new.yml
	$(NOECHO) $(ECHO) '    - t' >> META_new.yml
	$(NOECHO) $(ECHO) '    - inc' >> META_new.yml
	$(NOECHO) $(ECHO) 'requires:' >> META_new.yml
	$(NOECHO) $(ECHO) '  GetOpt::Long: '\''2.32'\''' >> META_new.yml
	$(NOECHO) $(ECHO) '  perl: '\''5.006'\''' >> META_new.yml
	$(NOECHO) $(ECHO) 'version: '\''0.04'\''' >> META_new.yml
	-$(NOECHO) $(MV) META_new.yml $(DISTVNAME)/META.yml
	$(NOECHO) $(ECHO) Generating META.json
	$(NOECHO) $(ECHO) '{' > META_new.json
	$(NOECHO) $(ECHO) '   "abstract" : "FAST Analysis of Sequences Toolbox",' >> META_new.json
	$(NOECHO) $(ECHO) '   "author" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "David H. Ardell <dhard@cpan.org>"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "dynamic_config" : 1,' >> META_new.json
	$(NOECHO) $(ECHO) '   "generated_by" : "ExtUtils::MakeMaker version 6.96, CPAN::Meta::Converter version 2.140640",' >> META_new.json
	$(NOECHO) $(ECHO) '   "license" : [' >> META_new.json
	$(NOECHO) $(ECHO) '      "perl_5"' >> META_new.json
	$(NOECHO) $(ECHO) '   ],' >> META_new.json
	$(NOECHO) $(ECHO) '   "meta-spec" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "url" : "http://search.cpan.org/perldoc?CPAN::Meta::Spec",' >> META_new.json
	$(NOECHO) $(ECHO) '      "version" : "2"' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "name" : "FAST",' >> META_new.json
	$(NOECHO) $(ECHO) '   "no_index" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "directory" : [' >> META_new.json
	$(NOECHO) $(ECHO) '         "t",' >> META_new.json
	$(NOECHO) $(ECHO) '         "inc"' >> META_new.json
	$(NOECHO) $(ECHO) '      ]' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "prereqs" : {' >> META_new.json
	$(NOECHO) $(ECHO) '      "build" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "Test::More" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "configure" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "ExtUtils::MakeMaker" : "0"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      },' >> META_new.json
	$(NOECHO) $(ECHO) '      "runtime" : {' >> META_new.json
	$(NOECHO) $(ECHO) '         "requires" : {' >> META_new.json
	$(NOECHO) $(ECHO) '            "GetOpt::Long" : "2.32",' >> META_new.json
	$(NOECHO) $(ECHO) '            "perl" : "5.006"' >> META_new.json
	$(NOECHO) $(ECHO) '         }' >> META_new.json
	$(NOECHO) $(ECHO) '      }' >> META_new.json
	$(NOECHO) $(ECHO) '   },' >> META_new.json
	$(NOECHO) $(ECHO) '   "release_status" : "stable",' >> META_new.json
	$(NOECHO) $(ECHO) '   "version" : "0.04"' >> META_new.json
	$(NOECHO) $(ECHO) '}' >> META_new.json
	-$(NOECHO) $(MV) META_new.json $(DISTVNAME)/META.json


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir distmeta 
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.yml to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.json to MANIFEST: $$$${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLPRIVLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLARCHLIB) \
		$(INST_BIN) $(DESTINSTALLBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(SITEARCHEXP)/auto/$(FULLEXT)


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLSITELIB) \
		$(INST_ARCHLIB) $(DESTINSTALLSITEARCH) \
		$(INST_BIN) $(DESTINSTALLSITEBIN) \
		$(INST_SCRIPT) $(DESTINSTALLSITESCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLSITEMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLSITEMAN3DIR)
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		$(PERL_ARCHLIB)/auto/$(FULLEXT)

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist \
		write $(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist \
		$(INST_LIB) $(DESTINSTALLVENDORLIB) \
		$(INST_ARCHLIB) $(DESTINSTALLVENDORARCH) \
		$(INST_BIN) $(DESTINSTALLVENDORBIN) \
		$(INST_SCRIPT) $(DESTINSTALLVENDORSCRIPT) \
		$(INST_MAN1DIR) $(DESTINSTALLVENDORMAN1DIR) \
		$(INST_MAN3DIR) $(DESTINSTALLVENDORMAN3DIR)


doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLPRIVLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLSITELIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to $(DESTINSTALLARCHLIB)/perllocal.pod
	-$(NOECHO) $(MKPATH) $(DESTINSTALLARCHLIB)
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" "$(INSTALLVENDORLIB)" \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> $(DESTINSTALLARCHLIB)/perllocal.pod


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) $(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) $(SITEARCHEXP)/auto/$(FULLEXT)/.packlist

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) $(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = /Users/travislawrence/perl5/perlbrew/perls/perl-5.18.2/bin/perl

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR= \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/*.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="$(VERSION)">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>FAST Analysis of Sequences Toolbox</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>David H. Ardell &lt;dhard@cpan.org&gt;</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <PERLCORE VERSION="5,006,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE VERSION="2.32" NAME="GetOpt::Long" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="darwin-2level-5.18" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/.DS_Store blib/lib/.DS_Store \
	  lib/FAST.pm blib/lib/FAST.pm \
	  lib/FAST/.DS_Store blib/lib/FAST/.DS_Store \
	  lib/FAST/Bio/Align/AlignI.pm blib/lib/FAST/Bio/Align/AlignI.pm \
	  lib/FAST/Bio/AlignIO.pm blib/lib/FAST/Bio/AlignIO.pm \
	  lib/FAST/Bio/AlignIO/Handler/GenericAlignHandler.pm blib/lib/FAST/Bio/AlignIO/Handler/GenericAlignHandler.pm \
	  lib/FAST/Bio/AlignIO/arp.pm blib/lib/FAST/Bio/AlignIO/arp.pm \
	  lib/FAST/Bio/AlignIO/bl2seq.pm blib/lib/FAST/Bio/AlignIO/bl2seq.pm \
	  lib/FAST/Bio/AlignIO/clustalw.pm blib/lib/FAST/Bio/AlignIO/clustalw.pm \
	  lib/FAST/Bio/AlignIO/emboss.pm blib/lib/FAST/Bio/AlignIO/emboss.pm \
	  lib/FAST/Bio/AlignIO/fasta.pm blib/lib/FAST/Bio/AlignIO/fasta.pm \
	  lib/FAST/Bio/AlignIO/largemultifasta.pm blib/lib/FAST/Bio/AlignIO/largemultifasta.pm \
	  lib/FAST/Bio/AlignIO/maf.pm blib/lib/FAST/Bio/AlignIO/maf.pm \
	  lib/FAST/Bio/AlignIO/mase.pm blib/lib/FAST/Bio/AlignIO/mase.pm \
	  lib/FAST/Bio/AlignIO/mega.pm blib/lib/FAST/Bio/AlignIO/mega.pm \
	  lib/FAST/Bio/AlignIO/meme.pm blib/lib/FAST/Bio/AlignIO/meme.pm \
	  lib/FAST/Bio/AlignIO/metafasta.pm blib/lib/FAST/Bio/AlignIO/metafasta.pm \
	  lib/FAST/Bio/AlignIO/msf.pm blib/lib/FAST/Bio/AlignIO/msf.pm \
	  lib/FAST/Bio/AlignIO/nexml.pm blib/lib/FAST/Bio/AlignIO/nexml.pm \
	  lib/FAST/Bio/AlignIO/nexus.pm blib/lib/FAST/Bio/AlignIO/nexus.pm \
	  lib/FAST/Bio/AlignIO/pfam.pm blib/lib/FAST/Bio/AlignIO/pfam.pm \
	  lib/FAST/Bio/AlignIO/phylip.pm blib/lib/FAST/Bio/AlignIO/phylip.pm \
	  lib/FAST/Bio/AlignIO/po.pm blib/lib/FAST/Bio/AlignIO/po.pm \
	  lib/FAST/Bio/AlignIO/proda.pm blib/lib/FAST/Bio/AlignIO/proda.pm \
	  lib/FAST/Bio/AlignIO/prodom.pm blib/lib/FAST/Bio/AlignIO/prodom.pm \
	  lib/FAST/Bio/AlignIO/psi.pm blib/lib/FAST/Bio/AlignIO/psi.pm \
	  lib/FAST/Bio/AlignIO/selex.pm blib/lib/FAST/Bio/AlignIO/selex.pm \
	  lib/FAST/Bio/AlignIO/stockholm.pm blib/lib/FAST/Bio/AlignIO/stockholm.pm \
	  lib/FAST/Bio/AlignIO/xmfa.pm blib/lib/FAST/Bio/AlignIO/xmfa.pm \
	  lib/FAST/Bio/AnalysisParserI.pm blib/lib/FAST/Bio/AnalysisParserI.pm \
	  lib/FAST/Bio/AnalysisResultI.pm blib/lib/FAST/Bio/AnalysisResultI.pm \
	  lib/FAST/Bio/AnnotatableI.pm blib/lib/FAST/Bio/AnnotatableI.pm \
	  lib/FAST/Bio/Annotation/AnnotationFactory.pm blib/lib/FAST/Bio/Annotation/AnnotationFactory.pm \
	  lib/FAST/Bio/Annotation/Collection.pm blib/lib/FAST/Bio/Annotation/Collection.pm \
	  lib/FAST/Bio/Annotation/Comment.pm blib/lib/FAST/Bio/Annotation/Comment.pm \
	  lib/FAST/Bio/Annotation/DBLink.pm blib/lib/FAST/Bio/Annotation/DBLink.pm \
	  lib/FAST/Bio/Annotation/OntologyTerm.pm blib/lib/FAST/Bio/Annotation/OntologyTerm.pm \
	  lib/FAST/Bio/Annotation/Reference.pm blib/lib/FAST/Bio/Annotation/Reference.pm \
	  lib/FAST/Bio/Annotation/SimpleValue.pm blib/lib/FAST/Bio/Annotation/SimpleValue.pm \
	  lib/FAST/Bio/Annotation/TagTree.pm blib/lib/FAST/Bio/Annotation/TagTree.pm \
	  lib/FAST/Bio/Annotation/Target.pm blib/lib/FAST/Bio/Annotation/Target.pm \
	  lib/FAST/Bio/Annotation/TypeManager.pm blib/lib/FAST/Bio/Annotation/TypeManager.pm \
	  lib/FAST/Bio/AnnotationCollectionI.pm blib/lib/FAST/Bio/AnnotationCollectionI.pm \
	  lib/FAST/Bio/AnnotationI.pm blib/lib/FAST/Bio/AnnotationI.pm \
	  lib/FAST/Bio/Cluster/FamilyI.pm blib/lib/FAST/Bio/Cluster/FamilyI.pm \
	  lib/FAST/Bio/Cluster/SequenceFamily.pm blib/lib/FAST/Bio/Cluster/SequenceFamily.pm \
	  lib/FAST/Bio/ClusterI.pm blib/lib/FAST/Bio/ClusterI.pm \
	  lib/FAST/Bio/DB/InMemoryCache.pm blib/lib/FAST/Bio/DB/InMemoryCache.pm \
	  lib/FAST/Bio/DB/RandomAccessI.pm blib/lib/FAST/Bio/DB/RandomAccessI.pm \
	  lib/FAST/Bio/DB/SeqI.pm blib/lib/FAST/Bio/DB/SeqI.pm \
	  lib/FAST/Bio/DB/Taxonomy.pm blib/lib/FAST/Bio/DB/Taxonomy.pm \
	  lib/FAST/Bio/DB/Taxonomy/entrez.pm blib/lib/FAST/Bio/DB/Taxonomy/entrez.pm \
	  lib/FAST/Bio/DB/Taxonomy/flatfile.pm blib/lib/FAST/Bio/DB/Taxonomy/flatfile.pm \
	  lib/FAST/Bio/DB/Taxonomy/list.pm blib/lib/FAST/Bio/DB/Taxonomy/list.pm \
	  lib/FAST/Bio/DescribableI.pm blib/lib/FAST/Bio/DescribableI.pm \
	  lib/FAST/Bio/Event/EventGeneratorI.pm blib/lib/FAST/Bio/Event/EventGeneratorI.pm \
	  lib/FAST/Bio/Event/EventHandlerI.pm blib/lib/FAST/Bio/Event/EventHandlerI.pm \
	  lib/FAST/Bio/Factory/FTLocationFactory.pm blib/lib/FAST/Bio/Factory/FTLocationFactory.pm \
	  lib/FAST/Bio/Factory/LocationFactoryI.pm blib/lib/FAST/Bio/Factory/LocationFactoryI.pm \
	  lib/FAST/Bio/Factory/ObjectBuilderI.pm blib/lib/FAST/Bio/Factory/ObjectBuilderI.pm \
	  lib/FAST/Bio/Factory/ObjectFactory.pm blib/lib/FAST/Bio/Factory/ObjectFactory.pm \
	  lib/FAST/Bio/Factory/ObjectFactoryI.pm blib/lib/FAST/Bio/Factory/ObjectFactoryI.pm \
	  lib/FAST/Bio/Factory/SequenceFactoryI.pm blib/lib/FAST/Bio/Factory/SequenceFactoryI.pm \
	  lib/FAST/Bio/Factory/SequenceStreamI.pm blib/lib/FAST/Bio/Factory/SequenceStreamI.pm \
	  lib/FAST/Bio/FeatureHolderI.pm blib/lib/FAST/Bio/FeatureHolderI.pm \
	  lib/FAST/Bio/GapSeq.pm blib/lib/FAST/Bio/GapSeq.pm \
	  lib/FAST/Bio/GapSeqI.pm blib/lib/FAST/Bio/GapSeqI.pm \
	  lib/FAST/Bio/HandlerBaseI.pm blib/lib/FAST/Bio/HandlerBaseI.pm \
	  lib/FAST/Bio/IdentifiableI.pm blib/lib/FAST/Bio/IdentifiableI.pm \
	  lib/FAST/Bio/LocatableSeq.pm blib/lib/FAST/Bio/LocatableSeq.pm \
	  lib/FAST/Bio/Location/Atomic.pm blib/lib/FAST/Bio/Location/Atomic.pm \
	  lib/FAST/Bio/Location/CoordinatePolicyI.pm blib/lib/FAST/Bio/Location/CoordinatePolicyI.pm \
	  lib/FAST/Bio/Location/Fuzzy.pm blib/lib/FAST/Bio/Location/Fuzzy.pm \
	  lib/FAST/Bio/Location/FuzzyLocationI.pm blib/lib/FAST/Bio/Location/FuzzyLocationI.pm \
	  lib/FAST/Bio/Location/NarrowestCoordPolicy.pm blib/lib/FAST/Bio/Location/NarrowestCoordPolicy.pm \
	  lib/FAST/Bio/Location/Simple.pm blib/lib/FAST/Bio/Location/Simple.pm \
	  lib/FAST/Bio/Location/Split.pm blib/lib/FAST/Bio/Location/Split.pm \
	  lib/FAST/Bio/Location/SplitLocationI.pm blib/lib/FAST/Bio/Location/SplitLocationI.pm \
	  lib/FAST/Bio/Location/WidestCoordPolicy.pm blib/lib/FAST/Bio/Location/WidestCoordPolicy.pm \
	  lib/FAST/Bio/LocationI.pm blib/lib/FAST/Bio/LocationI.pm \
	  lib/FAST/Bio/MyPrimarySeqI.pm blib/lib/FAST/Bio/MyPrimarySeqI.pm \
	  lib/FAST/Bio/MySeqI.pm blib/lib/FAST/Bio/MySeqI.pm \
	  lib/FAST/Bio/MySeqUtils.pm blib/lib/FAST/Bio/MySeqUtils.pm \
	  lib/FAST/Bio/Nexml/Factory.pm blib/lib/FAST/Bio/Nexml/Factory.pm \
	  lib/FAST/Bio/Ontology/DocumentRegistry.pm blib/lib/FAST/Bio/Ontology/DocumentRegistry.pm \
	  lib/FAST/Bio/Ontology/OBOEngine.pm blib/lib/FAST/Bio/Ontology/OBOEngine.pm \
	  lib/FAST/Bio/Ontology/Ontology.pm blib/lib/FAST/Bio/Ontology/Ontology.pm \
	  lib/FAST/Bio/Ontology/OntologyEngineI.pm blib/lib/FAST/Bio/Ontology/OntologyEngineI.pm \
	  lib/FAST/Bio/Ontology/OntologyI.pm blib/lib/FAST/Bio/Ontology/OntologyI.pm \
	  lib/FAST/Bio/Ontology/OntologyStore.pm blib/lib/FAST/Bio/Ontology/OntologyStore.pm \
	  lib/FAST/Bio/Ontology/Relationship.pm blib/lib/FAST/Bio/Ontology/Relationship.pm \
	  lib/FAST/Bio/Ontology/RelationshipFactory.pm blib/lib/FAST/Bio/Ontology/RelationshipFactory.pm \
	  lib/FAST/Bio/Ontology/RelationshipI.pm blib/lib/FAST/Bio/Ontology/RelationshipI.pm \
	  lib/FAST/Bio/Ontology/RelationshipType.pm blib/lib/FAST/Bio/Ontology/RelationshipType.pm \
	  lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor.pm blib/lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor.pm \
	  lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor02.pm blib/lib/FAST/Bio/Ontology/SimpleGOEngine/GraphAdaptor02.pm \
	  lib/FAST/Bio/Ontology/SimpleOntologyEngine.pm blib/lib/FAST/Bio/Ontology/SimpleOntologyEngine.pm \
	  lib/FAST/Bio/Ontology/Term.pm blib/lib/FAST/Bio/Ontology/Term.pm \
	  lib/FAST/Bio/Ontology/TermFactory.pm blib/lib/FAST/Bio/Ontology/TermFactory.pm \
	  lib/FAST/Bio/Ontology/TermI.pm blib/lib/FAST/Bio/Ontology/TermI.pm \
	  lib/FAST/Bio/OntologyIO.pm blib/lib/FAST/Bio/OntologyIO.pm \
	  lib/FAST/Bio/OntologyIO/Handlers/BaseSAXHandler.pm blib/lib/FAST/Bio/OntologyIO/Handlers/BaseSAXHandler.pm \
	  lib/FAST/Bio/OntologyIO/Handlers/InterProHandler.pm blib/lib/FAST/Bio/OntologyIO/Handlers/InterProHandler.pm \
	  lib/FAST/Bio/OntologyIO/Handlers/InterPro_BioSQL_Handler.pm blib/lib/FAST/Bio/OntologyIO/Handlers/InterPro_BioSQL_Handler.pm \
	  lib/FAST/Bio/OntologyIO/InterProParser.pm blib/lib/FAST/Bio/OntologyIO/InterProParser.pm \
	  lib/FAST/Bio/OntologyIO/dagflat.pm blib/lib/FAST/Bio/OntologyIO/dagflat.pm \
	  lib/FAST/Bio/OntologyIO/goflat.pm blib/lib/FAST/Bio/OntologyIO/goflat.pm \
	  lib/FAST/Bio/OntologyIO/obo.pm blib/lib/FAST/Bio/OntologyIO/obo.pm \
	  lib/FAST/Bio/OntologyIO/simplehierarchy.pm blib/lib/FAST/Bio/OntologyIO/simplehierarchy.pm \
	  lib/FAST/Bio/OntologyIO/soflat.pm blib/lib/FAST/Bio/OntologyIO/soflat.pm \
	  lib/FAST/Bio/PrimarySeq.pm blib/lib/FAST/Bio/PrimarySeq.pm \
	  lib/FAST/Bio/PrimarySeqI.pm blib/lib/FAST/Bio/PrimarySeqI.pm \
	  lib/FAST/Bio/PullParserI.pm blib/lib/FAST/Bio/PullParserI.pm \
	  lib/FAST/Bio/Range.pm blib/lib/FAST/Bio/Range.pm \
	  lib/FAST/Bio/RangeI.pm blib/lib/FAST/Bio/RangeI.pm \
	  lib/FAST/Bio/Root/Exception.pm blib/lib/FAST/Bio/Root/Exception.pm \
	  lib/FAST/Bio/Root/HTTPget.pm blib/lib/FAST/Bio/Root/HTTPget.pm \
	  lib/FAST/Bio/Root/IO.pm blib/lib/FAST/Bio/Root/IO.pm \
	  lib/FAST/Bio/Root/Root.pm blib/lib/FAST/Bio/Root/Root.pm \
	  lib/FAST/Bio/Root/RootI.pm blib/lib/FAST/Bio/Root/RootI.pm \
	  lib/FAST/Bio/Root/Version.pm blib/lib/FAST/Bio/Root/Version.pm \
	  lib/FAST/Bio/Search/BlastUtils.pm blib/lib/FAST/Bio/Search/BlastUtils.pm \
	  lib/FAST/Bio/Search/GenericStatistics.pm blib/lib/FAST/Bio/Search/GenericStatistics.pm \
	  lib/FAST/Bio/Search/HSP/BlastPullHSP.pm blib/lib/FAST/Bio/Search/HSP/BlastPullHSP.pm \
	  lib/FAST/Bio/Search/HSP/GenericHSP.pm blib/lib/FAST/Bio/Search/HSP/GenericHSP.pm \
	  lib/FAST/Bio/Search/HSP/HSPFactory.pm blib/lib/FAST/Bio/Search/HSP/HSPFactory.pm \
	  lib/FAST/Bio/Search/HSP/HSPI.pm blib/lib/FAST/Bio/Search/HSP/HSPI.pm \
	  lib/FAST/Bio/Search/HSP/HmmpfamHSP.pm blib/lib/FAST/Bio/Search/HSP/HmmpfamHSP.pm \
	  lib/FAST/Bio/Search/HSP/PullHSPI.pm blib/lib/FAST/Bio/Search/HSP/PullHSPI.pm \
	  lib/FAST/Bio/Search/Hit/BlastPullHit.pm blib/lib/FAST/Bio/Search/Hit/BlastPullHit.pm \
	  lib/FAST/Bio/Search/Hit/GenericHit.pm blib/lib/FAST/Bio/Search/Hit/GenericHit.pm \
	  lib/FAST/Bio/Search/Hit/HitFactory.pm blib/lib/FAST/Bio/Search/Hit/HitFactory.pm \
	  lib/FAST/Bio/Search/Hit/HitI.pm blib/lib/FAST/Bio/Search/Hit/HitI.pm \
	  lib/FAST/Bio/Search/Hit/HmmpfamHit.pm blib/lib/FAST/Bio/Search/Hit/HmmpfamHit.pm \
	  lib/FAST/Bio/Search/Hit/PullHitI.pm blib/lib/FAST/Bio/Search/Hit/PullHitI.pm \
	  lib/FAST/Bio/Search/Result/BlastPullResult.pm blib/lib/FAST/Bio/Search/Result/BlastPullResult.pm \
	  lib/FAST/Bio/Search/Result/CrossMatchResult.pm blib/lib/FAST/Bio/Search/Result/CrossMatchResult.pm \
	  lib/FAST/Bio/Search/Result/GenericResult.pm blib/lib/FAST/Bio/Search/Result/GenericResult.pm \
	  lib/FAST/Bio/Search/Result/HmmpfamResult.pm blib/lib/FAST/Bio/Search/Result/HmmpfamResult.pm \
	  lib/FAST/Bio/Search/Result/PullResultI.pm blib/lib/FAST/Bio/Search/Result/PullResultI.pm \
	  lib/FAST/Bio/Search/Result/ResultFactory.pm blib/lib/FAST/Bio/Search/Result/ResultFactory.pm \
	  lib/FAST/Bio/Search/Result/ResultI.pm blib/lib/FAST/Bio/Search/Result/ResultI.pm \
	  lib/FAST/Bio/Search/SearchUtils.pm blib/lib/FAST/Bio/Search/SearchUtils.pm \
	  lib/FAST/Bio/Search/StatisticsI.pm blib/lib/FAST/Bio/Search/StatisticsI.pm \
	  lib/FAST/Bio/SearchIO.pm blib/lib/FAST/Bio/SearchIO.pm \
	  lib/FAST/Bio/SearchIO/EventHandlerI.pm blib/lib/FAST/Bio/SearchIO/EventHandlerI.pm \
	  lib/FAST/Bio/SearchIO/FastHitEventBuilder.pm blib/lib/FAST/Bio/SearchIO/FastHitEventBuilder.pm \
	  lib/FAST/Bio/SearchIO/IteratedSearchResultEventBuilder.pm blib/lib/FAST/Bio/SearchIO/IteratedSearchResultEventBuilder.pm \
	  lib/FAST/Bio/SearchIO/SearchResultEventBuilder.pm blib/lib/FAST/Bio/SearchIO/SearchResultEventBuilder.pm \
	  lib/FAST/Bio/SearchIO/SearchWriterI.pm blib/lib/FAST/Bio/SearchIO/SearchWriterI.pm \
	  lib/FAST/Bio/SearchIO/Writer/BSMLResultWriter.pm blib/lib/FAST/Bio/SearchIO/Writer/BSMLResultWriter.pm \
	  lib/FAST/Bio/SearchIO/Writer/GbrowseGFF.pm blib/lib/FAST/Bio/SearchIO/Writer/GbrowseGFF.pm \
	  lib/FAST/Bio/SearchIO/Writer/HSPTableWriter.pm blib/lib/FAST/Bio/SearchIO/Writer/HSPTableWriter.pm \
	  lib/FAST/Bio/SearchIO/Writer/HTMLResultWriter.pm blib/lib/FAST/Bio/SearchIO/Writer/HTMLResultWriter.pm \
	  lib/FAST/Bio/SearchIO/Writer/HitTableWriter.pm blib/lib/FAST/Bio/SearchIO/Writer/HitTableWriter.pm \
	  lib/FAST/Bio/SearchIO/Writer/ResultTableWriter.pm blib/lib/FAST/Bio/SearchIO/Writer/ResultTableWriter.pm \
	  lib/FAST/Bio/SearchIO/Writer/TextResultWriter.pm blib/lib/FAST/Bio/SearchIO/Writer/TextResultWriter.pm \
	  lib/FAST/Bio/SearchIO/XML/BlastHandler.pm blib/lib/FAST/Bio/SearchIO/XML/BlastHandler.pm \
	  lib/FAST/Bio/SearchIO/XML/PsiBlastHandler.pm blib/lib/FAST/Bio/SearchIO/XML/PsiBlastHandler.pm \
	  lib/FAST/Bio/SearchIO/axt.pm blib/lib/FAST/Bio/SearchIO/axt.pm \
	  lib/FAST/Bio/SearchIO/blast.pm blib/lib/FAST/Bio/SearchIO/blast.pm \
	  lib/FAST/Bio/SearchIO/blast_pull.pm blib/lib/FAST/Bio/SearchIO/blast_pull.pm \
	  lib/FAST/Bio/SearchIO/blasttable.pm blib/lib/FAST/Bio/SearchIO/blasttable.pm \
	  lib/FAST/Bio/SearchIO/blastxml.pm blib/lib/FAST/Bio/SearchIO/blastxml.pm \
	  lib/FAST/Bio/SearchIO/cross_match.pm blib/lib/FAST/Bio/SearchIO/cross_match.pm \
	  lib/FAST/Bio/SearchIO/erpin.pm blib/lib/FAST/Bio/SearchIO/erpin.pm \
	  lib/FAST/Bio/SearchIO/exonerate.pm blib/lib/FAST/Bio/SearchIO/exonerate.pm \
	  lib/FAST/Bio/SearchIO/fasta.pm blib/lib/FAST/Bio/SearchIO/fasta.pm \
	  lib/FAST/Bio/SearchIO/gmap_f9.pm blib/lib/FAST/Bio/SearchIO/gmap_f9.pm \
	  lib/FAST/Bio/SearchIO/hmmer.pm blib/lib/FAST/Bio/SearchIO/hmmer.pm \
	  lib/FAST/Bio/SearchIO/hmmer2.pm blib/lib/FAST/Bio/SearchIO/hmmer2.pm \
	  lib/FAST/Bio/SearchIO/hmmer3.pm blib/lib/FAST/Bio/SearchIO/hmmer3.pm \
	  lib/FAST/Bio/SearchIO/hmmer_pull.pm blib/lib/FAST/Bio/SearchIO/hmmer_pull.pm \
	  lib/FAST/Bio/SearchIO/infernal.pm blib/lib/FAST/Bio/SearchIO/infernal.pm \
	  lib/FAST/Bio/SearchIO/megablast.pm blib/lib/FAST/Bio/SearchIO/megablast.pm \
	  lib/FAST/Bio/SearchIO/psl.pm blib/lib/FAST/Bio/SearchIO/psl.pm \
	  lib/FAST/Bio/SearchIO/rnamotif.pm blib/lib/FAST/Bio/SearchIO/rnamotif.pm \
	  lib/FAST/Bio/SearchIO/sim4.pm blib/lib/FAST/Bio/SearchIO/sim4.pm \
	  lib/FAST/Bio/SearchIO/waba.pm blib/lib/FAST/Bio/SearchIO/waba.pm \
	  lib/FAST/Bio/SearchIO/wise.pm blib/lib/FAST/Bio/SearchIO/wise.pm \
	  lib/FAST/Bio/Seq.pm blib/lib/FAST/Bio/Seq.pm \
	  lib/FAST/Bio/Seq/LargeLocatableSeq.pm blib/lib/FAST/Bio/Seq/LargeLocatableSeq.pm \
	  lib/FAST/Bio/Seq/LargePrimarySeq.pm blib/lib/FAST/Bio/Seq/LargePrimarySeq.pm \
	  lib/FAST/Bio/Seq/LargeSeqI.pm blib/lib/FAST/Bio/Seq/LargeSeqI.pm \
	  lib/FAST/Bio/Seq/Meta.pm blib/lib/FAST/Bio/Seq/Meta.pm \
	  lib/FAST/Bio/Seq/Meta/Array.pm blib/lib/FAST/Bio/Seq/Meta/Array.pm \
	  lib/FAST/Bio/Seq/MetaI.pm blib/lib/FAST/Bio/Seq/MetaI.pm \
	  lib/FAST/Bio/Seq/PrimaryQual.pm blib/lib/FAST/Bio/Seq/PrimaryQual.pm \
	  lib/FAST/Bio/Seq/QualI.pm blib/lib/FAST/Bio/Seq/QualI.pm \
	  lib/FAST/Bio/Seq/Quality.pm blib/lib/FAST/Bio/Seq/Quality.pm \
	  lib/FAST/Bio/Seq/RichSeq.pm blib/lib/FAST/Bio/Seq/RichSeq.pm \
	  lib/FAST/Bio/Seq/RichSeqI.pm blib/lib/FAST/Bio/Seq/RichSeqI.pm \
	  lib/FAST/Bio/Seq/SeqBuilder.pm blib/lib/FAST/Bio/Seq/SeqBuilder.pm \
	  lib/FAST/Bio/Seq/SeqFactory.pm blib/lib/FAST/Bio/Seq/SeqFactory.pm \
	  lib/FAST/Bio/Seq/SeqFastaSpeedFactory.pm blib/lib/FAST/Bio/Seq/SeqFastaSpeedFactory.pm \
	  lib/FAST/Bio/Seq/SequenceTrace.pm blib/lib/FAST/Bio/Seq/SequenceTrace.pm \
	  lib/FAST/Bio/Seq/TraceI.pm blib/lib/FAST/Bio/Seq/TraceI.pm \
	  lib/FAST/Bio/SeqAnalysisParserI.pm blib/lib/FAST/Bio/SeqAnalysisParserI.pm \
	  lib/FAST/Bio/SeqFeature/FeaturePair.pm blib/lib/FAST/Bio/SeqFeature/FeaturePair.pm \
	  lib/FAST/Bio/SeqFeature/Gene/Exon.pm blib/lib/FAST/Bio/SeqFeature/Gene/Exon.pm \
	  lib/FAST/Bio/SeqFeature/Gene/ExonI.pm blib/lib/FAST/Bio/SeqFeature/Gene/ExonI.pm \
	  lib/FAST/Bio/SeqFeature/Gene/GeneStructure.pm blib/lib/FAST/Bio/SeqFeature/Gene/GeneStructure.pm \
	  lib/FAST/Bio/SeqFeature/Gene/GeneStructureI.pm blib/lib/FAST/Bio/SeqFeature/Gene/GeneStructureI.pm \
	  lib/FAST/Bio/SeqFeature/Gene/Intron.pm blib/lib/FAST/Bio/SeqFeature/Gene/Intron.pm \
	  lib/FAST/Bio/SeqFeature/Gene/NC_Feature.pm blib/lib/FAST/Bio/SeqFeature/Gene/NC_Feature.pm \
	  lib/FAST/Bio/SeqFeature/Gene/Poly_A_site.pm blib/lib/FAST/Bio/SeqFeature/Gene/Poly_A_site.pm \
	  lib/FAST/Bio/SeqFeature/Gene/Promoter.pm blib/lib/FAST/Bio/SeqFeature/Gene/Promoter.pm \
	  lib/FAST/Bio/SeqFeature/Gene/Transcript.pm blib/lib/FAST/Bio/SeqFeature/Gene/Transcript.pm \
	  lib/FAST/Bio/SeqFeature/Gene/TranscriptI.pm blib/lib/FAST/Bio/SeqFeature/Gene/TranscriptI.pm \
	  lib/FAST/Bio/SeqFeature/Gene/UTR.pm blib/lib/FAST/Bio/SeqFeature/Gene/UTR.pm \
	  lib/FAST/Bio/SeqFeature/Generic.pm blib/lib/FAST/Bio/SeqFeature/Generic.pm \
	  lib/FAST/Bio/SeqFeature/Similarity.pm blib/lib/FAST/Bio/SeqFeature/Similarity.pm \
	  lib/FAST/Bio/SeqFeature/SimilarityPair.pm blib/lib/FAST/Bio/SeqFeature/SimilarityPair.pm \
	  lib/FAST/Bio/SeqFeature/Tools/FeatureNamer.pm blib/lib/FAST/Bio/SeqFeature/Tools/FeatureNamer.pm \
	  lib/FAST/Bio/SeqFeature/Tools/IDHandler.pm blib/lib/FAST/Bio/SeqFeature/Tools/IDHandler.pm \
	  lib/FAST/Bio/SeqFeature/Tools/TypeMapper.pm blib/lib/FAST/Bio/SeqFeature/Tools/TypeMapper.pm \
	  lib/FAST/Bio/SeqFeature/Tools/Unflattener.pm blib/lib/FAST/Bio/SeqFeature/Tools/Unflattener.pm \
	  lib/FAST/Bio/SeqFeatureI.pm blib/lib/FAST/Bio/SeqFeatureI.pm \
	  lib/FAST/Bio/SeqI.pm blib/lib/FAST/Bio/SeqI.pm \
	  lib/FAST/Bio/SeqIO.pm blib/lib/FAST/Bio/SeqIO.pm \
	  lib/FAST/Bio/SeqIO/FTHelper.pm blib/lib/FAST/Bio/SeqIO/FTHelper.pm \
	  lib/FAST/Bio/SeqIO/Handler/GenericRichSeqHandler.pm blib/lib/FAST/Bio/SeqIO/Handler/GenericRichSeqHandler.pm \
	  lib/FAST/Bio/SeqIO/MultiFile.pm blib/lib/FAST/Bio/SeqIO/MultiFile.pm \
	  lib/FAST/Bio/SeqIO/abi.pm blib/lib/FAST/Bio/SeqIO/abi.pm \
	  lib/FAST/Bio/SeqIO/ace.pm blib/lib/FAST/Bio/SeqIO/ace.pm \
	  lib/FAST/Bio/SeqIO/agave.pm blib/lib/FAST/Bio/SeqIO/agave.pm \
	  lib/FAST/Bio/SeqIO/alf.pm blib/lib/FAST/Bio/SeqIO/alf.pm \
	  lib/FAST/Bio/SeqIO/asciitree.pm blib/lib/FAST/Bio/SeqIO/asciitree.pm \
	  lib/FAST/Bio/SeqIO/bsml.pm blib/lib/FAST/Bio/SeqIO/bsml.pm \
	  lib/FAST/Bio/SeqIO/bsml_sax.pm blib/lib/FAST/Bio/SeqIO/bsml_sax.pm \
	  lib/FAST/Bio/SeqIO/chadoxml.pm blib/lib/FAST/Bio/SeqIO/chadoxml.pm \
	  lib/FAST/Bio/SeqIO/chaos.pm blib/lib/FAST/Bio/SeqIO/chaos.pm \
	  lib/FAST/Bio/SeqIO/chaosxml.pm blib/lib/FAST/Bio/SeqIO/chaosxml.pm \
	  lib/FAST/Bio/SeqIO/ctf.pm blib/lib/FAST/Bio/SeqIO/ctf.pm \
	  lib/FAST/Bio/SeqIO/embl.pm blib/lib/FAST/Bio/SeqIO/embl.pm \
	  lib/FAST/Bio/SeqIO/embldriver.pm blib/lib/FAST/Bio/SeqIO/embldriver.pm \
	  lib/FAST/Bio/SeqIO/entrezgene.pm blib/lib/FAST/Bio/SeqIO/entrezgene.pm \
	  lib/FAST/Bio/SeqIO/excel.pm blib/lib/FAST/Bio/SeqIO/excel.pm \
	  lib/FAST/Bio/SeqIO/exp.pm blib/lib/FAST/Bio/SeqIO/exp.pm \
	  lib/FAST/Bio/SeqIO/fasta.pm blib/lib/FAST/Bio/SeqIO/fasta.pm \
	  lib/FAST/Bio/SeqIO/fastq.pm blib/lib/FAST/Bio/SeqIO/fastq.pm \
	  lib/FAST/Bio/SeqIO/flybase_chadoxml.pm blib/lib/FAST/Bio/SeqIO/flybase_chadoxml.pm \
	  lib/FAST/Bio/SeqIO/game.pm blib/lib/FAST/Bio/SeqIO/game.pm \
	  lib/FAST/Bio/SeqIO/game/featHandler.pm blib/lib/FAST/Bio/SeqIO/game/featHandler.pm \
	  lib/FAST/Bio/SeqIO/game/gameHandler.pm blib/lib/FAST/Bio/SeqIO/game/gameHandler.pm \
	  lib/FAST/Bio/SeqIO/game/gameSubs.pm blib/lib/FAST/Bio/SeqIO/game/gameSubs.pm \
	  lib/FAST/Bio/SeqIO/game/gameWriter.pm blib/lib/FAST/Bio/SeqIO/game/gameWriter.pm \
	  lib/FAST/Bio/SeqIO/game/seqHandler.pm blib/lib/FAST/Bio/SeqIO/game/seqHandler.pm \
	  lib/FAST/Bio/SeqIO/gbdriver.pm blib/lib/FAST/Bio/SeqIO/gbdriver.pm \
	  lib/FAST/Bio/SeqIO/gbxml.pm blib/lib/FAST/Bio/SeqIO/gbxml.pm \
	  lib/FAST/Bio/SeqIO/gcg.pm blib/lib/FAST/Bio/SeqIO/gcg.pm \
	  lib/FAST/Bio/SeqIO/genbank.pm blib/lib/FAST/Bio/SeqIO/genbank.pm \
	  lib/FAST/Bio/SeqIO/interpro.pm blib/lib/FAST/Bio/SeqIO/interpro.pm \
	  lib/FAST/Bio/SeqIO/kegg.pm blib/lib/FAST/Bio/SeqIO/kegg.pm \
	  lib/FAST/Bio/SeqIO/largefasta.pm blib/lib/FAST/Bio/SeqIO/largefasta.pm \
	  lib/FAST/Bio/SeqIO/lasergene.pm blib/lib/FAST/Bio/SeqIO/lasergene.pm \
	  lib/FAST/Bio/SeqIO/locuslink.pm blib/lib/FAST/Bio/SeqIO/locuslink.pm \
	  lib/FAST/Bio/SeqIO/mbsout.pm blib/lib/FAST/Bio/SeqIO/mbsout.pm \
	  lib/FAST/Bio/SeqIO/metafasta.pm blib/lib/FAST/Bio/SeqIO/metafasta.pm \
	  lib/FAST/Bio/SeqIO/msout.pm blib/lib/FAST/Bio/SeqIO/msout.pm \
	  lib/FAST/Bio/SeqIO/nexml.pm blib/lib/FAST/Bio/SeqIO/nexml.pm \
	  lib/FAST/Bio/SeqIO/phd.pm blib/lib/FAST/Bio/SeqIO/phd.pm \
	  lib/FAST/Bio/SeqIO/pir.pm blib/lib/FAST/Bio/SeqIO/pir.pm \
	  lib/FAST/Bio/SeqIO/pln.pm blib/lib/FAST/Bio/SeqIO/pln.pm \
	  lib/FAST/Bio/SeqIO/qual.pm blib/lib/FAST/Bio/SeqIO/qual.pm \
	  lib/FAST/Bio/SeqIO/raw.pm blib/lib/FAST/Bio/SeqIO/raw.pm \
	  lib/FAST/Bio/SeqIO/scf.pm blib/lib/FAST/Bio/SeqIO/scf.pm \
	  lib/FAST/Bio/SeqIO/seqxml.pm blib/lib/FAST/Bio/SeqIO/seqxml.pm \
	  lib/FAST/Bio/SeqIO/strider.pm blib/lib/FAST/Bio/SeqIO/strider.pm \
	  lib/FAST/Bio/SeqIO/swiss.pm blib/lib/FAST/Bio/SeqIO/swiss.pm \
	  lib/FAST/Bio/SeqIO/swissdriver.pm blib/lib/FAST/Bio/SeqIO/swissdriver.pm \
	  lib/FAST/Bio/SeqIO/tab.pm blib/lib/FAST/Bio/SeqIO/tab.pm \
	  lib/FAST/Bio/SeqIO/table.pm blib/lib/FAST/Bio/SeqIO/table.pm \
	  lib/FAST/Bio/SeqIO/tigr.pm blib/lib/FAST/Bio/SeqIO/tigr.pm \
	  lib/FAST/Bio/SeqIO/tigrxml.pm blib/lib/FAST/Bio/SeqIO/tigrxml.pm \
	  lib/FAST/Bio/SeqIO/tinyseq.pm blib/lib/FAST/Bio/SeqIO/tinyseq.pm \
	  lib/FAST/Bio/SeqIO/tinyseq/tinyseqHandler.pm blib/lib/FAST/Bio/SeqIO/tinyseq/tinyseqHandler.pm \
	  lib/FAST/Bio/SeqIO/ztr.pm blib/lib/FAST/Bio/SeqIO/ztr.pm \
	  lib/FAST/Bio/SeqUtils.pm blib/lib/FAST/Bio/SeqUtils.pm \
	  lib/FAST/Bio/SimpleAlign.pm blib/lib/FAST/Bio/SimpleAlign.pm \
	  lib/FAST/Bio/Species.pm blib/lib/FAST/Bio/Species.pm \
	  lib/FAST/Bio/Taxon.pm blib/lib/FAST/Bio/Taxon.pm \
	  lib/FAST/Bio/Tools/AnalysisResult.pm blib/lib/FAST/Bio/Tools/AnalysisResult.pm \
	  lib/FAST/Bio/Tools/CodonTable.pm blib/lib/FAST/Bio/Tools/CodonTable.pm \
	  lib/FAST/Bio/Tools/GFF.pm blib/lib/FAST/Bio/Tools/GFF.pm \
	  lib/FAST/Bio/Tools/Genewise.pm blib/lib/FAST/Bio/Tools/Genewise.pm \
	  lib/FAST/Bio/Tools/Genomewise.pm blib/lib/FAST/Bio/Tools/Genomewise.pm \
	  lib/FAST/Bio/Tools/GuessSeqFormat.pm blib/lib/FAST/Bio/Tools/GuessSeqFormat.pm \
	  lib/FAST/Bio/Tools/IUPAC.pm blib/lib/FAST/Bio/Tools/IUPAC.pm \
	  lib/FAST/Bio/Tools/MySeqStats.pm blib/lib/FAST/Bio/Tools/MySeqStats.pm \
	  lib/FAST/Bio/Tools/Run/GenericParameters.pm blib/lib/FAST/Bio/Tools/Run/GenericParameters.pm \
	  lib/FAST/Bio/Tools/Run/ParametersI.pm blib/lib/FAST/Bio/Tools/Run/ParametersI.pm \
	  lib/FAST/Bio/Tools/SeqPattern.pm blib/lib/FAST/Bio/Tools/SeqPattern.pm \
	  lib/FAST/Bio/Tools/SeqPattern/Backtranslate.pm blib/lib/FAST/Bio/Tools/SeqPattern/Backtranslate.pm \
	  lib/FAST/Bio/Tools/SeqStats.pm blib/lib/FAST/Bio/Tools/SeqStats.pm \
	  lib/FAST/Bio/Tree/Node.pm blib/lib/FAST/Bio/Tree/Node.pm \
	  lib/FAST/Bio/Tree/NodeI.pm blib/lib/FAST/Bio/Tree/NodeI.pm \
	  lib/FAST/Bio/Tree/Tree.pm blib/lib/FAST/Bio/Tree/Tree.pm \
	  lib/FAST/Bio/Tree/TreeFunctionsI.pm blib/lib/FAST/Bio/Tree/TreeFunctionsI.pm \
	  lib/FAST/Bio/Tree/TreeI.pm blib/lib/FAST/Bio/Tree/TreeI.pm \
	  lib/FAST/Bio/UnivAln.pm blib/lib/FAST/Bio/UnivAln.pm \
	  lib/FAST/Bio/WebAgent.pm blib/lib/FAST/Bio/WebAgent.pm \
	  lib/Pod/Usage.pm blib/lib/Pod/Usage.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
