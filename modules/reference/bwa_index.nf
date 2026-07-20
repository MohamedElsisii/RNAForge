process BWA_INDEX {

    tag "bwa-index"

    publishDir "${params.outdir}/Reference/BWA", mode: 'copy'

    input:
        path genome

    output:
        path "genome*", emit: index

    script:
    """
    bwa index \
        -p genome \
        $genome
    """
}
