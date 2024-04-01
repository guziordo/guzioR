#' Calculate Alpha Diversity Metrics
#' 
#' This function is used to calculate multiple alpha diversity metrics all in one go. This calculates Shannon Index, Simpson Index, Pielou Index, and sample richness
#' 
#' @param x Data table with sample IDs in the first column
#' @param sample.col Column name containing sample identifiers
#' @returns A data frame containing associated alpha diversity metrics for samples in the provided table.
#' @export

alpha.div <- function(x, sample.col) {
  x %>%
    select(sample.name) %>%
    mutate(Shannon = diversity(x[,2:length(x)], index = 'shannon'),
           Simpson = diversity(x[,2:length(x)], index = 'simpson'),
           Pielou = pielou(x[,2:length(x)]) ,
           Richness = specnumber(x[,2:length(x)])) %>%
    as.data.table(.)
  
}
