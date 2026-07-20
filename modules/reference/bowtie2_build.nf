process BOWTIE2_BUILD {

    tag "bowtie2-build"

    publishDir "${params.outdir}/Reference/Bowtie2", mode: 'copy'

    input:
        path genome

    output:
        path "index", emit: index

    script:
    """
    mkdir index

    bowtie2-build \
        "$genome" \
        index/genome
    """
}
