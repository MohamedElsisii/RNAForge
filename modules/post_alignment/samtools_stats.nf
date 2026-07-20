process SAMTOOLS_STATS {

    tag "$sample"

    publishDir "${params.outdir}/Alignment/QC", mode: 'copy'

    input:
        tuple val(sample),
              val(layout),
              path(sorted_bam),
              path(bai)

    output:
        tuple val(sample),
              val(layout),
              path("${sample}.stats.txt"),
              emit: report

    script:
    """
    samtools stats \
        ${sorted_bam} \
        > ${sample}.stats.txt
    """
}
