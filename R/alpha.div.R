#' Calculate Alpha Diversity Metrics
#'
#' This function is used to calculate multiple alpha diversity metrics all in one go. This calculates Shannon Index, Simpson Index, Pielou Index, and sample richness
#'
#' @param data Data table with sample IDs in the first column
#' @param sample.col Column name containing sample identifiers
#' @returns A data frame containing associated alpha diversity metrics for samples in the provided table.
#' @export

alpha.div <- function(data, sample.col = 1) {
  data %>%
    select(sample.col) %>%
    mutate(Shannon = vegan::diversity(data[,2:length(data)], indedata = 'shannon'),
           Simpson = vegan::diversity(data[,2:length(data)], indedata = 'simpson'),
           Pielou = pielou(data[,2:length(data)]) ,
           Richness = vegan::specnumber(data[,2:length(data)]))
}
