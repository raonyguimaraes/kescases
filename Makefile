ALL_FREE_TARGETS=bin/time bin/traceproc bin/bwa bin/samtools bin/spades.py bin/python bin/snakemake bin/tabix bin/rtg bin/fastq-dump bin/blastn bin/quast.py bin/python2 bin/vcf2tsv bin/art_illumina bin/bedtools bin/bamToBed

ALL_NONFREE_TARGETS=lib/GenomeAnalysisTK.jar lib/picard.jar

# Site-specific make rules
-include local/build.mk


.PHONY: all
all: $(ALL_NONFREE_TARGETS) $(ALL_FREE_TARGETS)

.PHONY: allfree
allfree: $(ALL_FREE_TARGETS)

lib/GenomeAnalysisTK.jar lib/picard.jar:
	@ if [ ! -a $@ ]; then \
		echo "* $@ is not installed and must be manually downloaded." ; \
		echo "* See lib/NOTES for installation instructions." ; \
		echo "* To build all freely-available software, run \"make allfree\"" ; \
		exit 1 ; \
	fi ; \
	echo OK

bin/quast.py:
	make -C build/quast

bin/blastn:
	make -C build/blast

bin/fastq-dump:
	make -C build/sra

#bin/R bin/Rscript:
#	make -C build/r

bin/rtg:
	make -C build/rtg

bin/tabix:
	make -C build/tabix

bin/python bin/python2:
	make -C build/miniconda ../../bin/python
	make -C build/miniconda ../../bin/python2

bin/snakemake:
	make -C build/miniconda ../../bin/snakemake

bin/time:
	make -C build/time

bin/traceproc:
	make -C build/traceproc

bin/bwa:
	make -C build/bwa

bin/samtools:
	make -C build/samtools

bin/spades.py:
	make -C build/spades

bin/vcf2tsv:
	cd build; git clone --recursive git@github.com:vcflib/vcflib.git
	cd build/vcflib; git checkout v1.0.0-rc1
	make -C build/vcflib
	ln -s ../build/vcflib/bin/vcf2tsv bin/

bin/art_illumina:
	make -C build/art

bin/bedtools bin/bamToBed:
	make -C build/bedtools
	ln -sf ../build/bedtools/bedtools2/bin/bedtools bin/
	ln -sf ../build/bedtools/bedtools2/bin/bamToBed bin/

.PHONY: clean
clean:
	make -C build/time clean
	make -C build/traceproc clean
	make -C build/bwa clean
	make -C build/samtools clean
	make -C build/spades clean

