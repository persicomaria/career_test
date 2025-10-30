#!/usr/bin/perl -w
use strict;


use warnings;
our $litID;
our @A2;
my $field;
my $all="";
my $pmid="";
my $fulltext;
my $fn;
#my $PDBID;
my $line;
my $a;
my $pattern1;
my $pattern2;
my $pattern3;
my $expr4;
my $path;
#my $dir = "./temp.last.results";
my @fnames='';
my @tmpPMID='';
my @fulltext='';
my @A='';
our @AAsingleLetter='';
our @AA3Letters='';
our @AAwords='';
our @AAarrays='';
our %hashDictMatches='';
our %hashDictCounter='';
#my $dir2 = "./pdbFilesDir.test";
my($header) =
"\n\t\t*****************************************************************
\t\tPDBlit: Collect Full Text & Extract Relevant Info from Literature Associated to Protein Data Bank
\t\tAuthor: Maria Persico
\t\tCode for Retrieval of Full Text: Edoardo Dado Marcora, Ph.D.,http://bio-geeks.com>,a Camping web app that automagically fetches a PDF reprint
\t\t of a PubMed article given its PMID.
\t\tApplied Bioinformatics Group
\t\tDepartment of Biotecnology
\t\tBIOTEC Institute 
\t\tTU University of Dresden
\t\tWork flow development: Maria Persico, in preparation 
\t\tUsage:./extracted* ARGV0=partially filled table publications.txt ARGV1=partially filled table citedAAs ARGV2=doi or pmid or pmcid or issn ARGV3= relative path
\t\tUsage: inside this script there is the relative path to the folder storing the full text retrieved literature
\t\t********************************************************************\n";
print $header;

#my $dir2 = "/group/bioinfsvc/mariap/Lit2PDBids/testtxt"; #/biodata/biodb/ABG/databases/pdb/ #"/apps/bioinfp/ProHit/Data/PDB/REGULAR"
#my $dir2 = "./test.fulltxt";
my $dir2 =$ARGV[3];
my $filename="new.citedAAs.txt";#this is a 3 columns file: pmid (list of associated pdbIds)- listOfCitedAA

opendir(BIN, $dir2) or die "Can't open $dir2: $!";
@fnames = grep (!/^\.\.?$/, readdir(BIN));
foreach my $fn (@fnames){
print $fn,"\n";

@tmpPMID=split('\.',$fn);
#print "@tmpPMID\n";
$pmid=$tmpPMID[0];
#print $pmid,"\n";

open (FT, $dir2 . '/' . $fn) or die "Can't open  fulltext file:$!\n";
@fulltext= <FT>;
$fulltext=join("",@fulltext);
#print "here we have the fulltext\n$fulltext\n";

&extractBased3StandardFormatAA($fulltext, $pmid);
$fulltext='';
$pmid='';



}

################################################    subroutines    ###############################################################################
sub extractBased3StandardFormatAA
{
    
#parameters: fulltxtAsArraysOfRows and pmid
@AAsingleLetter=('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S', 'T', 'V', 'W', 'X', 'Y', 'Z');
@AA3Letters=('Ala', 'Asx', 'Cys', 'Asp', 'Glu', 'Phe', 'Gly', 'His', 'Ile', 'Lys', 'Leu', 'Met', 'Asn', 'Pro', 'Gln', 'Arg', 'Ser', 'Thr', 'Val', 'Trp', 'Xaa', 'Tyr', 'Glx');
@AAwords=('alanine', 'aspartic_acid', 'asparagine', 'cysteine', 'glutamic_acid', 'phenylalanine', 'glycine', 'histidine', 'isoleucine', 'lysine', 'leucine', 'methionine', 'proline', 'glutamine', 'arginine', 'serine', 'threonine', 'valine', 'tryptophan', 'amino_acid', 'tyrosine');
 
my ($harvest_array1,@harvest_array1);
my ($harvest_array2,@harvest_array2);
my ($harvest_array3,@harvest_array3);
my $result;

print "these are my parameters in calling this function: fulltxt and $_[1]\n"; 

#remember to deal with the _ in this last array
#3 harvests one for each format....inside one format we can have more than 1 match

foreach $a (@AAsingleLetter){
  #print $a,"\n";
  #$pattern1="$a" . '^[0-9]+$';# $a^[0-9]+$
  #print $pattern1,"\n";
  #print $_[0],"\n";
  if ($_[0]=~/$a[0-9]+/){ #| $A[1][0-9]{1} $A[2][0-9]{1}  if ($num !~ /^[0-9]+$/) &extractBased3StandardFormatAA($fulltext,$pmid)
        
    
    #$pmidAA_db{$pmid} = $&;  
    $result=$&;
    push(@harvest_array1,$result);
    print "this is my match: $result\n";
    #print "this is my growing harvest_array1:@harvest_array1\n";
    
  }
  
 }
$a='';
$pattern1='';
$result='';
$harvest_array1=join(";",@harvest_array1); # A78;E56;P576;D9
print "this is my harvest 1: $harvest_array1\n";
#exit;
################################################################
foreach  $a (@AA3Letters){
  #print $_;
  #print $a,"\n";
  #$pattern2="$a" . '^[0-9]+$';
  if ($_[0]=~/$a[0-9]+/){ 
        
    
    #$pmidAA_db{$pmid} = $&;  
    $result=$&;
    push(@harvest_array2,$result);
    print "this is my match: $result\n";
    #print "this is my growing harvest_array2:@harvest_array2\n";
 }
}
$a='';
$pattern2='';
$result=''; 
$harvest_array2=join(";",@harvest_array2);  # Ala78;Gly56;Pro576;Gln9
print "this is my harvest 2: $harvest_array2\n";;
################################################################
foreach $a (@AAwords){
#print $a,"\n";
  #print $_;
  #$pattern3="$a" . ' ^[0-9]+$';#attention here there must be a space between the word and the number...also maybe the word can begin with capital letter
  if ($_[0]=~/$a [0-9]+/){ 
        
    
    #$pmidAA_db{$pmid} = $&;  
    $result=$&;
    push(@harvest_array3,$result);
    print "this is my match: $result\n";
    #print "this is my growing harvest_array3: @harvest_array3\n"
 }
$a='';  
$pattern3='';
$result='';
$harvest_array3=join(";",@harvest_array3);# alanine 78;glycine 56
}
print "this is my harvest 3: $harvest_array3\n";;
####################################################################3
$all=$harvest_array1 . ' ' . $harvest_array2 . ' ' . $harvest_array3;
 #return 1 references to anonimous array?

 
 $hashDictMatches{$_[1]}=$all;

}############################################ end of subroutine ####################################

while ( my ($key, $value) = each(%hashDictMatches) ) {
        print "$key => $value\n";
    }

#here I create the dict. counter-->litID
open (FTarg0, $ARGV[0]) or die "Can't open  partially filled table publications.txt:$!\n";

while(<FTarg0>){

$line = $_;
chomp($line);
(@A) = split('\|', $line);
print "@A\n";

if ($ARGV[2] eq 'pmid'){###################attenzione forse qui dovrai invertire perche A9 dovrebbe essere la location dei doi e non dei pmid!!!!
 $field= $A[9];
  
}elsif($ARGV[2] eq 'doi'){
$field= $A[6];

}elsif($ARGV[2] eq 'issn'){
$field= $A[8];

}elsif($ARGV[2] eq 'pmcid'){
$field= $A[7];}



if (!exists $hashDictCounter{$A[0]} && $field ne ""){#here there is the assumption that the only way to retrieve full text is through ruby script fetching from pubmed
$hashDictCounter{$A[0]}=$field;#$A[9] is field num 7 in the table publication of db schema pdblit25jan.mwb...type mysql-workbench pdblit25jan.mwb&
}

}
while ( my ($key, $value) = each(%hashDictCounter) ) {
        print "$key => $value\n";
    }
#here I open the partially filled citedAAs file and going through row by row I add the information related 
#to extracted AAs: the last field in each row is the key of the previous already generated 
#dict
open (FTarg1, $ARGV[1]) or die "Can't open  partially filled table citedAAs:$!\n";
while(<FTarg1>){

$line = $_;
chomp($line);
(@A2) = split('\|', $line);
print "verify split: @A2\n";
print "first elem is $A2[0]; last elem is: $A2[$#A2] , literatureID info is: $hashDictCounter{$A2[$#A2]}\n";

$litID=$hashDictCounter{$A2[$#A2]};

if (exists $hashDictMatches{$litID}){ #hashDictMatches is built during subroutine running
#$hashDictCounter{$#A} is a dict key=integer, value=lit_identifier(pmid, doi, ISSN)
#$hashDictMatches is a dict key=lit_identifier(pmid, doi, ISSN) value=cited AAs

#modify row of partially filled table citedAAs
print "relevant info is: $hashDictMatches{$litID}\n";
$A2[8]=$hashDictMatches{$litID};
$all=join('|',@A2);
#$rec = join(':', $login,$passwd,$uid,$gid,$gcos,$home,$shell);
print "verify join: $all\n";
open(F_OUT, ">>$filename");
print F_OUT "$all\n";# viene scritto su file il pmid e tutti i matches trovati su quel pmid nei 3 diversi formati
close F_OUT;
}else{
  print "retrieval failure or no cited AAs\n" ;
  
  next;}

#
#$all=join(@A,'|');
#open(F_OUT, ">>$filename");
#print F_OUT "$all\n";# viene scritto su file il pmid e tutti i matches trovati su quel pmid nei 3 diversi formati  
#}




}
