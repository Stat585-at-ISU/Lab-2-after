install.packages("rvest")
library(rvest)

doc <- read_html("https://www.police.iastate.edu/crime-log/")
element <- html_element(doc, ".log")
pdf_file <- html_attr(element, "href")
download.file(pdf_file, destfile = file.path("isulogs", basename(pdf_file)))
