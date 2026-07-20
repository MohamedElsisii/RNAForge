process HISAT2 {

    tag "$sample"

    publishDir "${params.outdir}/Alignment/HISAT2", mode: 'copy'

    input:
        tuple val(sample), val(layout), path(reads)
        path index

    output:
        tuple val(sample),
              val(layout),
              path("${sample}.bam"),
              emit: bam

    script:

    def cmd

    if (layout == "PE") {

        cmd = """
        hisat2 \
            -p ${task.cpus} \
            ${params.hisat2_args} \
            -x genome \
            -1 ${reads[0]} \
            -2 ${reads[1]} \
        | samtools view -bS - \
            > ${sample}.bam
        """

    } else {

        cmd = """
        hisat2 \
            -p ${task.cpus} \
            ${params.hisat2_args} \
            -x genome \
            -U ${reads} \
        | samtools view -bS - \
            > ${sample}.bam
        """

    }

    return cmd
}
