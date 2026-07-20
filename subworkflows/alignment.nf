include { HISAT2 } from '../modules/alignment/hisat2'
include { BOWTIE2 } from '../modules/alignment/bowtie2'
include { BWA } from '../modules/alignment/bwa'

workflow ALIGNMENT {

    take:
        reads
        index

    main:

        if (params.aligner == "hisat2") {

            HISAT2(reads, index)
            bam = HISAT2.out.bam

        }
        else if (params.aligner == "bowtie2") {

            BOWTIE2(reads, index)
            bam = BOWTIE2.out.bam

        }
        else if (params.aligner == "bwa") {

            BWA(reads, index)
            bam = BWA.out.bam

        }
        else {

            error "Unsupported aligner: ${params.aligner}"

        }

    emit:
        bam
}
