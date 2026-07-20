process REFERENCE_MANAGER {

    tag "$assembly"

    input:
        val assembly

    output:
        path "genome.fna", emit: genome
        path "annotation", emit: annotation
        path "reference", emit: reference_dir

    script:
    """
    set -euo pipefail

    genome=\$(python ${projectDir}/scripts/reference_manager.py \
        --assembly ${assembly} \
        --field genome)

    annotation=\$(python ${projectDir}/scripts/reference_manager.py \
        --assembly ${assembly} \
        --field annotation)

    refdir=\$(python ${projectDir}/scripts/reference_manager.py \
        --assembly ${assembly} \
        --field reference_dir)

    if [ ! -f "\$genome" ]; then
        echo "ERROR: Genome FASTA not found: \$genome"
        exit 1
    fi

    if [ ! -f "\$annotation"  ]; then
        echo "ERROR: Annotation file not found: \$annotation"
        exit 1
    fi

    ln -sf "\$genome" genome.fna
    ln -sf "\$annotation" annotation
    ln -sfn "\$refdir" reference
    """
}

workflow TEST_REFERENCE_MANAGER {

    take:
        assembly

    main:

        REFERENCE_MANAGER(assembly)

    emit:
        genome = REFERENCE_MANAGER.out.genome
        annotation = REFERENCE_MANAGER.out.annotation
}
