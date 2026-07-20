include { HISAT2_BUILD } from '../modules/reference/hisat2_build'
include { BOWTIE2_BUILD } from '../modules/reference/bowtie2_build'
include { BWA_INDEX } from '../modules/reference/bwa_index'

workflow REFERENCE {

    take:
        genome

    main:

    if (params.aligner == "hisat2") {

        HISAT2_BUILD(genome)
        index = HISAT2_BUILD.out.index

    }
    else if (params.aligner == "bowtie2") {

        BOWTIE2_BUILD(genome)
        index = BOWTIE2_BUILD.out.index

    }
    else if (params.aligner == "bwa") {

        BWA_INDEX(genome)
        index = BWA_INDEX.out.index

    }
    else {

        error "Unsupported aligner: ${params.aligner}"

    }

    emit:
        index
}
