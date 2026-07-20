process SAMTOOLS_SORT {

    tag "$sample"

    publishDir "${params.outdir}/Alignment/Sorted", mode: 'copy'

    input:
        tuple val(sample),
              val(layout),
              path(bam)

    output:
        tuple val(sample),
              val(layout),
              path("${sample}.sorted.bam"),
              emit: sorted_bam

    script:
    """
    samtools sort \
        -o ${sample}.sorted.bam \
        ${bam}
    """
}
