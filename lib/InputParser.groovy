class InputParser {

    static String getSampleName(File file) {

        def name = file.name

        name = name.replaceAll(/\.fastq\.gz$/, "")
        name = name.replaceAll(/\.fq\.gz$/, "")
        name = name.replaceAll(/_1$/, "")
        name = name.replaceAll(/_2$/, "")

        return name
    }

}
