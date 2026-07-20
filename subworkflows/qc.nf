include { FASTQC } from '../modules/qc/fastqc'
include { MULTIQC } from '../modules/qc/multiqc'

workflow QC_WORKFLOW {

    take:
        reads

    main:

        FASTQC(reads)

        fastqc_reports = FASTQC.out.reports

        multiqc_input = fastqc_reports.map { sample, layout, reports ->
            tuple(sample, reports)
        }

        MULTIQC(multiqc_input)

    emit:

        fastqc_reports
}
