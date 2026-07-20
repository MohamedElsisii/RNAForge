def detectReads(inputDir) {

    def dir = file(inputDir)

    if (!dir.exists())
        error "Input directory not found: ${inputDir}"

    def files = dir.listFiles()*.name

    // --------------------------------------------------
    // Paired-end: R1/R2
    // --------------------------------------------------
    def r1 = files.find { it ==~ /.*_R1\.(fastq|fq)(\.gz)?$/ }

    if (r1) {

        println "Detected paired-end (R1/R2)"

        def ext = r1.replaceFirst(/^.*_R1/, "")

        return Channel
            .fromFilePairs(
                "${inputDir}/*_{R1,R2}${ext}",
                checkIfExists: true
            )
            .map { sample, reads ->
                tuple(sample, "PE", reads)
            }
    }

    // --------------------------------------------------
    // Paired-end: 1/2
    // --------------------------------------------------
    def r2 = files.find { it ==~ /.*_1\.(fastq|fq)(\.gz)?$/ }

    if (r2) {

        println "Detected paired-end (1/2)"

        def ext = r2.replaceFirst(/^.*_1/, "")

        return Channel
            .fromFilePairs(
                "${inputDir}/*_{1,2}${ext}",
                checkIfExists: true
            )
            .map { sample, reads ->
                tuple(sample, "PE", reads)
            }
    }

    // --------------------------------------------------
    // Single-end
    // --------------------------------------------------
    def se = files.find {
        it ==~ /.*\.(fastq|fq)(\.gz)?$/ &&
        !(it ==~ /.*_(R1|R2|1|2)\.(fastq|fq)(\.gz)?$/)
    }

    if (se) {

        println "Detected single-end"

        def ext = se.replaceFirst(/^.*(?=\.(fastq|fq))/, "")

        return Channel
            .fromPath(
                "${inputDir}/*${ext}",
                checkIfExists: true
            )
            .map { file ->

                def sample = file.baseName
                    .replaceAll(/\.fastq$/, "")
                    .replaceAll(/\.fq$/, "")

                tuple(sample, "SE", file)
            }
    }

    error "No supported FASTQ files found in '${inputDir}'."
}

workflow INPUT {

    take:
        input_dir

    main:

        reads = detectReads(input_dir)

    emit:

        reads
}
