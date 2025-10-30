#!/usr/bin/perl
use strict;
use warnings;

my $temp="";
my $key;
my $value;
my $newfn;
my $PDBID;
my $expr1;
my $expr2;
my $expr3;
my $expr4;
my $path;
#my $dir = "./temp.last.results";

#my $dir2 = "./pdbFilesDir.test";
my $dir2 = "/apps/bioinfp/ProHit/Data/PDB/REGULAR";

#my $filenamezero="/apps/bioinfp/sizezeroFiles.txt";              #temp.results/" . $newfn . '.OUT';
my $filenamezero="sizezeroFiles.test";
my $tempfilenameTO;
my $tempfilenamePMID;
my $tempfilenameREF;

my $resTO1;
my $mod_resTO1;
my $mod_resTO1bis;
my $resTO1bis;
my $resTO2;
my $mod_resTO2;
my $resTO3;
my $mod_resTO3;
my $resTO4;
my $mod_resTO4;
my $resTO4bis;

our %globalResult_hash={};
#my %both_hash={};
#my %onlyDOI_hash={};
#my %onlyPMID_hash={};



#my $resPMID;
#my $resREF;

#my $filenameNozero="/apps/bioinfp/NozeroFiles.txt";

#my $filenameTO="/apps/bioinfp/TObepublished.txt";
my $filenameTO4="DOI.txt";
#my $filenameTO4="./temp.last.results/DOI.txt";
#my $filenameTO4bis="./temp.last.results/DOIandPMID.txt";
my $filenameTO4bis="DOIandPMID.txt";
my $filenameTO3="ISSN.txt";
#my $filenameTO3bis="DOI.txt";
my $filenameTO2="PMID.txt";
#my $filenameTO2bis="DOI.txt";
my $filenameTO1="TOBEPUBLISHED.txt";
my $filenameTO1bis="NOTHINGTODO.txt";
my $filenamePROBLEMS="problems.txt";


#my $filenamePMID="/apps/bioinfp/JRNLall.txt";
#my $filenameREF="/apps/bioinfp/REF.txt";
my @fnames='';

#opendir(BIN, $dir) or die "Can't open $dir: $!";
#@fnames = grep (!/^\.\.?$/, readdir(BIN));
#foreach my $a (@fnames){
##print $a,"\n";

#if( -z $dir . "\/" . $a){
    #print $a,"\n";
    
    #open(F_OUT, ">>", $filenamezero) || die "non posso aprire $filenamezero\n";
    # print  F_OUT $a,"\n";     
           
           #}elsif(-s $dir . "\/" . $a){print "noZero: $a\n"; open(F_OUT2, ">>", $filenameNozero) || die "non posso aprire $filenameNozero\n";print  F_OUT2 $a,"\n";}
#}

#close F_OUT;
#close F_OUT2;

opendir(BIN, $dir2) or die "Can't open $dir2: $!";
@fnames = grep (!/^\.\.?$/, readdir(BIN));
foreach my $a (@fnames){
print $a,"\n";


#open(FILECONTENT, "< $a");


#$expr1= 'JRNL\[\[\:space\:\]\]\+REF\[\[\:space\:\]\]\+TO\[\[\:space\:\]\]BE\[\[\:space\:\]\]PUB';
$expr1= 'JRNL\[\[\:space\:\]\]\.\*TO\[\[\:space\:\]\]BE\[\[\:space\:\]\]PUB';
$expr2= 'JRNL\[\[\:space\:\]\]\.\*PMID';
$expr3= 'JRNL\[\[\:space\:\]\]\.\*ISSN';
$expr4= 'JRNL\[\[\:space\:\]\]\.\*DOI';

#while (!eof(FILECONTENT))
#{

#my          $line=<FILECONTENT>;
            #chomp $line;
            $path= $dir2 . '/' . $a;   #. '.gz';#this is an absolute file name /apps/bioinfp/ProHit/Data/PDB/REGULAR / pdb2e6n.ent .gz
            
            `uncompress $path`;
            
            if( $path=~/\.gz$/){
 $newfn=$`;  
 print "unzipped file path: ",$newfn ,"\n";
 
                                }else{print "are some files unzipped?", "\n";
                                      open(F_OUT_TOprob, ">>$filenamePROBLEMS");
                                      print F_OUT_TOprob "$newfn are some files unzipped\n" ;
                                      
                                      
                                      next};

#if( $newfn=~/\.ent$/){
  if( $newfn=~/pdb[0-9][a-z0-9][a-z0-9][a-z0-9]/){  
 #$PDBID=$`;
 $PDBID=$&;
 
 print "PDBid: ",$PDBID ,"\n";
}else{print "we don't have a PDBid", "\n";
      open(F_OUT_TOprob, ">>$filenamePROBLEMS");
      print F_OUT_TOprob "$newfn we don't have a standard PDBid\n" ;
      `gzip $newfn`;
      $PDBID="";
      next};

 #expr4 contains doi
 $resTO4=`grep $expr4 $newfn`;
 if( $resTO4=~/DOI/){
 $mod_resTO4=$';
 print "grep result for doi ",$resTO4,"\n";
 print "re result for doi ",$mod_resTO4,"\n";
 }
################ 
#we have the doi
################
if($resTO4 ne ""){
    # check also for pmid and then make a distinction between having both doi and pmid from those having only doi
    $resTO2=`grep $expr2 $newfn`;
    
    if($resTO2 ne ""){
        
        if( $resTO2=~/PMID/){
        $mod_resTO2=$';
        print "result for grep-pmid ",$resTO2,"\n";
        print "result for pmid ",$mod_resTO2,"\n";
            }else{print "attention please, here I should have a pmid because expr2 is for retrieving pmid\n";
                  open(F_OUT_TOprob, ">>$filenamePROBLEMS");
                  print F_OUT_TOprob "$mod_resTO2 here I should have a pmid because expr2 is for retrieving pmid\n" ;
                  
                  
                  next};
        
        chomp $mod_resTO2;
        chomp $mod_resTO4;
        
        $temp=$mod_resTO4 . ' ' . $mod_resTO2;
        $globalResult_hash{$PDBID}=$temp;
        #$globalResult_hash{$PDBID}=$mod_resTO2;
        #print out to BOTH
             open(F_OUT_TO4bis, ">>$filenameTO4bis");
             print F_OUT_TO4bis "$PDBID $temp\n" ;
             `gzip $newfn`;
             $PDBID="";
             next;
    }else{
        $globalResult_hash{$PDBID}=$mod_resTO4;
        #print out to ONLY DOI
        
        chomp $mod_resTO4;
        
        open(F_OUT_TO4, ">>$filenameTO4");
        print F_OUT_TO4 "$PDBID $mod_resTO4\n";
        `gzip $newfn`;
        next;
        }
################################    
#we don't have the doi
################################
}else{                                    #($resTO4 == "")
    #check for PMID, TObepublished
    $resTO2=`grep $expr2 $newfn`;
    
    
    if($resTO2 ne ""){#it is different from the empty string
        
     if( $resTO2=~/PMID/){
     $mod_resTO2=$';
     
     print "grep result for only a pmid ",$resTO2,"\n";
     print "re result for only a pmid ",$mod_resTO2,"\n";
     }else{print "Attention please\n";
           
           open(F_OUT_TOprob, ">>$filenamePROBLEMS");
           print F_OUT_TOprob "$resTO2 Attention no PMID match but RE was for capturing pmid\n";
           next};
        
        
    $globalResult_hash{$PDBID}=$mod_resTO2;
    #print out to ONLY PMID
    
    chomp $mod_resTO2;
    
    open(F_OUT_TO2, ">>$filenameTO2");
    print F_OUT_TO2 "$PDBID $mod_resTO2\n";
    `gzip $newfn`;
    $PDBID="";
    next;
    }else{   ###############################################we don't have the pmid
        #check for ISSN
        $resTO3=`grep $expr3 $newfn`;
         if($resTO3 ne ""){
            
            
           
    if( $resTO3=~/ISSN/){
    
    $mod_resTO3=$';
    
    chomp $mod_resTO3;
    
    print "result for grep-ISSN ",$resTO3,"\n";
    print "result for  ISSN",$mod_resTO3,"\n";
    
    }else{print "attention please\n";
          
          open(F_OUT_TOprob, ">>$filenamePROBLEMS");
          print F_OUT_TOprob "$resTO3 we don't have a ISSN match but the RE was for this\n" ;
          
          
          
          next};
            
            
            ############### but we have a ISSN print out to ONLY ISSN
            $globalResult_hash{$PDBID}=$mod_resTO3;
                                  
            open(F_OUT_TO3, ">>$filenameTO3");
            print F_OUT_TO3 "$PDBID $mod_resTO3\n";
            $PDBID="";
            `gzip $newfn`;
            next;
            }else{
          #check for  TObepublished
           $resTO1=`grep $expr1 $newfn`;
                     
           
           if($resTO1 ne ""){
           ########## we have a TObepublished statement  print out to TObePublished
           
           if( $resTO1=~/TO\sBE\sPUB/){
    $mod_resTO1=$&;
    print "result for grep-TO BE PUB ",$resTO1,"\n";
    print "result for  TO BE PUB",$mod_resTO1,"\n";
    
    }else{print "attention please\n";
          open(F_OUT_TOprob, ">>$filenamePROBLEMS");
          print F_OUT_TOprob "$resTO1 we don't have a TO BE PUB match\n" ;
          
          
          next};
           $globalResult_hash{$PDBID}=$mod_resTO1;
           open(F_OUT_TO1, ">>$filenameTO1");
           print F_OUT_TO1 "$PDBID $mod_resTO1\n";
           $PDBID="";
           `gzip $newfn`;
           next;
           }else{
            #print out to NOTHINGTODO
            open(F_OUT_TO1bis, ">>$filenameTO1bis");
            print F_OUT_TO1bis "$PDBID $mod_resTO1bis\n";
            $PDBID="";
            `gzip $newfn`;
            next;
            }
         }
          
          } 
    }

$newfn='';
$tempfilenameTO='';
$resTO1='';
$resTO2='';
$resTO3='';
$resTO4='';   
    
    };#end of looping the files in dir 


#@@@@@@@@@@@@while(($key, $value)=each(%globalResult_hash)){
    #@@@@@@@@@@@@@@@print "$key $value\n";
    
    
#@@@@@@@@@@@@@@@@@@@@@@@}
###$tempfilenameTO='';

###}

###`gzip $newfn`;


 #$tempfilenamePMID='';
 #$resPMID='';
 #$tempfilenameREF='';
 #$resREF=''



 #}
#close FILECONTENT;
close F_OUT_TO1;
close F_OUT_TO1bis;
close F_OUT_TO2;
close F_OUT_TO3;
close F_OUT_TO4;
close F_OUT_TO4bis;
close F_OUT_TOprob;
exit;
 
 #`grep $expr2  $newfn > $tempfilenamePMID`;
 #print $tempfilenamePMID ,"\n";

#$resPMID=`grep $expr2 $newfn`;
#if( -s $tempfilenamePMID){open(F_OUT_PMID, ">>$filenamePMID") || die "non posso aprire $filenamePMID\n";
#print F_OUT_PMID "$newfn $resPMID\n";
#}
 
       
 #`grep $expr3 $newfn> $tempfilenameREF`;
 #print $tempfilenameREF ,"\n";

#$resREF=`grep $expr3 $newfn`;
#if( -s $tempfilenameREF){open(F_OUT_REF, ">>$filenameREF") || die "non posso aprire $filenameREF\n";
#print F_OUT_REF "$newfn $resREF\n";
#}

             

 
#####}
######close FILECONTENT;


#close F_OUT_TO;
#close F_OUT_PMID;
#close F_OUT_REF;

#$tempfilenameTO = "$dir . '/' . 'OUT.txt'"; #./temp.3.results
#print $tempfilenameTO,"\n";

#$tempfilenameTO="/apps/bioinfp/temp.3.results/out.txt";# . $newfn . '.OUT'

###$tempfilenameTO="out.txt";

###`grep $expr1 $newfn > $tempfilenameTO`;
#print $tempfilenameTO ,"\n";
###if( -s $tempfilenameTO){open(F_OUT_TO, ">>$filenameTO") || die "non posso aprire $filenameTO\n";
 