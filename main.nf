nextflow.enable.dsl = 2

include { REFERENCE } from './subworkflows/reference'
include { INPUT } from './modules/input/input'
include { PREPROCESSING } from './subworkflows/preprocessing'
include { ALIGNMENT } from './subworkflows/alignment'
include { POST_ALIGNMENT } from './subworkflows/post_alignment'
include { QUANTIFICATION } from './subworkflows/quantification'
include { REFERENCE_MANAGER } from './modules/reference/reference_manager'

workflow {

    def genome
    def annotation

    if (params.assembly) {

        REFERENCE_MANAGER(params.assembly)

        genome = REFERENCE_MANAGER.out.genome
        annotation = REFERENCE_MANAGER.out.annotation

    }
    else if (params.reference) {

        def refDir = file(params.reference)

        if (!refDir.exists() || !refDir.isDirectory())
            error "Reference directory not found: ${params.reference}"

        def genomeFile = refDir.listFiles().find {
            it.name ==~ /.*\.(fa|fna|fasta)(\.gz)?$/
        }

        if (!genomeFile)
            error "No genome FASTA found in ${params.reference}"

        genome = Channel.value(genomeFile)

        def annotationFile = refDir.listFiles().find {
            it.name ==~ /.*\.(gtf|gff|gff3)(\.gz)?$/
        }

        if (!annotationFile)
            error """
No annotation file found in '${params.reference}'.

Expected one of:
    *.gtf
    *.gff
    *.gff3
"""

        annotation = Channel.value(annotationFile)

    }
    else {

        error "Please provide either --reference or --assembly"

    }

    // Validate aligner
    if (!(params.aligner in ['hisat2', 'bowtie2', 'bwa']))
        error "Unsupported aligner: ${params.aligner}"

    // Validate trimmer
    if (!(params.trimmer in ['none', 'cutadapt', 'trimmomatic']))
        error "Unsupported trimmer: ${params.trimmer}"

    // Validate Trimmomatic arguments
    if (params.trimmer == 'trimmomatic' && !params.trimmomatic_args?.trim())
        error """
Trimmomatic requires at least one trimming operation.

Example:

    --trimmomatic_args "SLIDINGWINDOW:4:20 MINLEN:36"

or

    --trimmomatic_args "ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 SLIDINGWINDOW:4:20 MINLEN:36"
"""

    log.info """
    =========================================
     RNAForge v${workflow.manifest.version}
    A modular Nextflow DSL2 RNA-seq pipeline                       
    =========================================
    Input        : ${params.input}
    Reference    : ${params.reference ?: params.assembly}
    Annotation   : Auto-detected
    Aligner      : ${params.aligner}
    Trimmer      : ${params.trimmer}
    Layout       : Auto-detected
    Output       : ${params.outdir}
    =========================================
    """

    /*
     * Input
     * Emits: tuple(sample, layout, reads)
     */
    INPUT(params.input)

    ch_reads = INPUT.out.reads

    /*
     * QC + Trimming
     * Emits: tuple(sample, layout, trimmed_reads)
     */
    PREPROCESSING(ch_reads)

    ch_trimmed = PREPROCESSING.out.ch_processed_reads

    /*
     * Build reference index
     */
    REFERENCE(genome)

    ch_index = REFERENCE.out.index

    /*
     * Alignment
     * Emits: tuple(sample, layout, bam)
     */
    ALIGNMENT(
        ch_trimmed,
        ch_index
    )

    ch_bam = ALIGNMENT.out.bam

    /*
     * Sort / Index BAM
     */
    POST_ALIGNMENT(ch_bam)

    ch_indexed_bam = POST_ALIGNMENT.out.indexed_bam

    /*
     * Quantification
     */
    QUANTIFICATION(
        ch_indexed_bam,
        annotation
    )

    ch_counts = QUANTIFICATION.out.counts
}
