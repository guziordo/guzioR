#' Calculate Pielou Evenness Index
#' 
#' This function is used to calculate how evenly features are distributed per sample across a data frame or data table.
#' 
#' @param x Data containing only numeric values, with samples in rows and features in columns
#' @returns A data vector containing calculated index values
#' @export

pielou <- function(x) {
  diversity(x)/log(specnumber(x))
}
