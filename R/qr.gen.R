#' QR Code Generation
#' 
#' Paste the website you want to make a QR code for and save it. QR code generator comes from the package 'qrcode'.
#' 
#' @param site Name of the address you want to make the QR code for.
#' @param path Name of the saved SVG file containing the QR code. Do not include ".svg" here.
#' @export

qr.gen <- function(site, filename) {
  code <- qr_code(site)
  plot(code)
  generate_svg(code, filename = paste0(filename,".svg"))
}
