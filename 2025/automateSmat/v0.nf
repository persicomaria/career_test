nextflow.enable.dsl=2

params.taxon_id = null

if (!params.taxon_id) {
    error "❌ Missing required parameter: --taxon_id"
}

workflow {

    Channel
        .value(params.taxon_id)
        .set { taxonIDs }

    taxonIDs | checkGetFastaConditions
    taxonIDs | checkRunAnnotatorConditions

    getFASTA
    runANNOTATOR
}

// Process: Check if .annot file exists and ends with $
process checkGetFastaConditions {
    tag "$ncbiTaxonID"
    input:
    val ncbiTaxonID

    output:
    val(ncbiTaxonID) optional true into validGetFastaIDs

    script:
    def file = "annotatedfiles/${ncbiTaxonID}.annot"
    """
    if [ -s "$file" ] && [ "\$(tail -c 1 $file)" == "\$" ]; then
        echo "$ncbiTaxonID"
    fi
    """
}

// Process: Check if .fasta file exists and ends with $
process checkRunAnnotatorConditions {
    tag "$ncbiTaxonID"
    input:
    val ncbiTaxonID

    output:
    val(ncbiTaxonID) optional true into validRunAnnotatorIDs

    script:
    def file = "proteomes/${ncbiTaxonID}.fasta"
    """
    if [ -s "$file" ] && [ "\$(tail -c 1 $file)" == "\$" ]; then
        echo "$ncbiTaxonID"
    fi
    """
}

// Process: getFASTA using embedded Perl logic
process getFASTA {
    tag "$ncbiTaxonID"
    input:
    val ncbiTaxonID from validGetFastaIDs

    output:
    path "proteomes/${ncbiTaxonID}.fasta" into generatedFastaFiles

    script:
    """
    mkdir -p proteomes

    perl -e '
    use strict;
    use warnings;
    use LWP::UserAgent;

    my \$id = "$ncbiTaxonID";

    if (\$id =~ /^UP\\d+\$/) {
        my \$output_file = "proteomes/\$id.fasta";
        my \$url = "https://rest.uniprot.org/uniprotkb/stream?compressed=false&format=fasta&query=(proteome:\$id)";
        my \$ua = LWP::UserAgent->new;
        \$ua->agent("Perl script for UniProt/1.0");

        my \$response = \$ua->get(\$url);
        if (\$response->is_success) {
            open(my \$fh, ">", \$output_file) or die "Cannot write to \$output_file: \$!";
            print \$fh \$response->decoded_content;
            close(\$fh);
        } else {
            die "Failed to fetch proteome: ", \$response->status_line, "\\n";
        }

    } elsif (\$id =~ /^\\d+\$/) {
        my \$query = "\"txid\$id\[Organism\]\"";
        my \$out_file = "proteomes/\$id.fasta";

        my \$esearch_path = `which esearch`;
        chomp \$esearch_path;
        my \$efetch_path = `which efetch`;
        chomp \$efetch_path;

        system("\$esearch_path -db protein -query \$query | \$efetch_path -format fasta > \$out_file") == 0
            or die "Failed to fetch from NCBI for \$id\\n";
    }
    '
    """
}

// Process: runANNOTATOR using embedded Bash and Python environment
process runANNOTATOR {
    tag "$ncbiTaxonID"
    input:
    val ncbiTaxonID from validRunAnnotatorIDs
    path "proteomes/${ncbiTaxonID}.fasta"

    output:
    path "annotated/${ncbiTaxonID}.out" dir true

    script:
    """
    mkdir -p annotated/${ncbiTaxonID}
    mkdir -p annotated/${ncbiTaxonID}.out

    cp proteomes/${ncbiTaxonID}.fasta annotated/${ncbiTaxonID}/${ncbiTaxonID}.fasta

    cd annotated/${ncbiTaxonID}

    conda activate microbeannotator

    microbeannotator \\
        -i ${ncbiTaxonID}.fasta \\
        -d microbeAnnotator_dblight \\
        -o ../${ncbiTaxonID}.out \\
        -m diamond -p 2 -t 2 --light
    """
}
