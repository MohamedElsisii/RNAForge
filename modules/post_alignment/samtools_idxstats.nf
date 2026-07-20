process SAMTOOLS_IDXSTATS {

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
              path("${sample}.idxstats.txt"),
              emit: report

    script:
    """
    samtools idxstats \
        ${sorted_bam} \
        > ${sample}.idxstats.txt
    """
}
