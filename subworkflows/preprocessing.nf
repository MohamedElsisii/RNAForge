include { QC_WORKFLOW } from './qc'
include { TRIMMING } from './trimming'

workflow PREPROCESSING {

    take:
        ch_reads

    main:

        // QC before trimming
        QC_WORKFLOW(ch_reads)

        // Optional trimming
        if (params.trimmer == "none") {

            ch_trimmed = ch_reads

        } else {

            TRIMMING(ch_reads)

            ch_trimmed = TRIMMING.out.trimmed_reads

        }

    emit:

        ch_processed_reads = ch_trimmed
}
