process FEATURECOUNTS {

    tag "featureCounts"

    publishDir "${params.outdir}/Quantification", mode: 'copy'

    input:
        path bam_files
        path annotation
        val layout

    output:
        path "gene_counts.txt", emit: count_matrix

    script:

    def paired = (layout == "PE") ? "-p" : ""

    def attribute = params.fc_attribute

    if (annotation.name.endsWith(".gff") || annotation.name.endsWith(".gff3")) {
        attribute = "ID"
    }

    """
    featureCounts \
        -T ${task.cpus} \
        ${paired} \
        -s ${params.fc_stranded} \
        -t ${params.fc_feature} \
        -g ${attribute} \
        ${params.featurecounts_args} \
        -a ${annotation} \
        -o gene_counts.txt \
        ${bam_files.join(' ')}
    """
}
