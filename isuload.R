library(rvest)

doc <- read_html("https://www.police.iastate.edu/crime-log/")
pdf_file <- doc %>% html_element(".log") %>% html_attr("href")
download.file(pdf_file, destfile = file.path("isulogs", basename(pdf_file)))
