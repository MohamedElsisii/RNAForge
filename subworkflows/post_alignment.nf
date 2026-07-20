include { SAMTOOLS_SORT }     from '../modules/post_alignment/samtools_sort'
include { SAMTOOLS_INDEX }    from '../modules/post_alignment/samtools_index'
include { SAMTOOLS_FLAGSTAT } from '../modules/post_alignment/samtools_flagstat'
include { SAMTOOLS_IDXSTATS } from '../modules/post_alignment/samtools_idxstats'
include { SAMTOOLS_STATS }    from '../modules/post_alignment/samtools_stats'

workflow POST_ALIGNMENT {

    take:
        bam

    main:

        SAMTOOLS_SORT(bam)

        sorted = SAMTOOLS_SORT.out.sorted_bam

        SAMTOOLS_INDEX(sorted)

        indexed = SAMTOOLS_INDEX.out.indexed_bam

        SAMTOOLS_FLAGSTAT(indexed)
        SAMTOOLS_IDXSTATS(indexed)
        SAMTOOLS_STATS(indexed)

    emit:

        indexed_bam = indexed

        flagstat = SAMTOOLS_FLAGSTAT.out.report
        idxstats = SAMTOOLS_IDXSTATS.out.report
        stats     = SAMTOOLS_STATS.out.report
}
