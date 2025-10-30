#!/usr/bin/perl -w
use strict;

my $line;
our $counter;
my $all;
my @fnames1;
my@A;
my %hashDictISSN;#key is issn....values: one or more pdbIds
my %hashDict1;#key is doi...values: one or more pdbIds
my %hashDict2;#key is pmid...values: one or more pdbIds
my $result1filename="citedAAs.txt";
my $result2filename="publications.txt";
#I need the following step to insert the pdbIds in the CitedAAs table

my $dir1 = "./pdbParsedFiles";
opendir(BIN, $dir1) or die "Can't open $dir1: $!";
@fnames1 = grep (!/^\.\.?$/, readdir(BIN));

$counter=0;
open(F_OUT, ">>$result2filename");
open(F_OUT1, ">>$result1filename"); 

foreach my $fn1 (@fnames1){

print $fn1,"\n";

next if $fn1=~/TOBEPUBLISHED/;#if ($_[0]=~/$a[0-9]+/){ #| 
next if $fn1=~/NOTHINGTODO/;

if( $fn1=~/ISSN.txt/){
open (FT, $dir1 . '/' . $fn1) or die "Can't open  fulltext file:$!\n";
while(<FT>){
$line = $_;
chomp($line);
(@A) = split("\t", $line);

    


if (!exists $hashDictISSN{$A[1]}){
    $hashDictISSN{$A[1]}=$A[0]; #example: pdb2lh7  0023-4761
    $counter++;
    
    #let's start to populate table publication in a partial way
    #for now, just create a txt file, then you will write the code for opening connection to db
    #open(F_OUT, ">>$result2filename");
    $all=$counter . '||||||||' . $A[1] . '|||';
    print F_OUT "$all\n";# viene scritto su file il pmid e tutti i matches trovati su quel pmid nei 3 diversi formati
    #close F_OUT;
    
#now do something also in the citedAA table:
#open(F_OUT1, ">>$result1filename");        #citedAAs
$all=$A[0] . '||||yes||||||' . $counter;   #has only pmid should be filled......remember that in citedAAs the pdbids are one for row!
print F_OUT1 "$all\n";#
#lose F_OUT1;
    
    
}elsif(exists $hashDictISSN{$A[1]}){
      $hashDictISSN{$A[1]}=$hashDictISSN{$A[1]} . ';' . $A[0];      
      #open(F_OUT, ">>$result2filename");
      #$all=$counter . '||||||||' . $A[1] . '|||';
      #print F_OUT "$all\n";# viene scritto su file il pmid e tutti i matches trovati su quel pmid nei 3 diversi formati
      #close F_OUT;
      #open(F_OUT1, ">>$result1filename");
      $all=$A[0] . '||||yes||||||' . $counter;
      print F_OUT1 "$all\n";# viene scritto su file il pmid e tutti i matches trovati su quel pmid nei 3 diversi formati
      
      
      }

#close F_OUT;
#close F_OUT1;

}#end of issn while
close FT;
#exit;
#####################################################only DOI or both case ############################################
}elsif( $fn1=~/DOI.txt/ ||  $fn1=~/both-doi-pmid.wellFormatted.txt/){
open (FT1, $dir1 . '/' . $fn1) or die "Can't open  fulltext file:$!\n";
while(<FT1>){

$line = $_;
chomp($line);
(@A) = split("\t", $line);
#open(F_OUT, ">>$result2filename");
#open(F_OUT1, ">>$result1filename"); 
if (!exists $hashDict1{$A[1]} && scalar(@A) eq 3){
    $hashDict1{$A[1]}=$A[0];
    $hashDict2{$A[2]}=$A[0];#inizio a riempire anche il dizionario dei pmid
    $counter++;
    
    #open(F_OUT, ">>$result2filename");             #publications.txt
    $all=$counter . '||||||' . $A[1] . '|||' . $A[2]  . '|';
    print F_OUT "$all\n";# 
    

#now do something also in the citedAA table:
#open(F_OUT1, ">>$result1filename");        #citedAAs
$all=$A[0] . '|||||yes|||||' . $counter;   #has only pmid should be filled......remember that in citedAAs the pdbids are one for row!
print F_OUT1 "$all\n";#


    #if($A[1]=~/10./ ){#attenzione!!!!!!!!!!!!!!! qui sei interessata a riempire il file "publication" con sia il doi identifier sia il pmid!!!
    #$all=$counter . '|||||||' . $hashDict1{$A[1]} . '|||';
    #print F_OUT "$all\n";# 
    #}else{
       #$all=$counter . '||||||' . $hashDict2{$A[1]} . '|||';
    #print F_OUT "$all\n";# 
    #}
    #close F_OUT;
}elsif(exists $hashDict1{$A[1]} && scalar(@A) eq 3){
    #push(@pdbArrays,$A[0]);
    #my $pdbset=join(';',@pdbArrays);
    $hashDict1{$A[1]}=$hashDict1{$A[1]} . ';' . $A[0];
    $hashDict2{$A[2]}=$hashDict2{$A[2]} . ';' . $A[0];
    
    #open(F_OUT1, ">>$result1filename");        #citedAAs
    $all=$A[0] . '|||||yes|||||' . $counter;     #has_both should be filled
    print F_OUT1 "$all\n";# 
    
      }

#here we are in the DOI file
if (!exists $hashDict1{$A[1]} && scalar(@A) != 3){
    $hashDict1{$A[1]}=$A[0];
    #$hashDict2{$A[2]}=$A[0];
    $counter++;
    
    #open(F_OUT, ">>$result2filename");              #publications.txt
    $all=$counter . '|||||||' . $A[1] . '||';
    print F_OUT "$all\n";
    
    
#now do something also in the citedAA table:
#open(F_OUT1, ">>$result1filename");        #citedAAs
$all=$A[0] . '||yes||||||||' . $counter;   #has only pmid should be filled......remember that in citedAAs the pdbids are one for row!
print F_OUT1 "$all\n";#

    #if($A[1]=~/10./ ){
    #$all=$counter . '|||||||' . $hashDict1{$A[1]} . '|||';
    #print F_OUT "$all\n";# viene scritto su file il pmid e tutti i matches trovati su quel pmid nei 3 diversi formati
    #}else{
       #$all=$counter . '||||||' . $hashDict2{$A[1]} . '|||';
    #print F_OUT "$all\n";# viene scritto su file il pmid e tutti i matches trovati su quel pmid nei 3 diversi formati 
    #}
    #close F_OUT;
}elsif(exists $hashDict1{$A[1]} && scalar(@A) != 3){
    #push(@pdbArrays,$A[0]);
    #my $pdbset=join(';',@pdbArrays);


    
    
    $hashDict1{$A[1]}=$hashDict1{$A[1]} . ';' . $A[0];
    
     #open(F_OUT1, ">>$result1filename");        #citedAAs
     $all=$A[0] . '||yes||||||||' . $counter;   #has only doi should be filled
     print F_OUT1 "$all\n";# viene scritto su file il pmid e tutti i matches trovati su quel pmid nei 3 diversi formati
     
      }

#close F_OUT,
#close F_OUT1;
#@pdbArrays='';
#$pdbset='';

}
close FT1;
#@fulltext= <FT1>;
#$fulltext1=join("",@fulltext1);
}elsif($fn1=~/PMID.txt/ )
{#end of else (filenames matching DOI PMID BOTH)
open (FT2, $dir1 . '/' . $fn1) or die "Can't open  fulltext file:$!\n";
while(<FT2>){

$line = $_;
chomp($line);
(@A) = split("\t", $line);

if (!exists $hashDict2{$A[1]}){  #key is pmid, value is pdbid or pbids...@A has length=2
    
    
   print "now add to previous hash the remaining pmid\n";
   $hashDict2{$A[1]}=$A[0];
   $counter++;
    
   #open(F_OUT, ">>$result2filename");              #publications.txt
   $all=$counter . '||||||' . $A[1] . '|||||';          #here the field pmid has to be filled
   print F_OUT "$all\n";
   #close F_OUT;
#now do something also in the citedAA table:
#open(F_OUT1, ">>$result1filename");        #citedAAs
$all=$A[0] . '|||yes|||||||' . $counter;   #has only pmid should be filled......remember that in citedAAs the pdbids are one for row!
print F_OUT1 "$all\n";#
#close F_OUT1; 



}elsif(exists $hashDict2{$A[1]}){
#let us the publication table untouch
    $hashDict2{$A[1]}=$hashDict2{$A[1]} . ';' . $A[0];
       
       
    #open(F_OUT1, ">>$result1filename");        #citedAAs
    $all=$A[0] . '|||yes|||||||' . $counter;   #has only pmid should be filled......remember that in citedAAs the pdbids are one for row!
    print F_OUT1 "$all\n";#
    #close F_OUT1; 
    } 
}#end of while for FT2 fh
close FT2;
}#



}#end of foreach file....in dir
close F_OUT,
close F_OUT1;
#let me come back to the other 2 output files , forget the publication table for now
#and let's us being focused on "citedAAs" table
#if parameter 1 in command line =yes, run the subroutine for adding meta data
#if parameter 2 in command line =yes, run the subroutine for adding retrieval info
