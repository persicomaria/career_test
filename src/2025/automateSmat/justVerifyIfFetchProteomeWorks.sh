#!/bin/bash
#
MY_i_DIR=/storage/brno2/home/mariap3636/automateSmat/INPUT
MY_o_DIR=/storage/brno2/home/mariap3636/automateSmat/OUTPUT
MY_o_DIR_fastafailures=/storage/brno2/home/mariap3636/automateSmat/OUTPUT/fastafailures
#
### FETCH proteomes from NCBI ###

listOfTAXONIDSfile=/storage/brno2/home/mariap3636/automateSmat/INPUT/mariaInputList_9-6-25

# Add a trailing slash if not present
[[ "${MY_o_DIR}" != */ ]] && path2fastasuccess="${MY_o_DIR}/"
echo "$path2fastasuccess"


# Add a trailing slash if not present
[[ "${MY_o_DIR_fastafailures}" != */ ]] && path2fastafailures="${MY_o_DIR_fastafailures}/"
echo "$path2fastafailures"


#counter=1
for a in `cat $listOfTAXONIDSfile`;do
/storage/brno2/home/mariap3636/automateSmat/getProteomeFromNCBI.pl $a 

frag1="output."
frag3=".fasta"

final="$frag1Sa$frag3"

if [ -s $final ]; then
    echo "File exists and is not empty."
mv $final "$path2fastasuccess"
else
    echo "File does not exist or is empty."
mv $final "$path2fastafailures"
fi

sleep 3m

done
exit
