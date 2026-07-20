process SAMTOOLS_FLAGSTAT {

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
              path("${sample}.flagstat.txt"),
              emit: report

    script:
    """
    samtools flagstat \
        ${sorted_bam} \
        > ${sample}.flagstat.txt
    """
}
