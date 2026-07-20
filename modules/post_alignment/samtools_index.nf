process SAMTOOLS_INDEX {

    tag "$sample"

    publishDir "${params.outdir}/Alignment/Indexed", mode: 'copy'

    input:
        tuple val(sample),
              val(layout),
              path(sorted_bam)

    output:
        tuple val(sample),
              val(layout),
              path(sorted_bam),
              path("${sample}.bai"),
              emit: indexed_bam

    script:
    """
    samtools index \
        ${sorted_bam} \
        ${sample}.bai
    """
}
