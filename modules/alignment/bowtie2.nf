process BOWTIE2 {

    tag "$sample"

    publishDir "${params.outdir}/Alignment/Bowtie2", mode: 'copy'

    input:
        tuple val(sample), val(layout), path(reads)
        path index

    output:
        tuple val(sample),
              val(layout),
              path("${sample}.bam"),
              emit: bam

    script:

    if (layout == "PE") {
        """
        bowtie2 \
            -x ${index}/genome \
            -1 ${reads[0]} \
            -2 ${reads[1]} \
            -p ${task.cpus} \
            ${params.bowtie2_args} \
        | samtools view -b \
            -o ${sample}.bam
        """
    }
    else {
        """
        bowtie2 \
            -x ${index}/genome \
            -U ${reads} \
            -p ${task.cpus} \
            ${params.bowtie2_args} \
        | samtools view -b \
            -o ${sample}.bam
        """
    }
}
