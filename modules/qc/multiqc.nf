process MULTIQC {

    input:
    tuple val(meta), path(reports)

    output:
    path "multiqc_report.html"

    script:
    """
    multiqc \
        ${params.multiqc_args} \
        .
    """
}
