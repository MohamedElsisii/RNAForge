include { FEATURECOUNTS } from '../modules/quantification/featurecounts'

workflow QUANTIFICATION {

    take:
        indexed_bams
        annotation

    main:

        // Extract layout (same for all samples)
        detectedLayout = indexed_bams
            .map { sample, layout, bam, bai -> layout }
            .first()

        // Collect BAM files
        bam_files = indexed_bams
            .map { sample, layout, bam, bai -> bam }
            .collect()

        FEATURECOUNTS(
            bam_files,
            annotation,
            detectedLayout
        )

    emit:

        counts = FEATURECOUNTS.out.count_matrix
}
