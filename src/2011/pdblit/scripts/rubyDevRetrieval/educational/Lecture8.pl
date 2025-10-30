use strict;
use LWP::Simple; # required package

my $base="http://eutils.ncbi.nlm.nih.gov/entrez/eutils/";
my ($esearch, $elink, $esummary, $efetch) = ("esearch.fcgi?", "elink.fcgi?", "esummary.fcgi?", "efetch.fcgi?");
my ($query, $param, $term, $web, $key, $result);

# esearch to convert accession to gi
$query="U49897";
$param ="&db=nuccore&term=$query&usehistory=y";
$result=get ($base.$esearch.$param);

# extract the WebEnv and QueryKey, and elink to gene
$web=$1 if ($result=~/<WebEnv>(.+)</);
$key=$1 if ($result=~/<QueryKey>(.+)</);
$param="&db=gene&dbfrom=nuccore&WebEnv=$web&query_key=$key&cmd=neighbor_history";
$result=get($base.$elink.$param);

# extract the WebEnv and QueryKey, and esummary to get a single gene record
$web=$1 if ($result=~/<WebEnv>(.+)</);
$key=$1 if ($result=~/<QueryKey>(.+)</);
# $param="&db=gene&WebEnv=$web&query_key=$key";
# $result=get ($base.$esummary.$param);
# print STDERR "$result\n";

# elink from gene to homologene using the same set of WebEnv and QueryKey
$param="&db=homologene&dbfrom=gene&WebEnv=$web&query_key=$key&cmd=neighbor_history";
$result=get($base.$elink.$param);

# elink from homologene back to gene to collect the complete set
$web=$1 if ($result=~/<WebEnv>(.+)</);
$key=$1 if ($result=~/<QueryKey>(.+)</);
$param="&db=gene&dbfrom=homologene&WebEnv=$web&query_key=$key&cmd=neighbor_history";
$result=get($base.$elink.$param);

# esummary to get the docsum of the gene set
$web=$1 if ($result=~/<WebEnv>(.+)</);
$key=$1 if ($result=~/<QueryKey>(.+)</);
$param="&db=gene&WebEnv=$web&query_key=$key";
$result=get($base.$esummary.$param);

#rountine to parse the chromosome accession, gene start and stop cooridnates
my ($tmp, $accn, $start, $stop, $strand, $seq, $id);
while ($result=~/<DocSum>(.+?)<\/DocSum>/gs){
      $tmp=$1;
      $id=$1 if ($tmp=~/<Id>(\d+)</);
      $accn = $1 if ($tmp=~/ChrAccVer.+>(.+)</);
      $start = $1 if ($tmp=~/ChrStart.+>(\d+)</);
      $stop = $1 if ($tmp=~/ChrStop.+>(\d+)</);
      if ($start==0 || $stop==0){
         print STDERR "Skipping $id due to ambiguous coordinates ...\n";
         next;
      }
      if ($start >$stop){
         $strand=2;
         $stop=$start+1500;
         $start-=1;
      } else {
         $strand=1;
         $stop=$start-1;
         $start-=1500;
      }
      $param="&db=nuccore&retmode=text&rettype=fasta&id=$accn&seq_start=$start&seq_stop=$stop&strand=$strand";
      $seq = get ($base.$efetch.$param);
      print $seq;
      $seq =""; $start=$stop=$strand=$id=0; sleep 3;
}
