#' @keywords internal
"_PACKAGE"

#' Internal package methods
#'
#' @import ggplot2
#' @import palettes
#' @import dplyr
#' @importFrom grDevices dev.off pdf png
#' @importFrom utils write.csv
#' @keywords internal
#' @name guzioR

utils::globalVariables(c(
  ".",
  "Intensity",
  "RetentionTime",
  "intensity",
  "mz",
  "mz.round",
  "plot.int",
  "scan.id"
))

NULL
