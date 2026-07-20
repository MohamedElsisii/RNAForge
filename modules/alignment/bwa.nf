process BWA {

    tag "$sample"

    publishDir "${params.outdir}/Alignment/BWA", mode: 'copy'

    input:
        tuple val(sample), val(layout), path(reads)
        path(index)

    output:
        tuple val(sample),
              val(layout),
              path("${sample}.bam"),
              emit: bam

    script:

    def cmd

    if (layout == "PE") {

        cmd = """
        bwa mem \
            -t ${task.cpus} \
            ${params.bwa_args} \
            genome \
            ${reads[0]} \
            ${reads[1]} \
        | samtools view -b \
            -o ${sample}.bam
        """

    } else {

        cmd = """
        bwa mem \
            -t ${task.cpus} \
            ${params.bwa_args} \
            genome \
            ${reads} \
        | samtools view -b \
            -o ${sample}.bam
        """

    }

    return cmd
}
