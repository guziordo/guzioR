#' QR Code Generation
#'
#' Generates a QR code for a given website URL and saves it as an SVG file.
#'
#' @param site URL of the website to generate the QR code for.
#' @param filename Name of the saved SVG file containing the QR code. Do not include ".svg" in the name.
#' @param path Path where the QR SVG should be saved. Defaults to a "svg" sub-directory within the "plots" directory.
#' @param show Determines if the generated SVG is immediately opened. Defaults to FALSE.
#' @export

generate.qr <- function(site, filename, path = paste0(getwd(), "/plots/svg"), show = FALSE) {
  code <- qrcode::qr_code(site)
  plot(code)
  qrcode::generate_svg(code, filename = paste0(path, "/", filename, ".svg"), show = show)
  rm(code)
}
