process FASTQC {

    tag "$sample"

    publishDir "${params.outdir}/FastQC", mode: 'copy'

    input:
        tuple val(sample), val(layout), path(reads)

    output:
        tuple val(sample),
              val(layout),
              path("*_fastqc.zip"),
              emit: reports

    script:
    """
    fastqc \
        -t ${task.cpus} \
        ${params.fastqc_args} \
        ${reads}
    """
}
