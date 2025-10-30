#!/usr/bin/perl
use strict;
use warnings;

my $keyForEUTIL;

$keyForEUTIL='"txid' . $ARGV[0] . '[Organism]"';

print "to be taken online at NCBI\n";

my $out_file='output.' . $ARGV[0] . '.fasta';

esearch_path=$(which esearch)
efetch_path=$(which fetch)

`$esearch_path -db "protein" -query $keyForEUTIL | $efetch_path -format fasta > $out_file`;

# efetch_path=$(command -v esearch) echo "$efetch_path"
#
# testing if you have installed `efetch` from NCBI E-utilities 
#You can check if `efetch` from NCBI E-utilities works by running a simple test query and checking the output. For example, to fetch a GenBank record for a known accession:
#```bash
#efetch -db nucleotide -id NM_000546 -format fasta
#```
#If `efetch` is working, this command should print the FASTA sequence for NM_000546.  
#You can also check if the command succeeds in a script:
#```bash
#if efetch -db nucleotide -id NM_000546 -format fasta | grep -q "^>"; then
#    echo "efetch works."
#else
#    echo "efetch failed."
#fi
#```
#This checks for a FASTA header (`>`) in the output.
#if efetch -db nucleotide -id NM_000546 -format fasta | grep -q "^>"; then
#    echo "efetch works."
#else
#    echo "efetch failed."
#fi
#automateSmat esearch -db "protein" -query "txid657322[Organism]" | efetch -format fasta > 657322.FASTA
