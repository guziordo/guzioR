#' %ni% (Not-In) Operator
#'
#' Use when wanting to exclude certain things instead of listing what to include.
#'
#' @param x A vector.
#' @param y A vector.
#' @return A logical vector indicating whether each element of x is not in y.
#' @export

`%ni%` <- function(x, y) {
  !(x %in% y)
}
