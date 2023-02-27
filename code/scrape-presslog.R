

## ----message=FALSE---------------------------------------------------------------------------
library(tidyverse, quietly = TRUE)
library(tabulizer)
library(lubridate, quietly = TRUE)


## ------------------------------------------------------------------------------------------------------
duplicates <- function(string) {
  # find the first '\r', delete everything afterwards
  # str_locate(string, pattern='\r')
  stopifnot(length(string)==1)
  splitter <- strsplit(string, split="\r")
  res <- unique(splitter[[1]])
  if (length(res) > 1) warning(sprintf("Multiple different values found in string: %s", paste(res, collapse=",")))
  res[1]
}


## -----------------------------------------------------------------------------------------------------
one_page <- function(plogi) {
  # take one of the pages, make into a data frame

  # Variables are in the first data row:
  variables <- plogi[1,]
  # remove the '\r'
  variables <- gsub("\r"," ", variables)

  plogi <- plogi[-1,, drop=FALSE]

  for (i in 1:ncol(plogi))
    plogi[,i] <- plogi[,i] %>% purrr::map_chr(.f = duplicates)

  # remove empty columns
  idx <- which(variables == "")
  if (length(idx) > 0) {
    if (all(is.na(plogi[,idx]))) {
      plogi <- plogi[,-idx, drop=FALSE]
      variables <- variables[-idx]
    }
  }
  dframe <- as_tibble(plogi, .name_repair = "minimal")
  names(dframe) <- variables

  dframe <- dframe %>% mutate(
    `Incident ID` = parse_number(`Incident ID`),
    `Report Number Assigned to Event` = parse_number(`Report Number Assigned to Event`)
  )
  dframe
}
