include { CUTADAPT } from '../modules/trimming/cutadapt'
include { TRIMMOMATIC } from '../modules/trimming/trimmomatic'

workflow TRIMMING {

    take:
        reads

    main:

        if (params.trimmer == "none") {

            trimmed_reads = reads

        }
        else if (params.trimmer == "cutadapt") {

            CUTADAPT(reads)
            trimmed_reads = CUTADAPT.out.trimmed_reads

        }
        else if (params.trimmer == "trimmomatic") {

            TRIMMOMATIC(reads)
            trimmed_reads = TRIMMOMATIC.out.trimmed_reads

        }
        else {

            error "Unsupported trimmer: ${params.trimmer}"

        }

    emit:
        trimmed_reads
}
