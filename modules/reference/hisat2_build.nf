process HISAT2_BUILD {

    tag "hisat2-build"

    publishDir "${params.outdir}/Reference/HISAT2", mode: 'copy'

    input:
        path genome

    output:
        path "genome.*.ht2", emit: index

    script:
    """
    hisat2-build \
        "$genome" \
        genome
    """
}
