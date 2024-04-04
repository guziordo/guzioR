#' Doug's Typical Directory Setup
#'
#' This sets up sub-directories in a way that I typically use. By no means do you need to do this, simply comes down to preference.
#'
#' @export

guzior.setdir <- function() {

  for(x in c("plots", "inputs", "outputs")) {

    if (!dir.exists(paste0(getwd(), "/", x))) {
      dir.create(paste0(getwd(), "/", x))
    }

  }

}
