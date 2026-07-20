process TRIMMOMATIC {

    tag "$sample"

    publishDir "${params.outdir}/Trimmed/Trimmomatic", mode: 'copy'

    input:
        tuple val(sample), val(layout), path(reads)

    output:
        tuple val(sample),
              val(layout),
              path("*.trim.fastq.gz"),
              emit: trimmed_reads

    script:

    if (!params.trimmomatic_args?.trim()) {
        error """
    Trimmomatic requires at least one trimming operation.

    Example:

    --trimmomatic_args "SLIDINGWINDOW:4:20 MINLEN:36"

    or

    --trimmomatic_args "ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:20 MINLEN:36"
    """
    }
    
    def cmd

    if (layout == "PE") {

        cmd = """
        trimmomatic PE \
            -threads ${task.cpus} \
            ${reads[0]} \
            ${reads[1]} \
            ${sample}_R1.trim.fastq.gz \
            ${sample}_R1.unpaired.fastq.gz \
            ${sample}_R2.trim.fastq.gz \
            ${sample}_R2.unpaired.fastq.gz \
            ${params.trimmomatic_args}
        """

    } else {

        cmd = """
        trimmomatic SE \
            -threads ${task.cpus} \
            ${reads} \
            ${sample}.trim.fastq.gz \
            ${params.trimmomatic_args}
        """

    }

    return cmd
}
