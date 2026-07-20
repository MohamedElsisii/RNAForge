process CUTADAPT {

    tag "$sample"

    publishDir "${params.outdir}/Trimmed/Cutadapt", mode: 'copy'

    input:
        tuple val(sample), val(layout), path(reads)

    output:
        tuple val(sample),
              val(layout),
              path("*.trim.fastq.gz"),
              emit: trimmed_reads

    script:

    def cmd

    if (layout == "PE") {

        cmd = """
        cutadapt \
            -j ${task.cpus} \
            ${params.cutadapt_args} \
            -o ${sample}_R1.trim.fastq.gz \
            -p ${sample}_R2.trim.fastq.gz \
            ${reads[0]} \
            ${reads[1]}
        """

    } else {

        cmd = """
        cutadapt \
            -j ${task.cpus} \
            ${params.cutadapt_args} \
            -o ${sample}.trim.fastq.gz \
            ${reads}
        """

    }

    return cmd
}
