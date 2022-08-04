library(rmarkdown)

args <- commandArgs(trailingOnly=TRUE)
paramsValue=list(inputDir=args[1],
                 OrgDb = args[2],
                 threshold=as.numeric(args[3]))

base="./results/"
file.remove(list.files(base, full.names = TRUE))
dir.create(base, showWarnings = FALSE)


rmarkdown::render("enrichmentReport.Rmd", output_format="html_document",
                  output_file='./results/enrichmentReport.html',
                  params=paramsValue)
