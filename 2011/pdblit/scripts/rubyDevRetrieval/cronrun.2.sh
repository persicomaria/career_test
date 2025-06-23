#!/bin/bash
cd /home/bioinf/mariap/PDBlit/PubmedPDF/
date >>error.log
cat xat | perl -e 'while (<>) {system("./pubmedid2pdf.rb $_");}' &>>error.log
